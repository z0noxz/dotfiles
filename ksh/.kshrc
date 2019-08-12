#!/bin/ksh

# if not running interactively, don't do anything
[ "${-#*i}" = "${-}" ] && return

for sh in $HOME/.kshrc.d/*.sh
do
    . $sh
done
