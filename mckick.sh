#! /bin/bash
# MINECRAFT KICK - MC server user manager script.
# Matt G | mattg.co.uk | @unnamedculprit on twitter
#
# Run up minecraft server in a named screen session first.
# any questions/additions/fixes lemme know :)
#

#VERSION
VER=1

usage()
{

  echo "Usage: `basename $0` -u username [-d delay(seconds)] [-n screen name]"
  echo ""
  echo "Minecraft Kick."
  echo "Version: $VER"
  echo "Matt G | mattg.co.uk | @unnamedculprit on twitter"
  echo ""
  echo "OPTIONS:"
  echo "-h show this message"
  echo "-u set username"
  echo "-d delay before kick IN SECONDS (min 60). Default value: 1 hour (3600s)"
  echo "-n name of Screen session MC is running in. Default value: MinecraftServer"
  echo "    example: `basename $0` -u unnamedculprit"
  echo "    example: `basename $0` -u unnamedculprit -d 600 -n MCServerScreen"
  echo ""
  echo "ABOUT:"
  echo "This script pardons a banned user on a minecraft server for a specified time and then bans them again."
  echo "It is intended to be used for time management, as it's way too easy to accidentally play for too long."
  echo "For this to work, Minecraft needs to be run in screen like so:"
  echo "screen -S MinecraftServer -c MINECRAFTDIR/screenrc java -Xmx200M -Xms200M -jar MINECRAFTDIR/minecraft_server.jar nogui"

}

USER=
DELAY=60
SCREENNAME=MinecraftServer

while getopts "hu:d:n:v" OPTION
do
    case $OPTION in
        h)
            usage
            exit 1
            ;;
        u)
            USER=$OPTARG
            ;;
        d)
            DELAY=$OPTARG
            ;;
        n)
            SCREENNAME=$OPTARG
            ;;
        v)
            usage
            exit
            ;;
        ?)
            usage
            exit
            ;;
    esac
done

#DELAY NEEDS TO BE -LT 60
if [[ -z $USER ]] || [[ -z SCREENNAME ]] || [[ $DELAY -lt 60 ]]
then
    usage
    exit 1
fi

echo "USER: $USER"
echo "DELAY: $DELAY"
echo "SCREENNAME: $SCREENNAME"
echo ""

echo "Pardoning $USER:"
screen -S $SCREENNAME -X stuff "say $USER is being allowed $DELAY on MC `echo -ne '\015'`"
screen -S $SCREENNAME -X stuff "pardon $USER`echo -ne '\015'`"

SLEEP=$(($DELAY - 30))
echo "Waiting $SLEEP seconds, will tell server, then kick 30s later"


sleep $SLEEP

echo "Warning server"
screen -S $SCREENNAME -X stuff "say $USER will be kicked in 30s. `echo -ne '\015'`"

sleep 30

echo "Kicking $USER"
screen -S $SCREENNAME -X stuff "kick $USER `echo -ne '\015'`"

echo "Banning $USER"
screen -S $SCREENNAME -X stuff "ban $USER `echo -ne '\015'`"

exit