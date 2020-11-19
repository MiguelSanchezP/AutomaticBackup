#!/bin/bash
. /home/username/.bashrc
date=`ssh -t remoteusername@domain cat /home/remoteusername/.Logs/.date.txt`;
find /path/to/directory/ -newermt $date >> /home/username/.Backup/files.txt;
find /path/to/another/directory/ -newermt $date >> /home/username/.Backup/files.txt;
sed -i -e 's/\/home\/username\///g' /home/username/.Backup/files.txt;
rsync -au --files-from=/home/username/.Backup/files.txt /home/username/ remoteusername@domain:/home/remoteusername/.Backup/;
ssh -t remoteusername@domain 'date +%F -d today > /home/remoteusername/.Logs/.date.txt';
rm /home/username/.Backup/files.txt;
