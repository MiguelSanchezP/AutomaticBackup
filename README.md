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
## Installation
In order to make an optimal automatic backup, ssh-keys need to be defined between any two connections that are going to be done and the downloaded script either `RemoteScriptGenerator.sh` or `LocalScriptGenerator.sh` has to be defined as an executable. To achieve that `chmod +x` should be run followed by the script name.
- ### Machine to Server
If the files are to be copied directly from a machine to a server, only the script LocalScriptGenerator.sh should be executed on the desired machine (`./LocalScriptGenerator.sh`). It will prompt the user with some questions which generate the script that's going to execute. Once the script has ended, a backup script (`backup.sh`) is going to be executed everytime the user turns off the computer. For periodic backups, one may want to add the generated script to cron.
- ### Machine to Access Point to Server
If the files are to be copied during the day to an access point and at midnight to a file server, it can be done by executing the LocalScriptGenerator.sh (`./LocalScriptGenerator.sh`) and following the steps above on the machine. And by executing the ./RemoteScriptGenerator.sh (`./RemoteScriptGenerator.sh`) on the access point server, that will generate a backup.sh script that may be added to cron to run at midnight (`@midnight`). Note that this latter script uses a remote connection to shut the server down, and hence a user without confirmation may be specified.
