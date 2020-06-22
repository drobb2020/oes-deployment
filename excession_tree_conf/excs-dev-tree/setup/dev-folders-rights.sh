#!/bin/bash
REL=0.1-6
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
# Last updated: Tue Jun 30 14:24:58 2015 
# Crontab command: Not recommended
# Supporting file: 
##############################################################################
HOST=$(hostname)
ID=$(whoami)
PORT=636
ADM=cn=admin,o=$1
PWD=yellowStone!228
SRCFLDR=/root/setup
LOG=/root/reports/ice-logs/dev-folders.log
NDSBIN=/opt/novell/eDirectory/bin
NSSSBIN=/opt/novell/nss/sbin
NSSROOT=/media/nss

# Create directories on NSS volumes
function createDirCommon() { 
mkdir -p $NSSROOT/COMMON/allhands
mkdir -p $NSSROOT/COMMON/collaboration
mkdir -p $NSSROOT/COMMON/collaboration/consultants
mkdir -p $NSSROOT/COMMON/collaboration/developers
mkdir -p $NSSROOT/COMMON/collaboration/finance
mkdir -p $NSSROOT/COMMON/collaboration/finance/gl
mkdir -p $NSSROOT/COMMON/collaboration/finance/ar
mkdir -p $NSSROOT/COMMON/collaboration/finance/pl
mkdir -p $NSSROOT/COMMON/collaboration/hr
mkdir -p $NSSROOT/COMMON/collaboration/hr/hiring
mkdir -p $NSSROOT/COMMON/collaboration/hr/grievance
mkdir -p $NSSROOT/COMMON/collaboration/hr/compensation
mkdir -p $NSSROOT/COMMON/collaboration/legal
mkdir -p $NSSROOT/COMMON/collaboration/management
mkdir -p $NSSROOT/COMMON/collaboration/operations
mkdir -p $NSSROOT/COMMON/collaboration/sales
mkdir -p $NSSROOT/COMMON/collaboration/sales/campaigns
mkdir -p $NSSROOT/COMMON/collaboration/sales/marketing-print
mkdir -p $NSSROOT/COMMON/collaboration/sales/marketing-internet
mkdir -p $NSSROOT/COMMON/collaboration/support
}

function createDirTechnical() {
mkdir -p $NSSROOT/TECHNICAL/technical
mkdir -p $NSSROOT/TECHNICAL/technical/Documentation
mkdir -p $NSSROOT/TECHNICAL/technical/Documentation/design
mkdir -p $NSSROOT/TECHNICAL/technical/Documentation/procedures
mkdir -p $NSSROOT/TECHNICAL/technical/Documentation/white_papers
mkdir -p $NSSROOT/TECHNICAL/technical/Documentation/cheat_sheets
mkdir -p $NSSROOT/TECHNICAL/technical/reports
mkdir -p $NSSROOT/TECHNICAL/technical/reports/sc
mkdir -p $NSSROOT/TECHNICAL/technical/reports/slp
mkdir -p $NSSROOT/TECHNICAL/technical/reports/backups
mkdir -p $NSSROOT/TECHNICAL/technical/reports/health
mkdir -p $NSSROOT/TECHNICAL/technical/product_docs
mkdir -p $NSSROOT/TECHNICAL/technical/product_docs/novell
mkdir -p $NSSROOT/TECHNICAL/technical/product_docs/suse
mkdir -p $NSSROOT/TECHNICAL/technical/network_docs/microsoft
mkdir -p $NSSROOT/TECHNICAL/technical/product_docs/vmware
mkdir -p $NSSROOT/TECHNICAL/technical/product_docs/oracle
mkdir -p $NSSROOT/TECHNICAL/technical/incidents
}

