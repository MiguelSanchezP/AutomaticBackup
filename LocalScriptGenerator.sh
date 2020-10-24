#!/bin/bash
echo "Welcome to the configuration of the remote backup service!!";
USER=`whoami`;
echo "#!/bin/bash" >> backup.sh;
answer="y";
while [ $answer = "y" ]
	do
		read -p "Write full path of directory to be backed up: " dir;
		echo -e "find "$dir" -newermt \`date +%F -d today\` >> /home/"$USER"/.Backup/files.txt;" >> backup.sh;
		read -p "Do you wish to add anohter directory [y/n]? " answer;
	done
echo "sed -i -e 's/\/home\/"$USER"\///g' /home/"$USER"/.Backup/files.txt;" >> backup.sh;
read -p "Write the ssh host in where to copy [user@host/alias]: " host;
read -p "Write the remote username in where to store files: " ruser;
echo "rsync -au --files-from=/home/"$USER"/.Backup/files.txt /home/"$USER"/ "$host":/home/"$ruser"/.Backup/;" >> backup.sh;
echo "rm /home/"$USER"/.Backup/files.txt;" >> backup.sh;
echo -e "\n";
echo "Make script executable";
chmod +x ./backup.sh;
echo "Setting script to run at shutdown";
sudo cp ./backup.sh /etc/rc6.d/K99_zzbackup;
echo "All set up. Thanks";
echo "Now the backup is only running on a computer shutdown, to run the script periodically add it to cron";
