#!/bin/bash - 
#===============================================================================
#
#          FILE: oescfgchk.sh
# 
#         USAGE: ./oescfgchk.sh 
# 
#   DESCRIPTION: Update and thenBackup OES configuration files, and then run 
#                the oes_upgrade_check.pl script.
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
#       CREATED: Tue Feb 23 2016 07:19
#  LAST UPDATED: Thu Mar 03 2016 13:16
#      REVISION: 5
#     SCRIPT ID: ---
# SSC SCRIPT ID: --
#===============================================================================
# set -o nounset                                # Treat unset variables as an error
version=0.1.5                                   # version number of the script
sid=000                                         # personal script id number
uid=00                                          # SSC/RCMP script id number
ts=$(date +"%b %d %T")                          # general date/time stamp
ds=$(date +%a)                                  # abbreviated day of the week, eg Mon
df=$(date +%A)                                  # full day of the week, eg Monday
dsp=$(date +'%A %B %d, %Y %T')                  # special Date/Time stamp
host=$(hostname)                                # host name of local server
user=$(whoami)                                  # who is running the script
email=calvin.hamilton@rcmp-grc.gc.ca            # who to send email to (comma separated list)
tree=$(cat /etc/sysconfig/novell/oes-ldap | grep CONFIG_LDAP_TREE_NAME | cut -f 2 -d '"') # eDir Tree name
ctx='ou=vaultadmin,ou=people,ou=rcmp-grc,o=gc,c=ca' # default context for admin accounts
log='/var/log/oesupcfgchk.log'                  # logging (if required)
bkdir=/home/backup                              # local backup destination
rep=${bkdir}/OES2015_conf_update_and_backup_report-${host}.txt  # generated report name

# Create Backup directory
install -m 1777 -o casadmin -g users -d /home/backup

echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "OES11 SP2 Configuration Update and Backup" | tee -a $rep
echo -e "Host: $host" | tee -a $rep
echo -e "Date: $dsp" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep

# Backup all oes11_sp1 config files under /etc/sysconfig/novell
sp1=$(ls /etc/sysconfig/novell/ | grep sp1 | wc -l)
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Checking for old OES11 SP1 config files" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo -e "There are $sp1 configuration files in /etc/sysconfig" | tee -a $rep
echo -e "/novell." | tee -a $rep

