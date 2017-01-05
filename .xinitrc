xrdb -merge /home/vlad/.Xresources
xbindkeys

setxkbmap -model pc104 -layout pl,ru -option grp:alt_shift_toggle

if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

session=${1:-xfce}
case $session in
	xfce ) exec startxfce4;;
	i3   ) exec i3;;
	*) exec i3;;
esac

xset r rate 300 50
