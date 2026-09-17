sleep 1
DISPLAY=":0"
HOME=/home/vlad/
XAUTHORITY=$HOME/.Xauthority
export DISPLAY XAUTHORITY HOME
/usr/bin/bash /home/vlad/.scripts/keyboard_setup.sh 1> $HOME/out 2>$HOME/err
