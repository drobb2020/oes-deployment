#!/bin/bash
REL=0.1-5
##############################################################################
#
#    d-nss-structure.sh - Bash script to create default  ldif information 
#                         into a new tree
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
# Date Created: Tue Aug 06 09:00:00 2013
# Last updated: Wed Aug 27 08:52:16 2014 
# Crontab command: Not recommended
# Supporting file: 
##############################################################################
HOST=$(hostname)
ID=$(whoami)
PORT=636
ADM=cn=admin,o=$1
PWD=nashira!=000
SRCFLDR=/root/setup
LOG=/root/reports/ice-logs/folders.log
NDSBIN=/opt/novell/eDirectory/bin

# Create directories on NSS volumes
function createDirData() { 
mkdir -p /media/nss/DATA/allhands
mkdir -p /media/nss/DATA/collaboration
mkdir -p /media/nss/DATA/collaboration/consultants
mkdir -p /media/nss/DATA/collaboration/developers
mkdir -p /media/nss/DATA/collaboration/finance
mkdir -p /media/nss/DATA/collaboration/finance/gl
mkdir -p /media/nss/DATA/collaboration/finance/ar
mkdir -p /media/nss/DATA/collaboration/finance/pl
mkdir -p /media/nss/DATA/collaboration/hr
mkdir -p /media/nss/DATA/collaboration/hr/hiring
mkdir -p /media/nss/DATA/collaboration/hr/grievance
mkdir -p /media/nss/DATA/collaboration/hr/compensation
mkdir -p /media/nss/DATA/collaboration/legal
mkdir -p /media/nss/DATA/collaboration/management
mkdir -p /media/nss/DATA/collaboration/operations
mkdir -p /media/nss/DATA/collaboration/sales
mkdir -p /media/nss/DATA/collaboration/sales/campaigns
mkdir -p /media/nss/DATA/collaboration/sales/marketing-print
mkdir -p /media/nss/DATA/collaboration/sales/marketing-internet
mkdir -p /media/nss/DATA/collaboration/support
mkdir -p /media/nss/DATA/collaboration/technical
mkdir -p /media/nss/DATA/collaboration/technical/reports
mkdir -p /media/nss/DATA/collaboration/technical/reports/sc
mkdir -p /media/nss/DATA/collaboration/technical/reports/slp
mkdir -p /media/nss/DATA/collaboration/technical/reports/backups
mkdir -p /media/nss/DATA/collaboration/technical/product_docs
mkdir -p /media/nss/DATA/collaboration/technical/product_docs/novell
mkdir -p /media/nss/DATA/collaboration/technical/product_docs/suse
mkdir -p /media/nss/DATA/collaboration/technical/network_docs/microsoft
mkdir -p /media/nss/DATA/collaboration/technical/product_docs/vmware
mkdir -p /media/nss/DATA/collaboration/technical/product_docs/oracle
mkdir -p /media/nss/DATA/collaboration/technical/incidents
mkdir -p /media/nss/DATA/confidential
mkdir -p /media/nss/DATA/confidential/consultants
mkdir -p /media/nss/DATA/confidential/developers
mkdir -p /media/nss/DATA/confidential/finance
mkdir -p /media/nss/DATA/confidential/hr
mkdir -p /media/nss/DATA/confidential/legal
mkdir -p /media/nss/DATA/confidential/management
mkdir -p /media/nss/DATA/confidential/management/consulting
mkdir -p /media/nss/DATA/confidential/management/development
mkdir -p /media/nss/DATA/confidential/management/finance
mkdir -p /media/nss/DATA/confidential/management/hr
mkdir -p /media/nss/DATA/confidential/management/legal
mkdir -p /media/nss/DATA/confidential/management/operations
mkdir -p /media/nss/DATA/confidential/management/sales-marketing
mkdir -p /media/nss/DATA/confidential/management/support
mkdir -p /media/nss/DATA/confidential/management/technical
mkdir -p /media/nss/DATA/confidential/operations
mkdir -p /media/nss/DATA/confidential/sales
mkdir -p /media/nss/DATA/confidential/support
mkdir -p /media/nss/DATA/confidential/technical
}

