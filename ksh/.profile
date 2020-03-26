# setup XDG environment variables
test -z "$XDG_DATA_HOME" && export XDG_DATA_HOME="$HOME/.local/share"
test -z "$XDG_CONFIG_HOME" && export XDG_CONFIG_HOME="$HOME/.config"
test -z "$XDG_DATA_DIRS" && export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"
test -z "$XDG_CONFIG_DIRS" && export XDG_CONFIG_DIRS="/etc/xdg"
test -z "$XDG_CACHE_HOME" && export XDG_CACHE_HOME="$HOME/.cache"
test -z "$XDG_RUNTIME_DIR" && export XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime-dir"

# create XDG_RUNTIME_DIR if non-existent
if ! test -d "${XDG_RUNTIME_DIR}"; then
	mkdir "${XDG_RUNTIME_DIR}"
	chmod 0700 "${XDG_RUNTIME_DIR}"
fi

# set kshrc as ENV if it exists
[ -f "$XDG_CONFIG_HOME/ksh/kshrc" ] && export ENV="$XDG_CONFIG_HOME/ksh/kshrc"

# add local paths
export PATH="$PATH:$HOME/.local/bin:/xtra/bin"

# setup pseudo XDG support
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESSHISTFILE=-
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

# setup miscellaneous environment variables
export TERMINAL="/usr/local/bin/st"
export WM="dwm"

# To avoid potential situation where cdm(1) crashes on every TTY, here we
# default to execute cdm(1) on tty1 only, and leave other TTYs untouched.
if [ "$(tty)" = '/dev/tty1' ]; then
	[ -n "$CDM_SPAWN" ] && return
	# Avoid executing cdm(1) when X11 has already been started.
	[ -z "$DISPLAY$SSH_TTY$(pgrep xinit)" ] && exec cdm
fi
