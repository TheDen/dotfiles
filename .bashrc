###### ALIASES ######
alias ll="ls -alF"
alias htop="sudo htop"
alias xemacs="/Applications/Emacs.app/Contents/MacOS/Emacs" 
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias be="bundle exec"
alias gitroot='cd $(git rev-parse --show-toplevel)'

###### COLORS ######
export GREP_OPTIONS="--color"

###### HISTORY ######
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
#export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

###### PS1 ######
PS1="\[\033[0;31m\]$ \[\033[0m\]"
export PYTHONSTARTUP=~/.pythonrc
force_color_prompt=yes

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
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

###### Completion ######
complete -cf sudo
complete -cf man

# Git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# AWS completion
complete -C aws_completer aws n

## brew completion
if which brew >/dev/null 2>&1; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  if [ -f `brew --prefix`/Library/Contributions/brew_bash_completion.sh ]; then
    . `brew --prefix`/Library/Contributions/brew_bash_completion.sh
  fi
fi

#if [ -f $(brew --prefix)/etc/bash_completion ]; then
#  . $(brew --prefix)/etc/bash_completion
#fi

# ssh completion
export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_sshcomplete() {
  local CURRENT_PROMPT="${COMP_WORDS[COMP_CWORD]}"
  if [[ ${CURRENT_PROMPT} == *@*  ]] ; then
    local OPTIONS="-P ${CURRENT_PROMPT/@*/}@ -- ${CURRENT_PROMPT/*@/}"
  else
    local OPTIONS=" -- ${CURRENT_PROMPT}"
  fi

  # parse all defined hosts from .ssh/config
  if [ -r "$HOME/.ssh/config" ]; then
    COMPREPLY=($(compgen -W "$(grep ^Host "$HOME/.ssh/config" | awk '{for (i=2; i<=NF; i++) print $i}' )" ${OPTIONS}) )
  fi

  # parse all hosts found in .ssh/known_hosts
  if [ -r "$HOME/.ssh/known_hosts" ]; then
    if grep -v -q -e '^ ssh-rsa' "$HOME/.ssh/known_hosts" ; then
      COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( awk '{print $1}' "$HOME/.ssh/known_hosts" | grep -v ^\| | cut -d, -f 1 | sed -e 's/\[//g' | sed -e 's/\]//g' | cut -d: -f1 | grep -v ssh-rsa)" ${OPTIONS}) )
    fi
  fi

  # parse hosts defined in /etc/hosts
  if [ -r /etc/hosts ]; then
    COMPREPLY=( ${COMPREPLY[@]} $(compgen -W "$( grep -v '^[[:space:]]*$' /etc/hosts | grep -v '^#' | awk '{for (i=2; i<=NF; i++) print $i}' )" ${OPTIONS}) )
  fi

  return 0
}
complete -o default -o nospace -F _sshcomplete ssh

# npm (Node Package Manager) completion
#if command -v npm &>/dev/null
#then
#  eval "$(npm completion)"
#fi

# pip bash completion
_pip_completion()
{
  COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

# tl completionm
source <(tl _completion --generate-hook)

function _tl_8cdd0758dfcfdfdb_complete {


    local CMDLINE_CONTENTS="$COMP_LINE"
    local CMDLINE_CURSOR_INDEX="$COMP_POINT"
    local CMDLINE_WORDBREAKS="$COMP_WORDBREAKS";

    export CMDLINE_CONTENTS CMDLINE_CURSOR_INDEX CMDLINE_WORDBREAKS

    local RESULT STATUS;

    RESULT="$(/usr/local/bin/tl _completion)";
    STATUS=$?;

    local cur;
    _get_comp_words_by_ref -n : cur;


    if [ $STATUS -eq 200 ]; then
        _filedir;
        return 0;

    elif [ $STATUS -ne 0 ]; then
        echo -e "$RESULT";
        return $?;
    fi;

    COMPREPLY=(`compgen -W "$RESULT" -- $cur`);

    __ltrim_colon_completions "$cur";
};

complete -F _tl_8cdd0758dfcfdfdb_complete "tl";

# Azure completion
# azure --completion >> ~/azure.completion.sh
source ~/azure.completion.sh

# Golang completion

# Copyright (c) 2014 Kura MIT
function _go() {
  cur="${COMP_WORDS[COMP_CWORD]}"
  case "${COMP_WORDS[COMP_CWORD-1]}" in
    "go")
      comms="build clean doc env fix fmt get install list run test tool version vet"
      COMPREPLY=($(compgen -W "${comms}" -- ${cur}))
      ;;
    *)
      files=$(find ${PWD} -mindepth 1 -maxdepth 1 -type f -iname "*.go" -exec basename {} \;)
      dirs=$(find ${PWD} -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
      repl="${files} ${dirs}"
      COMPREPLY=($(compgen -W "${repl}" -- ${cur}))
      ;;
  esac
  return 0
}

complete -F _go go

# switch completion

_switch_bash_autocomplete() {
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$( ${COMP_WORDS[0]} --completion-bash ${COMP_WORDS[@]:1:$COMP_CWORD} )
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}
complete -F _switch_bash_autocomplete switch

###### Golang Paths ######
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
