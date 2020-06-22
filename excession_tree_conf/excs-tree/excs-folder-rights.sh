#!/bin/bash - 
#===============================================================================
#
#          FILE: excs-folder-rights.sh
# 
#         USAGE: ./excs-folder-rights.sh 
# 
#   DESCRIPTION: Create and set rights on folders on NSS volumes for a new tree
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
#  REQUIREMENTS: ---
#          BUGS: Report bugs to David Robb, david.robb@microfocus.com, 613-793-2281
#         NOTES: ---
#        AUTHOR: David Robb (DER), david.robb@microfocus.com
#  CONTRIBUTORS: 
#  ORGANIZATION: Micro Focus Software (Canada) Inc.
#       CREATED: Tue Aug 06 2013 09:00
#   LAST UDATED: Sun Sep 30 2018 12:33
#       VERSION: 0.1.9 
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
lip=$(ifconfig | awk '/inet addr/{print substr($2,6)}' | grep -v 127) # local IP Addr
port=636                        	# LDAP secure port
adm=cn=admin,ou=services,o=$1   	# tree administrator account
pswd=yellowStone!228            	# administrator password
user=$(whoami)				# who is running the script
ot=excs.excs-tree                       # top o and tree name
srcfldr='/root/setup'           	# location of files
homelist='/root/setup/home-dirs.txt' 	# list of home folders
junklist='/root/setup/junk-dirs.txt'    # list of junk folders
techlist='/root/setup/tech-dirs.txt'    # list of tech folders
datalist='/root/setup/data-dirs.txt'    # list of data folders
ndsbin='/opt/novell/eDirectory/bin'     # path to nds binaries
nsssbin='/opt/novell/nss/sbin'          # path to nss supervisory binaries
nssbase='/media/nss'                    # base path to NSS volumes
dvol=/DATA				# DATA volume name
hvol=/HOME				# HOME volume name
tvol=/TECH				# TECH volume name
jvol=/JUNK				# JUNK volume name
email=					# email recipient(s)
log='/root/reports/ice-logs/dirs.log'   # log name and location (if required)
#===============================================================================

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

# Create directories on NSS volumes
function createDirData() { 
mkdir -p $nssbase/$dvol/allhands
mkdir -p $nssbase/$dvol/collaboration/consulting_team/{partners,customers}
mkdir -p $nssbase/$dvol/collaboration/development_team/{linux,windows,osx,ios,android,sql}
mkdir -p $nssbase/$dvol/collaboration/finance_team/{gl,ar,pl}
mkdir -p $nssbase/$dvol/collaboration/human_resources_team/{hiring,grievance,compensation,policies,harrassment}
mkdir -p $nssbase/$dvol/collaboration/legal_team/{intellectual_property,litigation}
mkdir -p $nssbase/$dvol/collaboration/management_team/{consulting,development,finance,human_resources,legal,operations,sales_marketing,support,technical}
mkdir -p $nssbase/$dvol/collaboration/sales_marketing_team/{inside_sales,customers,campaigns,events,marketing_print,marketing_internet}
mkdir -p $nssbase/$dvol/confidential/{consultants,developers,finance,human_resources,legal,operations,sales_marketing,support,technical}
mkdir -p $nssbase/$dvol/confidential/management/{consulting_team,development_team,finance_team,human_resources_team,legal_team,operations_team,sales_marketing_team,support_team,technical_team}
}

function createDirTech() { 
mkdir -p $nssbase/$tvol/technical_team/{deployment,documentation/{vendors,internal},patches,scripts,tools,software}
mkdir -p $nssbase/$tvol/operations_team/{reports/{sc,slp,server_health,backup},incidents,tools,software}
mkdir -p $nssbase/$tvol/support_team/{metrics,tools,software}
}

function createDirJunk() { 
mkdir -p $nssbase/$jvol/consulting_team/consulting_junk_folder{0..9}
mkdir -p $nssbase/$jvol/development_team/development_junk_folder{0..9}
mkdir -p $nssbase/$jvol/finance_team/finance_junk_folder{0..9}
mkdir -p $nssbase/$jvol/human_resources_team/human_resources_junk_folder{0..9}
mkdir -p $nssbase/$jvol/legal_team/legal_junk_folder{0..9}
mkdir -p $nssbase/$jvol/management_team/management_junk_folder{0..9}
mkdir -p $nssbase/$jvol/miscellaneous
mkdir -p $nssbase/$jvol/sales_marketing_team/sales_junk_folder{0..9}
mkdir -p $nssbase/$jvol/technical_team/tech_junk_folder{0..9}
mkdir -p $nssbase/$jvol/operations_team/operations_junk_folder{0..9}
mkdir -p $nssbase/$jvol/support_team/support_junk_folder{0..9}
}

