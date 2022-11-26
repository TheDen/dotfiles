#!/bin/bash
eval "$(/usr/local/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"
export TERM=screen-256color

## Prompt config
PS1='\[\033[0;$([[ $? = 0 ]] && printf 32 || printf 31)m\]$ \[\033[0m\]'

## Aliases
alias ..="cd .."
alias vi="vim"
alias vim="/opt/homebrew/bin/vim"
alias ll="ls -alF"
alias xemacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ccat="bat --style=plain"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias be="bundle exec"
alias gitroot='cd $(git rev-parse --show-toplevel 2> /dev/null || echo "$(pwd)") && echo "$_"'
alias gits='git status'
alias bluetoothresetMac='sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport && sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport'
alias flushDNSMac="sudo killall -HUP mDNSResponder"
alias docker-dev='make -f ~/repo/docker-dev-env/Makefile'
alias yamlvalidate="ruby -e \"require 'yaml';puts YAML.load_file(ARGV[0])\""
alias sha256sum="shasum -a 256"
alias sha512sum="shasum -a 512"
alias bksr="(gitroot && bksr)"
alias getlog='bkcli -c $(git rev-parse HEAD) -p $(basename $(git rev-parse --show-toplevel)) -f'
alias gitlog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative --branches'
alias k='kubectl'
alias kubectl="kcolor"
alias clustermem='cluster-resource-explorer -namespace="" -reverse -sort MemReq'
alias docker-clean='docker ps -aq | xargs -P $(nproc) -n1 docker rm -f ; docker rmi -f $(docker images --filter "dangling=true" -q --no-trunc)'
alias gl="git log --all --decorate --oneline --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias kbuild="/opt/homebrew/bin/kustomize build"
alias autoscalerstatus="kubectl describe -n kube-system configmap cluster-autoscaler-status"
alias clusterevents="kubectl get events --all-namespaces"
alias evictedpods="kubectl get pods --all-namespaces --field-selector=status.phase=Failed"
alias private='shopt -uo history'
alias unprivate='shopt -so history'
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias m1="arch -arm64"
alias x86="arch -x86_64"
alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias upgrade="ibrew upgrade && m1 brew upgrade && mas upgrade"
alias pip3="/usr/local/bin/pip3"
alias htop="sudo htop"
alias awsp='aws-profile switch'
export EDITOR=vim
export VISUAL=vim
export HOMEBREW_NO_ANALYTICS=1
export KUBECTX_IGNORE_FZF=1
# PATH exports
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/Users/den/Library/Python/3.9/bin/"
export VOLTA_HOME="$iHOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$PATH:/Users/den/.cargo/bin"
export JAVA_HOME=/"$(/usr/libexec/java_home -v 1.8)"
export PATH="/usr/local/opt/gettext/bin:$PATH:$HOME/.local/bin"
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:~/.kube/plugins/jordanwilson230
export PATH="/usr/local/opt/openssl/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
GPG_TTY="$(tty)"
export GPG_TTY
export GREP_COLOR='1;37;41'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export PYTHONSTARTUP=~/.pythonrc
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

# completion ekctl
if command -v eksctl @ > /dev/null >&1; then
  source <(eksctl completion bash)
fi

# completion brew
if type brew &> /dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi

  HOMEBREW_PREFIX="$(ibrew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
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

# added by travis gem
# shellcheck source=/dev/null
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
[ -f /usr/local/etc/profile.d/z.sh ] && . /usr/local/etc/profile.d/z.sh
[ -f "${HOME}/.zrc" ] && . "${HOME}/.zrc"

# Custom Functions

calculate() {
  echo "$*" | bc -l
}

shellformat() {
  local dir="${1}"
  if command -v shfmt > /dev/null 2>&1; then
    shfmt -i 2 -ci -sr -w "${dir:=.}"
  fi
}

pman() {
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

webp_convert() {
  local file="$1"
  cwebp -q 100 "$file" -o "${file%.*}.webp"
}

curl_status() {
  if [ -n "${1}" ]; then
    curl -L -o /dev/null --silent --head --write-out '%{http_code}\n' "$1"
  fi
}

gh-open() {
  file=${1:-""}
  git_branch=${2:-$(git symbolic-ref --quiet --short HEAD)}
  git_project_root=$(git config remote.origin.url | sed "s~git@\(.*\):\(.*\)~https://\1/\2~" | sed "s~\(.*\).git\$~\1~")
  git_directory=$(git rev-parse --show-prefix)
  open ${git_project_root}/tree/${git_branch}/${git_directory}${file}
}

vimperf() {
  vim -u NONE "${@}"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/den/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/Users/den/gcloud/google-cloud-sdk/path.bash.inc'; fi &> /dev/null

# The next line enables shell command completion for gcloud.
if [ -f '/Users/den/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/den/gcloud/google-cloud-sdk/completion.bash.inc'; fi &> /dev/null

filepath() {
  greadlink -f -- "$@"
}

# Private bashrc
. ~/.bashrc_private
