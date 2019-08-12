#!/bin/sh

pane="$(tmux capture-pane -J -p)"
urls=$(
    echo "$pane"                                                            \
    | grep -oE '(https?|s?ftps?|telnet|file):/?//[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'
)
wwws=$(
    echo "$pane"                                                            \
    | grep -oE 'www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*'         \
    | sed 's/^\(.*\)$/http:\/\/\1/'
)
ips=$(
    echo "$pane"                                                            \
    | grep -oE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}(:[0-9]{1,5})?(/\S+)*' \
    | sed 's/^\(.*\)$/http:\/\/\1/'
)

printf '%s\n' "$urls" "$wwws" "$ips"                                        \
    | sort -u                                                               \
    | sed -r '/^\s*$/d'                                                     \
    | nl -w3 -s '  '                                                        \
    | fzf-tmux                                                              \
        -d 35%                                                              \
        --exit-0                                                            \
        --cycle                                                             \
        --reverse                                                           \
        --no-preview                                                        \
    | awk '{print $2}'                                                      \
    | xargs -n1 -I {} dmenu_url_open {} &>/dev/null || true
