#!/bin/bash

# Author: James Ambrose (Saleen/Serpico)
# Purpose: Automatic 2ndMRB Arma Server restart.
# Syntax: ./restartServer

echo "Checking if Arma server has crashed..."
STR="$(sudo runuser -l arma3server -c '/home/arma3server/arma3server details' | grep -ie Status)"
SUB="OFFLINE"

if [[ "$STR" == *"$SUB"* ]]; then
     echo "Arma server is offline, restarting..."
     sudo runuser -l arma3server -c '/home/arma3server/arma3server restart'
else
     echo "Arma server is online, nothing for me to do."
fi