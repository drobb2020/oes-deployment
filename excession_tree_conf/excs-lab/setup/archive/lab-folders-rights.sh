#!/bin/bash
REL=0.1.7
##############################################################################
#
#    lab-folders-rights.sh - Bash script to create default nss folders 
#                            in a new tree
#    Copyright (C) 2013  David Robb
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
# Date Created: Tue Aug 06 09:00 2013
# Last updated: Wed Apr 19 09:54 2017
# Crontab command: Not recommended
# Supporting file: 
##############################################################################
HOST=$(hostname)
ID=$(whoami)
PORT=636
ADM=cn=admin,ou=services,o=excs
PWD=yellowStone!228
SRCFLDR=/root/setup
LOG=/root/reports/ice-logs/folders.log
NDSBIN=/opt/novell/eDirectory/bin

# Create directories on NSS volumes
function createDirData() { 
mkdir -p /media/nss/DATA/allhands
mkdir -p /media/nss/DATA/collaboration
mkdir -p /media/nss/DATA/collaboration/consulting_team
mkdir -p /media/nss/DATA/collaboration/development_team
mkdir -p /media/nss/DATA/collaboration/finance_team
mkdir -p /media/nss/DATA/collaboration/finance_team/budget
mkdir -p /media/nss/DATA/collaboration/finance_team/forecast
mkdir -p /media/nss/DATA/collaboration/finance_team/gl
mkdir -p /media/nss/DATA/collaboration/finance_team/ar
mkdir -p /media/nss/DATA/collaboration/finance_team/pl
mkdir -p /media/nss/DATA/collaboration/human_resources_team
mkdir -p /media/nss/DATA/collaboration/human_resources_team/hiring
mkdir -p /media/nss/DATA/collaboration/human_resources_team/grievance
mkdir -p /media/nss/DATA/collaboration/human_resources_team/compensation
mkdir -p /media/nss/DATA/collaboration/legal_team
mkdir -p /media/nss/DATA/collaboration/management_team
mkdir -p /media/nss/DATA/collaboration/sales_team
mkdir -p /media/nss/DATA/collaboration/sales_team/campaigns
mkdir -p /media/nss/DATA/collaboration/sales_team/marketing-print
mkdir -p /media/nss/DATA/collaboration/sales_team/marketing-internet
mkdir -p /media/nss/DATA/collaboration/technical_team
mkdir -p /media/nss/DATA/collaboration/technical_team/operations_team
mkdir -p /media/nss/DATA/collaboration/technical_team/support_team
mkdir -p /media/nss/DATA/collaboration/technical_team/change_requests
mkdir -p /media/nss/DATA/collaboration/technical_team/reports
mkdir -p /media/nss/DATA/collaboration/technical_team/reports/supportconfigs
mkdir -p /media/nss/DATA/collaboration/technical_team/reports/slp_reports
mkdir -p /media/nss/DATA/collaboration/technical_team/reports/backup_reports
mkdir -p /media/nss/DATA/collaboration/technical_team/product_docs
mkdir -p /media/nss/DATA/collaboration/technical_team/incidents
mkdir -p /media/nss/DATA/confidential
mkdir -p /media/nss/DATA/confidential/consulting_team
mkdir -p /media/nss/DATA/confidential/development_team
mkdir -p /media/nss/DATA/confidential/finance_team
mkdir -p /media/nss/DATA/confidential/human_resources_team
mkdir -p /media/nss/DATA/confidential/legal_team
mkdir -p /media/nss/DATA/confidential/management_team
mkdir -p /media/nss/DATA/confidential/management_team/consulting_team
mkdir -p /media/nss/DATA/confidential/management_team/development_team
mkdir -p /media/nss/DATA/confidential/management_team/finance_team
mkdir -p /media/nss/DATA/confidential/management_team/human_resources_team
mkdir -p /media/nss/DATA/confidential/management_team/legal_team
mkdir -p /media/nss/DATA/confidential/management_team/sales_team
mkdir -p /media/nss/DATA/confidential/management_team/technical_team
mkdir -p /media/nss/DATA/confidential/management_team/technical_team/operations_team
mkdir -p /media/nss/DATA/confidential/management_team/technical_team/support_team
mkdir -p /media/nss/DATA/confidential/sales_team
mkdir -p /media/nss/DATA/confidential/technical_team
mkdir -p /media/nss/DATA/confidential/technical_team/operations_team
mkdir -p /media/nss/DATA/confidential/technical_team/support_team
}

