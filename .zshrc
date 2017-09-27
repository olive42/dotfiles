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

# Autocompletion
setopt \
    always_to_end \
    complete_in_word

# shell history management
HISTFILE=~/.zsh.d/history
HISTSIZE=12000
SAVEHIST=10000
setopt \
  inc_append_history \
  hist_ignore_dups \
  hist_expire_dups_first \
  hist_ignore_space \
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

# autoload -U compinit
# compinit
source ~/.zsh.d/completion.zsh

umask 022

# autoload -U promptinit && promptinit
# prompt pure
# powerline-daemon -q
# . /usr/share/powerline/bindings/zsh/powerline.zsh

# Other way to set the prompt?
# https://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/
source ~/.zsh.d/prompt.zsh

export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
# TODO: put at the end
export PATH="$GEM_HOME/bin:~/bin:~/.local/bin:/usr/local/go/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# This does terrible things to PATH, GEM_HOME, GEM_PATH
#eval "$(chef shell-init zsh)"

export GIT_SSH=$(which ssh)

# Fish-like completion suggestions
# https://github.com/zsh-users/zsh-autosuggestions
source ~/.zsh.d/zsh-autosuggestions/zsh-autosuggestions.zsh

source ~/.zsh.d/alias.zsh

# end of .zshrc
