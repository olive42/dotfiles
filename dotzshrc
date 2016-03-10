# .zshrc, <olivier@tharan.org>
# -*- shell -*-

# various options
# don't send SIGHUP to running jobs when quitting the shell
setopt \
    no_notify \
    no_hup \
    multios \
    no_chase_links \
    no_prompt_cr \
    bare_glob_qual \
    numeric_glob_sort

# shell history management
HISTFILE=~/.zsh.d/history
HISTSIZE=12000
SAVEHIST=10000
setopt \
  inc_append_history \
  hist_ignore_dups \
  hist_expire_dups_first \
  hist_reduce_blanks \
  hist_verify

# end of options

# I am proud of this prompt
#setopt prompt_subst
# vanity hostname used to be a thing to get around some crazy naming scheme with Ganeti. This is not so useful now.
[[ -f /etc/vanity-hostname ]] && vanity_hostname=" [%B$(< /etc/vanity-hostname | sed 's/.corp.google.com//')%b]"
PS1="%n@%2m$vanity_hostname: %d%(?..(%?%))
: %D{%Y:%m:%d} %T %#; "

path+=(~/bin)

bindkey -e
bindkey ' ' magic-space

# if command exec time (u+s) is greater than REPORTTIME, display this time
export REPORTTIME=2

# variables to use the system
# editor, used by many apps
export EDITOR="emacsclient -t -a vim"
export VISUAL=vim
export ALTERNATE_EDITOR=vim
export EMAIL=olivier@tharan.org

# less(1) options : color search patterns, case-insensitive search, verbose prompt, silent, raw chars, break long lines
export LESS='-giMq~'
export PAGER=less

# word delimiter in the shell (/ is missing from the default value)
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export ANSIBLE_INVENTORY=~/ansible-conf/ansible-hosts

autoload -U compinit
compinit

umask 022

# end of .zshrc