function createDirProtected() {
mkdir -p $NSSROOT/PROTECTED/confidential
mkdir -p $NSSROOT/PROTECTED/confidential/consultants
mkdir -p $NSSROOT/PROTECTED/confidential/developers
mkdir -p $NSSROOT/PROTECTED/confidential/finance
mkdir -p $NSSROOT/PROTECTED/confidential/hr
mkdir -p $NSSROOT/PROTECTED/confidential/legal
mkdir -p $NSSROOT/PROTECTED/confidential/management
mkdir -p $NSSROOT/PROTECTED/confidential/management/consulting
mkdir -p $NSSROOT/PROTECTED/confidential/management/development
mkdir -p $NSSROOT/PROTECTED/confidential/management/finance
mkdir -p $NSSROOT/PROTECTED/confidential/management/hr
mkdir -p $NSSROOT/PROTECTED/confidential/management/legal
mkdir -p $NSSROOT/PROTECTED/confidential/management/operations
mkdir -p $NSSROOT/PROTECTED/confidential/management/sales-marketing
mkdir -p $NSSROOT/PROTECTED/confidential/management/support
mkdir -p $NSSROOT/PROTECTED/confidential/management/technical
mkdir -p $NSSROOT/PROTECTED/confidential/operations
mkdir -p $NSSROOT/PROTECTED/confidential/sales
mkdir -p $NSSROOT/PROTECTED/confidential/support
mkdir -p $NSSROOT/PROTECTED/confidential/technical
}

function createDirHomeA() { 
mkdir -p $NSSROOT/HOME_A/users
mkdir -p $NSSROOT/HOME_A/users/aanderso
mkdir -p $NSSROOT/HOME_A/users/abailey
mkdir -p $NSSROOT/HOME_A/users/aclark
mkdir -p $NSSROOT/HOME_A/users/agagnon
mkdir -p $NSSROOT/HOME_A/users/agray
mkdir -p $NSSROOT/HOME_A/users/ahernand
mkdir -p $NSSROOT/HOME_A/users/ahughes
mkdir -p $NSSROOT/HOME_A/users/ajenkins
mkdir -p $NSSROOT/HOME_A/users/alopez
mkdir -p $NSSROOT/HOME_A/users/amartine
mkdir -p $NSSROOT/HOME_A/users/aortiz
mkdir -p $NSSROOT/HOME_A/users/aperez
mkdir -p $NSSROOT/HOME_A/users/arivera
mkdir -p $NSSROOT/HOME_A/users/arobb
mkdir -p $NSSROOT/HOME_A/users/ataylor
mkdir -p $NSSROOT/HOME_A/users/athompso
mkdir -p $NSSROOT/HOME_A/users/award
mkdir -p $NSSROOT/HOME_A/users/awhite
mkdir -p $NSSROOT/HOME_A/users/badams
mkdir -p $NSSROOT/HOME_A/users/bcook
mkdir -p $NSSROOT/HOME_A/users/bramirez
mkdir -p $NSSROOT/HOME_A/users/bross
mkdir -p $NSSROOT/HOME_A/users/cbaker
mkdir -p $NSSROOT/HOME_A/users/cgarcia
mkdir -p $NSSROOT/HOME_A/users/cmorgan
mkdir -p $NSSROOT/HOME_A/users/croy
mkdir -p $NSSROOT/HOME_A/users/dflores
mkdir -p $NSSROOT/HOME_A/users/dharris
mkdir -p $NSSROOT/HOME_A/users/dpowell
mkdir -p $NSSROOT/HOME_A/users/drobb
mkdir -p $NSSROOT/HOME_A/users/edavis
mkdir -p $NSSROOT/HOME_A/users/ehoward
mkdir -p $NSSROOT/HOME_A/users/escott
mkdir -p $NSSROOT/HOME_A/users/ethomas
mkdir -p $NSSROOT/HOME_A/users/ewilliam
mkdir -p $NSSROOT/HOME_A/users/eyoung
mkdir -p $NSSROOT/HOME_A/users/gedwards
mkdir -p $NSSROOT/HOME_A/users/gking
mkdir -p $NSSROOT/HOME_A/users/gnelson
mkdir -p $NSSROOT/HOME_A/users/greed
mkdir -p $NSSROOT/HOME_A/users/hlewis
mkdir -p $NSSROOT/HOME_A/users/hmitchel
mkdir -p $NSSROOT/HOME_A/users/ibennett
mkdir -p $NSSROOT/HOME_A/users/igomez
mkdir -p $NSSROOT/HOME_A/users/ijohnson
mkdir -p $NSSROOT/HOME_A/users/jallen
mkdir -p $NSSROOT/HOME_A/users/jcampbel
mkdir -p $NSSROOT/HOME_A/users/jcox
mkdir -p $NSSROOT/HOME_A/users/jgonzale
mkdir -p $NSSROOT/HOME_A/users/jlam
mkdir -p $NSSROOT/HOME_A/users/jlrobb
mkdir -p $NSSROOT/HOME_A/users/jmiller
mkdir -p $NSSROOT/HOME_A/users/jmorales
mkdir -p $NSSROOT/HOME_A/users/jmurphy
mkdir -p $NSSROOT/HOME_A/users/jprice
mkdir -p $NSSROOT/HOME_A/users/jreyes
mkdir -p $NSSROOT/HOME_A/users/jrobb
mkdir -p $NSSROOT/HOME_A/users/jroberts
mkdir -p $NSSROOT/HOME_A/users/jsmith
mkdir -p $NSSROOT/HOME_A/users/jterry
mkdir -p $NSSROOT/HOME_A/users/jwatson
mkdir -p $NSSROOT/HOME_A/users/jwood
mkdir -p $NSSROOT/HOME_A/users/krobb
mkdir -p $NSSROOT/HOME_A/users/mbrown
mkdir -p $NSSROOT/HOME_A/users/mcarey
mkdir -p $NSSROOT/HOME_A/users/mmartin
mkdir -p $NSSROOT/HOME_A/users/mowen
mkdir -p $NSSROOT/HOME_A/users/mrobb
mkdir -p $NSSROOT/HOME_A/users/mrobinso
mkdir -p $NSSROOT/HOME_A/users/njackson
mkdir -p $NSSROOT/HOME_A/users/owilson
mkdir -p $NSSROOT/HOME_A/users/sjones
mkdir -p $NSSROOT/HOME_A/users/testuser
mkdir -p $NSSROOT/HOME_A/users/wmoore
}

