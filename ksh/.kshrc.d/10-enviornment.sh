#!/bin/ksh

export VISUAL="vim"
export EDITOR="$VISUAL"
export BROWSER="/usr/local/bin/surf"
export IMG_VIEWER="/usr/local/bin/sxiv"
export PDF_VIEWER="/bin/zathura"
export HISTFILE="$HOME/.cache/ksh/history"
export REFER="$HOME/documents/data/refer.bib"
export GROFF_FONT_PATH="$HOME/.fonts/groff"
export RTV_BROWSER="$BROWSER -y surf_rtv"
export LESSHISTFILE="$HOME/.cache/less/history"
export FZF_DEFAULT_OPTS="--bind='K:up,J:down,H:preview-up,L:preview-down'"
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