function createDirUser() { 
mkdir -p /media/nss/HOME/users
mkdir -p /media/nss/HOME/admin
mkdir -p /media/nss/HOME/sa
mkdir -p /media/nss/HOME/users/aanderso
mkdir -p /media/nss/HOME/users/abailey
mkdir -p /media/nss/HOME/users/aclark
mkdir -p /media/nss/HOME/users/agagnon
mkdir -p /media/nss/HOME/users/agray
mkdir -p /media/nss/HOME/users/ahernand
mkdir -p /media/nss/HOME/users/ahughes
mkdir -p /media/nss/HOME/users/ajenkins
mkdir -p /media/nss/HOME/users/alopez
mkdir -p /media/nss/HOME/users/amartine
mkdir -p /media/nss/HOME/users/aortiz
mkdir -p /media/nss/HOME/users/aperez
mkdir -p /media/nss/HOME/users/arivera
mkdir -p /media/nss/HOME/users/arobb
mkdir -p /media/nss/HOME/users/ataylor
mkdir -p /media/nss/HOME/users/athompso
mkdir -p /media/nss/HOME/users/award
mkdir -p /media/nss/HOME/users/awhite
mkdir -p /media/nss/HOME/users/badams
mkdir -p /media/nss/HOME/users/bcook
mkdir -p /media/nss/HOME/users/bramirez
mkdir -p /media/nss/HOME/users/bross
mkdir -p /media/nss/HOME/users/cbaker
mkdir -p /media/nss/HOME/users/cgarcia
mkdir -p /media/nss/HOME/users/cmorgan
mkdir -p /media/nss/HOME/users/croy
mkdir -p /media/nss/HOME/users/dflores
mkdir -p /media/nss/HOME/users/dharris
mkdir -p /media/nss/HOME/users/dpowell
mkdir -p /media/nss/HOME/users/drobb
mkdir -p /media/nss/HOME/users/edavis
mkdir -p /media/nss/HOME/users/ehoward
mkdir -p /media/nss/HOME/users/escott
mkdir -p /media/nss/HOME/users/ethomas
mkdir -p /media/nss/HOME/users/ewilliam
mkdir -p /media/nss/HOME/users/eyoung
mkdir -p /media/nss/HOME/users/gedwards
mkdir -p /media/nss/HOME/users/gking
mkdir -p /media/nss/HOME/users/gnelson
mkdir -p /media/nss/HOME/users/greed
mkdir -p /media/nss/HOME/users/hlewis
mkdir -p /media/nss/HOME/users/hmitchel
mkdir -p /media/nss/HOME/users/ibennett
mkdir -p /media/nss/HOME/users/igomez
mkdir -p /media/nss/HOME/users/ijohnson
mkdir -p /media/nss/HOME/users/jallen
mkdir -p /media/nss/HOME/users/jcampbel
mkdir -p /media/nss/HOME/users/jcox
mkdir -p /media/nss/HOME/users/jgonzale
mkdir -p /media/nss/HOME/users/jlam
mkdir -p /media/nss/HOME/users/jlrobb
mkdir -p /media/nss/HOME/users/jmiller
mkdir -p /media/nss/HOME/users/jmorales
mkdir -p /media/nss/HOME/users/jmurphy
mkdir -p /media/nss/HOME/users/jprice
mkdir -p /media/nss/HOME/users/jreyes
mkdir -p /media/nss/HOME/users/jrobb
mkdir -p /media/nss/HOME/users/jroberts
mkdir -p /media/nss/HOME/users/jsmith
mkdir -p /media/nss/HOME/users/jterry
mkdir -p /media/nss/HOME/users/jwatson
mkdir -p /media/nss/HOME/users/jwood
mkdir -p /media/nss/HOME/users/krobb
mkdir -p /media/nss/HOME/users/mbrown
mkdir -p /media/nss/HOME/users/mcarey
mkdir -p /media/nss/HOME/users/scarey
mkdir -p /media/nss/HOME/users/icarey
mkdir -p /media/nss/HOME/users/dcarey
mkdir -p /media/nss/HOME/users/mmartin
mkdir -p /media/nss/HOME/users/mowen
mkdir -p /media/nss/HOME/users/mrobb
mkdir -p /media/nss/HOME/users/mrobinso
mkdir -p /media/nss/HOME/users/njackson
mkdir -p /media/nss/HOME/users/owilson
mkdir -p /media/nss/HOME/users/sjones
mkdir -p /media/nss/HOME/users/testuser
mkdir -p /media/nss/HOME/users/wmoore
mkdir -p /media/nss/HOME/sa/ediradmin
mkdir -p /media/nss/HOME/sa/edirreports
mkdir -p /media/nss/HOME/sa/ftpupload
mkdir -p /media/nss/HOME/sa/ftpdnload
mkdir -p /media/nss/HOME/sa/gwadmin
mkdir -p /media/nss/HOME/sa/gwagents
mkdir -p /media/nss/HOME/sa/gwcaladm
mkdir -p /media/nss/HOME/sa/idmadmin
mkdir -p /media/nss/HOME/sa/ldapuser
mkdir -p /media/nss/HOME/sa/helpdesk
mkdir -p /media/nss/HOME/sa/nmadmin
mkdir -p /media/nss/HOME/sa/pwmadmin
mkdir -p /media/nss/HOME/sa/pwmproxy
mkdir -p /media/nss/HOME/sa/vibemail
mkdir -p /media/nss/HOME/sa/zenadmin
mkdir -p /media/nss/HOME/admin/aarobb
mkdir -p /media/nss/HOME/admin/adrobb
mkdir -p /media/nss/HOME/admin/admin
}

