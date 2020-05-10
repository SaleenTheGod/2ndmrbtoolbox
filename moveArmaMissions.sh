#! /bin/bash

SCAN_DIR="/home/centos/"
DEST_DIR="/home/arma3server/serverfiles/mpmissions/"
count=`find $SCAN_DIR -name "*.pbo" | wc -l`

if [ $count != 0 ]
then 
    echo "New Arma Mission detected, moving to Arma server mpmissions folder and restarting."
    find $SCAN_DIR -iname "*.pbo" -exec mv {} $DEST_DIR \;
    sudo chown -R arma3server:arma3server $DEST_DIR
    sudo runuser -l arma3server -c '/home/arma3server/arma3server restart'
else
    echo "No new Arma missions detected in $SCAN_DIR"
fi