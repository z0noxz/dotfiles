#!/bin/ksh

umask 022               # umask (rwx r-x r-x)
set -o vi               # enable vi command-line mode
stty -ixon              # disable terminal scroll lock (fix for vim 'hang')
