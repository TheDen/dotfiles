#!/bin/bash
# shellcheck disable=SC2155,SC1090,SC1091
#eval "$(/usr/local/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/brew shellenv)"
export TERM=screen-256color

## Prompt config
PS1='\[\033[0;$([[ $? = 0 ]] && printf 32 || printf 31)m\]$ \[\033[0m\]'

## Aliases
alias ..="cd .."
alias grepc="grep --color=always"
alias bat='bat -Pp'
alias vi="nvim"
alias vim="/opt/homebrew/bin/nvim"
alias ll="ls -alF"
alias xemacs="/Applications/Emacs.app/Contents/MacOS/Emacs"
alias ccat="bat --style=plain"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias be="bundle exec"
alias gitroot='cd $(git rev-parse --show-toplevel 2> /dev/null || echo "$(pwd)") && echo "$_"'
alias gits='git status'
alias bluetoothresetMac='sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport && sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport'
alias flushDNSMac="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
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
alias dockerimages='docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}" | sort -k 2 -h'
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
alias brewcleanup='brew cleanup --prune=all -s && ibrew cleanup --prune=all -s'
alias upgrade="ibrew upgrade && m1 brew upgrade && mas upgrade"
alias pip3="/usr/local/bin/pip3"
alias htop="sudo htop"
alias awsp='aws-profile switch'
alias awspl='aws configure list-profiles'
alias tmuxlog='tmux capture-pane -pS N > ~/tmuxlog.txt'
alias tmuxattach='tmux attach -t 0'
alias go-projects="cd ${GOPATH}/src/github.com/TheDen/"
alias pbcopy='gcopy'
export EDITOR=vim
export VISUAL=vim
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export KUBECTX_IGNORE_FZF=1
# PATH exports
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export GOPATH=~/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/Users/den/Library/Python/3.9/bin/"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$PATH:/Users/den/.cargo/bin"
# use "$(/usr/libexec/java_home -v 1.8)" to get JAVA_HOME
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home"
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
# Manpage colours
export LESS_TERMCAP_mb="$(printf "\e[1;31m")"
export LESS_TERMCAP_md="$(printf "\e[1;31m")"
export LESS_TERMCAP_me="$(printf "\e[0m")"
export LESS_TERMCAP_se="$(printf "\e[0m")"
export LESS_TERMCAP_so="$(printf "\e[1;44;33m")"
export LESS_TERMCAP_ue="$(printf "\e[0m")"
export LESS_TERMCAP_us="$(printf "\e[1;32m")"
export PYTHONSTARTUP=~/.pythonrc
alias dusort='du -h -d1 * | sort -h'

## History
export HISTFILESIZE=
export HISTSIZE=
# Change the file location because certain bash sessions truncate .bash_history file upon close.
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

## Completions
source <(kubectl completion bash)
complete -cf sudo
complete -cf man
complete -o nospace -F __start_kubectl k
complete -F _kube_contexts kcontext
complete -F _kube_namespaces knamespace
complete -C aws_completer aws n

# completion ekctl
if command -v eksctl @ > /dev/null >&1; then
  source <(eksctl completion bash)
fi

# completion brew
if type brew &> /dev/null; then
  HOMEBREW_PREFIX="/opt/homebrew"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi

  HOMEBREW_PREFIX="/usr/local"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# completion helm
if type helm &> /dev/null; then
  source <(helm completion bash)
fi

# completion go
function _go() {
  cur="${COMP_WORDS[COMP_CWORD]}"
  case "${COMP_WORDS[COMP_CWORD - 1]}" in
    "go")
      comms="build clean doc env fix fmt get install list run test tool version vet"
      # shellcheck disable=SC2207
      COMPREPLY=($(compgen -W "${comms}" -- "${cur}"))
      ;;
    *)
      files="$(find "${PWD}" -mindepth 1 -maxdepth 1 -type f -iname "*.go" -exec basename {} \;)"
      dirs="$(find "${PWD}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
      repl="${files} ${dirs}"
      # shellcheck disable=SC2207
      COMPREPLY=($(compgen -W "${repl}" -- "${cur}"))
      ;;
  esac
  return 0
}
complete -F _go go

complete -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.2.9/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/den/gcloud/google-cloud-sdk/path.bash.inc' ]; then . '/Users/den/gcloud/google-cloud-sdk/path.bash.inc'; fi &> /dev/null
# The next line enables shell command completion for gcloud.
if [ -f '/Users/den/gcloud/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/den/gcloud/google-cloud-sdk/completion.bash.inc'; fi &> /dev/null

# Private bashrc
. ~/.bashrc_private

source /Users/den/.bash_completions/netcheck.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
