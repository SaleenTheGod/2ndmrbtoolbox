#! /bin/bash

if [ -z "$1" ]
then
    sudo mv *.pbo /home/arma3server/serverfiles/mpmissions/
    sudo chown -R arma3server:users /home/arma3server/serverfiles/mpmissions/
else
    if [ $1 = "restart" ]
    then
        sudo mv *.pbo /home/arma3server/serverfiles/mpmissions/
        sudo chown -R arma3server:users /home/arma3server/serverfiles/mpmissions/   
        sudo runuser -l arma3server -c '/home/arma3server/arma3server restart'
    fi
fi

