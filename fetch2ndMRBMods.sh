#!/bin/bash

# Author: James Ambrose (Saleen/Serpico)
# Purpose: Automatic grabs an entire steam workshop nod collection for Arma 3 and downloads the mods to a directory specifed.
# Syntax: ./fetch2ndMRBMods STEAM_USERNAME STEAM_PASSWORD
# Requirements: steamcmd, rsync/rclone, curl

current_user=$(whoami)
steam_collection="https://steamcommunity.com/sharedfiles/filedetails/?id=2178755545" #2nd MRB mod collection
steam_game_id="107410" # Arma 3 ID
server_mod_dir="/home/arma3server/serverfiles/mods"
server_steamapps_dir="$server_mod_dir/steamapps/workshop/content/$steam_game_id"
server_steamapps_dir_content="$server_steamapps_dir/*"
depth=0
arma_server_cfg="/home/arma3server/lgsm/config-lgsm/arma3server/arma3server.cfg"

if [ -z "$1" ]
then
     echo "Steam username not found. Please follow the proper syntax of this script..."
     echo "./fetch2ndMRBMods STEAM_USERNAME STEAM_PASSWORD"
     exit 1
fi

if [ -z "$2" ]
then
     echo "Steam password not found. Please follow the proper syntax of this script..."
     echo "./fetch2ndMRBMods STEAM_USERNAME STEAM_PASSWORD"
     exit 1
fi

if [ "$current_user" != "arma3server" ]
then
     echo "You are not logged in as the \"arma3server\" user. Please attempt to login to that user by running the following..."
     echo "sudo su arma3server && cd ~"
     exit 1
else

     cd $server_steamapps_dir
     mv 583496184/ /tmp/583496184
     rm -rf $server_steamapps_dir_content
     mv /tmp/583496184 $server_steamapps_dir

     cd ~/steamcmd
     curl $steam_collection > source.html
     echo "./steamcmd.sh +login "$1" "$2" +force_install_dir $server_mod_dir/ \\" > moddownload.sh
     cat source.html \
     | grep -E "<div class=\"workshopItemPreviewHolder " \
     | sed 's/"><div class=.*//' \
     | sed 's/.*id=//' \
     | sed -e "s/^/+workshop_download_item $steam_game_id /" \
     | sed -e 's/$/ validate \\/' >> moddownload.sh
     echo "+quit" >> moddownload.sh
     sed -i '/583496184/d' ./moddownload.sh #CUP TERRIANS WILL TIME OUT
     chmod +x moddownload.sh
     ./moddownload.sh
     rm source.html
     rm moddownload.sh

     # Renaming the mods and moving them to where they need to be.
     cd "$server_mod_dir/steamapps/workshop/content/$steam_game_id/"
     rsync -r . $server_mod_dir -P
     cd "$server_mod_dir"

     #Rename all files in dirs to be lowercase. I hate bash...
     for x in $(find . -type d | sed "s/[^/]//g")
     do
          if [ ${depth} -lt ${#x} ]
          then
               let depth=${#x}
          fi
     done
     echo "the depth is ${depth}"
     for ((i=1;i<=${depth};i++))
     do
          for x in $(find . -maxdepth $i | grep [A-Z])
          do
               mv $x $(echo $x | tr 'A-Z' 'a-z')
          done
     done

     #gets all the server directory names in the current dir, and updates the arma3server.cfg file to look for the mods ingested
     DIR_ARRAY=()
     for dir in */
     do
          if [ ${dir::-1} != "steamapps" ]
          then
               echo "Found Directory ${dir}... adding to Arma mod config"
               DIR_ARRAY+="mods/${dir}\;"
          fi
     done

     sed -i '$ d' $arma_server_cfg
     echo "mods=\"${DIR_ARRAY[@]}\"" >> $arma_server_cfg


     chown -R arma3server:arma3server /home/arma3server
fi