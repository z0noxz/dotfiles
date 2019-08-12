#=====================================#
#          Personnal aliases          #
#=====================================#
## TODO :: https://www.bigeekfan.com/post/20190315_refining_ksh_and_fzf/

# quickies
alias ..='cd ..'
alias :r='. ~/.kshrc'
alias :q='exit'

# source aliases into functions
for a in ~/.bin/alias/*; do
    unalias "${a##*/}"
    eval "${a##*/}() {
        . $a
    }"
done

# extra
alias websiteget="wget --random-wait -r -p -e robots=off -U mozilla"
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