function createDirHomeB() {
mkdir -p $NSSROOT/HOME_B/sa
mkdir -p $NSSROOT/HOME_B/admin
mkdir -p $NSSROOT/HOME_B/sa/ediradmin
mkdir -p $NSSROOT/HOME_B/sa/edirreports
mkdir -p $NSSROOT/HOME_B/sa/ftpupload
mkdir -p $NSSROOT/HOME_B/sa/ftpdnload
mkdir -p $NSSROOT/HOME_B/sa/gwadmin
mkdir -p $NSSROOT/HOME_B/sa/gwagents
mkdir -p $NSSROOT/HOME_B/sa/gwcaladm
mkdir -p $NSSROOT/HOME_B/sa/idmadmin
mkdir -p $NSSROOT/HOME_B/sa/ldapuser
mkdir -p $NSSROOT/HOME_B/sa/helpdesk
mkdir -p $NSSROOT/HOME_B/sa/nmadmin
mkdir -p $NSSROOT/HOME_B/sa/pwmadmin
mkdir -p $NSSROOT/HOME_B/sa/pwmproxy
mkdir -p $NSSROOT/HOME_B/sa/vibemail
mkdir -p $NSSROOT/HOME_B/sa/zenadmin
mkdir -p $NSSROOT/HOME_B/admin/aarobb
mkdir -p $NSSROOT/HOME_B/admin/adrobb
mkdir -p $NSSROOT/HOME_B/admin/admin
}

function rightsDataCommon() { 
$NSSSBIN/rights -f $NSSROOT/COMMON/allhands -r all trustee allhands.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/consultants -r all trustee consultants.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/developers -r all trustee developers.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/finance -r all trustee finance.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/hr -r all trustee hr.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/legal -r all trustee legal.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/management -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/operations -r all trustee operations.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/sales -r all trustee sales.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/support -r all trustee support.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration/technical -r all trustee technical.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/COMMON/collaboration -r all trustee management.dev-groups.dev.dev-tree
}

