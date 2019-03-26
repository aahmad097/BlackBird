#!/usr/bin/env bash

# Configuration File

mkdir -p ~/HOPC_Flyover/

CONFIGFILE=$(realpath ~/HOPC_Flyover/config.default)

BASENAME=$(basename $0)

clear

read_config() {
	if [ ! -r $CONFIGFILE ]; then
		echo "ERROR: CONFIGFILE not found. Set the variable before proceeding."
		exit;
	fi
	PROGRAMS=""
	VARIABLES=""
	PATHS=""
	VARS=""
	FILES=""

	while IFS="=" read -r name value; do
		# strip quotes
		value="${value%\"}"
		value="${value#\"}"

		# set it to global scope if it has a value
		if [[ ! $name =~ ^\ *# && -n $value ]]; then
			export declare "${name}"=${value}
		fi

		# Capture the set variable names for further validation
		# Use the name from config and not operational name
		if [[ $name =~ ^PG_ ]]; then
			PROGRAMS="${PROGRAMS} ${name}"
		fi
		if [[ $name =~ ^PATH_ ]]; then
			PATHS="${PATHS} ${name}"
		fi
		if [[ $name =~ ^VAR_ ]]; then
			VARIABLES="${VARIABLES} ${name}"
		fi
		if [[ $name =~ ^FILE_ ]]; then
			FILES="${FILES} ${name}"
		fi

	done < $CONFIGFILE
}

check_config() {
	local CONFERRORS

	# --- Check required values that are blank by default in config.default --- #
	if [ -z "$VAR_SLACK_TOKEN" ]; then
		CONFERRORS="${CONFERRORS} 
		- VAR_SLACK_TOKEN must be defined"
	fi
	if [ -z "$PATH_FLYOVER_BASE" ]; then
		CONFERRORS="${CONFERRORS} 
		- PATH_FLYOVER_BASE must be defined"
	fi

	# -- Check that required programs exist and are executable -- #
	for PGM in $PROGRAMS; do
		if ! type ${!PGM} > /dev/null 2>&1; then
			CONFERRORS="${CONFERRORS} 
		- Program ${!PGM} does not exist on the system"
		else
			if [[ ! -x "${!PGM}" ]]; then
			CONFERRORS="${CONFERRORS} 
		- ${PGM} is not executable"
			fi
		fi
	done

	# -- Check that paths exist -- #
	for VAR in $PATHS; do
                if [[ ! -d ${!VAR} ]]; then
                        CONFERRORS="${CONFERRORS}
                - ${VAR}'s value of \"${!VAR}\" is not a directory on the filesystem"
                fi
        done

	# -- Check that files exist -- #
	for VAR in $FILES; do
                if [[ ! -f ${!VAR} || ! -r ${!VAR} ]]; then
                        CONFERRORS="${CONFERRORS}
                - ${VAR}'s value of \"${!VAR}\" is not a regular file on the filesystem, or is not readable by this user"
                fi
        done

	# -- Check that variables are set ( ${!VAR} substitutes the var value as the var name ) -- #
	for VAR in $VARIABLES; do
		if [[ -z "${!VAR}" ]]; then
			CONFERRORS="${CONFERRORS} 
		- ${VAR} has no value in config"
		fi
	done
	
	# -- Report CONFERRORS if any and die if so -- #
	if [ ! -z "$CONFERRORS" ]; then
		echo "The following configuration errors were found:"
		echo "$CONFERRORS"
		echo
		exit;
	fi
}

title() {
	
	read -d '' TITLE <<- EOF
	+------------
	| High Orbit Particle Cannon
	+------------
	EOF
	
	echo "$TITLE"
	
}

help_msg() {
	read -d '' HELPMSG <<- EOF
	+------------
	| Black_Bird
	+------------

	USAGE:
	*   $BASENAME -d <Domain To Recon>  : Domain to Run Active Recon on
	*   $BASENAME -h                    : Display this message

	EOF

	echo "$HELPMSG"
	exit 0
}

voodooMagic() {
	

	# --- Slack Alert --- #

	$PG_SLACK_CLI -t $VAR_SLACK_TOKEN -d blackbird-output "Flyover running on $1 as requested sir"
	
	# --- Folder Generation --- #
	
	mkdir -p $PATH_FLYOVER_BASE/$1/subdomains/scraped 
	mkdir -p $PATH_FLYOVER_BASE/$1/subdomains/bruteforced
	mkdir -p $PATH_FLYOVER_BASE/$1/Megan
	
	# --- Scraping --- #
	
	nohup $PG_SUBLISTER -d $1 -o $PATH_FLYOVER_BASE/$1/subdomains/scraped/sublister.txt &
	nohup $PG_SUBFINDER -d $1 -o $PATH_FLYOVER_BASE/$1/subdomains/scraped/subfinder.txt &
	
	# --- Brute-Forcing --- #
	
	$PG_SUBBRUTE $FILE_SUBDOMAIN_WORDLIST $1 | $PG_MASSDNS -r $FILE_RESOLVER_WORDLIST -t A -o S -w $PATH_FLYOVER_BASE/$1/subdomains/bruteforced/MassDNS.txt
	
	# --- All-Domain List Generation --- #
	
	cat $PATH_FLYOVER_BASE/$1/subdomains/scraped/*.txt | sort | uniq >> $PATH_FLYOVER_BASE/$1/subdomains/scraped/All_Scraped_Domains.txt
	sed 's/. .*//' $PATH_FLYOVER_BASE/$1/subdomains/bruteforced/MassDNS.txt >> $PATH_FLYOVER_BASE/$1/subdomains/bruteforced/BF_Domains.txt
	
	cat $PATH_FLYOVER_BASE/$1/subdomains/scraped/All_Scraped_Domains.txt $PATH_FLYOVER_BASE/$1/subdomains/bruteforced/BF_Domains.txt | sort | uniq >> $PATH_FLYOVER_BASE/$1/subdomains/all_subdomains.txt
	
	# --- Blind - URL - Generation --- #
	
	while read DomainName
	do
		echo "http://""$DomainName" >> $PATH_FLYOVER_BASE/$1/urls.txt
		echo "https://""$DomainName" >> $PATH_FLYOVER_BASE/$1/urls.txt
	
	done < $PATH_FLYOVER_BASE/$1/subdomains/all_subdomains.txt

	# --- Slack Blind - URL output --- #

	$PG_SLACK_CLI -t $VAR_SLACK_TOKEN -d blackbird-output -f $PATH_FLYOVER_BASE/$1/urls.txt
	
	# --- Modules --- #
	
	#ScreenShotter
	nohup $PATH_BLACKBIRD_BASE/modules/screenShotter.sh $PG_EYEWITNESS $PATH_FLYOVER_BASE $PATH_FLYOVER_BASE/$1/urls.txt $1 $VAR_SLACK_TOKEN &
	#PortScanner 
	nohup $PATH_BLACKBIRD_BASE/modules/portScanner.sh $PATH_BLACKBIRD_BASE $PATH_FLYOVER_BASE $PATH_FLYOVER_BASE$1/subdomains/all_subdomains.txt $1 $VAR_SLACK_TOKEN &
	#FileEnumerator
	nohup $PATH_BLACKBIRD_BASE/modules/configfileDiscovery.sh $PG_MEG $FILE_MEG_WORDLIST $PATH_FLYOVER_BASE$1/urls.txt $1 $VAR_SLACK_TOKEN $PATH_FLYOVER_BASE &
	#BruteForcer
	nohup $PATH_BLACKBIRD_BASE/modules/bruteforcer.sh $PG_DIRSEARCH $PATH_FLYOVER_BASE$1/subdomains/all_subdomains.txt $1 $PATH_FLYOVER_BASE $VAR_SLACK_TOKEN &
	# --- Good Bye Page --- #
	
	clear
	
	title
	echo "Currently running meg, eye-witness, portscans, and dirsearch as background processes. Check later to get the results."
	echo "Good Day!"
	
	exit 0
}


# -- Read config file & check configuration before starting -- # 
read_config
check_config

# -- If configuration is correct eval options -- #
while getopts ":hd:" opt
do
	case $opt in
		h)
			help_msg
			;;
		d)
			voodooMagic $OPTARG
			;;
		\?)
			help_msg
			;;
		:)
			>&2 echo "ERROR: I need an address following -d"
			exit 10
			;;
	esac
done
help_msg
