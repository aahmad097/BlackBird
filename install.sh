#!/usr/bin/env bash

mkdir -p ~/HOPC_Flyover/
touch ~/HOPC_Flyover/config.default
temppath=$(realpath ~/HOPC_Flyover)/
echo "# -- Note that prefixes are required for validation. -- #" >> ~/HOPC_Flyover/config.default
echo "# -- To add new prefixes for validation, edit read_config() and check_config() -- #" >> ~/HOPC_Flyover/config.default
echo "# -- Any other values here will be added as a variable (e.g., $NAME=VALUE) but no valiation will occur --#" >> ~/HOPC_Flyover/config.default
echo "" >> ~/HOPC_Flyover/config.default
echo "# -- Variables -- #" >> ~/HOPC_Flyover/config.default
echo "VAR_SLACK_TOKEN=\"\"" >> ~/HOPC_Flyover/config.default
echo "VAR_SHODAN_KEY=\"\"" >> ~/HOPC_Flyover/config.default
echo "" >> ~/HOPC_Flyover/config.default
echo "# -- Paths  -- #" >> ~/HOPC_Flyover/config.default
echo "PATH_FLYOVER_BASE=\"$temppath\"" >> ~/HOPC_Flyover/config.default
echo "PATH_BLACKBIRD_BASE=\"$(pwd)\"" >> ~/HOPC_Flyover/config.default
echo "" >> ~/HOPC_Flyover/config.default
echo "# -- Files -- #" >> ~/HOPC_Flyover/config.default
echo "FILE_MEG_WORDLIST=\"/opt/blackbird-tools/wordlists/configfiles\"" >> ~/HOPC_Flyover/config.default
echo "FILE_SUBDOMAIN_WORDLIST=\"/opt/blackbird-tools/wordlists/all.txt\"" >> ~/HOPC_Flyover/config.default
echo "FILE_RESOLVER_WORDLIST=\"/opt/blackbird-tools/wordlists/resolvers.txt\"" >> ~/HOPC_Flyover/config.default
echo "" >> ~/HOPC_Flyover/config.default
echo "# -- Programs -- #" >> ~/HOPC_Flyover/config.default
echo "PG_SLACK_CLI=\"/usr/local/bin/slack-cli\"" >> ~/HOPC_Flyover/config.default
echo "PG_DIRSEARCH=\"/opt/blackbird-tools/dirsearch/dirsearch.py\"" >> ~/HOPC_Flyover/config.default
echo "PG_SUBLISTER=\"/opt/blackbird-tools/Sublist3r/sublist3r.py\"" >> ~/HOPC_Flyover/config.default
echo "PG_SUBFINDER=\"/opt/blackbird-tools/subfinder/subfinder\"" >> ~/HOPC_Flyover/config.default
echo "PG_EYEWITNESS=\"/opt/blackbird-tools/EyeWitness/EyeWitness.py\"" >> ~/HOPC_Flyover/config.default
echo "PG_MEG=\"/opt/blackbird-tools/meg/meg\"" >> ~/HOPC_Flyover/config.default
echo "PG_SUBBRUTE=\"/opt/blackbird-tools/massdns/scripts/subbrute.py\"" >> ~/HOPC_Flyover/config.default
echo "PG_MASSDNS=\"/opt/blackbird-tools/massdns/bin/massdns\"" >> ~/HOPC_Flyover/config.default

### Pre-req

apt install golang
apt install nmap


### Folder Generation ###

mkdir -p /opt/blackbird-tools/wordlists
cd /opt/blackbird-tools

### Building wordlists ###
cd wordlists

wget https://gist.githubusercontent.com/orangetw/c10324f68f200fbdc365ec17fa5c18c7/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
wget https://raw.githubusercontent.com/EdOverflow/megplus/master/lists/configfiles

echo "8.8.8.8" >> resolvers.txt
echo "1.1.1.1" >> resolvers.txt
echo "9.9.9.9" >> resolvers.txt
echo "208.67.222.222" >> resolvers.txt
echo "77.88.8.7" >> resolvers.txt
echo "8.26.56.26" >> resolvers.txt

cd ..

### Tools ###

# python #
git clone https://github.com/aboul3la/Sublist3r.git
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
git clone https://github.com/maurosoria/dirsearch.git

# golang #
git clone https://github.com/subfinder/subfinder.git
git clone https://github.com/tomnomnom/meg.git

# c #
git clone https://github.com/blechschmidt/massdns.git

### Python Requirements ###

pip install slack-cli
pip install -r Sublist3r/requirements.txt
./EyeWitness/setup/setup.sh

### Go Apps Setup ###

#subfinder
cd subfinder
go get github.com/subfinder/subfinder
go build

cd ..

#meg
cd meg
go get -u github.com/tomnomnom/meg
go build

cd ..


### C App Setup ###
cd massdns
make

clear


