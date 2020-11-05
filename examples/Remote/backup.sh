#!/bin/bash
. /home/miguelsanchezp/.bashrc
rm /home/user1/.Logs/.backup-successful
date >> /home/user1/.Logs/.backup.log;
rm /home/user2/.Logs/.backup-successful
date >> /home/user2/.Logs/.backup.log;
if ! ping -q -w3 -c 1 static_ip
	then
		ISSERVEROFF=true;
else
	ISSERVEROFF=false;
fi
if $ISSERVEROFF = true
	then
		echo 'Initial server status off so turning on' >> /home/user1/.Logs/.backup.log;
		echo 'Initial server status off so turning on' >> /home/user2/.Logs/.backup.log;
		wakeonlan server_mac;
		while ! ping -q -c 1 static_ip;
			do
				sleep 1;
			done
fi
rsync -auv /home/user1/.Backup/ user1remote@static_ip:/home/user1remote/ >> /home/user1/.Logs/.backup.log;
rm -rv /home/user1/.Backup/* >> /home/user1/.Logs/.backup.log;
rsync -auv /home/user2/.Backup/ user2remote@static_ip:/home/user2remote/ >> /home/user2/.Logs/.backup.log;
rm -rv /home/user2/.Backup/* >> /home/user2/.Logs/.backup.log;
if $ISSERVEROFF = true
	then
		echo -e 'Turning server off \n----------------------------------------------------\n\n' >> /home/user1/.Logs/.backup.log;
		echo -e 'Turning server off \n----------------------------------------------------\n\n' >> /home/user2/.Logs/.backup.log;
		ssh -t user1remote@static_ip 'sudo shutdown now';
fi
touch /home/user1/.Logs/.backup-successful
touch /home/user2/.Logs/.backup-successful