function createDirUser() { 
mkdir -p /media/nss/USER/users
mkdir -p /media/nss/USER/admin
mkdir -p /media/nss/USER/sa
mkdir -p /media/nss/USER/users/aanderso
mkdir -p /media/nss/USER/users/abailey
mkdir -p /media/nss/USER/users/aclark
mkdir -p /media/nss/USER/users/agagnon
mkdir -p /media/nss/USER/users/agray
mkdir -p /media/nss/USER/users/ahernand
mkdir -p /media/nss/USER/users/ahughes
mkdir -p /media/nss/USER/users/ajenkins
mkdir -p /media/nss/USER/users/alopez
mkdir -p /media/nss/USER/users/amartine
mkdir -p /media/nss/USER/users/aortiz
mkdir -p /media/nss/USER/users/aperez
mkdir -p /media/nss/USER/users/arivera
mkdir -p /media/nss/USER/users/arobb
mkdir -p /media/nss/USER/users/ataylor
mkdir -p /media/nss/USER/users/athompso
mkdir -p /media/nss/USER/users/award
mkdir -p /media/nss/USER/users/awhite
mkdir -p /media/nss/USER/users/badams
mkdir -p /media/nss/USER/users/bcook
mkdir -p /media/nss/USER/users/bramirez
mkdir -p /media/nss/USER/users/bross
mkdir -p /media/nss/USER/users/cbaker
mkdir -p /media/nss/USER/users/cgarcia
mkdir -p /media/nss/USER/users/cmorgan
mkdir -p /media/nss/USER/users/croy
mkdir -p /media/nss/USER/users/dflores
mkdir -p /media/nss/USER/users/dharris
mkdir -p /media/nss/USER/users/dpowell
mkdir -p /media/nss/USER/users/drobb
mkdir -p /media/nss/USER/users/edavis
mkdir -p /media/nss/USER/users/ehoward
mkdir -p /media/nss/USER/users/escott
mkdir -p /media/nss/USER/users/ethomas
mkdir -p /media/nss/USER/users/ewilliam
mkdir -p /media/nss/USER/users/eyoung
mkdir -p /media/nss/USER/users/gedwards
mkdir -p /media/nss/USER/users/gking
mkdir -p /media/nss/USER/users/gnelson
mkdir -p /media/nss/USER/users/greed
mkdir -p /media/nss/USER/users/hlewis
mkdir -p /media/nss/USER/users/hmitchel
mkdir -p /media/nss/USER/users/ibennett
mkdir -p /media/nss/USER/users/igomez
mkdir -p /media/nss/USER/users/ijohnson
mkdir -p /media/nss/USER/users/jallen
mkdir -p /media/nss/USER/users/jcampbel
mkdir -p /media/nss/USER/users/jcox
mkdir -p /media/nss/USER/users/jgonzale
mkdir -p /media/nss/USER/users/jlam
mkdir -p /media/nss/USER/users/jlrobb
mkdir -p /media/nss/USER/users/jmiller
mkdir -p /media/nss/USER/users/jmorales
mkdir -p /media/nss/USER/users/jmurphy
mkdir -p /media/nss/USER/users/jprice
mkdir -p /media/nss/USER/users/jreyes
mkdir -p /media/nss/USER/users/jrobb
mkdir -p /media/nss/USER/users/jroberts
mkdir -p /media/nss/USER/users/jsmith
mkdir -p /media/nss/USER/users/jterry
mkdir -p /media/nss/USER/users/jwatson
mkdir -p /media/nss/USER/users/jwood
mkdir -p /media/nss/USER/users/krobb
mkdir -p /media/nss/USER/users/mbrown
mkdir -p /media/nss/USER/users/mcarey
mkdir -p /media/nss/USER/users/mmartin
mkdir -p /media/nss/USER/users/mowen
mkdir -p /media/nss/USER/users/mrobb
mkdir -p /media/nss/USER/users/mrobinso
mkdir -p /media/nss/USER/users/njackson
mkdir -p /media/nss/USER/users/owilson
mkdir -p /media/nss/USER/users/sjones
mkdir -p /media/nss/USER/users/testuser
mkdir -p /media/nss/USER/users/wmoore
mkdir -p /media/nss/USER/sa/ediradmin
mkdir -p /media/nss/USER/sa/edirreports
mkdir -p /media/nss/USER/sa/ftpupload
mkdir -p /media/nss/USER/sa/ftpdnload
mkdir -p /media/nss/USER/sa/gwadmin
mkdir -p /media/nss/USER/sa/gwagents
mkdir -p /media/nss/USER/sa/gwcaladm
mkdir -p /media/nss/USER/sa/idmadmin
mkdir -p /media/nss/USER/sa/ldapuser
mkdir -p /media/nss/USER/sa/helpdesk
mkdir -p /media/nss/USER/sa/nmadmin
mkdir -p /media/nss/USER/sa/pwmadmin
mkdir -p /media/nss/USER/sa/pwmproxy
mkdir -p /media/nss/USER/sa/vibemail
mkdir -p /media/nss/USER/sa/zenadmin
mkdir -p /media/nss/USER/admin/aarobb
mkdir -p /media/nss/USER/admin/adrobb
mkdir -p /media/nss/USER/admin/admin
}

function rightsData() { 
/opt/novell/nss/sbin/rights -f /media/nss/DATA/allhands -r all trustee allhands.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/consultants -r all trustee consultants.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/developers -r all trustee developers.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/finance -r all trustee finance.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/hr -r all trustee hr.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/legal -r all trustee legal.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/management -r all trustee management.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/operations -r all trustee operations.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/sales -r all trustee sales.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/support -r all trustee support.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration/technical -r all trustee technical.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/collaboration -r all trustee management.idm-groups.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/DATA/confidential -r all trustee management.idm-groups.idm.idm-tree
}

