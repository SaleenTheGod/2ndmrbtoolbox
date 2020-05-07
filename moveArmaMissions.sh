#! /bin/bash

sudo mv *.pbo /home/arma3server/serverfiles/mpmissions/
sudo chown -R arma3server:users /home/arma3server/serverfiles/mpmissions/

if [ $1 = "restart" ]
then
    sudo runuser -l arma3server -c '/home/arma3server/arma3server restart'
fi