function createDirUser() { 
mkdir -p $nssbase/$hvol/users/aanderso/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/abailey/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/aclark/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/agagnon/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/agray/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ahernand/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ahughes/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ajenkins/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/alopez/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/amartine/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/aortiz/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/aperez/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/arivera/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/arobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ataylor/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/athompso/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/award/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/awhite/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/badams/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/bcook/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/bramirez/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/bross/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/cbaker/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/cgarcia/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/cmorgan/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/croy/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/dflores/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/dharris/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/dpowell/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/drobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/edavis/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ehoward/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/escott/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ethomas/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ewilliam/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/eyoung/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/gedwards/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/gking/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/gnelson/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/greed/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/hlewis/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/hmitchel/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ibennett/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/igomez/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/ijohnson/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jallen/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jcampbel/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jcox/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jgonzale/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jlam/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jlrobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jmiller/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jmorales/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jmurphy/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jprice/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jreyes/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jrobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jroberts/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jsmith/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jterry/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jwatson/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/jwood/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/krobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mbrown/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mcarey/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mmartin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mowen/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mrobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/mrobinso/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/njackson/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/owilson/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/sjones/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/sspr-TestUser/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/testuser/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/users/wmoore/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/ediradmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/edirreports/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/ftpupload/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/ftpdnload/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/gwadmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/gwagents/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/gwcaladm/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/idmadmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/ldapuser/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/helpdesk/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/nmadmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/pwmadmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/pwmproxy/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/vibemail/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/sa/zenadmin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/admin/david/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/admin/aarobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/admin/adrobb/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
mkdir -p $nssbase/$hvol/admin/admin/{bin,Contacts,Desktop,Documents,Downloads,Favorites,Links,Music,Pictures,Saved_Games,Searches,Videos,Templates,Public_html}
}

function rightsData() { 
$nsssbin/rights -f $nssbase/$dvol/allhands -r all trustee allhands.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/consulting_team -r all trustee consultants.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/development_team -r all trustee developers.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/finance_team -r all trustee finance.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/human_resources_team -r all trustee hr.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/legal_team -r all trustee legal.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/management_team -r all trustee management.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration/sales_marketing_team -r all trustee sales.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/collaboration -r all trustee management.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$dvol/confidential -r all trustee management.excs-groups.${ot}
}

function rightsTech() { 
$nsssbin/rights -f $nssbase/$tvol/technical_team -r all trustee technical.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$tvol/operations_team -r all trustee operations.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$tvol/support_team -r all trustee support.excs-groups.${ot}
}

function rightsJunk() { 
$nsssbin/rights -f $nssbase/$jvol/consulting_team -r all trustee consultants.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/development_team -r all trustee developers.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/finance_team -r all trustee finance.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/human_resources_team -r all trustee hr.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/legal_team -r all trustee legal.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/management_team -r all trustee management.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/miscellaneous -r all trustee allhands.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/sales_marketing_team -r all trustee sales.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/technical_team -r all trustee technical.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/operations_team -r all trustee operations.excs-groups.${ot}
$nsssbin/rights -f $nssbase/$jvol/support_team -r all trustee support.excs-groups.${ot}
}

