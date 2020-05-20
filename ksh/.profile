# setup XDG environment variables
test -z "$XDG_DATA_HOME" && export XDG_DATA_HOME="$HOME/.local/share"
test -z "$XDG_CONFIG_HOME" && export XDG_CONFIG_HOME="$HOME/.config"
test -z "$XDG_DATA_DIRS" && export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"
test -z "$XDG_CONFIG_DIRS" && export XDG_CONFIG_DIRS="/etc/xdg"
test -z "$XDG_CACHE_HOME" && export XDG_CACHE_HOME="$HOME/.cache"
test -z "$XDG_RUNTIME_DIR" && export XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime-dir"

# this is a window manager, not a desktop environment
export XDG_DESKTOP_DIR="$HOME/"

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
export ADB_VENDOR_KEY="$XDG_CONFIG_HOME/android"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export DIALOGRC="$XDG_CONFIG_HOME/dialog/dialogrc"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESSHISTFILE=-
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
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
export WM="dwm"
export TERMINAL="/usr/local/bin/st"
export VISUAL="vim"
export EDITOR="$VISUAL"
export BROWSER="/usr/local/bin/surf"
export IMG_VIEWER="/usr/local/bin/sxiv"
export PDF_VIEWER="/bin/zathura"
export FZF_DEFAULT_OPTS="--bind='K:up,J:down,H:preview-up,L:preview-down'"
export REFER="$HOME/documents/data/refer.bib"
export GROFF_FONT_PATH="$XDG_DATA_HOME/fonts/groff"
export GREP_COLORS="\
ms=01;31:\
mc=01;31:\
sl=:\
cx=:\
fn=01;37:\
ln=32:\
bn=32:\
se=36"
export LS_COLORS="\
no=00:\
fi=00:\
di=01;34:\
ln=01;36:\
pi=40;33:\
so=01;36:\
do=01;36:\
bd=40;33;01:\
cd=40;33;01:\
or=40;31;01:\
mi=01;05;37;41:\
su=37;41:\
sg=30;43:\
ca=30;41:\
tw=30;42:\
ow=34;42:\
st=37;44:\
ex=01;32:\
\
*.tar=01;31:\
*.tgz=01;31:\
*.svgz=01;31:\
*.arj=01;31:\
*.taz=01;31:\
*.lzh=01;31:\
*.lzma=01;31:\
*.zip=01;31:\
*.z=01;31:\
*.Z=01;31:\
*.dz=01;31:\
*.gz=01;31:\
*.bz2=01;31:\
*.tbz2=01;31:\
*.bz=01;31:\
*.tz=01;31:\
*.deb=01;31:\
*.rpm=01;31:\
*.jar=01;31:\
*.rar=01;31:\
*.ace=01;31:\
*.zoo=01;31:\
*.cpio=01;31:\
*.7z=01;31:\
*.rz=01;31:\
\
*.jpg=01;36:\
*.jpeg=01;36:\
*.gif=01;36:\
*.bmp=01;36:\
*.pbm=01;36:\
*.pgm=01;36:\
*.ppm=01;36:\
*.tga=01;36:\
*.xbm=01;36:\
*.xpm=01;36:\
*.tif=01;36:\
*.tiff=01;36:\
*.ff.bz=01;36:\
*.ff.gz=01;36:\
*.ff.xz=01;36:\
*.png=01;36:\
*.mng=01;36:\
*.pcx=01;36:\
*.mov=01;36:\
*.mpg=01;36:\
*.mpeg=01;36:\
*.m2v=01;36:\
*.mkv=01;36:\
*.ogm=01;36:\
*.mp4=01;36:\
*.m4v=01;36:\
*.mp4v=01;36:\
*.vob=01;36:\
*.qt=01;36:\
*.nuv=01;36:\
*.wmv=01;36:\
*.asf=01;36:\
*.rm=01;36:\
*.rmvb=01;36:\
*.flc=01;36:\
*.avi=01;36:\
*.fli=01;36:\
*.gl=01;36:\
*.dl=01;36:\
*.xcf=01;36:\
*.xwd=01;36:\
*.yuv=01;36:\
*.svg=01;36:\
*.pdf=01;36:\
\
*.aac=00;36:\
*.au=00;36:\
*.flac=00;36:\
*.mid=00;36:\
*.midi=00;36:\
*.mka=00;36:\
*.mp3=00;36:\
*.mpc=00;36:\
*.ogg=00;36:\
*.ra=00;36:\
*.wav=00;36:\
"

# To avoid potential situation where cdm(1) crashes on every TTY, here we
# default to execute cdm(1) on tty1 only, and leave other TTYs untouched.
if [ "$(tty)" = '/dev/tty1' ]; then
	[ -n "$CDM_SPAWN" ] && return
	# Avoid executing cdm(1) when X11 has already been started.
	[ -z "$DISPLAY$SSH_TTY$(pgrep xinit)" ] && exec cdm
fi
