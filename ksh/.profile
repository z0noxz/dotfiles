# set .kshrc as ENV if it exists
[ -f "$HOME/.kshrc" ] && export ENV="$HOME/.kshrc"

# setup XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# add local paths
export PATH="$PATH:$HOME/.bin:/xtra/bin"

# setup vimrc with XDG support
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
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

