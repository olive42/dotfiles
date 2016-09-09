#!/bin/sh

echo Files differences:
for f in $(git ls-tree --full-tree -r HEAD --name-only); do
    if [ -f ~/$f ]; then
	diff -q $f ~/$f
    fi
done
