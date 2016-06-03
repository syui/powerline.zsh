### prompt {{{

case $OSTYPE in
linux*)
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="<"
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="<<"
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=">"
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN=">>"
  TMUX_POWERLINE_GIT="|"
;;
darwin*)
  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"
  TMUX_POWERLINE_GIT="|"
;;
esac
setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt

export USER_PROMPT
PERIOD=5
function periodic_function1 () {
    USER_PROMPT=`w | grep user, | cut -d , -f 2` 
}
autoload -Uz add-zsh-hook
add-zsh-hook periodic periodic_function1

#function percmd_function1 () {
#    export USER_JULIUS
#    USER_JULIUS=`ps | grep julius | grep -v grep | wc -l | tr -d ' '`
#}
#autoload -Uz add-zsh-hook
#add-zsh-hook percmd percmd_function1

#function percmd_function2 () {
#    export USER_PROMPT
#    USER_PROMPT=`w | grep user, | cut -d , -f 2` 
#}
#autoload -Uz add-zsh-hook
#add-zsh-hook percmd percmd_function2

color256()
{
  local red=$1; shift
  local green=$2; shift
  local blue=$3; shift

  echo -n $[$red * 36 + $green * 6 + $blue + 16]
}

fg256()
{
  echo -n $'\e[38;5;'$(color256 "$@")"m"
}

bg256()
{
  echo -n $'\e[48;5;'$(color256 "$@")"m"
}

zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:hg:*' get-revision true
zstyle ':vcs_info:hg:*' use-simple true

autoload -Uz is-at-least
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "-"
zstyle ':vcs_info:git:*' unstagedstr "${TMUX_POWERLINE_GIT}"
zstyle ':vcs_info:*' actionformats '[%b|%a]'

zstyle ':vcs_info:git:*' formats '%{%k%f%}%F{black}%K{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%F{white}%K{green} %s %f%k%K{blue}%F{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{blue} %b %f%k%K{black}%F{blue}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{black} %c%u %f%k'

autoload -Uz vcs_info

prompt_bar_left_self="%{%F{white}%K{020}%} %n%{%k%f%}%{%F{white}%K{020}%}@%{%k%f%}%{%F{white}%K{020}%}%m %{%k%f%}%{%B%F{020}%K{020}%}%{%b%f%k%}%K{026}%F{blue}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%B%F{red}%K{026}%}  [%~]  %{%k%f%b%}%{%k%f%}%K{069}%F{026}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%(?.%F{white}%K{069}%} COMP %k%f.%B%K{069}%F{red}%} ERROR %b%k%f)%{%K{045}%F{069}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%F{white}%K{045}%} %h  %{%k%f%}%K{black}%F{045}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f"

prompt_bar_left="${prompt_bar_left_self} ${prompt_bar_left_status} ${prompt_bar_left_date}"
prompt_left='%{%F{white}%K{black}%}  $SHELL  %{%k%f%}%{%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%B%F{black}%K{white}%} %# ${p_buffer_stack} %{%b%k%f%f%}%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f '
#prompt_left='%F{white}%# >%f '

count_prompt_characters()
{
  print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}

update_prompt()
{
  local bar_left_length=$(count_prompt_characters "$prompt_bar_left")
  local bar_rest_length=$[COLUMNS - bar_left_length]
  local stash
  stash="stash "$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  local ahead
  ahead="push "$(git rev-list origin/master..master 2>/dev/null \
    | wc -l \
    | tr -d ' ')
  stash="%K{013}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{013}%} $stash %{%k%f%}%F{013}%K{blue}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{blue}%} $ahead %{%k%f%}%F{blue}%K{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}"
  local stad
  # stash を有効にする
  #stad=$stash
  local bar_left="$prompt_bar_left"$stad
  local bar_right_without_path="${prompt_bar_right:s/%d//}"
  local bar_right_without_path_length=$(count_prompt_characters "$bar_right_without_path")
  bar_right=${prompt_bar_right:s/%d/%(C,%${max_path_length}<...<%d%<<,)/}
  bar_right="%${bar_rest_length}<<${separator}${bar_right}%<<"
  prompt_bar_left_2="%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%F{black}%K{white}%} %l %K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{black}%}  $LANG  %{%k%f%}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}"

  PROMPT="${bar_left}${bar_right}${prompt_bar_left_2}"$'\n'"${prompt_left}"$'\n'"> "

  case "$TERM_PROGRAM" in
    Apple_Terminal)
      PROMPT="${PROMPT}"
      ;;
  esac

  LANG=C vcs_info >&/dev/null
  if [ -n "$vcs_info_msg_0_" ]; then
    PROMPT="${bar_left}${bar_right}${vcs_info_msg_0_}${prompt_bar_left_2}"$'\n'"${prompt_left}"
  fi
}

precmd_functions=($precmd_functions update_prompt)

### }}}

### vi-mode {{{
## prompt {{{
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if bindkey -lL main | cut -d ' ' -f 3 | grep emacs > /dev/null 2>&1;then
    EMACS_INSERT="%K{black}%F{011}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
    VIM_INSERT="%K{011}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
    EMACS_INSERT="%K{black}%F{034}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{034}%F{011} % $EMACS_INSERT %k%f"
    VIM_INSERT="%K{034}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
#VIM_INSERT="%K{034}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%%k%f"
RPROMPT="$EMACS_INSERT$VIM_INSERT"
function zle-keymap-select {
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if echo $EMACS_INSERT | grep emacs > /dev/null 2>&1;then
  EMACS_INSERT="%K{black}%F{011}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{011}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{011}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{034}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{034}%F{011} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{034}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{034}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
RPROMPT="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
zle reset-prompt
}
zle -N zle-keymap-select
## prompt }}}

# prompt-bindkey {{{
function airchrome-bindmode-emacs () {
bindkey -e
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if echo $EMACS_INSERT | grep emacs > /dev/null 2>&1;then
  EMACS_INSERT="%K{black}%F{011}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{011}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{011}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{011}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{011}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{011}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
RPS1="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
RPS2=$RPS1
zle reset-prompt
}
zle -N airchrome-bindmode-emacs
bindkey -v '^e' airchrome-bindmode-emacs
bindkey -a '^e' airchrome-bindmode-emacs

function airchrome-bindmode-vi () {
bindkey -v
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if echo $EMACS_INSERT | grep emacs > /dev/null 2>&1;then
  EMACS_INSERT="%K{black}%F{011}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{011}%F{034} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{011}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{011}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{034}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{034}%F{011} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{034}%F{125}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{125}%F{015} % NORMAL %k%f%K{125}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{034}%F{075}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{075}%F{026} % INSERT %k%f%K{075}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
RPS1="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
RPS2=$RPS1
zle reset-prompt
}
zle -N airchrome-bindmode-vi
bindkey -e '^v' airchrome-bindmode-vi
### }}}
### }}}