function rightsUser() { 
/opt/novell/nss/sbin/rights -f /media/nss/USER/admin/aarobb -r all trustee aarobb.admin.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/admin/adrobb -r all trustee adrobb.admin.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/admin/admin -r all trustee admin.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/ediradmin -r all trustee ediradmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/edirreports -r all trustee edirreports.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/ftpupload -r all trustee edirreports.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/ftpdnload -r all trustee edirreports.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/gwadmin -r all trustee gwadmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/gwagents -r all trustee gwagents.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/gwcaladm -r all trustee gwcaladm.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/idmadmin -r all trustee idmadmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/ldapuser -r all trustee ldapuser.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/helpdesk -r all trustee helpdesk.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/nmadmin -r all trustee nmadmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/pwmadmin -r all trustee PwmAdmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/pwmproxy -r all trustee PwmProxy.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/vibemail -r all trustee vibemail.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/sa/zenadmin -r all trustee zenadmin.sa.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/aanderso -r all trustee aanderso.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/abailey -r all trustee abailey.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/aclark -r all trustee aclark.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/agagnon -r all trustee agagnon.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/agray -r all trustee agray.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ahernand -r all trustee ahernand.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ahughes -r all trustee ahughes.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ajenkins -r all trustee ajenkins.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/alopez -r all trustee alopez.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/amartine -r all trustee amartine.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/aortiz -r all trustee aortiz.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/aperez -r all trustee aperez.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/arivera -r all trustee arivera.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/arobb -r all trustee arobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ataylor -r all trustee ataylor.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/athompso -r all trustee athompso.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/award -r all trustee award.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/awhite -r all trustee awhite.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/badams -r all trustee badams.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/bcook -r all trustee bcook.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/bramirez -r all trustee bramirez.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/bross -r all trustee bross.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/cbaker -r all trustee cbaker.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/cgarcia -r all trustee cgarcia.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/cmorgan -r all trustee cmorgan.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/croy -r all trustee croy.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/dflores -r all trustee dflores.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/dharris -r all trustee dharris.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/dpowell -r all trustee dpowell.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/drobb -r all trustee drobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/edavis -r all trustee edavis.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ehoward -r all trustee ehoward.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/escott -r all trustee escott.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ethomas -r all trustee ethomas.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ewilliam -r all trustee ewilliam.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/eyoung -r all trustee eyoung.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/gedwards -r all trustee gedwards.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/gking -r all trustee gking.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/gnelson -r all trustee gnelson.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/greed -r all trustee greed.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/hlewis -r all trustee hlewis.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/hmitchel -r all trustee hmitchel.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ibennett -r all trustee ibennett.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/igomez -r all trustee igomez.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/ijohnson -r all trustee ijohnson.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jallen -r all trustee jallen.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jcampbel -r all trustee jcampbel.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jcox -r all trustee jcox.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jgonzale -r all trustee jgonzale.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jlam -r all trustee jlam.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jlrobb -r all trustee jlrobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jmiller -r all trustee jmiller.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jmorales -r all trustee jmorales.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jmurphy -r all trustee jmurphy.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jprice -r all trustee jprice.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jreyes -r all trustee jreyes.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jrobb -r all trustee jrobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jroberts -r all trustee jroberts.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jsmith -r all trustee jsmith.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jterry -r all trustee jterry.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jwatson -r all trustee jwatson.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/jwood -r all trustee jwood.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/krobb -r all trustee krobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mbrown -r all trustee mbrown.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mcarey -r all trustee mcarey.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mmartin -r all trustee mmartin.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mowen -r all trustee mowen.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mrobb -r all trustee mrobb.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/mrobinso -r all trustee mrobinso.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/njackson -r all trustee njackson.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/owilson -r all trustee owilson.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/sjones -r all trustee sjones.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/testuser -r all trustee testuser.active.idm-users.idm.idm-tree
/opt/novell/nss/sbin/rights -f /media/nss/USER/users/wmoore -r all trustee wmoore.active.idm-users.idm.idm-tree
}

function welcome() { 
for i in $(cat ~/setup/folders.txt)
do
echo -e "WELCOME\n\nWelcome to Excession Systems production network. This is your personal home directory. The files stored here can only be accessed by you. You are not allowed to grant other employee's access to this directory. If you need to share files with other please do so on the collaboration drive. There is a 2 GB quota on your drive. This should be sufficient for most people. If you require more space please submit a request to the helpdesk along with a compelling reason.\n\nExcession Network Management\n" >> $i/welcome.txt
done
}

function warning() {
  echo "--[ Warning ]--------------------------------------"
  echo "This script will automatically create the default"
  echo "directory structures on NSS volumes named:"
  echo "DATA and USER"
  echo "The NSS Pools and Volumes need to exist before"
  echo "running this script."
  echo "==================================================="
}
# Menu
warning
selection=
until [ "Sselection" = "0" ]; do
  echo ""
  echo "NSS Directory Creation and Rights Assignment Menu"
  echo "====================================================="
  echo "Run steps 1 and 2 before importing users!"
  echo "1 - Create directories on DATA"
  echo "2 - Create directories on USER"
  echo "Run steps 3 and 4 after importing users!"
  echo "3 - Assign rights to DATA"
  echo "4 - Assign rights to USER"
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

