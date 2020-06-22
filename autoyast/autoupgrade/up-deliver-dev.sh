#!/bin/bash - 
#===============================================================================
#
#          FILE: up-deliver-dev.sh
# 
#         USAGE: ./up-deliver-dev.sh <fqdn of server> 
# 
#   DESCRIPTION: Deliver upgrade scripts to target servers in the CAS-DEV tree
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
#       CREATED: Tue Feb 23 2016 11:19
#  LAST UPDATED: Thu Mar 03 2016 07:50
#      REVISION: 1
#     SCRIPT ID: ---
# SSC UNIQUE ID: --
#===============================================================================
set -o nounset                                  # Treat unset variables as an error
version=0.1.1                                   # version number of the script
sid=000                                         # personal script id number
uid=00                                          # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
email=root                                      # who to send email to (comma separated list)
log='/var/log/up-deliver-dev.log'               # logging (if required)

function helpme() {
  echo ""
  echo "------------------------------------------------------------------------"
  echo "WARNING"
  echo "------------------------------------------------------------------------"
  echo "The correct command line syntax is ./up-deliver-dev.sh <FQDN of Server>"
  echo "for example: ./up-deliver-dev.sh acpic-s2861.ross.rossdev.rcmp-grc.gc.ca"
  echo "The script will now exit."
  echo "========================================================================"
  exit 1
}

function runas_check() {
  if [ $user != "casadmin" ]; then
    echo -e "You must be casadmin to run this script, but you are $user."
    echo -e "The script will now exit. please su to casadmin and try again."
    sleep 5
    exit 1
  fi
}

runas_check

if [ $# -lt 1 ]; then
  helpme
else
  # Copy the scripts to the target server
  /usr/bin/scp -q /home/casadmin/bin/oes_upgrade_check.pl $1:~/bin
  /usr/bin/scp -q /home/casadmin/bin/oescfgchk.sh $1:~/bin
  /usr/bin/scp -q /home/casadmin/bin/preupchk.sh $1:~/bin
  /usr/bin/scp -q /home/casadmin/bin/preupbk.sh $1:~/bin
  # Move the scripts to the correct locations
  ssh -t $1 << EOF
  sudo -u root mv /home/casadmin/bin/oes_upgrade_check.pl /opt/novell/oes-install/util/
  sudo -u root mv /home/casadmin/bin/*.sh /root/bin/
EOF
fi

# Finished
exit 1

