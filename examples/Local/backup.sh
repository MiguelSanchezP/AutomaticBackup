#!/bin/bash
. /home/username/.bashrc
find /path/to/directory/ -newermt `date +%F -d today` >> /home/username/.Backup/files.txt;
find /path/to/another/directory/ -newermt `date +%F -d today` >> /home/username/.Backup/files.txt;
sed -i -e 's/\/home\/username\///g' /home/username/.Backup/files.txt;
rsync -au --files-from=/home/username/.Backup/files.txt /home/username/ usernameremote@domain:/home/usernameremote/.Backup/;
rm /home/username/.Backup/files.txt;
