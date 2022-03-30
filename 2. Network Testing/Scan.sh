#!/bin/bash

#Add colour to the shell output
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

if [ $# -eq 1 ]; then
    echo -e "Target ${RED}IP:$1${WHITE}"
else
    echo "incorrect command"
    echo -e "Usuage: ${RED} ./Scan.sh https://example.com ${WHITE}"
    exit 1
fi

#Get the date so it can be used in the filename
DATE=`date +%Y-%m-%d`
dirbname="$(echo $1| sed 's/https\?:\/\///')"
nmapname="$(echo $1| sed 's/https\?:\/\///' | cut -f1 -d"/")"
filename=$nmapname-$DATE


mkdir $filename &&
cd $filename &&

echo -e "Running  ${RED}Nmap quick scan ${WHITE}"
# Quick scan
nmap -F  $nmapname > Nmap_quick_scan_$filename.txt &&
echo -e "${GREEN}Nmap Quick scan Complete ${WHITE} \n\n\a"

echo -e "Running  ${RED} TestSSL.sh ${WHITE}"
# TestSSl scan
~/testssl.sh/./testssl.sh $nmapname > testSSL__$filename.txt &&
echo -e " ${GREEN}SSLtest.sh Complete${WHITE} \n\n"

echo -e "Running  ${RED}Nikto ${WHITE}"
# Quick Nikto
nikto -host https://$nmapname -output Nikto__$filename.txt &&
echo -e " ${GREEN}Nikto Complete${WHITE} \n\n"

echo -e "Running  ${RED}Dirbuster ${WHITE}"
# Dirbuster
dirb http://$dirbname /usr/share/dirb/wordlists/big.txt -o Dirb_HTTP__$filename.txt &&
echo -e " ${GREEN}Dirbuster HTTP Complete${WHITE} "
dirb https://$dirbname /usr/share/dirb/wordlists/big.txt -o Dirb_HTTP__$filename.txt &&
echo -e " ${GREEN}Dirbuster HTTPS Complete${WHITE} \n\n"


echo -e "Running ${RED}Nmap Script Scan ${WHITE}"
#Script scan
sudo nmap -Pn -A -v --script safe,vuln,fuzzer,discovery  $nmapname > Nmap_script_scan_$filename.txt &&
echo -e " ${GREEN}Nmap Script scan Complete ${WHITE} \n\n"

echo -e "Running ${RED}Slow Comprehensive ${WHITE}scan ......"
# Slow comprehensive scan
sudo nmap -sS -sU -T4 -A -v -PE -PP -PM -PS80,443 -PA3389 -PU40125 -PY -g 53  $nmapname > Nmap_slow-N-Full_scan_$filename.txt &&
echo -e "Results -> ${RED}slowFull_nmapscan_$filename.txt${WHITE}"

echo -e "${GREEN}All Scans Complete \a ${WHITE}....."
cd ~
exit 0
