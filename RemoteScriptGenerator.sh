echo "#!/bin/bash" >> backup.sh;
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
		echo "date >> /home/"$u"/.backup.log;" >> backup.sh;
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
		echo -e "\t\techo 'Initial server status off so turning on' >> /home/"$u"/.backup.log;" >> backup.sh;
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
		echo "rsync -auv /home/"$u"/.Backup/ "$remote_username"@"$static_ip":/home/"$remote_username"/ >> /home/"$u"/.backup.log;" >> backup.sh;
		echo "rm -rv /home/"$u"/.Backup/* >> /home/"$u"/.backup.log;" >> backup.sh;
	done
echo -e "if \$ISSERVEROFF = true" >> backup.sh;
echo -e "\tthen" >> backup.sh;
for u in ${user[*]}
	do
		echo -e "\t\techo -e 'Turning server off \\\n----------------------------------------------------\\\n\\\n' >> /home/"$u"/.backup.log;" >> backup.sh;
	done
read -p "Write a remote username with privileges to shutdown the server without confirmation: " shutdown_user
echo -e "\t\tssh -t "$shutdown_user"@"$static_ip" 'sudo shutdown now';" >> backup.sh;
echo "fi" >> backup.sh;
echo "Make script executable";
chmod +x ./backup.sh;
echo "Now the backup script needs to be set to run at midnight through cron"
