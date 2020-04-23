#!/bin/ksh

export PS1="$(printf '[xxx]%s\[%s\]%s\[%s\] \\w%s \$ '                      \
    '$(_ksh_set_title)'                                                     \
    '$(tput bold)'                                                          \
    '$(tput sgr0)'                                                          \
    '$(_ksh_user_prompt)'                                                   \
    '$(_ksh_git_prompt)'                                                    \
)"

_ksh_user_prompt() {

    # abort if me
    [ $(id -u) == 1000 ] && return

    # print username
    printf ' %s' "$(id -un)"
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
    status="$(git status 2> /dev/null)"

    # parse git status into flags
    [ "${status#*renamed:}"                 != "$status" ] && flags=">$flags"
    [ "${status#*Your branch is ahead of:}" != "$status" ] && flags="*$flags"
    [ "${status#*new file:}"                != "$status" ] && flags="+$flags"
    [ "${status#*Untracked files:}"         != "$status" ] && flags="?$flags"
    [ "${status#*deleted:}"                 != "$status" ] && flags="x$flags"
    [ "${status#*modified:}"                != "$status" ] && flags="!!$flags"
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
