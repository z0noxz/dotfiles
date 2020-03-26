#!/bin/ksh

export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# termcap   terminfo
# ks        smkx        make the keypad send commands
# ke        rmkx        make the keypad send digits
# vb        flash       emit visual bell
# mb        blink       start blink
# md        bold        start bold
# me        sgr0        turn off bold, blink and underline
# so        smso        start standout (reverse video)
# se        rmso        stop standout
# us        smul        start underline
# ue        rmul        stop underline

export LESS_TERMCAP_mb=$(tput setaf 7; tput bold)
export LESS_TERMCAP_md=$(tput setaf 7; tput bold)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput setaf 6; tput rev)
export LESS_TERMCAP_se=$(tput sgr0)
export LESS_TERMCAP_us=$(tput setaf 1; tput smul)
export LESS_TERMCAP_ue=$(tput sgr0)