function rightsUser() { 
$nsssbin/rights -f $nssbase/$hvol/admin/aarobb -r all trustee aarobb.admin.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/admin/adrobb -r all trustee adrobb.admin.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/admin/admin -r all trustee admin.services.${ot}
$nsssbin/rights -f $nssbase/$hvol/admin/david -r all trustee david.admin.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/ediradmin -r all trustee ediradmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/ftpupload -r all trustee edirreports.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/ftpdnload -r all trustee edirreports.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/gwadmin -r all trustee gwadmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/gwagents -r all trustee gwagents.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/gwcaladm -r all trustee gwcaladm.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/idmadmin -r all trustee idmadmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/ldapuser -r all trustee ldapuser.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/helpdesk -r all trustee helpdesk.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/nmadmin -r all trustee nmadmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/pwmadmin -r all trustee PwmAdmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/pwmproxy -r all trustee PwmProxy.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/vibemail -r all trustee vibemail.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/sa/zenadmin -r all trustee zenadmin.sa.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/aanderso -r all trustee aanderso.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/abailey -r all trustee abailey.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/aclark -r all trustee aclark.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/agagnon -r all trustee agagnon.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/agray -r all trustee agray.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ahernand -r all trustee ahernand.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ahughes -r all trustee ahughes.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ajenkins -r all trustee ajenkins.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/alopez -r all trustee alopez.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/amartine -r all trustee amartine.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/aortiz -r all trustee aortiz.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/aperez -r all trustee aperez.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/arivera -r all trustee arivera.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/arobb -r all trustee arobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ataylor -r all trustee ataylor.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/athompso -r all trustee athompso.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/award -r all trustee award.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/awhite -r all trustee awhite.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/badams -r all trustee badams.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/bcook -r all trustee bcook.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/bramirez -r all trustee bramirez.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/bross -r all trustee bross.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/cbaker -r all trustee cbaker.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/cgarcia -r all trustee cgarcia.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/cmorgan -r all trustee cmorgan.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/croy -r all trustee croy.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/dflores -r all trustee dflores.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/dharris -r all trustee dharris.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/dpowell -r all trustee dpowell.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/drobb -r all trustee drobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/edavis -r all trustee edavis.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ehoward -r all trustee ehoward.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/escott -r all trustee escott.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ethomas -r all trustee ethomas.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ewilliam -r all trustee ewilliam.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/eyoung -r all trustee eyoung.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/gedwards -r all trustee gedwards.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/gking -r all trustee gking.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/gnelson -r all trustee gnelson.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/greed -r all trustee greed.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/hlewis -r all trustee hlewis.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/hmitchel -r all trustee hmitchel.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ibennett -r all trustee ibennett.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/igomez -r all trustee igomez.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/ijohnson -r all trustee ijohnson.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jallen -r all trustee jallen.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jcampbel -r all trustee jcampbel.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jcox -r all trustee jcox.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jgonzale -r all trustee jgonzale.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jlam -r all trustee jlam.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jlrobb -r all trustee jlrobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jmiller -r all trustee jmiller.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jmorales -r all trustee jmorales.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jmurphy -r all trustee jmurphy.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jprice -r all trustee jprice.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jreyes -r all trustee jreyes.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jrobb -r all trustee jrobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jroberts -r all trustee jroberts.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jsmith -r all trustee jsmith.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jterry -r all trustee jterry.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jwatson -r all trustee jwatson.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/jwood -r all trustee jwood.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/krobb -r all trustee krobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mbrown -r all trustee mbrown.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mcarey -r all trustee mcarey.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mmartin -r all trustee mmartin.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mowen -r all trustee mowen.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mrobb -r all trustee mrobb.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/mrobinso -r all trustee mrobinso.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/njackson -r all trustee njackson.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/owilson -r all trustee owilson.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/sjones -r all trustee sjones.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/sspr-TestUser -r all trustee sspr-TestUser.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/testuser -r all trustee testuser.active.excs-users.${ot}
$nsssbin/rights -f $nssbase/$hvol/users/wmoore -r all trustee wmoore.active.excs-users.${ot}
}

function homeMessage() { 
for i in $(cat ${homelist})
do
echo -e "WELCOME\n\nWelcome to Excession Systems development network. This is your personal home directory. The files stored here can only be accessed by you. You are not allowed to grant other employee's access to this directory. If you need to share files with other please do so on the collaboration drive. There is a 2 GB quota on your drive. This should be sufficient for most people. If you require more space please submit a request to the helpdesk along with a compelling reason.\n\nExcession Network Management\n" >> $i/welcome.txt
done
}

function junkMessage() { 
for i in $(cat ${junklist})
do
echo -e "WELCOME\n\nThe purpose of the Junk drive and junk folders on the Excession Systems development network is to store temporary and non-critical data files and binaries. Backup's of this drive is irregular so some data loss may occur. Critical data should be stored on the DATA drive. Have fun and keep the JUNK drive clean. There are no quotas or automated cleanup routimes on this drive, so if it runs out of space at any time data will simply be deleted.\n\nExcession Network Management\n" >> $i/purpose_of_junk_folders.txt
done
}

