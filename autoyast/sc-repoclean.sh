#!/bin/bash - 
#===============================================================================
#
#          FILE: sc-repoclean.sh
# 
#         USAGE: ./sc-repoclean.sh 
# 
#   DESCRIPTION: script to cleanup the supportconfig repository of any 
#                supportconfig collections older than 7 days
#
#                Copyright (C) 2016  David Robb
#
#        GPL v2: This program is free software: you can redistribute it and/or
#                modify it under the terms of the GNU General Public License
#                as published by the Free Software Foundation; either version 2
#                of the License, or (at your option) any later version.
#
#                This program is distributed in the hope that it will be useful,
#                but WITHOUT ANY WARRANTY; without even the implied warranty of
#                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#                GNU General Public License for more details.
#
#                You should have received a copy of the GNU General Public License
#                along with this program; if not, write to the Free Software
#                Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.)
#
#       OPTIONS: Run script every day via cron on acpic-s2860, and acpic-s2657
#  REQUIREMENTS: ---
#          BUGS: Report bugs to David Robb, david.robb@microfocus.com, 613-793-2281
#         NOTES: ---
#        AUTHOR: David Robb (DER), david.robb@microfocus.com
#  CONTRIBUTORS: Jacques Guillemette (jacques.guillemette@ssc-spc.gc.ca)
#                Calvin Hamilton (calvin.hamilton@rcmp-grc.gc.ca)
#  ORGANIZATION: Micro Focus Software (Canada) Inc
#       CREATED: Thu Jan 08 2015 09:30
#  LAST UPDATED: Mon Jul 18 2016 13:23
#       VERSION: 4
#     SCRIPT ID: ---
# SSC UNIQUE ID: 9
#===============================================================================
set -o nounset                                  # Treat unset variables as an error
version=0.1.4                                   # version number of the script
sid=000                                         # personal script id number
uid=9                                           # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
email=root                                      # who to send email to (comma separated list)
log='/var/log/sc-repoclean.log'                 # logging (if required)

# Use find to create a list of old supportconfigs to delete and then delete them
/usr/bin/find /opt/supportconf/repo -maxdepth 1 -type f -mtime +6 -exec rm -f {} \;

# finished
exit 1

