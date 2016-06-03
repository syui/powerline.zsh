### prompt {{{
# https://github.com/syui/powerline.zsh
# https://github.com/syui/ricomoon

case $OSTYPE in
	linux*)
	  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
	  #TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="◀"
	  #TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="▶"
	  #TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
	  #TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"
	;;
	darwin*)
	  TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	  TMUX_POWERLINE_SEPARATOR_LEFT_THIN="❮"
	  TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="❯"
	;;
esac

if [ -f ~/.local/share/fonts/Ricomoon.ttf ];then
	export phoenix=""
	export phoenix_gen=""
	export archlinux=""
	export archlinuxjp=""
	export icon_good=""
	export icon_bad=""
	export icon_directory=""
	export icon_github=""
	export icon_git=""
	export icon_power=""
	export icon_lan=""
	export icon_wan=""
	export icon_lock=""
	export icon_git_branch=""
	export icon_git_commit=""

	if [ -n "$SSH_CONNECTION" ];then
		export icon_user_ssh="%F{cyan}%K{red}${phoenix_gen}%f%k"
		export icon_user="%F{cyan}%K{red}${phoenix}%f%k"
		#if echo $SSH_CLIENT | grep '192.168' > /dev/null 2>&1;then
		#	export icon_user="${icon_user} ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} ${icon_lan}"
		#else
		#	export icon_user="${icon_user} ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} ${icon_wan}"
		#fi
	else
		export icon_user_ssh="${phoenix}"
		export icon_user=${phoenix}
	fi

	export icon_os=${archlinux}
	export icon_mem=""

	case $OSTYPE in
		darwin*)
			export icon_os=""
			;;
		linux*)
			export icon_os=${archlinux}
			;;
		windows*)
			export icon_os=""
			;;
		android*)
			export icon_os=""
			;;
	esac

	export icon_off=""
	export icon_on=""
	export icon_ime=""
	export icon_bat=""
	export icon_bookmark=""
	export icon_hdd=""
	export icon_rocket=""
	export icon_tag=""
	export icon_linux=""
	export icon_code=""
	export icon_twitter=""
	export icon_dropbox=""
	export icon_download=""
	export icon_upload=""
	export icon_battery=""
	export icon_volume=""
	export icon_usb=""
	export icon_bluetooth=""
	export icon_bitbucket=""
	export icon_heroku="H"
	export icon_bluemix="B"
	export icon_gitlab="L"
	export icon_slack=""
	export icon_mail=""
	export icon_mobile=""
	export icon_notepc=""
	export icon_keyboard=""
	export icon_heart=""
	export icon_time=""
	export icon_home=""
	export icon_open=""
	export icon_userone=""
	export icon_load=""
	export icon_reload=""
	export icon_music=""
	export icon_music_re=""
	export icon_music_re=""
	export icon_music_ra=""
	export icon_git_push=${icon_download}
	export icon_git_merge=${icon_download}
	export icon_git_fork=${icon_upload}
  	export TMUX_POWERLINE_GIT_BRANCH_ST=${icon_git_branch}
	export TMUX_POWERLINE_GIT_BRANCH=${icon_git_commit}
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
zstyle ':vcs_info:git:*' stagedstr "%F{red}${icon_git_branch}%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{cyan}${icon_git_commit}%f"
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a] %m'
zstyle ':vcs_info:git:*' formats '%{%k%f%}%F{black}%K{yellow}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%F{magent}%K{yellow} ${icon_git} ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %s ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %r ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %m%a %f%k%K{green}%F{yellow}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{green} %b %f%k%K{black}%F{green}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%%F{white}%K{black} %c%u %f%k'

zstyle ':vcs_info:git+set-message:*' hooks \
                                        git-hook-begin \
                                        git-untracked \
                                        git-push-status \
                                        git-nomerge-branch \
				        git-config-user \
                                        git-stash-count
function +vi-git-config-user(){
  	#hook_com[misc]+=`git config user.email`
	local ahead
        ahead=$(git rev-list origin/master..master 2>/dev/null | wc -l | tr -d ' ')
	local stash
	stash=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
	local vcsh
	vcsh=$(git remote -v)
	if echo ${vcsh} | grep github > /dev/null 2>&1;then
		hook_com[misc]+="${icon_github} `git config user.name`"
	elif echo ${vcsh} | grep bitbucket > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_bitbucket} `git config user.name`"
	elif echo ${vcsh} | grep heroku > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_heroku} `git config user.name`"
	elif echo ${vcsh} | grep gitlab > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_gitlab} `git config user.name`"
	elif echo ${vcsh} | grep bluemix > /dev/null 2>&1;then 
		hook_com[misc]+="${icon_bluemix} `git config user.name`"
	fi

        if [[ "$ahead" -gt 0 ]]; then

		hook_com[misc]+=" ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} ${icon_git_push} ${ahead}"
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

prompt_bar_left_self="%{%F{white}%K{magent}%} ${icon_user} ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN} %n%{%k%f%}%{%F{white}%K{magent}%}@%{%k%f%}%{%F{white}%K{magent}%}%m %{%k%f%}%{%B%F{blue}%K{blue}%}%{%b%f%k%}%K{blue}%F{magent}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%B%F{white}%K{blue}%}  ${icon_directory} %~ %{%k%f%b%}%{%k%f%}%K{cyan}%F{blue}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%(?.%F{white}%K{cyan}%} ${icon_good} %k%f.%B%K{cyan}%F{magent}%} ${icon_bad} %b%k%f)%{%K{white}%F{cyan}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%F{black}%K{white}%} ${icon_os}  %k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} %h %{%k%f%}%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f"

prompt_bar_left="${prompt_bar_left_self} ${icon_user_ssh} ${prompt_bar_left_status} ${prompt_bar_left_date}"
prompt_left="%{%F{white}%K{black}%} ${SHELL} %(?.%{%k%f%}%{%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%B%F{black}%K{white}%} %# ${p_buffer_stack} %{%b%k%f%f%}%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f.%{%k%f%}%{%K{magenta}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%B%F{white}%K{magenta}%} %# ${p_buffer_stack} %{%b%k%f%f%}%K{black}%F{magenta}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f)  "
#prompt_left='%F{white}%#>%f '
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
  prompt_bar_left_2="%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD} ${icon_heart} %k%f%K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%K{white}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%F{black}%K{white}%} %l %K{black}%F{white}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}%k%f%{%k%f%}%{%F{white}%K{black}%} $LANG %{%k%f%}%F{black}${TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}"

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
