#!/bin/bash - 
#===============================================================================
#
#          FILE: rembackup.sh
# 
#         USAGE: ./rembackup.sh <fqdn of server> 
# 
#   DESCRIPTION: Perform the OES2015 backups from a remote server, and move the
#                files to a central storage server.
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
#       CREATED: Tue Jan 26 2016 15:00
#  LAST UPDATED: Tue Feb 23 2016 13:02
#      REVISION: 4
#     SCRIPT ID: ---
# SSC UNIQUE ID: --
#===============================================================================
set -o nounset                                  # Treat unset variables as an error
version=0.1.4                                   # version number of the script
sid=000                                         # personal script id number
uid=00                                          # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
email=root                                      # who to send email to (comma separated list)
log='/var/log/rembackup.log'                    # logging (if required)
bkdir='/opt/supportconf/repo/oes2015_backups'

function helpme() { 
  echo "WARNING"
  echo "-------------------------------------------------------------------"
  echo "The correct command line syntax is ./rembackup.sh <FQDN of Server>"
  echo "for example: ./rembackup.sh acpic-s2007.ross.rossdev.rcmp-grc.gc.ca"
  echo "The script will now exit."
  echo "==================================================================="
  exit 1
}

if [ $# -lt 1 ]; then
  helpme
else
  # Move the backup files to a central location
  rsync --remove-source-files -a casadmin@$1:/home/backup/* $bkdir
fi

# Finished
exit 1

