#!/bin/bash - 
#===============================================================================
#
#          FILE: oes2018upchk.sh
# 
#         USAGE: ./oes2018upchk.sh 
# 
#   DESCRIPTION: Update and thenBackup OES configuration files, and then run 
#                the oes_upgrade_check.pl script.
#
#                Copyright (C) 2018 David Robb
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
#       CREATED: Tue Feb 23 2016 07:19
#  LAST UPDATED: Thu Nov 22 2018 14:00
#      REVISION: 2.4
#     SCRIPT ID: ---
# SSC SCRIPT ID: --
#===============================================================================
version=0.2.4                                   # version number of the script
sid=000                                         # personal script id number
uid=00                                          # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
dsp=$(date +'%A %B %d, %Y %T')                  # special Date/Time stamp
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
red='\033[0;31m'                                # red text so it stands out - for major issues
green='\033[0;32m'                              # green text so it stands out - for good to go
yellow='\033[1;33m'                             # yellow text so it stands out - warnings
nc='\033[0m'                                    # standard white on black
email=root                                      # who to send email to (comma separated list)
tree=$(cat /etc/sysconfig/novell/oes-ldap | grep CONFIG_LDAP_TREE_NAME | cut -f 2 -d '"') # eDir Tree name
ctx='ou=services,o=cluster'                     # default context for admin accounts
logdir='/var/log/oes2018up'                     # log directory
log='/var/log/oes2018up/oesbackup.log'          # logging
errlog='/var/log/oes2018up/oesbackup.error.log' # error logging
bkdir=/home/backup                              # local backup destination
rep=${bkdir}/OES2018_configuration_update_backup_report-${host}.txt  # generated report name

# Make any missing directories and touch the logs
mklogdir () { 
  if [ -d ${logdir} ]; then
    echo "logging directory exists, continuing" > /dev/null
  else
    mkdir -p $logdir
  fi
}

mkbkdir () { 
  if [ -d ${bkdir} ]; then
    echo "backup directory exists, continuing" > /dev/null
  else
    install -m 1777 -o excsadmin -g users -d /home/backup
    rm -f $rep
    touch $rep
  fi
}

initlog () {
  if [ -e $log ]; then
    echo "log file exists" > /dev/null
  else
    touch $log
    echo "Logging started at ${ts}" > ${log}
    echo "All actions are being performed by the user: ${user}" >> ${log}
    echo "" >> ${log}
  fi
}

initerrlog () {
  if [ -e $errlog ]; then
    echo "log file exists" > /dev/null
  else
    touch $errlog
    echo "Logging started at ${ts}" > ${errlog}
    echo "All actions are being performed by the user: ${user}" >> ${errlog}
    echo "" >> ${errlog}
  fi
}

# Check that the user executing the script is root!
rootchk () { 
  if [ $user != "root" ]; then
    echo -e ""
    echo -e "WARNING"
    echo "---------------------------------------------------------"
    echo -e "${red}You must be root to run this script. Exiting..."
    echo -e "Please sudo to root and try again.${nc}"
    echo -e ""
    exit 1
  fi
}

mklogdir
mkbkdir
initlog
initerrlog
rootchk

echo ""                                                          | tee -a $rep
echo -e "OES2015 SP1 Configuration Update and Backup"            | tee -a $rep
echo -e "Host: $host"                                            | tee -a $rep
echo -e "Date: $dsp"                                             | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo "This script is intended to check the current configuration"| tee -a $rep
echo "of an OES2015 SP1 server and see if it is ready for an"    | tee -a $rep
echo "upgrade to OES2018. Changes will be made to the server if" | tee -a $rep
echo "you continue. The script does require user input to"       | tee -a $rep
echo "complete successfully."                                    | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e ""
read -p "Do you want to proceed at this time? (Y|N): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e ""
  echo -e "${green}\nContinuing with Upgrade check of ${host}${nc}"
else
  clear
  echo -e ""
  echo -e "REMINDER"
  echo "---------------------------------------------------------"
  echo -e "${yellow}Please run this script again when you are ready to"
  echo -e "prepare ${host} for an upgrade to OES2018.${nc}"
  echo -e ""
  exit 1
fi

# Backup all oes11_sp1 config files under /etc/sysconfig/novell
oes11sp1=$(ls /etc/sysconfig/novell/ | grep "oes11_sp1" | wc -l)
oes11sp2=$(ls /etc/sysconfig/novell/ | grep "oes11_sp2" | wc -l)
oes2015sp1=$(ls /etc/sysconfig/novell/ | grep "oes2015_sp1" | wc -l)

