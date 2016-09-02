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

path+=(/usr/local/bin ~/bin /usr/local/go/bin)
fpath+=(~/.zfunctions)

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

if [ -n "$INSIDE_EMACS" ]; then
    export ZSH_THEME="rawsyntax"
else
    export ZSH_THEME="robbyrussell"
fi

export GOPATH=/Users/olive/go

export BYOBU_PREFIX=$(brew --prefix)

# from brew install groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# See https://gist.github.com/christopheranderton/8644743 for how to
# create a Github token for Homebrew. This is sometimes necessary to
# avoid being throttled by GH
# Personal tokens are here: https://github.com/settings/tokens
export HOMEBREW_GITHUB_API_TOKEN=""
eval "$(rbenv init -)"

autoload -U compinit
compinit

umask 022

autoload -U promptinit && promptinit
prompt pure

# end of .zshrc
