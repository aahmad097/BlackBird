#!/usr/bin/env bash

########
#
# BlackBird's configuration file discovery module
#
#######

PG_MEG=$1
FILE_MEG_WORDLIST=$2
InFile=$3
Domain=$4
SLACK_TOKEN=$5
PATH_FLYOVER_BASE=$6

# Config File Discovery Initial Alert
slack-cli -t $SLACK_TOKEN -d blackbird-output "Meg config file discovery started on $Domain"

# Config File Kickoff

$PG_MEG $FILE_MEG_WORDLIST $InFile $PATH_FLYOVER_BASE$Domain/Megan

# Config File Discovery Final Alert
slack-cli -t $SLACK_TOKEN -d blackbird-output "Meg config file discovery finished on $Domain"
