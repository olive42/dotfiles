# https://raw.githubusercontent.com/gma/bundler-exec/master/bundler-exec.sh
[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh
alias be='bundle exec'

# https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
# TODO(olive): just get the list of files in ~/.zfunctions?
autoload -Uz centreon downtime gitpushupto ilo ipmi pknife tmuxp toMac checkHealth rack

# rdesktop to Windows machines
alias windows='rdesktop -a 16 -z -P -g 1440x900 -u o.tharan -d PAR -x 0x20 -r clipboard:PRIMARYCLIPBOARD -p $(pass xxx | head -1)'

alias gg='git grep'

alias startvm=vboxmanage startvm chef-workstation --type headless
alias stopvm=vboxmanage controlvm chef-workstation poweroff
