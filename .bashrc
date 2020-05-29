#!/bin/bash

## Prompt config
PS1='\[\033[0;$([[ $? = 0 ]] && printf 32 || printf 31)m\]$ \[\033[0m\]'

## Aliases
alias vi="vim"
alias ll="ls -alF"
alias xemacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias be="bundle exec"
alias gitroot='cd $(git rev-parse --show-toplevel 2> /dev/null || echo "$(pwd)") && echo "$_"'
alias bluetoothresetMac='sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport && sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport'
alias macdown="/usr/local/bin/macdown"
alias flushDNSMac="sudo killall -HUP mDNSResponder"
alias docker-dev='make -f ~/repo/docker-dev-env/Makefile'
alias yamlvalidate="ruby -e \"require 'yaml';puts YAML.load_file(ARGV[0])\""
alias sha256sum="shasum -a 256"
alias sha512sum="shasum -a 512"
alias bksr="(gitroot && bksr)"
alias getlog='bkcli -c $(git rev-parse HEAD) -p $(basename $(git rev-parse --show-toplevel)) -f'
alias gitlog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative --branches'
alias k='kubectl'
alias clustermem='cluster-resource-explorer -namespace="" -reverse -sort MemReq'
alias docker-clean='docker ps -aq | xargs -P $(nproc) -n1 docker rm -f ; docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias gl="git log --all --decorate --oneline --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias curlstatus="curl -L -o /dev/null --silent --head --write-out '%{http_code}\n'" $1
alias kbuild="/usr/local/bin/kustomize build --load_restrictor none"
alias autoscalerstatus="kubectl describe -n kube-system configmap cluster-autoscaler-status"
alias clusterevents="kubectl get events --all-namespaces"
alias evictedpods="kubectl get pods --all-namespaces --field-selector=status.phase=Failed"

## Autocomplete Ignore
if command -v kustomize > /dev/null; then
  EXECIGNORE=$(which kustomize || true)
fi

