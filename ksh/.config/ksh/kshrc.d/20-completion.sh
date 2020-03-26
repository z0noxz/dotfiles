#!/bin/sh

readonly _tmp_ksh_completion="/tmp/ksh_completion"
readonly _tmp_sv_list="$_tmp_ksh_completion/sv_list"
readonly _tmp_mpvc_cmds="$_tmp_ksh_completion/mpvc_cmds"
readonly _tmp_host_list="$_tmp_ksh_completion/host_list"
readonly _tmp_pkg_cmds="$_tmp_ksh_completion/pkg_cmds"
readonly _tmp_pass_list="$_tmp_ksh_completion/pass_list"
readonly _tmp_man_list="$_tmp_ksh_completion/man_list"
readonly _tmp_op_list="$_tmp_ksh_completion/op_list"

ksh_completion_load () {
    [ ! -d "$_tmp_ksh_completion" ] && mkdir -p "$_tmp_ksh_completion"
    [ ! -f "$_tmp_sv_list" ] && \
        ls -1 /var/service > "$_tmp_sv_list"
    [ ! -f "$_tmp_mpvc_cmds" ] && \
        mpvc | grep -e '^ [a-z]*' | grep -v -e '^[[:space:]]*$' | awk '{print $1;}' > "$_tmp_mpvc_cmds"
    [ ! -f "$_tmp_host_list" ] && \
        awk '{split($1,a,","); gsub("].*", "", a[1]); gsub("\\[", "", a[1]); print a[1] " root@" a[1]}' "$HOME/.ssh/known_hosts" | sort | uniq > "$_tmp_host_list"
    [ ! -f "$_tmp_pkg_cmds" ] && \
        pkg | grep -e '^ [a-z]*' | grep -v -e '^[[:space:]]*$' | awk '{print $1;}' > "$_tmp_pkg_cmds"
    [ ! -f "$_tmp_pass_list" ] && \
        find "$XDG_DATA_HOME/pass/" -type f | grep "gpg$" | sed 's/^.*\pass\///' | sed 's/\.gpg$//' > "$_tmp_pass_list"
    [ ! -f "$_tmp_man_list" ] && \
        man -k Nm~. | cut -d\( -f1 | tr -d , > "$_tmp_man_list"
    [ ! -f "$_tmp_op_list" ] && \
        operations list > "$_tmp_op_list"

    typeset _sv_list="$(cat "$_tmp_sv_list")"
    typeset _mpvc_cmds="$(cat "$_tmp_mpvc_cmds")"
    typeset _host_list="$(cat "$_tmp_host_list")"
    typeset _pkg_cmds="$(cat "$_tmp_pkg_cmds")"
    typeset _pass_list="$(cat "$_tmp_pass_list")"
    typeset _man_list="$(cat "$_tmp_man_list")"
    typeset _op_list="$(cat "$_tmp_op_list")"

    set -A complete_sv_1 -- reload restart start status stop
    set -A complete_sv_2 -- ${_sv_list}
    set -A complete_mpvc_1 -- ${_mpvc_cmds}
    set -A complete_ssh -- ${_host_list}
    set -A complete_pkg_1 -- ${_pkg_cmds}
    set -A complete_pass -- ${_pass_list} ls find show grep insert edit generate rm mv cp git help version
    set -A complete_operations_1 -- ${_op_list}
    set -A complete_make_1 -- clean install publish
    set -A complete_git_1 -- clone checkout commit pull push status

    case "$1" in
        # slow completion commands here
        full)
            set -A complete_man_1 -- ${_man_list}
        ;;
    esac
}

ksh_completion_reload () {
    rm -f "$_tmp_sv_list"
    rm -f "$_tmp_mpvc_cmds"
    rm -f "$_tmp_host_list"
    rm -f "$_tmp_pkg_cmds"
    rm -f "$_tmp_pass_list"
    rm -f "$_tmp_man_list"
    rm -f "$_tmp_op_list"

    ksh_completion_load
}

ksh_completion_load

# https://deftly.net/posts/2017-05-01-openbsd-ksh-tab-complete.html
