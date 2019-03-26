#!/usr/bin/env bash

########
#
# BlackBird's Bruteforcing Module 
#
#######

PG_DIRSEARCH=$1
In_File=$2
Domain=$3
In_Path=$4
VAR_SLACK_TOKEN=$5

mkdir $In_Path$Domain/bruteforcer

slack-cli -t $VAR_SLACK_TOKEN -d blackbird-output "Dirsearch Bruteforcing Started Against $Domain"

while read DOMAIN
do

	$PG_DIRSEARCH -u $(echo "http://""$DOMAIN") -e txt,css,html,js,zip,tar,config,xml,php,jsp,asp,aspx,cs,vb,py,pl,rb,csv,yml --plain-text-report=$In_Path$Domain/bruteforcer/$(echo "http_""$DOMAIN")
	$PG_DIRSEARCH -u $(echo "https://""$DOMAIN") -e txt,css,html,js,zip,tar,config,xml,php,jsp,asp,aspx,cs,vb,py,pl,rb,csv,yml --plain-text-report=$In_Path$Domain/bruteforcer/$(echo "https_""$DOMAIN")

done < $In_File

slack-cli -t $VAR_SLACK_TOKEN -d blackbird-output "Dirsearch Bruteforcing Finished Against $Domain"
