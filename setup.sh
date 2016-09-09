#!/bin/sh -e

# Make sure some directories exist
for d in ~/.zsh.d ~/.emacs.d/lisp ~/.zfunctions ~/.i3 ; do
    mkdir -p $d
done

# TODO(olive): distinguish between Linux and MacOS
# Copy files
ISDF=~/.initial-setup-done
if [ ! -f $ISDF ]; then
    for f in .emacs.d/* .gitconfig .i3/config .i3status.conf .irssi/config .zfunctions/* .zshrc ; do
	cp $f ~/$(dirname $f)
    done
    touch $ISDF
fi
