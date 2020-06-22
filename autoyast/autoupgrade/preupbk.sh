#!/bin/bash - 
#===============================================================================
#
#          FILE: preupbk-0.1.0.sh
# 
#         USAGE: ./preupbk-0.1.0.sh 
# 
#   DESCRIPTION: Performs the required OES2015 pre-upgrade backups of /etc, /opt,
#                /var, /home, and /root
#
#                Copyright (C) 2016  David Robb
#
#        GPL v3: This program is free software: you can redistribute it and/or 
#                modify it under the terms of the GNU General Public License as
#                published by the Free Software Foundation, either version 3 of
#                the License, or (at your option) any later version.
#
#                This program is distributed in the hope that it will be useful,
#                but WITHOUT ANY WARRANTY; without even the implied warranty of
#                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#                GNU General Public License for more details.
#
#                You should have received a copy of the GNU General Public
#                License along with this program.  If not,
#                see <http://www.gnu.org/licenses/>. 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: Report bugs to David Robb, david.robb@microfocus.com, 613-793-2281
#         NOTES: ---
#        AUTHOR: David Robb (DER), david.robb@microfocus.com
#  CONTRIBUTORS: 
#  ORGANIZATION: Micro Focus
#       CREATED: Tue Jan 26 2016 08:41
#  LAST UPDATED: Thu Mar 03 2016 13:10
#      REVISION: 6
#     SCRIPT ID: ---
# SSC UNIQUE ID: --
#===============================================================================
set -o nounset                                  # Treat unset variables as an error
version=0.1.6                                   # version number of the script
sid=000                                         # personal script id number
uid=00                                          # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
dsp=$(date +'%A %B %d, %Y %Y')                  # special date/time stamp
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
email=calvin.hamilton@rcmp-grc.gc.ca            # who to send email to (comma separated list)
log='/var/log/preupbk.log'                      # logging (if required)
bkdir=/home/backup                              # local backup destination
rep=$bkdir/OES2015_Backup_report-$host.txt      # generated report name

# Generate a list of sockets for /opt and /var
find /opt -type s > /root/bin/opt_sockets.lst 2>/dev/null
find /var -type s > /root/bin/var_sockets.lst

echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "OES11 SP2 Backup Report" | tee -a $rep
echo -e "Host: $host" | tee -a $rep
echo -e "Date: $dsp" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep

# Prior to upgrading OES11 SP2 to OES2015 you must backup /etc/, /opt/, and /var/
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "Begining backup of /etc/" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/backup_etc_${host}_$(date +'%Y%m%d_%H%M').tbz /etc/*
echo -e "The backup of /etc/ has completed."  | tee -a $rep

# Backup /home, except /home/backup
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "Beginning backup of /home/" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/backup_home_${host}_$(date +'%Y%m%d_%H%M').tbz /home/* --exclude=home/backup
echo "Backup of /home/ is complete." | tee -a $rep

# Backup of /root
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "Beginning backup of /root/" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/backup_root_${host}_$(date +'%Y%m%d_%H%M').tbz /root/*
echo "Backup of /root/ is complete." | tee -a $rep

# Backup of /opt
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "Beginning backup of /opt/" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/backup_opt_${host}_$(date +'%Y%m%d_%H%M').tbz /opt/* --exclude=opt/novell/nss/mnt --exclude=opt/NAI --exclude=opt/scripts/os/isos --exclude-from=/root/bin/opt_sockets.lst
echo "Backup of /opt/ is complete." | tee -a $rep

# Backup of /var
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "Beginning backup of /var/" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/backup_var_${host}_$(date +'%Y%m%d_%H%M').tbz /var/* --exclude=var/opt/novell/eDirectory/data/dib --exclude=var/lib/ntp/proc --exclude=/var/spool --exclude=var/run --exclude=var/opt/novell/ganglia/rrds --exclude-from=/root/bin/var_sockets.lst
echo "Backup of /var/ is complete." | tee -a $rep

/bin/sleep 3

# Completion message
/usr/bin/clear
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo "OES2015 pre upgrade filesysten backups are complete" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo "OES2015 Pre upgrade filesystem backup requirements" | tee -a $rep
echo "have been met. The tar files will be moved to the" | tee -a $rep
echo "appropriate deployment server and stored under:" | tee -a $rep
echo "/opt/supportconf/repo/oes2015_backups"  | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo "The report can be found here: $rep" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo "" | tee -a $rep

# cleanup files
/bin/rm -f /root/bin/*.lst

# Finished
exit 1

