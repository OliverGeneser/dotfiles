#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export QT_QPA_PLATFORMTHEME="qt5ct"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
