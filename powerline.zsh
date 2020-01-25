### prompt {{{
# https://github.com/syui/powerline.zsh
# https://github.com/syui/ricomoon

case $OSTYPE in
	linux*)
	  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
	  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD=""
	  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
	;;
	darwin*)
	  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD=""
	  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
	;;
esac

if [ -f ~/.local/share/fonts/ricomoon.ttf ];then
	export phoenix=""
	export phoenix_gen=""
	export archlinux=""
	export archlinuxjp=""
	export icon_good=""
	export icon_bad=""
	export icon_directory=""
	export icon_github=""
	export icon_git=""
	export icon_power=""
	export icon_git_branch=""
	export icon_git_st=""
	export icon_git_un=""
	export icon_git_ac=""
	export icon_os=${archlinux}
  export icon_ai=""
	export icon_tag=""
	export icon_linux=""
	export icon_hearts=""
	export icon_moon=""
	export icon_game=""
	export icon_code=""
	export icon_term=""
	export icon_twitter=""
	export icon_mastodon=""
	export icon_keybase=""
	export icon_heroku=""
	export icon_gitlab=""
	export icon_slack=""
	export icon_mail=""
	export icon_load=""
	export icon_music=""
	export icon_list=""
	export icon_git_push=${icon_download}
	export icon_git_merge=${icon_download}
	export icon_git_fork=${icon_upload}
  export TMUX_POWERLINE_GIT_BRANCH_ST=${icon_git_branch}
	export TMUX_POWERLINE_GIT_BRANCH=${icon_git_commit}

	if [ -n "$SSH_CONNECTION" ];then
		export icon_user="%F{cyan}${phoenix}%f"
	else
		export icon_user="%F{black}${phoenix}%f"
	fi

	case $OSTYPE in
		darwin*)
			export icon_os=""
			;;
		linux*)
			os_name=`cat /etc/os-release|head -n 1|cut -d '"' -f 2`
			if [ "$os_name" = "Arch Linux" ];then
				export icon_os=${archlinux}
		  else
				export icon_os=${icon_linux}
			fi
			;;
		windows*)
			export icon_os=""
			;;
		android*)
			export icon_os=""
			;;
	esac

fi

setopt prompt_subst
setopt prompt_percent
setopt transient_rprompt
export USER_PROMPT
export PERIOD=5
function periodic_function1 () {
    USER_PROMPT=`w | grep user, | cut -d , -f 2` 
}
autoload -Uz vcs_info 
autoload -Uz add-zsh-hook
add-zsh-hook periodic periodic_function1

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
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{red}${icon_git_st}%f "
zstyle ':vcs_info:git:*' unstagedstr "%F{cyan}${icon_git_un}%f "
zstyle ':vcs_info:git:*' actionformats "${icon_git_ac} (%s)-[%b|%a] %m"
zstyle ':vcs_info:git:*' formats '%{%k%f%}%F{black}%K{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%F{white}%K{green} ${icon_git} ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %s ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %r ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %m%a %f%k%K{yellow}%F{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{yellow} %b %f%k%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{black} %c%u %f%k'

zstyle ':vcs_info:git+set-message:*' hooks \
	git-hook-begin \
	git-untracked \
	git-push-status \
	git-nomerge-branch \
	git-config-user \
	git-stash-count
function +vi-git-config-user(){
	local ahead
        #ahead=$(git rev-list origin/master..master 2>/dev/null | wc -l | tr -d ' ')
        ahead=$(git --no-pager shortlog -sn |tr -d ' '|cut -f 1 | head -n 1)
	local stash
	stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
	local vcsh
	vcsh=$(git remote -v)
	if echo ${vcsh} | grep github > /dev/null 2>&1;then
		hook_com[misc]+="${icon_github} `git config user.name`"
	elif echo ${vcsh} | grep heroku > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_heroku} `git config user.name`"
	elif echo ${vcsh} | grep gitlab > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_gitlab} `git config user.name`"
	elif echo ${vcsh} | grep gitea > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_ai} `git config user.name`"
	fi

	if [[ "$ahead" -gt 0 ]]; then
		hook_com[misc]+=" ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} ${icon_git_push}${icon_list} ${ahead}"
	fi
	if [[ "$stash" -gt 0 ]]; then
		hook_com[misc]+=" ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} ${icon_git_commit} ${stash}"
	fi
	if [[ "${hook_com[branch]}" != "master" ]]; then
		hook_com[branch]+=" %F{magenta}${icon_git_branch}%f"
	else
		hook_com[branch]+=" ${icon_git_branch}"
	fi
}

