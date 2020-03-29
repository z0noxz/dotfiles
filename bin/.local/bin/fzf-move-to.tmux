#!/bin/sh

sessions="$(tmux list-sessions)"

printf '%s\n' "$sessions"                                                   \
	| fzf-tmux                                                              \
		-d 35%                                                              \
		--exit-0                                                            \
		--cycle                                                             \
		--reverse                                                           \
		--no-preview                                                        \
	| sed -r 's/^([^:]*:).*/\1/g'                                           \
	| xargs -i sh -c 'tmux move-window -t {}99 && tmux move-window -r -t {}'
