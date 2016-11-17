#!/bin/sh -e

# Make sure some directories exist
for d in ~/.zsh.d ~/.emacs.d/lisp ~/.zfunctions ~/.i3 ~/.config/dunst ~/.config/terminator ~/go ~/bin ~/tmp ; do
    mkdir -p $d
done

# TODO(olive): distinguish between Linux and MacOS
# TODO(olive): probably use $(hostname) as a git branch name and make sure we're in it before copying files. Maybe do this automatically back-n-forth? Maybe use UUID instead of hostname to make it more consistent?
# Copy files
ISDF=~/.initial-setup-done
if [ ! -f $ISDF ]; then
    for f in \
        .emacs.d/* \
            .gnus.el \
            .config/dunst/dunstrc \
            .config/terminator/config \
            .gitconfig \
            .i3/config \
            .i3/autostart \
            .i3status.conf \
            .irssi/config \
            .tmux.conf \
            .zfunctions/* \
            .zshrc \
        ; do
	cp $f ~/$(dirname $f)
    done
    touch $ISDF
fi