function rightsData() { 
/opt/novell/nss/sbin/rights -f /media/nss/DATA/allhands -r all trustee allhands.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/consulting_team -r all trustee consultants.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/development_team -r all trustee developers.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/finance_team -r all trustee finance.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/human_resources_team -r all trustee hr.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/legal_team -r all trustee legal.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/management_team -r all trustee management.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/technical_team/operations_team -r all trustee operations.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/sales_team -r all trustee sales.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/technical_team/support_team -r all trustee support.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/technical_team -r all trustee technical.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration -r all trustee management.excs-groups.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/confidential -r all trustee management.excs-groups.excs.excs-tree
}

function rightsUser() { 
/opt/novell/nss/sbin/rights -f /media/nss/HOME/admin/aarobb -r all trustee aarobb.admin.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/admin/adrobb -r all trustee adrobb.admin.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/admin/admin -r all trustee admin.services.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/ediradmin -r all trustee ediradmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/edirreports -r all trustee edirreports.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/ftpupload -r all trustee edirreports.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/ftpdnload -r all trustee edirreports.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/gwadmin -r all trustee gwadmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/gwagents -r all trustee gwagents.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/gwcaladm -r all trustee gwcaladm.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/idmadmin -r all trustee idmadmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/ldapuser -r all trustee ldapuser.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/helpdesk -r all trustee helpdesk.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/nmadmin -r all trustee nmadmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/pwmadmin -r all trustee PwmAdmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/pwmproxy -r all trustee PwmProxy.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/vibemail -r all trustee vibemail.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/sa/zenadmin -r all trustee zenadmin.sa.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/aanderso -r all trustee aanderso.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/abailey -r all trustee abailey.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/aclark -r all trustee aclark.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/agagnon -r all trustee agagnon.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/agray -r all trustee agray.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ahernand -r all trustee ahernand.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ahughes -r all trustee ahughes.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ajenkins -r all trustee ajenkins.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/alopez -r all trustee alopez.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/amartine -r all trustee amartine.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/aortiz -r all trustee aortiz.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/aperez -r all trustee aperez.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/arivera -r all trustee arivera.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/arobb -r all trustee arobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ataylor -r all trustee ataylor.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/athompso -r all trustee athompso.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/award -r all trustee award.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/awhite -r all trustee awhite.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/badams -r all trustee badams.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/bcook -r all trustee bcook.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/bramirez -r all trustee bramirez.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/bross -r all trustee bross.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/cbaker -r all trustee cbaker.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/cgarcia -r all trustee cgarcia.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/cmorgan -r all trustee cmorgan.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/croy -r all trustee croy.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/dflores -r all trustee dflores.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/dharris -r all trustee dharris.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/dpowell -r all trustee dpowell.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/drobb -r all trustee drobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/edavis -r all trustee edavis.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ehoward -r all trustee ehoward.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/escott -r all trustee escott.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ethomas -r all trustee ethomas.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ewilliam -r all trustee ewilliam.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/eyoung -r all trustee eyoung.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/gedwards -r all trustee gedwards.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/gking -r all trustee gking.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/gnelson -r all trustee gnelson.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/greed -r all trustee greed.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/hlewis -r all trustee hlewis.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/hmitchel -r all trustee hmitchel.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ibennett -r all trustee ibennett.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/igomez -r all trustee igomez.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/ijohnson -r all trustee ijohnson.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jallen -r all trustee jallen.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jcampbel -r all trustee jcampbel.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jcox -r all trustee jcox.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jgonzale -r all trustee jgonzale.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jlam -r all trustee jlam.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jlrobb -r all trustee jlrobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jmiller -r all trustee jmiller.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jmorales -r all trustee jmorales.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jmurphy -r all trustee jmurphy.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jprice -r all trustee jprice.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jreyes -r all trustee jreyes.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jrobb -r all trustee jrobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jroberts -r all trustee jroberts.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jsmith -r all trustee jsmith.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jterry -r all trustee jterry.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jwatson -r all trustee jwatson.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/jwood -r all trustee jwood.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/krobb -r all trustee krobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mbrown -r all trustee mbrown.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mcarey -r all trustee mcarey.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/scarey -r all trustee scarey.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/icarey -r all trustee icarey.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/dcarey -r all trustee dcarey.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mmartin -r all trustee mmartin.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mowen -r all trustee mowen.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mrobb -r all trustee mrobb.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/mrobinso -r all trustee mrobinso.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/njackson -r all trustee njackson.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/owilson -r all trustee owilson.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/sjones -r all trustee sjones.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/testuser -r all trustee testuser.active.excs-users.excs.excs-tree
/opt/novell/nss/sbin/rights -f /media/nss/HOME/users/wmoore -r all trustee wmoore.active.excs-users.excs.excs-tree
}

