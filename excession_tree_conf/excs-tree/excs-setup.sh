#!/bin/bash - 
#===============================================================================
#
#          FILE: cluster-setup.sh
# 
#         USAGE: ./cluster-setup.sh 
# 
#   DESCRIPTION: Bash script to import ldif information into a new tree
#
#                Copyright (c) 2018, David Robb
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
#                Foundation, Inc., 51 Franklin Street, Fifth Floor, 
#                Boston, MA  02110-1301, USA.)
#
#       OPTIONS: ---
#  REQUIREMENTS: the file excs-tree.ldif must be in the correct location
#          BUGS: Report bugs to David Robb, david.robb@microfocus.com, 613-793-2281
#         NOTES: ---
#        AUTHOR: David Robb (DER), david.robb@microfocus.com
#  CONTRIBUTORS: 
#  ORGANIZATION: Micro Focus Software (Canada) Inc.
#       CREATED: Tue Aug 06 2013 09:00
#   LAST UDATED: Wed Jan 03 2018 14:44
#       VERSION: 0.1.8
#     SCRIPT ID: 000
# SSC SCRIPT ID: 00
#===============================================================================
version=0.1.8				# version number of the script
sid=000					# personal script ID
uid=00					# SSC | RCMP script ID
#===============================================================================
ts=$(date +"%b %d %T")			# general date|time stamp
ds=$(date +%a)				# short day of the week eg. Mon
df=$(date +%A)				# long day of the week eg. Monday
host=$(hostname)			# hostname of the local server
fqdn=$(hostname -f)			# fully qualified host name of local server
hip=$(hostname -i)      	        # IP Addr associated with hostname
lip=$(ifconfig | awk '/inet addr/{print substr($2,6)}' | grep -v 127) # local IP Addr
port=636				# LDAP secure port
tree=excs-tree				# nds tree name
org=excs				# organization name
adm=cn=admin,ou=services,o=excs		# administrator account
pswd=yellowStone!228			# administrator account password
srcfldr=/root/setup			# source folder for files
ldif=excs-tree.ldif			# name of ldif file to import
ndsbin=/opt/novell/eDirectory/bin	# path to nds binaries
user=$(whoami)				# who is running the script
email=					# email recipient(s)
log='/root/reports/ice-logs/excs-setup.log'	# log name and location (if required)
#===============================================================================

# Reminder for command line options
function helpme() { 
  echo ""
  echo "--[ Oops! ]-----------------------------"
  echo "You forgot to add the organization name"
  echo "to the command-line, try again ..."
  echo "The correct command line syntax is:"
  echo "./excs-setup.sh <organization name>"
  echo "for example ./excs-setup.sh $org"
  echo "========================================"
}

# Check to see if you are root
if [ $user != "root" ]; then
  echo ""
  echo "--[ Warning ]---------------------------"
  echo "You must be root to run this script."
  echo "The script will now exit. Please sudo to"
  echo "root, and run this script again."
  echo "========================================"
  exit 1
fi

# Create log directory
if [ -d ~/reports/ice-logs ]; then
  echo "Reports folder exists, continuing ..." > /dev/null
else
  mkdir -p ~/reports/ice-logs
fi

# Test that there are enough command-line arguments
if [ $# -lt 1 ]; then
  helpme
  exit 1
fi

# Test that ldif and other files are where they need to be
if [ -f $srcfldr/$ldif ]; then
  echo "File exists in the expected location, continuing ..." > /dev/null
else
  echo ""
  echo "--[ ldif missing ]----------------------"
  echo "The ldif file does not exist in the" 
  echo "expected location of $srcfldr."
  echo "Please correct this and try again"
  echo "========================================"
  exit 1	
fi

# Reminder to modify the source ldif files before running script
function reminder() { 
echo ""
echo "--[ Reminder ]--------------------------"
echo "Please remember that you might need to" 
echo "modify the $ldif file for the tree you"
echo "are setting up. If you have already done" 
echo "this, answer yes to the following"
echo "question:"
echo "========================================"
read -p "All files have been modified? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doit
  else
    echo "-------------------------------------------"
    echo -e "\n  Failing to plan is planning to fail!"
    echo -e "Please modify the file and try again."
    echo "-------------------------------------------"
    exit 1
  fi
}

# Use ice to import the contents of the ldif file specified on the command line
function doit() { 
if [ $# -lt 1 ]; then
  $ndsbin/ice -l $log -S LDIF -f $srcfldr/excs-tree.ldif -v -D LDAP -s ${hip} -p $port -L -d $adm -w $pswd -v
  sleep 3
  clear
  echo ""
  echo "--[ Success ]---------------------------"
  echo "The new nds tree has been populated with" 
  echo "containers, users and groups for" 
  echo "the $tree, enjoy."
  echo "========================================"
fi
}

reminder

# Finished
exit 1

