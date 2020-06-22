#!/bin/bash

# Move the backup files to a central host
host=$(hostname)
chost=excs-s8189.excession.org
user=$(whoami)

# Use scp to move the files (shared keys need to be configured)
echo -e ""
echo -e "Moving backup files to a central host server"
echo "-----------------------------------------------------------"
echo -e "Files are being moved now to $chost"
/usr/bin/scp /home/backup/* root@${chost}:/data/oes2018-backups && rm -f /home/backup/*

echo -e "Files have been successfully moved to $chost and removed from $host."

#finished
exit 1
