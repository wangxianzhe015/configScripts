#!/bin/bash

# This script is intended to run on new Ubuntu 
# Server VMs to assist in initial setup, including apt 
# upgrades and hostname changing.'

# This will be set up to run in the initial login script

# This script goes in: /usr/local/bin/setupserver
# Then add "setupserver" to .bash_login in main user's home

# Written by Ben Yanke
# https://github.com/benyanke

clear;
echo "#######################";
echo "New Server Setup Script";
echo "#######################";
echo ""        

# get current user
user=${SUDO_USER:-$(whoami)}

# Upgrade to root if it isn't already
if [ "$(whoami)" != "root" ]
then
    echo "Need to upgrade this session to root."
    echo ""
    
    sudo su -s "$0"
    exit
fi



notconfigHName="unconfiguredServer"

OLD_HOSTNAME="$( hostname )"


# Run Apt Update and Upgrade in the Background

{ apt-get update; apt-get install -y; apt dist-upgrade -y; dpkg --configure -a;  apt update; sudo apt install -f -y; apt upgrade -y; apt dist-upgrade -y; apt-get autoremove -y } >/dev/null 2>&1 &

# check for flag in temporary directory
if [ $notconfigHName = $OLD_HOSTNAME ] ; then

    echo ""

else
        echo "This server appears to be already configured."
        read -n1 -r -p "Would you like to continue to setup this server? [Y/N] " key
        echo " "

                if [ $key = "Y" ] || [ $key = "y" ]; then
                        echo " ";
                elif [ $key = "N" ] || [ $key = "n" ]; then
                        echo "Exiting.";
                        exit 0;
                else
                        echo "Not a recognized option. Exiting without modification.";
                        exit 1;
                fi
fi


NEW_HOSTNAME="$1"

if [ -z "$NEW_HOSTNAME" ]; then
 echo -n "Please enter new hostname: "
 read NEW_HOSTNAME < /dev/tty
fi


if [ -z "$NEW_HOSTNAME" ]; then
 echo "Error: no hostname entered. Exiting."
 exit 1
fi

echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."



# change hostname on system
hostname $NEW_HOSTNAME

# Change name in hosts file
cat /etc/hosts | sed s/$OLD_HOSTNAME/$NEW_HOSTNAME/ > /tmp/newhosts
mv /tmp/newhosts /etc/hosts

# Change name in hostname file
echo $NEW_HOSTNAME > /etc/hostname

# Remove bash login, which makes this script run every login
mkdir -p temp 2> /dev/null
mv /home/$user/.bash_login /home/$user/temp/old.bash_login   2> /dev/null

echo "Hostname successfully changed"
echo ""

echo "Your current IP addresses are: "

ip addr | awk '
/^[0-9]+:/ { 
  sub(/:/,"",$2); iface=$2 } 
/^[[:space:]]*inet / { 
  split($2, a, "/")
  print iface" : "a[1] 
}'

echo ""


echo "Waiting for background processes to complete."

# Wait for apt processes to complete
wait
echo ""
echo "Press any key to continue and reboot."
read nul




shutdown -r now