precmd() { vcs_info }  

prompt_bar_left_self="%{%B%F{black}%K{white}%} %~ %{%k%f%b%}%k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%(?.%F{black}%K{white}%} ${icon_good} %k%f.%B%K{white}%F{red}%} ${icon_bad} %b%k%f)%{%K{white}%F{black} %k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%F{black}%K{white}%} ${icon_os}  %k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f"

prompt_bar_left="${prompt_bar_left_self}"
prompt_left="%{%F{white}%K{black}%} ${SHELL} %(?.%{%k%f%}%{%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%B%F{black}%K{white}%} %# ${p_buffer_stack} %{%b%k%f%f%}%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f.%{%k%f%}%{%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%B%F{white}%K{magenta}%} %# ${p_buffer_stack} %{%b%k%f%f%}%K{black}%F{magenta}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f)  "
prompt_left='%F{white} %n@%m [%#]>%f '
#${SHELL##*/}
count_prompt_characters()
{
  print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}

update_prompt()
{
  #local bar_left_length=$(count_prompt_characters "$prompt_bar_left")
  #local bar_rest_length=$[COLUMNS - bar_left_length]
  #local stash
  #stash="stash "$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  #local ahead
  #ahead="push "$(git rev-list origin/master..master 2>/dev/null \
  #  | wc -l \
  #  | tr -d ' ')
  #stash="%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{magenta}%} $stash %{%k%f%}%F{magenta}%K{blue}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{blue}%} $ahead %{%k%f%}%F{blue}%K{magenta}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}"
  #local stad
  local bar_left="$prompt_bar_left"$stad
  local bar_right_without_path="${prompt_bar_right:s/%d//}"
  local bar_right_without_path_length=$(count_prompt_characters "$bar_right_without_path")
  bar_right=${prompt_bar_right:s/%d/%(C,%${max_path_length}<...<%d%<<,)/}
  bar_right="%${bar_rest_length}<<${separator}${bar_right}%<<"
  prompt_bar_left_2="%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} ${icon_user}  %k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f"
  #PROMPT="${bar_left}${bar_right} ${prompt_bar_left_2}"$'\n'"${prompt_left}"
  PROMPT="${bar_left}${bar_right} ${prompt_bar_left_2}"$'\n'"${prompt_left}"

  case "$TERM_PROGRAM" in
    Apple_Terminal)
      PROMPT="${PROMPT}"
      ;;
  esac

  LANG=C vcs_info >&/dev/null
  if [ -n "${vcs_info_msg_0_}" ]; then
    PROMPT="${bar_left}${bar_right}${vcs_info_msg_0_}${prompt_bar_left_2}"$'\n'"${prompt_left}"
  fi
}

precmd_functions=($precmd_functions update_prompt)

### }}}

### vi-mode {{{
## prompt {{{
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if bindkey -lL main | cut -d ' ' -f 3 | grep emacs > /dev/null 2>&1;then
    EMACS_INSERT="%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{yellow}%F{green} % $EMACS_INSERT %k%f"
    VIM_INSERT="%K{yellow}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
    EMACS_INSERT="%K{black}%F{green}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{green}%F{yellow} % $EMACS_INSERT %k%f"
    VIM_INSERT="%K{green}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
RPROMPT="$EMACS_INSERT$VIM_INSERT"
function zle-keymap-select {
EMACS_INSERT=`bindkey -lL main | cut -d ' ' -f 3`
if echo $EMACS_INSERT | grep emacs > /dev/null 2>&1;then
  EMACS_INSERT="%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{yellow}%F{green} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{yellow}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{yellow}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{green}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{green}%F{yellow} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{green}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{green}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
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
  EMACS_INSERT="%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{yellow}%F{green} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{yellow}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{yellow}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{yellow}%F{green} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{yellow}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{yellow}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
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
  EMACS_INSERT="%K{black}%F{yellow}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{yellow}%F{green} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{yellow}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{yellow}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
else
  EMACS_INSERT="%K{black}%F{green}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{green}%F{yellow} % $EMACS_INSERT %k%f"
  VIM_NORMAL="%K{green}%F{magenta}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{magenta}%F{white} % NORMAL %k%f%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
  VIM_INSERT="%K{green}%F{cyan}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f%K{cyan}%F{white} % INSERT %k%f%K{cyan}%F{black}${TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}%k%f"
fi
RPS1="$EMACS_INSERT${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
RPS2=$RPS1
zle reset-prompt
}
zle -N airchrome-bindmode-vi
bindkey -e '^v' airchrome-bindmode-vi
### }}}
### }}}