if [ $sp1 -ge 1 ]; then
  tar jcf /$bkdir/oes11_sp1_conf_files-${host}.tbz /etc/sysconfig/novell/*sp1
  rm -f /etc/sysconfig/novell/*sp1 
  echo -e "Going to tar these files up separately." | tee -a $rep
else
  echo "There are no OES11_SP1 files to tar up." | tee -a $rep
fi

# Backup all oes11_sp2 config files under /etc/sysconfig/novell
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Backing up OES11 SP2 config files" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
tar jcf $bkdir/oes11_sp2_conf_files1-${host}.tbz /etc/sysconfig/novell/*
echo -e "The intial backup of the OES11 SP2 configuration files is done." | tee -a $rep

# Update edir_oes11-sp2 conf file with correct values
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Check edir_oes11_sp2 config file" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo -e "The file edir_oes11_sp2 must contain the correct IP" | tee -a $rep
echo -e "Address of a eDir replica holder in the tree." | tee -a $rep
rip=$(cat /etc/sysconfig/novell/edir_oes11_sp2 | grep CONFIG_EDIR_REPLICA_SERVER | cut -f 2 -d "=")
echo $rip > /tmp/rip.tmp.$$
urip=$(cat /tmp/rip.tmp.$$ | sed -e 's/^"//' -e 's/"$//')
echo $urip > /tmp/urip.tmp.$$

# CAS-RND Tree
if [ "$tree" == CAS-RND ]; then
  echo -e "The tree name is: $tree" | tee -a $rep
  if [ $(cat /tmp/urip.tmp.$$ | cut -f 4 -d '.') == 215 ]; then
    echo -e "The IP in the edir_oes11_sp2 file is correct for CAS-RND." | tee -a $rep
  else
    echo -e "There is either no IP Address, or the wrong IP Address in edir_oes11_sp2, going to correct this." | tee -a $rep
   sed -i 's/CONFIG_EDIR_REPLICA_SERVER='"$rip"'/CONFIG_EDIR_REPLICA_SERVER="192.168.9.215"/g' /etc/sysconfig/novell/edir_oes11_sp2
  fi
fi

# CAS-DEV Tree
if [ ${tree} == CAS-DEV ]; then
  echo -e "The tree name is: $tree" | tee -a $rep
  if [ $(cat /tmp/urip.tmp.$$ | cut -f 4 -d '.') == 246 ]; then
    echo -e "The IP in the edir_oes11_sp2 file is correct for CAS-DEV." | tee -a $rep
  else
    echo -e "There is either no IP Address, or the wrong IP Address in edir_oes11_sp2, going to correct this." | tee -a $rep
    sed -i 's/CONFIG_EDIR_REPLICA_SERVER='"$rip"'/CONFIG_EDIR_REPLICA_SERVER="192.168.9.246"/g' /etc/sysconfig/novell/edir_oes11_sp2
  fi
fi

# CAS-SAC Tree
if [ ${tree} == CAS-SAC ]; then
  echo -e "The tree name is: $tree" | tee -a $rep
  if [ $(cat /tmp/rip.tmp.$$ | cut -f 4 -d '.') == 247 ]; then
    echo -e "The IP in the edir_oes11_sp2 file is correct for CAS-SAC." | tee -a $rep
  else
    echo -e "There is either no IP Address, or the wrong IP Address in edir_oes11_sp2, going to correct this." | tee -a $rep
    sed -i 's/CONFIG_EDIR_REPLICA_SERVER='"$cadm"'/CONFIG_EDIR_REPLICA_SERVER="10.4.32.247"/g' /etc/sysconfig/novell/edir_oes11_sp2
  fi
fi

# Set the admin account name
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Set the correct eDir Admin accoutn in oes-ldap" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
read -p "Please enter your $tree admin account name in the format aXXXXXXXX: " adm

admfdn=cn=$adm,$ctx
cadm=$(cat /etc/sysconfig/novell/oes-ldap | grep CONFIG_LDAP_ADMIN_CONTEXT | cut -f 2- -d "=")
echo $admfdn
echo $cadm

if [ ${admfdn} = ${cadm} ]; then
  echo -e "Your eDir admin account is already configured." | tee -a $rep
else
  sed -i 's/CONFIG_LDAP_ADMIN_CONTEXT='"$cadm"'/CONFIG_LDAP_ADMIN_CONTEXT='"\"$admfdn\""'/g' /etc/sysconfig/novell/oes-ldap
  echo -e "The oes-ldap config file has been updated with your admin account." | tee -a $rep
fi
sleep 5

# Create the answer file
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Create Answer file for eDir Admin password" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep

echo -e "Please follow the prompts on the next screens and enter your admin password."
yast /usr/share/YaST2/clients/create-answer-file.ycp
mv answer /opt/novell/oes-install/

echo -e "Your admin password has been stored securly in an answer" | tee -a $rep
echo -e "file and moved to /opt/novell/oes-install/" | tee -a $rep

# Check the local filesystem for usage (alarm if any are above 80%)
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Local filesystem Utilization" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
echo -e "Filesystems over 80% are at risk of running out" | tee -a $rep
echo -e "of space during an upgrade, and causing the" | tee -a $rep
echo -e "upgrade to fail." | tee -a $rep
sdf=$(df -h | grep system-lvm | awk '{print $6, $5}')
echo $sdf >/tmp/sdf.tmp.$$
sed -i 's/\//root/' /tmp/sdf.tmp.$$
tr -s '/'  '\n' < /tmp/sdf.tmp.$$ > /tmp/sdf.$$

spc=$(df -h | grep system-lvm | awk '{print $5}' | sed -e 's/%//g')
echo $spc > /tmp/spc.tmp.$$
for p in $(cat /tmp/spc.tmp.$$); do
  if [ $p -ge 80 ]; then
    echo -e "At least one filesystem is at or above 80% utilization." | tee -a $rep
  else
      echo -e "All filesystems are below 80% utilization." | tee -a $rep
  fi
done

echo -e "" | tee -a $rep
echo -e "======================================================" | tee -a $rep
echo -e "Filesystem Utilization is" | tee -a $rep
echo -e "------------------------------------------------------" | tee -a $rep
cat /tmp/sdf.$$ | tee -a $rep

# Check if drives are being mounted by path 
fsc=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | wc -l)
mk=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep dev | wc -l)
ml=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep LABEL | wc -l)
mu=$(cat /etc/fstab | grep -Ev '(loop|nss|nfs|proc|sysfs|debugfs|devpts)' | grep UUID | wc -l)
echo -e "" | tee -a $rep
echo -e "======================================================" | tee -a $rep
echo -e "Mounting of Local filesystems" | tee -a $rep
echo -e "------------------------------------------------------" | tee -a $rep
echo -e "Server $host has a total of $fsc filesystems. There" | tee -a $rep
echo -e "are $mk mounted by kernel device name. There are $ml" | tee -a $rep
echo -e "mounted by label, and $mu mounted by uuid." | tee -a $rep
echo -e "Mounting by kernel device name is not persistent, and" | tee -a $rep
echo -e "therefore unreliable for use during an upgrade" | tee -a $rep
echo -e "process." | tee -a $rep
if [ ${mk} -ge 1 ]; then
  echo -e "Please convert the mounts to by-LABEL or by-UUID." | tee -a $rep
else
  echo -e "" | tee -a $rep
fi

# Check for a static IP Address
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "IP Address Verification" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
stip=$(cat /etc/sysconfig/network/ifcfg-eth* | grep BOOTPROTO | cut -f 2 -d "=")
ipa=$(cat /etc/sysconfig/network/ifcfg-eth* | grep -w IPADDR | cut -f 2 -d "=")
echo -e "The currently assigned IP address is: $ipa" | tee -a $rep
echo -e "This server has a $stip IP Address." | tee -a $rep

# Check for Third-party software
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Third-Party Software" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
smf=$(ls /opt/ | grep McAfee | wc -l)
sna=$(ls /opt/ | grep NAI | wc -l)
sti=$(ls /opt/ | grep tivoli | wc -l)
# McAfee Agent check and stop
if [ $smf -ge 1 ]; then
  echo -e "McAfee cma is installed on this server" | tee -a $rep
  /etc/init.d/cma stop
  chkconfig cma off
else
  echo -e "No McAfee products installed" | tee -a $rep
fi
# LinuxShield check and stop
if [ $sna -ge 1 ]; then
  echo -e "NAI LinuxShield is installed on this server" | tee -a $rep
  /etc/init.d/nails stop
  chkconfig nails off
else
  echo -e "No NAI products installed" | tee -a $rep
fi
# Tivoli check
if [ $sti -ge 1 ]; then
  echo -e "Tivoli is installed on this server" | tee -a $rep
else
  echo -e "No Tivoli products installed" | tee -a $rep
fi

# Check for patches
echo "" | tee -a $rep
echo "======================================================" | tee -a $rep
echo -e "Check for outstanding OS and OES Patches" | tee -a $rep
echo "------------------------------------------------------" | tee -a $rep
zypper ref -s > /dev/null
pch=$(zypper pch | grep Needed | wc -l)
if [ $pch -ge 1 ]; then
  echo -e "Server needs to have $pch patches installed before" | tee -a $rep
  echo -e "it can be upgraded." | tee -a $rep
  read -p "Pathces will be applied now? " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    zypper up
  else
    echo -e "\nYou must complete patching before upgrading." | tee -a $rep
    echo -e "Please patch this server before attemping an upgrade." | tee -a $rep
  fi
else
 echo -e "Server is up-to-date and is ready to be upgraded." | tee -a $rep
fi

# Pre upgrade checks complete
echo "" | tee -a $rep
echo -e "======================================================" | tee -a $rep
echo -e "OES11 SP2 Pre Upgrade Checks and Backups are complete" | tee -a $rep
echo -e "------------------------------------------------------" | tee -a $rep
echo -e "The report can be found here: $rep" | tee -a $rep
echo -e "------------------------------------------------------" | tee -a $rep

# Cleanup
rm -f /tmp/*.$$

# Finished
exit 1

