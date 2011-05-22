#! /bin/bash
# MINECRAFT KICK - MC server user manager script.
# Matt G | mattg.co.uk | @unnamedculprit on twitter
#
# Run up minecraft server in a named screen session first.
# any questions/additions/fixes lemme know :)
#
# commands are sent into minecraft by 'stuff'ing through screen.

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

# Set defaults
USER=
DELAY=60
SCREENNAME=MinecraftServer

# Get options, deal with them
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

# Check if input is sufficient
if [[ -z $USER ]] || [[ -z SCREENNAME ]] || [[ $DELAY -lt 60 ]]
then
    usage
    exit 1
fi

# Reiterate what the user typed in, in case the user is stupid.
echo ""
echo "User: $USER"
echo "Delay (seconds): $DELAY"
echo "Screen session name: $SCREENNAME"
echo ""
echo ""

echo "Pardoning $USER:"
# tell everyone on the server what's happening
screen -S $SCREENNAME -X stuff "say $USER is being allowed $DELAYs on MC `echo -ne '\015'`"
# pardon the user
screen -S $SCREENNAME -X stuff "pardon $USER`echo -ne '\015'`"

#take 30s off the delay time to include warning
SLEEP=$(($DELAY - 30))
echo "Waiting $SLEEP seconds, will tell server, then kick 30s later"

sleep $SLEEP

#with 30s to go, warn server occupants what is about to happen
echo "Warning server"
screen -S $SCREENNAME -X stuff "say $USER will be kicked and banned in 30s. `echo -ne '\015'`"

sleep 20

echo "Bye Bye $USER"
screen -S $SCREENNAME -X stuff "say Bye bye $USER! `echo -ne '\015'`"

sleep 10

echo "Kicking $USER"
screen -S $SCREENNAME -X stuff "kick $USER `echo -ne '\015'`"

echo "Banning $USER"
screen -S $SCREENNAME -X stuff "ban $USER `echo -ne '\015'`"

echo "Insult $USER behind $USER's back"
screen -S $SCREENNAME -X stuff "say I didn't like $USER anyway `echo -ne '\015'`"

exit