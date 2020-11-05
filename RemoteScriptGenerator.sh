echo "Welcome to the remote script generator!!";
echo "#!/bin/bash" >> backup.sh;
echo ". /home/`whoami`/.bashrc" >> backup.sh;
answer="y";
user_num=0;
while [ $answer = "y" ]
	do
		read -p "Username in which to perform backup: " user[user_num];
		((user_num++));
		read -p "Do you wish to add another username [y/n]: " answer;
	done

for u in ${user[*]}
	do
		echo "rm /home/"$u"/.Logs/.backup-successful" >> backup.sh;
		echo "date >> /home/"$u"/.Logs/.backup.log;" >> backup.sh;
	done
read -p "Server's static IP address: " static_ip;
echo "if ! ping -q -w3 -c 1 "$static_ip >> backup.sh;
echo -e "\tthen" >> backup.sh;
echo -e "\t\tISSERVEROFF=true;" >> backup.sh;
echo "else" >> backup.sh;
echo -e "\tISSERVEROFF=false;" >> backup.sh;
echo "fi" >> backup.sh;
echo -e "if \$ISSERVEROFF = true" >> backup.sh;
echo -e "\tthen" >> backup.sh;
for u in ${user[*]}
	do
		echo -e "\t\techo 'Initial server status off so turning on' >> /home/"$u"/.Logs/.backup.log;" >> backup.sh;
	done
read -p "Server's MAC address: " mac
echo -e "\t\twakeonlan "$mac";" >> backup.sh;
echo -e "\t\twhile ! ping -q -c 1 "$static_ip";" >> backup.sh;
echo -e "\t\t\tdo" >> backup.sh;
echo -e "\t\t\t\tsleep 1;" >> backup.sh;
echo -e "\t\t\tdone" >> backup.sh;
echo "fi" >> backup.sh;
for u in ${user[*]}
	do
		read -p "Write the remote username for '"$u"' username: " remote_username;
		echo "rsync -auv /home/"$u"/.Backup/ "$remote_username"@"$static_ip":/home/"$remote_username"/ >> /home/"$u"/.Logs/.backup.log;" >> backup.sh;
		echo "rm -rv /home/"$u"/.Backup/* >> /home/"$u"/.Logs/.backup.log;" >> backup.sh;
	done
echo -e "if \$ISSERVEROFF = true" >> backup.sh;
echo -e "\tthen" >> backup.sh;
for u in ${user[*]}
	do
		echo -e "\t\techo -e 'Turning server off \\\n----------------------------------------------------\\\n\\\n' >> /home/"$u"/.Logs/.backup.log;" >> backup.sh;
	done
read -p "Write a remote username with privileges to shutdown the server without confirmation: " shutdown_user
echo -e "\t\tssh -t "$shutdown_user"@"$static_ip" 'sudo shutdown now';" >> backup.sh;
echo "fi" >> backup.sh;
read -p "Are you willing to set up a telegram bot to notify when the script has been executed [y/n]: " telegram;
if [ $telegram = "y" ]
	then
		echo "import telegram" >> confirmation.py;
		echo "import os.path" >> confirmation.py;
		echo -e "import sys\n" >> confirmation.py;
		read -p "Write here the telegram bot token: " token;
		echo "bot = telegram.Bot('"$token"')" >> confirmation.py;
		echo -e "usernames = [\c" >> confirmation.py;
		for u in ${user[*]}
			do
				echo -e "['"$u"', \c" >> confirmation.py;
				answer="y";
				while [ $answer = "y" ]
					do
						read -p "Telegram ID to send notification from username "$u": " receiver;
						echo -e "'"$receiver"', \c" >> confirmation.py;
						read -p "Do you wish to add another receiver [y/n]: " answer;
					done
				echo -e "], \c" >> confirmation.py;
			done
		echo "]" >> confirmation.py;
		echo "if sys.argv[1] == 'backup':" >> confirmation.py;
		echo -e "\tfor username in usernames:" >> confirmation.py;
		echo -e "\t\tif os.path.isfile('/home/'+username[0]+'/.Logs/.backup-successful'):" >> confirmation.py;
		echo -e "\t\t\tfor i in range(1, len(username)):" >> confirmation.py;
		echo -e "\t\t\t\tbot.send_message(chat_id=username[i], text='Backup success on username '+username[0])" >> confirmation.py;
		echo -e "\t\telse:" >> confirmation.py;
		echo -e "\t\t\tbot.send_message(chat_id=username[i], text='Backup failure on username '+username[0])" >> confirmation.py;
fi
for u in ${user[*]}
	do
		echo "touch /home/"$u"/.Logs/.backup-successful" >> backup.sh;
	done

echo "Make script executable";
chmod +x ./backup.sh;
echo -e "\nPENDING OPERATIONS:"
echo "· The backup script needs to be set to run at midnight through cron.";
echo "· If created, the python script also needs to be set up to run through cron, some time after the backup script";
echo "· Initialize the chats on the devices with the telegram bot"
echo "For more information look at README"
echo "Thanks!";