## Environment Variables
export EDITOR=vim
#export PYTHONSTARTUP=~/.pythonrc
man() {
  env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

man() {
  env \
    LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\e[0m")" \
    LESS_TERMCAP_se="$(printf "\e[0m")" \
    LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\e[0m")" \
    LESS_TERMCAP_us="$(printf "\e[1;32m")" \
    man "$@"
}

## History
export HISTFILESIZE=
export HISTSIZE=
# Change the file location because certain bash sessions truncate .bash_history file upon close.
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## Completions
complete -cf sudo
complete -cf man
complete -o default -F __start_kubectl k
complete -F _kube_contexts kcontext
complete -F _kube_namespaces knamespace
complete -C aws_completer aws n

if command -v eksctl @ > /dev/null >&1; then
  . <(eksctl completion bash)
fi

# completion brew
if command -v brew > /dev/null 2>&1; then
  if [ -f "$(brew --prefix)"/etc/bash_completion ]; then
    # shellcheck source=/dev/null
    . "$(brew --prefix)/etc/bash_completion"
  fi

  if [ -f "$(brew --prefix)"/Library/Contributions/brew_bash_completion.sh ]; then
    # shellcheck source=/dev/null
    . "$(brew --prefix)"/Library/Contributions/brew_bash_completion.sh
  fi
fi

# completion helm
if command -v helm > /dev/null 2>&1; then
  eval "$(helm completion bash)"
fi

# completion ssh
export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}
_sshcomplete() {
  local CURRENT_PROMPT="${COMP_WORDS[COMP_CWORD]}"
  if [[ ${CURRENT_PROMPT} == *@* ]]; then
    local OPTIONS="-P ${CURRENT_PROMPT/@*/}@ -- ${CURRENT_PROMPT/*@/}"
  else
    local OPTIONS=" -- ${CURRENT_PROMPT}"
  fi

  # parse all defined hosts from .ssh/config
  if [ -r "$HOME/.ssh/config" ]; then
    COMPREPLY=($(compgen -W "$(grep ^Host "$HOME/.ssh/config" | awk '{for (i=2; i<=NF; i++) print $i}')" ${OPTIONS}))
  fi

  # parse all hosts found in .ssh/known_hosts
  if [ -r "$HOME/.ssh/known_hosts" ]; then
    if grep -v -q -e '^ ssh-rsa' "$HOME/.ssh/known_hosts"; then
      COMPREPLY=(${COMPREPLY[@]} $(compgen -W "$(awk '{print $1}' "$HOME/.ssh/known_hosts" | grep -v ^\| | cut -d, -f 1 | sed -e 's/\[//g' | sed -e 's/\]//g' | cut -d: -f1 | grep -v ssh-rsa)" ${OPTIONS}))
    fi
  fi

  # parse hosts defined in /etc/hosts
  if [ -r /etc/hosts ]; then
    COMPREPLY=(${COMPREPLY[@]} $(compgen -W "$(grep -v '^[[:space:]]*$' /etc/hosts | grep -v '^#' | awk '{for (i=2; i<=NF; i++) print $i}')" ${OPTIONS}))
  fi

  return 0
}
complete -o default -o nospace -F _sshcomplete ssh

# completion pip
_pip_completion() {
  COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    PIP_AUTO_COMPLETE=1 $1))
}
complete -o default -F _pip_completion pip

# completion go
function _go() {
  cur="${COMP_WORDS[COMP_CWORD]}"
  case "${COMP_WORDS[COMP_CWORD - 1]}" in
    "go")
      comms="build clean doc env fix fmt get install list run test tool version vet"
      COMPREPLY=($(compgen -W "${comms}" -- ${cur}))
      ;;
    *)
      files="$(find "${PWD}" -mindepth 1 -maxdepth 1 -type f -iname "*.go" -exec basename {} \;)"
      dirs="$(find "${PWD}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
      repl="${files} ${dirs}"
      COMPREPLY=($(compgen -W "${repl}" -- ${cur}))
      ;;
  esac
  return 0
}
complete -F _go go

# PATH exports
export PATH="$HOME/bin:$PATH"
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# nvm config
#export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# shellcheck source=/dev/null
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# added by travis gem
# shellcheck source=/dev/null
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh

# Custom Functions
namespace() {
  if [ -z "$1" ]; then
    :
  else
    kubectl config set-context "$(kubectl config current-context)" --namespace="${1}"
  fi
}

calculate() {
  echo "$*" | bc -l
}

quick() {
  tmux split-window -p 33 ${EDITOR} "$@" || exit
}

shellformat() {
  local dir="${1}"
  if command -v shfmt > /dev/null 2>&1; then
    shfmt -i 2 -ci -sr -w "${dir:=.}"
  fi
}

function pman() {
  if [ -d /Applications/Preview.app/ ]; then
    man -t "${1}" | open -f -a /Applications/Preview.app
  fi
}

markdown_spellcheck() {
  if [ -n "${1}" ]; then
    local checkFiles="${1}"
  else
    local checkFiles="**/*.md"
  fi
  if command -v mdspell > /dev/null 2>&1; then
    mdspell --en-au --ignore-numbers -r "${checkFiles}"
  fi
}

2qr() {
  qrencode "$1" -t ANSI256 -o -
}

dockerfile_format() {
  if command -v dockerfile-utils > /dev/null 2>&1; then
    dockerfile-utils format --spaces 4 "$1"
  fi
}

gh-open() {
  file=${1:-""}
  git_branch=${2:-$(git symbolic-ref --quiet --short HEAD)}
  git_project_root=$(git config remote.origin.url | sed "s~git@\(.*\):\(.*\)~https://\1/\2~" | sed "s~\(.*\).git\$~\1~")
  git_directory=$(git rev-parse --show-prefix)
  open ${git_project_root}/tree/${git_branch}/${git_directory}${file}
}
