#!/bin/bash
# shellcheck disable=SC1090,SC1091,SC2317,SC2142

case $- in
  *i*) ;;
  *) return 0 2> /dev/null || exit 0 ;;
esac

command_exists() {
  command -v "$1" > /dev/null 2>&1
}

source_if_readable() {
  [[ -r "$1" ]] && source "$1"
}

path_prepend() {
  [[ -d "$1" ]] || return
  case ":${PATH}:" in
    *":$1:"*) ;;
    *) PATH="$1:${PATH}" ;;
  esac
}

path_append() {
  [[ -d "$1" ]] || return
  case ":${PATH}:" in
    *":$1:"*) ;;
    *) PATH="${PATH}:$1" ;;
  esac
}

## Homebrew
# Static equivalent of `eval "$(brew shellenv)"`, which forks brew (~35ms).
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
fi
if [[ -n ${HOMEBREW_PREFIX} ]]; then
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
  path_prepend "${HOMEBREW_PREFIX}/sbin"
  path_prepend "${HOMEBREW_PREFIX}/bin"
  case ":${INFOPATH}:" in
    *":${HOMEBREW_PREFIX}/share/info:"*) ;;
    *) export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH:+:${INFOPATH}}" ;;
  esac
fi

export TERM=screen-256color

## Prompt config
PS1='\[\033[0;$([[ $? = 0 ]] && printf 32 || printf 31)m\]$ \[\033[0m\]'

## Environment
export EDITOR=nvim
export VISUAL=nvim
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export KUBECTX_IGNORE_FZF=1
export DO_NOT_TRACK=true

## PATH
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
export GOPATH="$HOME/go"
export GOBIN=$GOPATH/bin
path_append "$GOBIN"
path_append "$HOME/Library/Python/3.9/bin"
#export VOLTA_HOME="$HOME/.volta"
#export PATH="$VOLTA_HOME/bin:$PATH"
path_append "$HOME/.cargo/bin"
# use "$(/usr/libexec/java_home -v 1.8)" to get JAVA_HOME
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home"
path_prepend "/usr/local/opt/gettext/bin"
path_prepend "/usr/local/sbin"
path_append "$HOME/.kube/plugins/jordanwilson230"
path_prepend "/usr/local/opt/openssl/bin"
export GEM_HOME="$HOME/.gem"
path_prepend "$HOME/.gem/bin"
path_prepend "/usr/local/opt/ruby/bin"
export PATH
GPG_TTY="$(tty)"
export GPG_TTY
export GREP_COLOR='1;37;41'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
# Manpage colours ($'...' avoids a subshell per variable)
LESS_TERMCAP_mb=$'\e[1;31m'
LESS_TERMCAP_md=$'\e[1;31m'
LESS_TERMCAP_me=$'\e[0m'
LESS_TERMCAP_se=$'\e[0m'
LESS_TERMCAP_so=$'\e[1;44;33m'
LESS_TERMCAP_ue=$'\e[0m'
LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se
export LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us
export PYTHONSTARTUP=~/.pythonrc

## Aliases: Shell and tools
alias ..="cd .."
alias ll="ls -alF"
alias private='shopt -uo history'
alias unprivate='shopt -so history'
alias grepc="grep --color=always"
alias ccat="bat --style=plain"
alias bat='bat -Pp'
alias dusort='du -h -d1 * | sort -h'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias smart_disk_usage='smartctl -a /dev/disk0 | awk -F ":" "/Percentage Used:/{gsub(/ /, \"\", \$2); print \$2}"'
alias sha256sum="shasum -a 256"
alias sha512sum="shasum -a 512"
alias yamlvalidate="ruby -e \"require 'yaml';puts YAML.load_file(ARGV[0])\""

## Aliases: Editors
alias vi="nvim"
alias vim="/opt/homebrew/bin/nvim"
alias xemacs="/Applications/Emacs.app/Contents/MacOS/Emacs"

## Aliases: Git
alias be="bundle exec"
alias gitroot='cd $(git rev-parse --show-toplevel 2> /dev/null || echo "$(pwd)") && echo "$_"'
alias gh-open='gh browse'
alias gits='git status'
alias bksr="(gitroot && bksr)"
alias getlog='bkcli -c $(git rev-parse HEAD) -p $(basename $(git rev-parse --show-toplevel)) -f'
alias gl="git log --all --decorate --oneline --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gitlog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative --branches'

## Aliases: Cloud and Kubernetes
alias awsp='aws-profile switch'
alias awspl='aws configure list-profiles'
alias k='kubectl'
alias kubectl="kcolor"
alias kbuild="/opt/homebrew/bin/kustomize build"
alias clustermem='cluster-resource-explorer -namespace="" -reverse -sort MemReq'
alias clusterevents="kubectl get events --all-namespaces"
alias autoscalerstatus="kubectl describe -n kube-system configmap cluster-autoscaler-status"
alias evictedpods="kubectl get pods --all-namespaces --field-selector=status.phase=Failed"

## Aliases: Docker
alias docker-clean='docker system prune --volumes -f'
alias dockerimages='docker images --format "{{.ID}}\t{{.Size}}\t{{.Repository}}" | sort -k 2 -h'

