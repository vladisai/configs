~/.scripts/keyboard_setup.sh

session=${1:-xfce}
case $session in
	xfce ) exec startxfce4;;
	i3   ) exec i3;;
	*) exec i3;;
esac
