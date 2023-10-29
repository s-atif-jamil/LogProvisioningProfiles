#!/bin/bash

RED='\033[0;31m'
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC='\033[0m' # No Color
format1='%a %b %e %H:%M:%S %Z %Y'
format2='%Y-%m-%d-%H-%M-%S'
format3='%b %d %Y at %H:%M:%S %Z'
now=$(date +$format2)
profilesInfo=("")


cd $HOME/Library/MobileDevice/Provisioning\ Profiles
mkdir -p ~/Desktop/Provisioning\ Profiles/expired
mkdir -p ~/Desktop/Provisioning\ Profiles/redundant
echo -e "Name\tIdentifier\tFile Name\tExpiration Date\tIs Expired?\tIs Redundant?" > ~/Desktop/Provisioning\ Profiles/log.csv

for path in *; do
    if [[ $path == *".mobileprovision"* ]]; then
        plist=$(security cms -D -i $path -o /tmp/tmp.plist)

        id=$(/usr/libexec/PlistBuddy -c 'Print :Entitlements:application-identifier' /tmp/tmp.plist)
        exp1=$(/usr/libexec/PlistBuddy -c 'Print :ExpirationDate' /tmp/tmp.plist)
        name=$(/usr/libexec/PlistBuddy -c 'Print :AppIDName' /tmp/tmp.plist)
        file=$path

        exp2=$(date -jf "$format1" "+$format2" "$exp1")
        profilesInfo+=("$id:$exp2:$name:$file")
    fi
done

IFS=$'\n' sortedInfo=($(sort -r <<<"${profilesInfo[*]}")); unset IFS

lastId=""

for infoCSV in "${sortedInfo[@]}"; do
    IFS=':' read -r -a infoArray <<< "$infoCSV"
    id=${infoArray[0]}
    exp2=${infoArray[1]}
    name=${infoArray[2]}
    file=${infoArray[3]}

    exp3=$(date -jf "$format2" "+$format3" "$exp2")

    if [[ "$now" > "$exp2" ]]; then
        echo ""
        echo -e "$name\n$id\n$file\n${RED}$exp3 (Expired)${NC}"
        echo -e "$name\t$id\t$file\t$exp3\ttrue\ttrue" >> ~/Desktop/Provisioning\ Profiles/Log.csv
        mv -vn $file ~/Desktop/Provisioning\ Profiles/expired/$file
    elif [[ "$lastId" = "$id" ]]; then
        echo ""
        echo -e "$name\n$id\n$file\n${BLUE}$exp3 (Redundant)${NC}"
        echo -e "$name\t$id\t$file\t$exp3\tfalse\ttrue" >> ~/Desktop/Provisioning\ Profiles/log.csv
        mv -vn $file ~/Desktop/Provisioning\ Profiles/redundant/$file
    else
        echo ""
        echo -e "$name\n$id\n$file\n${GREEN}$exp3${NC}"
        echo -e "$name\t$id\t$file\t$exp3\tfalse\tfalse" >> ~/Desktop/Provisioning\ Profiles/log.csv
    fi        

    lastId=$id
done

echo ""