## Aliases: System
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias bluetoothresetMac='sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport && sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport'
alias flushDNSMac="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias htop="sudo htop"
alias pip3="/usr/local/bin/pip3"

## Aliases: Architecture and package management
alias m1="arch -arm64"
alias x86="arch -x86_64"
alias ibrew='arch -x86_64 /usr/local/bin/brew'
alias brewcleanup='brew cleanup --prune=all -s && ibrew cleanup --prune=all -s'
alias upgrade='(brew upgrade -g -y; mas upgrade)' '(ibrew upgrade -g && m1 brew upgrade -g -y); mas upgrade'

## Aliases: tmux and projects
alias tmuxlog='tmux capture-pane -pS N > ~/tmuxlog.txt'
alias tmuxattach='tmux attach -t 0'
alias go-projects='cd "${GOPATH}/src/github.com/TheDen/"'
if command_exists gcopy; then
  alias pbcopy='gcopy'
fi

## History
shopt -s histappend
export HISTFILESIZE=
export HISTSIZE=
# Change the file location because certain bash sessions truncate .bash_history file upon close.
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
case ";${PROMPT_COMMAND};" in
  *";history -a;"*) ;;
  *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

## Google Cloud SDK PATH
# Inlined from google-cloud-sdk/path.bash.inc, which is all that file does.
path_prepend "$HOME/gcloud/google-cloud-sdk/bin"

## Completions
# Loading completions eagerly costs ~800ms per shell: bash-completion 1.x
# sources all ~300 of its scripts up front, and every `<tool> completion bash`
# is a fork. Instead everything below is deferred to the first TAB press, via
# the "default" completion hook that bash consults for commands with no
# completion of their own. Returning 124 from that hook tells bash to retry the
# completion once the real definitions are in place, so the first TAB still
# completes correctly -- it just costs the load.

# Cache `<tool> completion bash` output, regenerating only when the tool binary
# is newer than the cache. Usage: completion_cached <tool> <generator command...>
COMPLETION_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/bash_completion"
completion_cached() {
  local tool="$1" bin cache
  shift
  # type -P (not command -v) so an alias of the same name is ignored.
  bin="$(type -P "${tool}")" || return 0
  cache="${COMPLETION_CACHE_DIR}/${tool}.bash"
  if [[ ! -s "${cache}" || "${bin}" -nt "${cache}" ]]; then
    mkdir -p "${COMPLETION_CACHE_DIR}"
    if ! "$@" > "${cache}.$$" 2> /dev/null; then
      rm -f "${cache}.$$"
      return 0
    fi
    mv -f "${cache}.$$" "${cache}"
  fi
  source_if_readable "${cache}"
}

load_completions() {
  # Drop this hook first so a failure below cannot loop.
  complete -r -D 2> /dev/null

  complete -cf sudo
  complete -cf man
  if type -P kubectl > /dev/null; then
    completion_cached kubectl kubectl completion bash
    complete -o nospace -F __start_kubectl k
  fi
  if command_exists aws_completer; then
    complete -C aws_completer aws
  fi

  # completion ekctl
  if command_exists eksctl; then
    completion_cached eksctl eksctl completion bash
  fi

  # completion brew
  local brew_prefix completion
  for brew_prefix in /opt/homebrew /usr/local; do
    [[ -d "${brew_prefix}" ]] || continue
    if [[ -r "${brew_prefix}/etc/profile.d/bash_completion.sh" ]]; then
      source_if_readable "${brew_prefix}/etc/profile.d/bash_completion.sh"
    else
      for completion in "${brew_prefix}/etc/bash_completion.d/"*; do
        source_if_readable "${completion}"
      done
    fi
  done
  if declare -F _kube_contexts > /dev/null; then
    complete -F _kube_contexts kcontext
  fi
  if declare -F _kube_namespaces > /dev/null; then
    complete -F _kube_namespaces knamespace
  fi

  # completion helm
  if command_exists helm; then
    completion_cached helm helm completion bash
  fi

  # completion lima
  if command_exists limactl; then
    completion_cached limactl limactl completion bash
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

  if command_exists terraform; then
    complete -C "$(command -v terraform)" terraform
  fi

  # completion gcloud
  source_if_readable "$HOME/gcloud/google-cloud-sdk/completion.bash.inc" &> /dev/null

  # completion nvm (does not need nvm.sh itself)
  source_if_readable "${NVM_DIR}/bash_completion"

  # Ask bash to retry the completion now that the real definitions are loaded.
  return 124
}
complete -D -F load_completions

# Private bashrc
source_if_readable ~/.bashrc_private

source_if_readable "$HOME/.bash_completions/netcheck.sh"

## nvm
# Sourcing nvm.sh costs ~220ms. The default alias is `system`, so nvm puts
# nothing on PATH anyway -- node/npm come from Homebrew either way. Load it on
# first use instead; the shim replaces itself with the real function.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() {
    unset -f nvm
    \. "$NVM_DIR/nvm.sh"
    source_if_readable "$NVM_DIR/bash_completion"
    nvm "$@"
  }
fi