function techMessage() { 
for i in $(cat ${techlist})
do
echo -e "WELCOME\n\nThe purpose of the Tech drive and tech folders on the Excession Systems development network is to store data files and binaries necessary for the day-to-day operation of the network. Backup's of this drive is irregular so some data loss may occur. Critical data should be stored on the DATA drive. Have fun and keep the TECH drive clean. There are no quotas or automated cleanup routimes on this drive, space usage is monitored on an ongoing basis and will be expaneded as necessary.\n\nExcession Network Management\n" >> $i/purpose_of_tech_folders.txt
done
}

function dataMessage() { 
for i in $(cat ${datalist})
do
echo -e "WELCOME\n\nThe purpose of the Data drive and the data folders on the Excession Systems development network is to store permanent and critical data files and binaries. Backup's of this drive is on a daily basis, so data loss will not occur. Non-critical data should be stored on the JUNK drive. Have fun and keep the DATA drive clean. There are no quotas or automated cleanup routimes on this drive, space usage is monitored on an ongoing basis and will be expaneded as necessary.\n\nExcession Network Management\n" >> $i/purpose_of_data_folders.txt
done
}

function homeQuota() {
for i in $(cat ${homelist})
do
  nssquota -D -s 5GB -d $i
done
clear
echo ""
echo "Quotas have been set on all home folders."
echo ""
}

function dvolList() { 
/usr/bin/tree $nssbase/$dvol -dfi >> /root/reports/${dvol}_folder_report.txt
}

function hvolList() { 
/usr/bin/tree $nssbase/$hvol -dfi >> /root/reports/${hvol}_folder_report.txt
}

function tvolList() { 
/usr/bin/tree $nssbase/$tvol -dfi >> /root/reports/${tvol}_folder_report.txt
}

function jvolList() { 
/usr/bin/tree $nssbase/$jvol -dfi >> /root/reports/${jvol}_folder_report.txt
}

function warning() {
echo "--[ Help ]---------------------------------------"
echo "This script will automatically create the default"
echo "directory structures on NSS volumes named:"
echo "$dvol, $hvol, $tvol, and $jvol"
echo "The NSS Pools and Volumes need to exist before"
echo "running this script."
echo "Once the folders exist you can set access rights,"
echo "and quotas on the volumes."       
echo "================================================="
}

# Menu
warning
selection=
until [ "$selection" = "0" ]; do
echo ""
echo "NSS Directory Creation Menu"
echo "================================================="
echo "1 - Create directories on $nssbase/$dvol"
echo "2 - Create directories on $nssbase/$hvol"
echo "3 - Create directories on $nssbase/$tvol"
echo "4 - Create directories on $nssbase/$jvol"
echo "5 - Assign rights to $nssbase/$dvol"
echo "6 - Assign rights to $nssbase/$hvol"
echo "7 - Assign rights to $nssbase/$tvol"
echo "8 - Assign rights to $nssbase/$jvol"
echo "9 - Set quotas on $nssbase/$hvol"
echo "-------------------------------------------------"
echo "0 - exit"
echo "-------------------------------------------------"
echo ""
echo -n "Enter selection: "
read selection
echo ""
  case $selection in
    1 ) echo -e "$dvol folders are now being created." ; createDirData ; sleep 5 ; dataMessage ; sleep 5 ; dvolList ; clear;;
    2 ) echo -e "$hvol folders are now being created." ; createDirUser ; sleep 5 ; homeMessage ; sleep 5 ; hvolList ; clear ;;
    3 ) echo -e "$tvol folders are now being created." ; createDirTech ; sleep 5 ; techMessage ; sleep 5 ; tvolList ; clear;;
    4 ) echo -e "$jvol folders are now being created." ; createDirJunk ; sleep 5 ; junkMessage ; sleep 5 ; jvolList ; clear;;
    5 ) echo -e "Setting nss rights on $dvol folders." ; rightsData ; sleep 5 ; clear;;
    6 ) echo -e "Setting nss rights on $hvol folders." ; rightsUser ; sleep 5 ; clear;;
    7 ) echo -e "Setting nss rights on $tvol folders." ; rightsTech ; sleep 5 ; clear;;
    8 ) echo -e "Setting nss rights on $jvol folders." ; rightsJunk ; sleep 5 ; clear;;
    9 ) echo -e "Setting nss quotas on $hvol folders." ; homeQuota ; sleep 5 ; clear;;
    0 ) exit ;;
    * ) echo "Please enter 1 to 9, or 0 to exit, all other entries are invalid!" ;;
  esac
done

# Finished
exit 1

