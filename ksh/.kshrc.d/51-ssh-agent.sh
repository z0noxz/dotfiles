#!/bin/ksh

export SSH_AUTH_SOCK="$HOME/.tmp/.ssh-agent"

[ -S "$SSH_AUTH_SOCK" ] && return

rm -f "$SSH_AUTH_SOCK"
ssh-agent -a "$SSH_AUTH_SOCK" 2>&1 >/dev/null
