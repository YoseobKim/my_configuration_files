# $FreeBSD: release/10.0.0/share/skel/dot.profile 199243 2009-11-13 05:54:55Z ed $
#
# .profile - Bourne Shell startup script for login shells
#
# see also sh(1), environ(7).
#

# remove /usr/games if you want
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin; export PATH

# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
 TERM=xterm-256color; 	export TERM

BLOCKSIZE=K;	export BLOCKSIZE
EDITOR=vi;   	export EDITOR
PAGER=more;  	export PAGER

# set ENV to a file invoked each time sh is started for interactive use.
ENV=$HOME/.shrc; export ENV

if [ -x /usr/games/fortune ] ; then /usr/games/fortune freebsd-tips ; fi

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
#case $- in
#    *i*) ;;
#      *) return;;
#esac

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
alias gcc='gcc48'

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

# colored prompts
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
export CLICOLOR=yes

# colored make
colored_make(){
     make $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12 $13 2>&1 | sed -e 's%^.*: error: .*$%\x1b[37;41m&\x1b[m%' -e 's%^.*: warning: .*$%\x1b[30;43m&\x1b[m%' -e 's%^.*: fatal error: .*$%\x1b[37;41m&\x1b[m%' -e 's%^.*Error *$%\x1b[37;41m&\x1b[m%'

}

alias makec=colored_make

# print error only
alias makee='make -j5 | grep error'

# for correct git log output
export PAGER=less
export LOGIN_USER="root"
export YOSEOB_DEBUG="1"

alias sudo='sudo LD_LIBRARY_PATH=$LD_LIBRARY_PATH CU_HOME=$CU_HOME'

# korean
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

#colored ls
# FILE-TYPE =fb
# # where f is the foreground color
# # b is the background color
# # So to setup Directory color blue setup DIR to ex
# # Default for all
# # Color code (fb)
# # a     black
# # b     red
# # c     green
# # d     brown
# # e     blue
# # f     magenta
# # g     cyan
# # h     light grey
# # A     bold black, usually shows up as dark grey
# # B     bold red
# # C     bold green
# # D     bold brown, usually shows up as yellow
# # E     bold blue
# # F     bold magenta
# # G     bold cyan
# # H     bold light grey; looks like bright white
# # x     default foreground or background
#
# # search path for cd(1)
# # CDPATH=.:$HOME
# # Colour code
 DIR=Ex
 SYM_LINK=Gx
 SOCKET=Fx
 PIPE=dx
 EXE=Cx
 BLOCK_SP=Dx
 CHAR_SP=Dx
 EXE_SUID=Bx
 EXE_GUID=Bx
 DIR_STICKY=eg
 DIR_WO_STICKY=eg
# # Want to see fancy ls output? blank to disable it
 ENABLE_FANCY="-F"
#
export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"
#
# [ "$ENABLE_FANCY" == "-F" ] && alias ls=’ls -GF’ || alias ls=’ls -G’
#
# # now some handy stuff
# alias l=’ls’
# alias ll=’ls -laFo’
# alias lm=’ll|less’
alias ls='ls -FG'

git_add_untracked_files_to_local_ignore(){
    echo "Querying the list of files to add to $(git rev-parse --show-toplevel)/.git/info/exclude..."
    git ls-files --others --exclude-standard
    echo ""
    cd $(git rev-parse --show-toplevel)
    if [ ! -f .git/info/exclude ]; then
        git ls-files --others --exclude-standard &> $(git rev-parse --show-toplevel)/.git/info/exclude
    else
        git ls-files --others --exclude-standard >> $(git rev-parse --show-toplevel)/.git/info/exclude
    fi
    cd - &>/dev/null

    echo "Done."
}

git_status_with_new_files(){
    echo "New source files in git"
    find "$(git rev-parse --show-toplevel)" -cmin -1440 -and \( -name "*.cc" -or -name "*.h" -or -name "*.cpp" -or "CMakeLists.txt" \) | xargs git ls-files --others --exclude-standard
    echo ""
    echo "---------------"
    git status
}

alias gst=git_status_with_new_files
alias git_clean_untracked=git_add_untracked_files_to_local_ignore
alias gcu=git_add_untracked_files_to_local_ignore

alias git='LC_ALL=LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 git'

# auto jump
source /usr/local/share/autojump/autojump.bash
export PROMPT_COMMAND=$PROMPT_COMMAND"; history -a; history -n;"
