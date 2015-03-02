nix?(){ nix-env -qa \* -P | fgrep -i "$1"; }

export PATH=/home/wfaler/bin:$PATH
export SBT_OPTS="-Xms512M -Xmx1536M -Xss128M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=768M"
export JAVA_HOME=$(javahome.sh)
#feh --bg-scale /home/wfaler/.settings/sandakan__borneo.jpg
setxkbmap -layout gb -variant mac
xscreensaver -no-splash &
