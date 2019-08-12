#!/bin/sh -eu

# make sure 'nrows' variable exist
tmux showenv nrows 1>&2 2>/dev/null || tmux setenv nrows 1
rows=$(tmux showenv nrows | sed 's|^.*=||')
rows=${rows:-1}

# read number of desired rows from input
input=${@:-}
if [ -n "$input" ]
then
    case "$input" in
    # increase row number
    '++') rows=$((rows + 1)) ;;

    # decrease row number
    '--') rows=$((rows - 1)) ;;

    # allow numeric input for row count
    *) [ $input -eq $input 2>/dev/null ] && rows=$input ;;
    esac
fi

# get some initial data
set -- $(tmux list-panes -F '#{pane_id}')
spane=$(tmux display -p '#{pane_id}')
hpane=$(tmux last-pane 2>/dev/null \;display -p '#{pane_id}' \;last-pane) || :
wd=$(tmux display -p '#{window_width}x#{window_height}')
ww=${wd%%x*}
wh=${wd##*x}

exec tmux $({

    n=$#

    [ $rows -lt 1 ] && rows=1                       # at least one row, please
    [ $n -lt $rows ] && rows=$n                     # never allow empty rows

    tmux setenv nrows $rows

    # counters
    ri=0; ci=0; uc=0; uw=0; uh=0

    # define first row
    cols=$((n / rows))                              # number of columns
    ch=$((wh / rows))                               # client/pane height
    uc=$cols                                        # utilized columns
    uh=$ch                                          # utilized height
    rs=""                                           # resolutions tracker

    # stack panes
    echo select-layout even-vertical

    # format panes in a grid
    for pid
    do
        if [ $ci -eq $cols ]
        then
            uw=0                                    # utilized width
            ci=0                                    # column index
            ri=$((ri + 1))                          # row index

            # next row
            cols=$(((n - uc) / (rows - ri)))
            uc=$((uc + cols))
            ch=$(((wh - uh) / (rows - ri)))
            uh=$((uh + ch))
        fi

        cw=$(((ww - uw) / (cols - ci)))             # client/pane width
        uw=$((uw + cw))
        rs="$rs$cw:$ch;"

        echo select-pane -t $pid

        # move pane if it's not first in the row
        if [ $ci -gt 0 ]
        then
            echo move-pane -d -s . -t .-1 -h
            echo resize-pane -t . -x $((cw - 1))
        fi

        ci=$((ci+1))
    done

    # resize panes in the new grid layout
    for pid
    do
        r="${rs%%;*}"                               # resolution
        w="${r%%:*}"                                # width
        h="${r##*:}"                                # height
        rs="${rs#*;}"

        echo resize-pane -t $pid -x $((w - 1)) -y $((h - 1))
    done

    # restore selection
    [ -n "$hpane" ] &&  echo select-pane -t $hpane
    echo select-pane -t $spane

} | sed 's/$/ ;/')
