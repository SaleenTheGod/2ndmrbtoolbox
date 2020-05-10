#! /bin/bash

count=`ls -1 /home/centos/*.pbo 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
    echo "New Arma Mission detected, moving to Arma server mpmissions folder and restarting."
    sudo mv /home/centos/*.pbo /home/arma3server/serverfiles/mpmissions/
    sudo chown -R arma3server:users /home/arma3server/serverfiles/mpmissions/   
    sudo runuser -l arma3server -c '/home/arma3server/arma3server restart'
fi 