function rightsDataTechnical() {
$NSSSBIN/rights -f $NSSROOT/TECHNICAL/technical -r all trustee technical.dev-groups.dev.dev-tree
}

function rightsDataProtected() { 
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/consultants -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/developers -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/finance -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/hr -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/legal -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/management -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/operations -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/sales -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/support -r all trustee management.dev-groups.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/PROTECTED/confidential/technical -r all trustee management.dev-groups.dev.dev-tree
}

function rightsHomeB() { 
$NSSSBIN/rights -f $NSSROOT/HOME_B/admin/aarobb -r all trustee aarobb.admin.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/admin/adrobb -r all trustee adrobb.admin.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/admin/admin -r all trustee admin.services.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/ediradmin -r all trustee ediradmin.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/edirreports -r all trustee edirreports.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/ftpupload -r all trustee edirreports.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/ftpdnload -r all trustee edirreports.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/gwadmin -r all trustee gwadmin.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/gwagents -r all trustee gwagents.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/gwcaladm -r all trustee gwcaladm.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/idmadmin -r all trustee idmadmin.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/ldapuser -r all trustee ldapuser.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/helpdesk -r all trustee helpdesk.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/nmadmin -r all trustee nmadmin.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/pwmadmin -r all trustee PwmAdmin.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/pwmproxy -r all trustee PwmProxy.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/vibemail -r all trustee vibemail.sa.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_B/sa/zenadmin -r all trustee zenadmin.sa.dev-users.dev.dev-tree
}

function rightsHomeA() {
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/aanderso -r all trustee aanderso.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/abailey -r all trustee abailey.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/aclark -r all trustee aclark.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/agagnon -r all trustee agagnon.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/agray -r all trustee agray.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ahernand -r all trustee ahernand.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ahughes -r all trustee ahughes.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ajenkins -r all trustee ajenkins.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/alopez -r all trustee alopez.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/amartine -r all trustee amartine.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/aortiz -r all trustee aortiz.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/aperez -r all trustee aperez.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/arivera -r all trustee arivera.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/arobb -r all trustee arobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ataylor -r all trustee ataylor.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/athompso -r all trustee athompso.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/award -r all trustee award.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/awhite -r all trustee awhite.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/badams -r all trustee badams.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/bcook -r all trustee bcook.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/bramirez -r all trustee bramirez.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/bross -r all trustee bross.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/cbaker -r all trustee cbaker.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/cgarcia -r all trustee cgarcia.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/cmorgan -r all trustee cmorgan.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/croy -r all trustee croy.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/dflores -r all trustee dflores.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/dharris -r all trustee dharris.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/dpowell -r all trustee dpowell.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/drobb -r all trustee drobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/edavis -r all trustee edavis.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ehoward -r all trustee ehoward.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/escott -r all trustee escott.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ethomas -r all trustee ethomas.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ewilliam -r all trustee ewilliam.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/eyoung -r all trustee eyoung.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/gedwards -r all trustee gedwards.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/gking -r all trustee gking.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/gnelson -r all trustee gnelson.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/greed -r all trustee greed.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/hlewis -r all trustee hlewis.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/hmitchel -r all trustee hmitchel.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ibennett -r all trustee ibennett.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/igomez -r all trustee igomez.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/ijohnson -r all trustee ijohnson.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jallen -r all trustee jallen.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jcampbel -r all trustee jcampbel.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jcox -r all trustee jcox.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jgonzale -r all trustee jgonzale.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jlam -r all trustee jlam.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jlrobb -r all trustee jlrobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jmiller -r all trustee jmiller.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jmorales -r all trustee jmorales.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jmurphy -r all trustee jmurphy.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jprice -r all trustee jprice.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jreyes -r all trustee jreyes.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jrobb -r all trustee jrobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jroberts -r all trustee jroberts.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jsmith -r all trustee jsmith.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jterry -r all trustee jterry.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jwatson -r all trustee jwatson.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/jwood -r all trustee jwood.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/krobb -r all trustee krobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mbrown -r all trustee mbrown.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mcarey -r all trustee mcarey.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mmartin -r all trustee mmartin.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mowen -r all trustee mowen.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mrobb -r all trustee mrobb.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/mrobinso -r all trustee mrobinso.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/njackson -r all trustee njackson.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/owilson -r all trustee owilson.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/sjones -r all trustee sjones.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/testuser -r all trustee testuser.active.dev-users.dev.dev-tree
$NSSSBIN/rights -f $NSSROOT/HOME_A/users/wmoore -r all trustee wmoore.active.dev-users.dev.dev-tree
}