echo ""                                                          | tee -a $rep
echo -e "Checking for old OES11 SP1 config files"                | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "${green}There are $oes11sp1 configuration files in /etc/sysconfig/novell${nc}"  | tee -a $rep
echo ""                                                          | tee -a $rep
echo -e "Checking for old OES11 SP2 config files"                | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "${green}There are $oes11sp2 configuration files in /etc/sysconfig/novell${nc}"  | tee -a $rep
echo ""                                                          | tee -a $rep
echo -e "Checking for OES2015 SP1 config files"                  | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "${green}There are $oes2015sp1 configuration files in /etc/sysconfig/novell${nc}" | tee -a $rep
echo ""                                                          | tee -a $rep
echo -e "Backing up any older config files under /etc/sysconfig/novell"       | tee -a $rep
if [ $oes11sp1 -ge 1 ]; then
  tar jcf /$bkdir/oes11_sp1_conf_files-${host}.tbz /etc/sysconfig/novell/*oes11_sp1
  rm -f /etc/sysconfig/novell/*oes11_sp1 
fi
if [ $oes11sp2 -ge 1 ]; then
  tar jcf /$bkdir/oes11_sp2_conf_files-${host}.tbz /etc/sysconfig/novell/*oes11_sp2
  rm -f /etc/sysconfig/novell/*oes11_sp2
fi
sleep 5
clear

# Backup all oes2015_sp1 config files under /etc/sysconfig/novell
echo ""                                                          | tee -a $rep
echo -e "Backing up current OES2015 SP1 config files"            | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/oes2015_sp1_oes_config_files-${host}.tbz /etc/sysconfig/novell/*
echo -e "The intial backup of the OES2015 SP1 configuration files is done." | tee -a $rep
sleep 5
clear

# Update edir_oes2015-sp1 conf file with correct values
echo ""                                                          | tee -a $rep
echo -e "Check edir_oes2015_sp1 config file"                     | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "The file edir_oes2015_sp1 must contain the correct IP"  | tee -a $rep
echo -e "Address of a eDir replica holder in the tree."          | tee -a $rep
rip=$(cat /etc/sysconfig/novell/edir_oes2015_sp1 | grep CONFIG_EDIR_REPLICA_SERVER | cut -f 2 -d "=")
echo $rip > /tmp/rip.tmp.$$
urip=$(cat /tmp/rip.tmp.$$ | sed -e 's/^"//' -e 's/"$//')
echo $urip > /tmp/urip.tmp.$$ | tee -a $rep

# TREE information
if [ "$tree" == CLUSTER-TREE ]; then
  echo -e ""                                                     | tee -a $rep
  echo -e "The tree name is: $tree"                              | tee -a $rep
  if [ $(cat /tmp/urip.tmp.$$ | cut -f 4 -d '.') == 193 ]; then
    echo -e "The eDir Replica IP address is: $urip"              | tee -a $rep
    echo -e "The eDir replica IP address in the edir_oes2015_sp1"| tee -a $rep
    echo -e "file is correct for $tree"                          | tee -a $rep
  else
    echo -e "There is either no IP Address, or the wrong IP"     | tee -a $rep
    echo -e "Address in edir_oes2015_sp1, going to correct this." | tee -a $rep
   sed -i 's/CONFIG_EDIR_REPLICA_SERVER='"$rip"'/CONFIG_EDIR_REPLICA_SERVER="192.168.2.193"/g' /etc/sysconfig/novell/edir_oes2015_sp1
  fi
fi
sleep 5
clear

# Set the admin account name if needed
echo ""                                                          | tee -a $rep
echo -e "Set the correct eDir Admin accoutn in oes-ldap"         | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
read -p "Please enter your $tree admin account name: " adm

admfdn=cn=$adm,$ctx
cadm=$(cat /etc/sysconfig/novell/oes-ldap | grep CONFIG_LDAP_ADMIN_CONTEXT | cut -f 2- -d "=" | sed -e 's/^"//' -e 's/"$//')
echo $admfdn
echo $cadm

if [ ${admfdn} = ${cadm} ]; then
  echo -e "${green}Your eDir admin account is already configured.${nc}"       | tee -a $rep
else
  sed -i 's/CONFIG_LDAP_ADMIN_CONTEXT='"$cadm"'/CONFIG_LDAP_ADMIN_CONTEXT='"\"$admfdn\""'/g' /etc/sysconfig/novell/oes-ldap
  echo -e "The oes-ldap config file has been updated with your admin account." | tee -a $rep
fi
sleep 5
clear

# Create the answer file
echo ""                                                          | tee -a $rep
echo -e "Create Answer file for eDir Admin password"             | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "Storing the admin password for the upgrade will allow"  | tee -a $rep
echo -e "the upgrade to proceed without any further intervention"| tee -a $rep
echo -e "after you have commenced the autoupgrade"               | tee -a $rep
echo -e "Please follow the prompts on the next screens and enter your admin password."
    yast /usr/share/YaST2/clients/create-answer-file.ycp
    mv answer /opt/novell/oes-install/
echo -e ""                                                       | tee -a $rep
echo -e "Your admin password has been stored securly in an answer" | tee -a $rep
echo -e "file and moved to /opt/novell/oes-install/"             | tee -a $rep
sleep 5
clear

# Check the local filesystem for usage (alarm if any are above 80%)
echo ""                                                          | tee -a $rep
echo -e "Local filesystem Utilization"                           | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "Filesystems over 80% are at risk of running out"        | tee -a $rep
echo -e "of space during the upgrade, and causing the"           | tee -a $rep
echo -e "upgrade to fail."                                       | tee -a $rep
sdf=$(df -h | grep system-lvm | awk '{print $6, $5}')
echo $sdf >/tmp/sdf.tmp.$$
sed -i 's/\//root/' /tmp/sdf.tmp.$$
tr -s '/'  '\n' < /tmp/sdf.tmp.$$ > /tmp/sdf.$$
spc=$(df -h | grep sda | awk '{print $5}' | sed -e 's/%//g')
echo $spc > /tmp/spc.tmp.$$
for p in $(cat /tmp/spc.tmp.$$); do
  if [ $p -ge 80 ]; then
    echo -e ""                                                       | tee -a $rep
    echo -e "At least one filesystem is at or above 80% utilization."| tee -a $rep
    echo -e ""                                                       | tee -a $rep
    echo -e "Filesystem(s) with high space utilization"              | tee -a $rep
    echo "---------------------------------------------------------" | tee -a $rep
    cat /tmp/sdf.$$                                                  | tee -a $rep

  else
      echo -e "" | tee -a $rep
      echo -e "All filesystems are below 80% utilization." | tee -a $rep
  fi
done
sleep 5
clear

# Check if drives are being mounted by path 
fsc=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | wc -l)
mk=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep dev | wc -l)
ml=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep LABEL | wc -l)
mu=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep UUID | wc -l)
echo -e ""                                                       | tee -a $rep
echo -e "Mounting of Local filesystems"                          | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "Server $host has a total of $fsc filesystems. There"    | tee -a $rep
echo -e "are $mk mounted by kernel device name. There are $ml"   | tee -a $rep
echo -e "mounted by label, and $mu mounted by uuid."             | tee -a $rep
echo -e "Mounting by kernel device name is not persistent, and"  | tee -a $rep
echo -e "therefore unreliable for use during an upgrade"         | tee -a $rep
echo -e "process."                                               | tee -a $rep
if [ ${mk} -ge 1 ]; then
  echo -e ""                                                     | tee -a $rep
  echo -e "Please convert the mounts to by-LABEL or by-UUID."    | tee -a $rep
else
  echo -e ""                                                     | tee -a $rep
  echo -e "All filesystems are mounted by an acceptable method"  | tee -a $rep
fi
sleep 5
clear

# Check for a static IP Address
echo ""                                                          | tee -a $rep
echo -e "IP Address and DNS Verification"                        | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
stip=$(cat /etc/sysconfig/network/ifcfg-eth* | grep BOOTPROTO | cut -f 2 -d "=")
ipa=$(cat /etc/sysconfig/network/ifcfg-eth* | grep -w IPADDR | cut -f 2 -d "=")
echo -e "The currently assigned IP address is: $ipa"             | tee -a $rep
echo -e "This server has a $stip IP address assigned."           | tee -a $rep
# nslookup on DNS names
echo -e ""                                                       | tee -a $rep
echo -e "The assigned DNS servers are:"                          | tee -a $rep
echo -e "$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')" | tee -a $rep
echo -e ""                                                       | tee -a $rep
echo -e "The following DNS entries were returned:"               | tee -a $rep
echo -e "$(/usr/bin/nslookup $host | tail -3 | sed '/^$/d')"     | tee -a $rep
sleep 5
clear

# Check for Third-party software
echo ""                                                          | tee -a $rep
echo -e "Third-Party Software"                                   | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
smf=$(ls /opt/ | grep McAfee | wc -l)
sna=$(ls /opt/ | grep NAI | wc -l)
sti=$(ls /opt/ | grep tivoli | wc -l)
# McAfee Agent check and stop
if [ $smf -ge 1 ]; then
  echo -e "McAfee cma is installed on this server"               | tee -a $rep
  /etc/init.d/cma stop
  chkconfig cma off
  echo -e "McAfee has been disabled from starting during the upgrade" | tee -a $rep
else
  echo -e "No McAfee products installed"                         | tee -a $rep
fi
# LinuxShield check and stop
if [ $sna -ge 1 ]; then
  echo -e "NAI LinuxShield is installed on this server"          | tee -a $rep
  /etc/init.d/nails stop
  chkconfig nails off
  echo -e "NAI linuxShield has been disabled from starting during the upgrade" | tee -a $rep
else
  echo -e "No NAI products installed"                            | tee -a $rep
fi
# Tivoli check
if [ $sti -ge 1 ]; then
  echo -e "Tivoli is installed on this server"                   | tee -a $rep
else
  echo -e "No Tivoli products installed"                         | tee -a $rep
fi
sleep 5
clear

# Check for patches
echo ""                                                          | tee -a $rep
echo -e "Check for outstanding OS and OES Patches"               | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
zypper ref -s > /dev/null
pch=$(zypper pch | grep Needed | wc -l)
if [ $pch -ge 1 ]; then
  echo -e "Server needs to have $pch patches installed before"   | tee -a $rep
  echo -e "it can be upgraded."                                  | tee -a $rep
  read -p "Do you want to apply the patches now? (Y|N): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    zypper up
  else
    echo -e "\nYou must complete patching before upgrading"      | tee -a $rep
    echo -e "Please patch this server before attemping an upgrade" | tee -a $rep
  fi
else
  echo -e "${green}Server is up-to-date and is ready to be upgraded${nc}" | tee -a $rep
  echo -e "A reboot may be required if the server was patched"   | tee -a $rep
fi
sleep 5
clear

# Run the oes_upgrade_check.pl script
echo ""                                                          | tee -a $rep
echo -e "OES Upgrade Check Script"                               | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo "The perl script provided by Micro Focus will ensure"       | tee -a $rep
echo "that the configuration files under /etc/sysconfig/novell"  | tee -a $rep
echo "are up-to-date with the current server configuration"      | tee -a $rep
echo "Any files changed will be backed up first"                 | tee -a $rep
read -p "Do you want to continue with a configuration check? (Y|N): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo yes | /opt/novell/oes-install/util/oes_upgrade_check.pl all 
    echo -e "Upgrade check script completed. Some files under"   | tee -a $rep
    echo -e "/etc/sysconfig/novell may have been modified."      | tee -a $rep
    echo -e "The script made a backup of these files under:"     | tee -a $rep
    echo -e "/etc/sysconfig/.novell/"                            | tee -a $rep                             
  else
    echo -e "${red}\nOES upgrade check skipped.${nc}"            | tee -a $rep
  fi
sleep 5
clear

# Generate a list of sockets for /opt and /var
find /opt -type s > /root/bin/opt_sockets.lst 2>/dev/null
find /var -type s > /root/bin/var_sockets.lst

# Backup /etc, /home, /root, /opt, and /var
echo ""                                                          | tee -a $rep
echo -e "Critical file and folder backup"                        | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo "It is highly recommended to have a backup of the"          | tee -a $rep
echo "important files and folders on an OES Server"              | tee -a $rep
echo "This script will back up the contents of /etc, /home"      | tee -a $rep
echo "/root, /opt, and /var"                                     | tee -a $rep
echo "This is not a substitute for a full server backup,"        | tee -a $rep
echo "it does not back up data on NSS volumes, nor does it."     | tee -a $rep
echo "perform an eDirectory backup. These should be done"        | tee -a $rep
echo "separately."                                               | tee -a $rep 
read -p "Do you want to perform this backup now? (Y|N): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then

# Backup of /etc
echo -e ""                                                       | tee -a $rep
echo -e "\nBeginning backup of /etc"                             | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcvf $bkdir/backup_etc_${host}_$(date +'%Y%m%d_%H%M').tbz /etc/* > $log 2> $errlog
echo -e "${green}The backup of /etc has completed.${nc}"         | tee -a $rep

# Backup of /home
echo -e ""                                                        | tee -a $rep
echo -e "Beginning backup of /home"                               | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcvf $bkdir/backup_home_${host}_$(date +'%Y%m%d_%H%M').tbz /home/* --exclude=home/backup >> $log 2>> $errlog
echo -e "${green}Backup of /home is complete.${nc}"               | tee -a $rep

# Backup of /root
echo -e ""                                                        | tee -a $rep
echo -e "Beginning backup of /root"                               | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcvf $bkdir/backup_root_${host}_$(date +'%Y%m%d_%H%M').tbz /root/* >> $log 2>> $errlog
echo -e "${green}Backup of /root is complete.${nc}"               | tee -a $rep

# Backup of /opt
echo -e ""                                                        | tee -a $rep
echo -e "Beginning backup of /opt"                                | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcvf $bkdir/backup_opt_${host}_$(date +'%Y%m%d_%H%M').tbz /opt/* --exclude=opt/novell/nss/mnt --exclude=opt/NAI --exclude=opt/scripts/os/isos --exclude-from=/root/bin/opt_sockets.lst >> $log 2>> $errlog
echo -e "${green}Backup of /opt is complete.${nc}"                | tee -a $rep

# Backup of /var
echo -e ""                                                        | tee -a $rep
echo -e "Beginning backup of /var"                                | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
tar jcvf $bkdir/backup_var_${host}_$(date +'%Y%m%d_%H%M').tbz /var/* --exclude=var/opt/novell/eDirectory/data/dib --exclude=var/lib/ntp/proc --exclude=/var/spool --exclude=var/run --exclude=var/opt/novell/ganglia/rrds --exclude=var/log/oes2018up --exclude-from=/root/bin/var_sockets.lst >> $log 2>> $errlog
echo -e "${green}Backup of /var is complete.${nc}"                | tee -a $rep
else
    echo -e "${red}\nBackup of files and folders skipped.${nc}"   | tee -a $rep
  fi
sleep 5
clear

# Run a supportconfig (just-in-case)
echo ""                                                          | tee -a $rep
echo -e "OES2015 SP1 Supportconfig"                              | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "Please be patient while supportconfig runs in the backgroud"
/sbin/supportconfig -QR /home/backup
echo -e "${green}Supportconfig complete.${nc}"                   | tee -a $rep
sleep 5
clear

# Pre upgrade checks and fs backupis complete
echo ""                                                          | tee -a $rep
echo -e "OES2015 SP1 Upgrade Checks and FS Backups are complete" | tee -a $rep
echo "---------------------------------------------------------" | tee -a $rep
echo -e "The report can be found here: $rep"                     | tee -a $rep
echo -e "If you performed a backup:"                             | tee -a $rep
echo -e "The backup success log can be found here: $log"         | tee -a $rep
echo -e "The backup error log can be found here: $errlog"        | tee -a $rep
echo -e "The server is now ready to be upgraded to OES2018"      | tee -a $rep
# Combine all files together into a single tarball
echo -e "Creating a single archive file under ${bkdir}"          | tee -a $rep
tar jcvf ${bkdir}/oes2018_prep.tbz ${bkdir}/backup_etc*.tbz ${bkdir}/backup_home*.tbz  ${bkdir}/backup_root*.tbz  ${bkdir}/backup_opt*.tbz ${bkdir}/backup_var*.tbz  ${bkdir}/oes2015_*.tbz ${bkdir}/nts_*.tbz ${bkdir}/nts_*.tbz.md5 >> $log 2>> $errlog
echo "---------------------------------------------------------" | tee -a $rep

# Cleanup
/bin/rm -f /tmp/*.$$
/bin/rm -f /root/bin/*.lst
/bin/rm -f ${bkdir}/backup_etc*.tbz
/bin/rm -f ${bkdir}/backup_home*.tbz
/bin/rm -f ${bkdir}/backup_root*.tbz
/bin/rm -f ${bkdir}/backup_opt*.tbz
/bin/rm -f ${bkdir}/backup_var*.tbz
/bin/rm -f ${bkdir}/oes2015_sp1_*.tbz
/bin/rm -f ${bkdir}/nts_*.tbz
/bin/rm -f ${bkdir}/nts_*.tbz.md5

# Finished
exit 1

