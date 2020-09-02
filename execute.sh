#!/bin/bash

BLUE='\033[1;34m'
BOLD='\033[1m'
COLORF='\033[0m'
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
RED='\033[1;31m'

credits(){
echo
echo -e "${BOLD}===============================================${COLORF}"
echo -e "${BOLD}Script developed by:${COLORF} ${BLUE}Eduardo Buzzi${COLORF}"
echo -e "${BOLD}More Scripts in:${COLORF} ${RED}https://github.com/edubuzzi${COLORF}"
echo -e "${BOLD}===============================================${COLORF}"
}

ip_or_domain(){
echo
read -p "IP/DOMAIN => " IPDOMAIN
if [ -z "$IPDOMAIN" ]
then
ip_or_domain
fi
VERIFICATION=$(nmap -sn $IPDOMAIN | grep "1 host up")
if [ -z "$VERIFICATION" ]
then
ip_or_domain
fi
}

define_ttl(){
VERIFICATION2=$(timeout 3s ping -c1 $IPDOMAIN | grep "received")

if [ -z "$VERIFICATION2" ]
then
principal
fi

TTL=$(ping -c1 $IPDOMAIN | grep 'ttl' | cut -d ' ' -f7 | cut -d '=' -f2)
if [ $TTL -lt 64 ]
then
HOPS=$((64-$TTL))
fi
if [ $TTL -lt 128 ]
then
HOPS=$((128-$TTL))
fi
if [ $TTL -lt 255 ]
then
HOPS=$((255-$TTL))
fi
}


traceroute(){
echo
for i in `seq 1 $TTL`
do
ping -c1 -t$i $IPDOMAIN | grep "From" | cut -d ' ' -f2,3
sleep 0.5
done
}

principal(){
ip_or_domain
define_ttl
traceroute
principal
}
credits
principal