function welcomeA() { 
for i in $(cat ~/setup/foldersA.txt)
do
echo -e "WELCOME\n\nWelcome to Excession Systems production network. This is your personal home directory. The files stored here can only be accessed by you. You are not allowed to grant other employee's access to this directory. If you need to share files with other please do so on the collaboration drive. There is a 2 GB quota on your drive. This should be sufficient for most people. If you require more space please submit a request to the helpdesk along with a compelling reason.\n\nExcession Network Management\n" >> $i/welcome.txt
done
}

function welcomeB() {
for i in $(cat ~/setup/foldersB.txt)
do
echo -e "WELCOME\n\nWelcome to Excession Systems production network. This is your personal home directory. The files stored here can only be accessed by you. You are not allowed to grant other employee's access to this directory. If you need to share files with other please do so on the collaboration drive. There is a 2 GB quota on your drive. This should be sufficient for most people. If you require more space please submit a request to the helpdesk along with a compelling reason.\n\nExcession Network Management\n" >> $i/welcome.txt
done
}

function warning() {
  echo "--[ Warning ]--------------------------------------"
  echo "This script will automatically create the default"
  echo "directory structures on NSS volumes named:"
  echo "COMMON, PROTECTED, TECHNICAL, HOME_A, and HOME_B"
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
  echo "================================================="
  echo "Run steps 1 to 5 at any time!"
  echo " 1 - Create directories on COMMON"
  echo " 2 - Create directories on PROTECTED"
  echo " 3 - Create directories on TECHNICAL"
  echo " 4 - Create directories on HOME_A"
  echo " 5 - Create directories on HOME_B"
  echo "Run steps 6 to 10 only after importing users!"
  echo " 6 - Assign rights to COMMON"
  echo " 7 - Assign rights to PROTECTED"
  echo " 8 - Assign rights to TECHNICAL"
  echo " 9 - Assign rights to HOME_A"
  echo "10 - Assign rights to HOME_B"
  echo "0 - exit"
  echo ""
  echo -n "Enter selection: "
  read selection
    echo ""
    case $selection in
    1 ) echo -e "Common data folders are now being created." ; createDirCommon ;;
    2 ) echo -e "Protected data folders are now being created." ; createDirProtected ;;
    3 ) echo -e "Technical data folders are now being created." ; createDirTechnical ;;
    4 ) echo -e "Home drive A folders are now being created." ; createDirHomeA ; echo -e "Let's add a welcome message to everyone's home folder." ; welcomeA ;;
    5 ) echo -e "Home drive B folders are now being created." ; createDirHomeB ; echo -e "Let's add a welcome message to everyone's home folder." ; welcomeB ;;
    6 ) echo -e "Rights being applied to Common" ; rightsDataCommon ;;
    7 ) echo -e "Rights being applied to Protected" ; rightsDataProtected ;;
    8 ) echo -e "Rights being applied to Technical" ; rightsDataTechnical ;;
    9 ) echo -e "Rights being applied to Home_A" ; rightsHomeA ;;
   10 ) echo -e "Rights being applied to Home_B" ; rightsHomeB ;;
    0 ) exit ;;
    * ) echo "Please enter a number between 1 and 10, or 0 to exit" ;;
    esac
done

# Finished
exit 1

