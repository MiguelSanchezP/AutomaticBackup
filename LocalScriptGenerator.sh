#!/bin/bash
echo "Welcome to the configuration of the remote backup service!!";
USER=`whoami`;
mkdir /home/$USER/.Backup;
echo "#!/bin/bash" >> backup.sh;
echo ". /home/"$USER"/.bashrc" >> backup.sh;
read -p "Write the remote username in where to store files: " ruser;
read -p "Write the domain in where to copy the files: " host;
echo -e "date=\`ssh -t "$ruser"@"$host" cat /home/"$ruser"/.Logs/.date.txt\`;" >> backup.sh;
answer="y";
while [ $answer = "y" ]
	do
		read -p "Write full path of directory to be backed up: " dir;
		echo -e "find "$dir" -newermt \$date >> /home/"$USER"/.Backup/files.txt;" >> backup.sh;
		read -p "Do you wish to add anohter directory [y/n]? " answer;
	done
echo "sed -i -e 's/\/home\/"$USER"\///g' /home/"$USER"/.Backup/files.txt;" >> backup.sh;
echo "rsync -au --files-from=/home/"$USER"/.Backup/files.txt /home/"$USER"/ "$ruser"@"$host":/home/"$ruser"/.Backup/;" >> backup.sh;
echo "ssh -t "$ruser"@"$host" 'date +%F -d today > /home/"$ruser"/.Logs/.date.txt';" >> backup.sh;
echo "rm /home/"$USER"/.Backup/files.txt;" >> backup.sh;
echo -e "\n";
echo "Make script executable";
chmod +x ./backup.sh;
echo "Setting script to run at shutdown";
sudo cp ./backup.sh /etc/rc6.d/K99_zzbackup;
echo "All set up. Thanks";
echo -e "\nPENDING OPERATIONS:"
echo "· Now the backup is only running on a computer shutdown, to run the script periodically add it to cron";
echo "For more information look at README"
