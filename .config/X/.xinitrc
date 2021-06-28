~/.scripts/keyboard_setup.sh 2>&1
xrdb -merge ~/.config/X/.Xresources_light 2>&1

exec dbus-launch i3 2>&1
