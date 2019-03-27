# BlackBird

Blackbird was designed to automate and handle the heavy lifting of recon for large domains. It currently uses the following tools to do the following functionalities : 

- Subdomain Scrabing via Subfinder and Sublister
- Subdomain Bruteforcing via MassDNS
- Screenshotting via Eyewitness 
- 'Passive portscanning' via shodan
- Active portscanning via nmap 
- Directory bruteforcing via Dirsearch
- Config file discovery via Meg

Blackbird also uses a [slack legacy token](https://api.slack.com/custom-integrations/legacy-tokens) to alert you whenever a certain segment from the functionalities listed above has been started or is finsihed. 

Finally you can also choose to run the BlackBird API, the API allows you to launch the scanner from slack or any other tool of choice!

To install blackbird simply clone the repo : 
```
git clone https://github.com/S4R1N/BlackBird.git
```

Then go to the BlackBird Directory and run the installer : 
```
cd BlackBird
./install.sh
```

Set up you keys under the `config.default` file

and finally run the tool :
```
./BlackBird.sh -d <DOMAIN>
```
