# AutomaticBackup
## Description
Linux scripts created with the aim of automatically performing a backup of given directories. Coded in shell the copy of the files is done through ssh and with the command rsync.
## Dependencies
### Local to Server
When connecting from a machine to the server, the following commands are used:
 - `rsync`
 - `ssh`
 ### Local to Access Point to Server
 - `rsync`
 - `ssh`
 - `wakeonlan`
 ### Telegram notification
 - `python3`
 - `python-telegram-bot`
## Installation
In order to make an optimal automatic backup, ssh-keys need to be defined between any two connections that are going to be done and the downloaded script either `RemoteScriptGenerator.sh` or `LocalScriptGenerator.sh` has to be defined as an executable. To achieve that `chmod +x` should be run followed by the script name.
- ### Machine to Server
If the files are to be copied directly from a machine to a server, only the script LocalScriptGenerator.sh should be executed on the desired machine (`./LocalScriptGenerator.sh`). It will prompt the user with some questions which generate the script that's going to execute. Once the script has ended, a backup script (`backup.sh`) is going to be executed everytime the user turns off the computer. For periodic backups, one may want to add the generated script to cron.
- ### Machine to Access Point to Server
If the files are to be copied during the day to an access point and at midnight to a file server, it can be done by executing the LocalScriptGenerator.sh (`./LocalScriptGenerator.sh`) and following the steps above on the machine. And by executing the ./RemoteScriptGenerator.sh (`./RemoteScriptGenerator.sh`) on the access point server, that will generate a backup.sh script that may be added to cron to run at midnight (`@midnight`). Note that this latter script uses a remote connection to shut the server down, and hence a user without confirmation may be specified, this can be achieved through changing the permissions of the command specified in `sudoers` file.
- ### Telegram notification
To receive a notification everytime the script executes, a telegram bot needs to be created. This is done through the bot `botfather` found in telegram, who at the end of the configuration would give a token that is unique to identify the bot. This token has to be specified during the execution of `RemoteScriptGenerator.sh`. Also the ID's of the users who are going to receive the notification have to be specified (those can be obtained through `userinfobot`. Lastly the chat with the created bot has to be started, otherwise the bot won't find the chat in where to send the notification.
## Pending things to do after script execution
- Add scripts to cron, in order to make the backups periodically, the scripts have to be scheduled through cron. Both the Remote and Local scripts have to be added, the Local script will make the backup at system shutdown by default, but it is recommended to run it with a smaller interval so that more recent files are always copied.
- Set telegram notification to run periodically, it has to be set some time after the backup script has been called, otherwise it would not check whether the backup has been done. This can be done by putting a greater time in cron, for example a lapse of an hour to be completely sure.