function welcome() { 
for i in $(cat ~/setup/lab-folders.txt)
do
echo -e "WELCOME\n\nWelcome to Excession Systems production network. This is your personal home directory. The files stored here can only be accessed by you. You are not allowed to grant other employee's access to this directory. If you need to share files with other please do so on the collaboration drive. There is a 2 GB quota on your drive. This should be sufficient for most people. If you require more space please submit a request to the helpdesk along with a compelling reason.\n\nExcession Network Management\n" >> $i/welcome.txt
done
}

function warning() {
	echo "--[ Warning ]--------------------------------------"
	echo "This script will automatically create the default"
	echo "directory structures on NSS volumes named:"
	echo "DATA and HOME"
	echo "The NSS Pools and Volumes need to exist before"
	echo "running this script."
	echo "==================================================="
}
# Menu
warning
selection=
until [ "Sselection" = "0" ]; do
	echo ""
	echo "NSS Directory Creation Menu"
	echo "====================================================="
	echo "1 - Create directories on DATA"
	echo "2 - Create directories on HOME"
	echo "3 - Assign rights to DATA"
	echo "4 - Assign rights to HOME"
	echo "0 - exit"
	echo ""
	echo -n "Enter selection: "
	read selection
	echo ""
	case $selection in
		1 ) echo -e "Data folders are now being created." ; createDirData ;;
		2 ) echo -e "User home folders are now being created." ; createDirUser ; echo -e "Let's add a welcome message to everyone's home folder." ; welcome ;;
		3 ) echo -e "Setting nss rights on data folders." ; rightsData ;;
		4 ) echo -e "Setting nss rights on home folders." ; rightsUser ;;
		0 ) exit ;;
		* ) echo "Please enter 1, 2, 3, 4, or 0" ;;
	esac
done

# Finished
exit 1

