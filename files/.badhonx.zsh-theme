local current_dir='%{$fg_bold[red]%}[%{$reset_color%}%~%{$fg_bold[red]%}]%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="
%(?,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[blue]%}BADHONX%{$fg_bold[cyan]%}]%{$fg_bold[cyan]%}-%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%} ${git_branch}
%{$fg_bold[cyan]%} └────╼%{$fg_bold[yellow]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} ,%{$fg_bold[cyan]%} ┌─╼%{$fg_bold[cyan]%}[%{$fg_bold[green]%}%(5~|%-1~/…/%2~|%4~)%{$fg_bold[cyan]%}]%{$reset_color%}
%{$fg_bold[cyan]%} └╼%{$fg_bold[cyan]%} ❯%{$fg_bold[blue]%}❯%{$fg_bold[cyan]%}❯%{$reset_color%} )"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Git prompt function (required for git_prompt_info)
function git_prompt_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

setopt PROMPT_SUBST

bindkey '^R' history-incremental-search-backward

# Timer for command execution tracking
typeset -g timer
typeset -g timer_show

preexec() {
  if [[ $1 =~ ^(bash|sh|python|python3|nano|vim|vi|open|pkg|apt|php) ]] && [[ $(echo $1 | wc -w) -ge 2 ]]; then
    timer=${timer:-$SECONDS}
  fi
}

precmd() {
  # Command execution time calculation
  if [[ $timer ]]; then
    timer_show=$((SECONDS - timer))
    
    local hours=$((timer_show / 3600))
    local minutes=$(( (timer_show % 3600) / 60 ))
    local seconds=$((timer_show % 60))
    
    local elapsed_str=""
    
    if [[ $hours -gt 0 ]]; then
      if [[ $minutes -gt 0 ]]; then
        elapsed_str="%F{blue}Run time:%f %F{cyan}${hours}%f h %F{cyan}${minutes}%f m"
      else
        elapsed_str="%F{blue}Run time:%f %F{cyan}${hours}%f h"
      fi
    elif [[ $minutes -gt 0 ]]; then
      if [[ $seconds -gt 0 ]]; then
        elapsed_str="%F{blue}Run time:%f %F{cyan}${minutes}%f m %F{cyan}${seconds}%f s"
      else
        elapsed_str="%F{blue}Run time:%f %F{cyan}${minutes}%f m"
      fi
    else
      elapsed_str="%F{blue}Run time:%f %F{cyan}${seconds}%f s"
    fi

    RPROMPT='%F{green}[%f⏱%F{green}]%f ${elapsed_str}'
    unset timer
  else
    # Default RPROMPT with time
    RPROMPT='%F{green}[%f%F{green}]%f %F{cyan}%D{%L:%M:%S}%f%F{white} - %f%F{cyan}%D{%p}%f'
  fi
  
  # Reset timer for next command
  timer=${timer:-$SECONDS}
}
