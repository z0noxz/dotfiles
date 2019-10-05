# set .kshrc as ENV if it exists
[ -f "$HOME/.kshrc" ] && export ENV="$HOME/.kshrc"

# add local paths
export PATH="$PATH:$HOME/.bin:/xtra/bin"

export TERMINAL="/usr/local/bin/st"
export WM="dwm"

# To avoid potential situation where cdm(1) crashes on every TTY, here we
# default to execute cdm(1) on tty1 only, and leave other TTYs untouched.
if [ "$(tty)" = '/dev/tty1' ]
then
    [ -n "$CDM_SPAWN" ] && return
    # Avoid executing cdm(1) when X11 has already been started.
    [ -z "$DISPLAY$SSH_TTY$(pgrep xinit)" ] && exec cdm
fi

