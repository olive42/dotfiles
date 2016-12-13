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
# See man gpg-agent(1)
export GPG_TTY=$(tty)

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

# Ruby, Gem, Chef
eval "$(rbenv init -)"
# https://raw.githubusercontent.com/gma/bundler-exec/master/bundler-exec.sh
[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh
alias be='bundle exec'

# Get Centreon health for a given machine
# - Get machine name in some way (short host + prod|preprod ?)
# - Get node entry from ~/criteo/chef-devtools/nodes/...
# - extract line ^name 'xxx' => xxx
# - be knife centreon host get xxx
function centreon() {
    local h=${1:-jenkins01-par}
    local p=${2:-prod}
    local knife_opts=""
    if [[ $p = "prod" ]]; then
	knife_opts="-c.chef/knife-prod.rb"
    fi
    pushd ~/criteo/chef-repositories/chef-devtools

    for h1 in $(echo nodes/$p/**/$h*); do
	macname=$(awk -F"'" '/^name/ {print $2}' $h1)
	be knife centreon host get $macname $knife_opts
    done
    popd
}

function downtime() {
    local h=${1:-jenkins01-par}
    local d=${2:-"in 2 days"}
    local c=${3:-"I am too lazy to put a comment"}
    local p=${4:-prod}
    local knife_opts=""
    if [ $p = "prod" ]; then
        knife_opts="-c.chef/knife-prod.rb"
    fi
    pushd ~/criteo/chef-repositories/chef-devtools

    be knife centreon ${knife_opts} host downtime set --comment $c --to $d $h
    popd
}

# FIXME(olive): Config should be in a dict and the whole function
# should be in a better language.
function tmuxp() {
    sess1='criteo1'

    if [ $(tmux list-sessions -F '#{session_name}' | grep ${sess1}) ]; then
        tmux attach-session -d -t ${sess1}
    else
        proj1=build-configurations
        dir1=~/criteo/qa/${proj1}
        proj2=chef-devtools
        dir2=~/criteo/chef-repositories/${proj2}

        tmux new-session -s criteo1
        tmux new-window -c ${dir1} -n ${proj1}
        tmux split-window -h -t ${proj1} -c ${dir1}
        tmux new-window -c ${dir2} -n ${proj2}
        tmux split-window -h -t ${proj2} -c ${dir2}
        tmux select-window -t 0
    fi
}

alias windows='rdesktop -a 16 -z -P -g 1440x900 -u o.tharan -d PAR -x 0x20'
alias jindows='rdesktop -a 16 -z -P -g 1440x900 -u jenkins-node -x 0x20 -p -'

## End of local changes

autoload -U compinit
compinit

umask 022

autoload -U promptinit && promptinit
prompt pure

# end of .zshrc
