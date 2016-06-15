#!/bin/bash
# Ref : http://www.cyberciti.biz/faq/linux-random-password-generator/
#       http://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
genpasswd() {
    tr -dc a-z0-9 < /dev/urandom | head -c ${l} | xargs
}

if [[ "$1" == "" ||  "$1" == "0" || $1 -lt -25 || $1 -gt 25 ]]; then
    l=6;
else
    l=$1;
fi
#echo "l=$1";
genpasswd;
exit;
	
