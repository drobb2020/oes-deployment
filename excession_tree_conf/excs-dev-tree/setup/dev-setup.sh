#!/bin/bash
REL=0.1-6
##############################################################################
#
#    excs-setup.sh - Bash script to import ldif information into a new tree
#    Copyright (C) 2012  David Robb
#
##############################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################
# Date Created: Tue Aug 06 09:00:00 2013
# Last updated: Tue Jun 30 08:56:13 2015 
# Crontab command: Not recommended
# Supporting file: 1-<tree>-containers.ldif
##############################################################################
HOST=$(hostname)
ID=$(whoami)
PORT=636
ADM=cn=admin,ou=services,o=dev
PWD=yellowStone!228
SRCFLDR=/root/setup
LOG=/root/reports/ice-logs/dev-setup.log
NDSBIN=/opt/novell/eDirectory/bin

# Reminder for command line options
function helpme() { 
	echo "--[ Help ]------------------------------"
	echo "The correct command line syntax is:"
	echo "./dev-setup.sh <organization name>"
	echo "for example ./dev-setup.sh dev"
	echo "========================================"
}

# Check to see if you are root
if [ $ID != "root" ]
    then
	echo "You must be root to run this script, exiting ..."
	exit 1
fi

# Create log directory
if [ -d ~/reports/ice-logs ]
    then
	echo "Reports folder exists, continuing ..." > /dev/null
    else
	mkdir -p ~/reports/ice-logs
fi

# Test that there are enough command-line arguments
if [ $# -lt 1 ]
    then
	echo "You forgot to add the organization name to the command-line, try again ..." 
	helpme
	exit 1
fi

# Test that ldif files are where they need to be
if [ -f $SRCFLDR/dev-tree.ldif ]
    then
	echo "File exists in the expected location, continuing ..." > /dev/null
    else
	echo "File does not exist in the expected location of /root/setup. Please correct and try again, exiting script ..."
	exit 1	
fi

# Reminder to modify the source ldif files before running script
function reminder() { 
	echo "--[ Reminder ]----------------------------------------------------------------"
	echo "Please remember that you might need to modify the dev-tree.ldif file for the"
        echo "tree you are setting up. If you have already done so answer yes to the "
        echo "following question:"
	echo "=============================================================================="
	read -p "All files have been modified? " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	    then
		doit
	    else
		echo -e "\n  Failing to plan is planning to fail!"
		echo -e "Please modify the file and try again."
		exit 1
	fi
}

# Use ice to import the contents of the ldif file specified on the command line
function doit() { 
if [ $# -lt 1 ]
    then
	$NDSBIN/ice -l $LOG -S LDIF -f $SRCFLDR/dev-tree.ldif -v -D LDAP -s $HOST -p $PORT -L -d $ADM -w $PWD -v
	echo "The tree has been populated with containers, users and groups excs-tree, enjoy."
fi
}

reminder

# Finished
exit 1

