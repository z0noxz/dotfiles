#!/bin/sh

# make sure in tmux
[ ! -n "$TMUX" ] && return

# make sure in shell
_TTY=$(tmux display -p "#{pane_tty}" | sed "s=/dev/==")
[ "$(pgrep -at$_TTY | grep -v "${SHELL##*/}")" ] && return

# make sure HISTFILE is set
if [ ! -n "$HISTFILE" ]
then
	HISTFILE="$HOME_CACHE_HOME/ksh/history"
fi

# get command from history file
_CMD="$(cat "$HISTFILE"                                                     \
	| sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -e '/^[[:space:]]*$/d'          \
	| sort -u                                                               \
	| fzf-tmux)"

# send keys to current session
tmux send-keys "$_CMD"
tmux send-keys "enter"
