#! /bin/bash

# usage ./SMB-Installed-Software_Version.sh <IP ADDRESS>
smbclient //$1/C$/ -D "Program Files (x86)\Adobe\Acrobat Reader DC\Reader" -c "get AcroRd32.exe" -U <USERNAME>%<PASSWORD> -W <WORKGROUP> &&
peres -a AcroRd32.exe | grep "File Version" &&
rm AcroRd32.exe
