#!/bin/bash
. /home/user/.bashrc;
if  ! ping -q -w3 -c 1 static_ip
	then
		ISSERVEROFF=true;
else
	ISSERVEROFF=false;
fi

if $ISSERVEROFF = true
	then
		wakeonlan mac_adress;
		while ! ping -q -c 1 static_ip;
		do sleep 1;
		done;
fi

rsync -auv /home/user/.Backup/ server:/home/user/;
rm -r /home/user/.Backup/*;

if $ISSERVEROFF = true
	then
		ssh -t server "sudo shutdown now";
fi
