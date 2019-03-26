#!/usr/bin/env bash

########
#
# BlackBird's Port Scanning Module 
#
#######


PATH_BLACKBIRD_BASE=$1
PATH_FLYOVER_BASE=$2
InFile=$3
Domain=$4
SLACK_TOKEN=$5

mkdir -p $PATH_FLYOVER_BASE$Domain/nmap
mkdir -p $PATH_FLYOVER_BASE$Domain/passivePortScanner

# Passive Port Scanning Portion 

slack-cli -t $SLACK_TOKEN -d blackbird-output "Passive and Active Port Scanners started on $Domain"

while read DOMAIN
do

 	$PATH_BLACKBIRD_BASEmodules/shodan_api.py -d $DOMAIN >> $PATH_FLYOVER_BASE$DomainpassivePortScanning/passiveOutput.txt

done < $InFile

# Passive Port Scanning Ending Alert, Active Port Scanning Beginning Alert

slack-cli -t $SLACK_TOKEN -d blackbird-output "Passive Scanning is done, Activating Active Scanner $Domain"

nmap -T4 -sS -Pn -v3 -p1- -iL $InFile -oA $PATH_FLYOVER_BASE$Domain/nmap/allTCP_Quick

# Port Scanning Finished Alert 

slack-cli -t $SLACK_TOKEN -d blackbird-output "Active Scanning for $Domain is done"
