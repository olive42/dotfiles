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

fpath=( ~/.zfunctions "${fpath[@]}" )

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
# See man gpg-agent(1)
export GPG_TTY=$(tty)

autoload -U compinit
compinit

umask 022

# autoload -U promptinit && promptinit
# prompt pure
powerline-daemon -q
. /usr/share/powerline/bindings/zsh/powerline.zsh

export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
# TODO: put at the end
export PATH="$GEM_HOME/bin:/home/o.tharan/bin:/home/o.tharan/.local/bin:/usr/local/go/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# This does terrible things to PATH, GEM_HOME, GEM_PATH
#eval "$(chef shell-init zsh)"
# https://raw.githubusercontent.com/gma/bundler-exec/master/bundler-exec.sh
[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh
alias be='bundle exec'

# https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
# TODO(olive): just get the list of files in ~/.zfunctions?
autoload -Uz ilo ipmi pknife tmuxp toMac checkHealth rack

# rdesktop to Windows machines
alias windows='rdesktop -a 16 -z -P -g 1440x900 -u XXusernameXX -d XXdomainXX -x 0x20 -r clipboard:PRIMARYCLIPBOARD -p $(pass XXpasswordfileXX | head -1)'

alias kitchen-ec2='KITCHEN_YAML=".kitchen.ec2.yml" bundle exec kitchen'

# Not sure why this is here.
export GIT_SSH=$(which ssh)
alias gg='git grep'

# Fish-like completion suggestions
# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh.d/zsh-autosuggestions/zsh-autosuggestions.zsh

# end of .zshrc
