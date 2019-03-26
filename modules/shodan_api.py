#!/usr/bin/env python

import sys
import requests
import subprocess
import getopt
import socket
import json
	
def api_lookup(ip):
	
	API_KEY='' #Shodan API KEY
	API_ENDPOINT='https://api.shodan.io/shodan/host/' # Shodan API Endpoint 
	PARAMS = {'key':API_KEY, 'minify':'true'} # Sets Shodan API Key as a Parameter
	URL = API_ENDPOINT + ip # Creates Endpoint + IP
	
	r = requests.get(url = URL, params = PARAMS)
	
	data = r.json() #RESPONSE DATA
	
	ports = 'No Ports Found on Shodan' #Sets default Port(s)
	
	try:
		ports = data['ports']
		json_string = json.dumps(ports)
		ports = json_string
	except:
		pass
	return ports
	
def host_ip(domain):
	ip = '127.0.0.1'
	try:
		ip = socket.gethostbyname(domain)
	except socket.gaierror:
		pass
	return ip

def main(argv):
	domain = ''
	try:
		opts, args = getopt.getopt(argv,"hd:",["help","domain="]) # Listing arguments
	except getopt.GetoptError:
		print("ERROR I need the following input -d <domain>"); # Error handling 
		sys.exit(2)
  
	for opt, arg in opts:
		if opt in ("--help"):
			print("shodan_api.py -d <domain> "); # Help Message
			sys.exit()
		elif opt in ("-h"):
			print("shodan_api.py -d <domain> "); # Help Message
			sys.exit()
		elif opt in ("-d", "--domain"): #assigning domain 
			domain = arg
			
	ip = host_ip(domain)
	
	if ip == '127.0.0.1': 
		print '"' + domain + '"' + ':' + '"' + ip + '"' + ':' + '"' + 'No Ports Found on Shodan' + '"'
	else : 
		print '"' + domain + '"' + ':' + '"' + ip + '"' + ':' + '"' + api_lookup(ip) + '"'


if __name__ == "__main__":
   main(sys.argv[1:])
