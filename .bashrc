# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# ~/.bashrc
# vim:enc=utf-8:nu:ft=sh:

# skip when non-interactive shell
[ -z "$PS1" ] && return

# colorize dir and ls
[ -f ~/.dircolors ] && eval `/bin/dircolors -b ~/.dircolors`

# bash options
#shopt -s checkwinsize       # update value of LINES and COLUMNS if altered after command
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s histappend         # append to the history file
shopt -s no_empty_cmd_completion    # don't search completions in PATH on an empty line

# advanced bash completion and with sudo
complete -cf sudo
[ -f /etc/bash_completion ] && source /etc/bash_completion

# set the titlebar in xterm/urxvt
case "$TERM" in
  xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\0033]0;${HOSTNAME} ${PWD/$HOME/~}\007"'
    ;;
  *)
    ;;
esac

# bash prompts
PS1="\[\033[37;1m\][\[\033[33;1m\]\u\[\033[37;1m\]@\[\033[32;1m\]\h\[\033[37;1m\]:\[\033[0;36m\]\w\[\033[37;1m\]]\[\033[m\]$ "
#PS1="\[\033[37;1m\][\[\033[m\]\u\[\033[37;1m\]@\[\033[m\]\h\[\033[37;1m\]:\[\033[m\]\w\[\033[37;1m\]]\[\033[m\]$ "
#PS1='[\u@\h \W]\$ '      # default prompt

# when connecting via SSH, start or reattach screen session
if [ -n "$SSH_CONNECTION" ] && [ -z "$SCREEN_EXIST" ]; then
  export SCREEN_EXIST=1
  screen -DR
fi

# linux console colors -------------------------------------

export TERM=xterm-256color

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P8505354" #darkgrey
    echo -en "\e]P1f92672" #darkred
    echo -en "\e]P9ff5995" #red
    echo -en "\e]P282b414" #darkgreen
    echo -en "\e]PAb6e354" #green
    echo -en "\e]P3fd971f" #brown
    echo -en "\e]PBfeed6c" #yellow
    echo -en "\e]P456c2d6" #darkblue
    echo -en "\e]PC8cedff" #blue
    echo -en "\e]P58c54fe" #darkmagenta
    echo -en "\e]PD9e6ffe" #magenta
    echo -en "\e]P6465457" #darkcyan
    echo -en "\e]PE899ca1" #cyan
    echo -en "\e]P7ccccc6" #lightgrey
    echo -en "\e]PFf8f8f2" #white
    clear # bring us back to default input colours
fi
clear

alias mountall='udisksctl mount -b /dev/sda1; udisksctl mount -b /dev/sda2' 
alias mount_u='sudo mount -o umask=000'
alias adb='~/Applications/android/SDK/platform-tools/adb'
alias android_studio='source ~/Applications/android-studio/bin/studio.sh'
alias monitor_setup='xrandr --output HDMI1 --mode 1920x1080; keyboard_setup.sh'
alias two_screens='xrandr --output HDMI1 --auto --output eDP1 --auto --left-of HDMI1'
alias sshlogin='ssh -v 97022413196@www.sds.uw.edu.pl'

alias rm="echo rm is disabled. Use del to move to trash, or use /bin/rm."
#alias del='mkdir ~/.trash/$(date +"%Y_%m_%d_%H_%M_%S"); mv -t $_'
alias del='safe_delete.sh'

alias org="vim -S ~/Documents/org.vim"

alias chrnex="chrome_launcher.py start && chromium --new-window --user-data-dir=/tmp/temp-profile --disable-extensions && chrome_launcher.py end;"

export SCALA_HOME=:/usr/share/scala/
export PATH=$PATH:$SCALA_HOME/bin

export ANDROID_HOME=${HOME}/Android/Sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools
export PATH=${PATH}:~/.scripts

#so as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon
