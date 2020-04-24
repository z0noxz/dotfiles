#!/bin/ksh

export PS1="$(printf '[xxx]%s\[%s\]%s\[%s\] \\w%s \$ '                      \
	'$(_ksh_set_title)'                                                     \
	'$(tput bold)'                                                          \
	'$(tput sgr0)'                                                          \
	'$(_ksh_user_prompt)'                                                   \
	'$(_ksh_git_prompt)'                                                    \
)"

_ksh_var_hostname() {
	[ -z "$HOSTNAME" ] && HOSTNAME=$(hostname)
	printf "$HOSTNAME"
}

_ksh_user_prompt() {

	# abort if me and not an SSH connection
	[ $(id -u) == 1000 ] && [ -z "$SSH_CLIENT" ] && return

	 # print username (and hostname)
	 printf ' %s%s'                                                         \
		"$USER"                                                             \
		"$([ ! -z "$SSH_CLIENT" ] && echo "@$(_ksh_var_hostname)")"
}

_ksh_git_prompt() {

	# abort if not a git repository
	[ ! -f .git ] && [ ! -d .git ] && return

	# variable
	local branch=""
	local status=""
	local flags=""

	# collect necessary data
	branch="$(git branch 2>/dev/null | sed 's/* \(.*\)/\1/')"
	status="$(git status --short 2> /dev/null | cut -c1-3 | uniq)"

	# parse git status into flags
	[ "${status#* R}"   != "$status" ] && flags=">$flags"
	[ "${status#* A}"   != "$status" ] && flags="+$flags"
	[ "${status#*??}"   != "$status" ] && flags="?$flags"
	[ "${status#* D}"   != "$status" ] && flags="x$flags"
	[ "${status#* M}"   != "$status" ] && flags="!!$flags"
	[ ! "$flags" = "" ] && flags=" $flags"

	# print git prompt
	printf ' \[%s\](%s%s)\[%s\]'                                            \
		"$(tput setaf 3)"                                                   \
		"$branch"                                                           \
		"$flags"                                                            \
		"$(tput sgr0)"
}

_ksh_set_title() {
	# variable
	local term=""

	# collect necessary data
	term="$(cat /proc/$PPID/comm)"

	# set title
	printf '\[\033]2;%s (\w)\007\]' "${term##*/}"
}
