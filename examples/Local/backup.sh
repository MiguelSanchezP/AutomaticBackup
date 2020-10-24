#!/bin/bash
find /home/user/folder/ -newermt `date +%F -d today` >> /home/user/.Backup/files.txt;
sed -i -e 's/\/home\/user\///g' /home/user/.Backup/files.txt;
rsync -au --files-from=/home/user/.Backup/files.txt /home/user/ host:/home/user/.Backup/;
rm /home/user/.Backup/files.txt;


