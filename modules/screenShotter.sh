#!/usr/bin/env bash

########
#
# BlackBird's Screenshotting Module 
#
#######


PG_EYEWITNESS=$1
PATH_FLYOVER_BASE=$2
InFile=$3
Domain=$4
SLACK_TOKEN=$5

#Screenshotting Initial Alert
slack-cli -t $SLACK_TOKEN -d blackbird-output "Screenshotting has been started on $Domain"


#Screenshotting Kick-off
$PG_EYEWITNESS --no-prompt --web -f $InFile -d $PATH_FLYOVER_BASE$Domain/EyeWitness_OutPut

#Screenshotting Final Alert
slack-cli -t $SLACK_TOKEN -d blackbird-output "Screenshotting is finished on $Domain"
