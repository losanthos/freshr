#!/bin/bash

logfile="/home/plex/bin/freshr.log"
cookies="/home/plex/bin/cookies.txt"
rssfeed="https://immortalseed.me/rss.php?secret_key=cb07d95abdba3a5c861eb10e2f31aa54&feedtype=download&timezone=-5&showrows=5&categories=8"
wgetlog="/home/plex/bin/wget.log"
feedrfile="/home/plex/bin/feedr.txt"
findrfile="/home/plex/bin/findr.txt"

declare -a shows
shows=()

wget --load-cookies $cookies $rssfeed -o $wgetlog -O $feedrfile > /dev/null

xmlgetnext () {
   local IFS='>'
   read -d '<' TAG VALUE
}

while xmlgetnext ; do
#       echo "$TAG - $VALUE"

        case $TAG in
                'title')
                        title="$VALUE"
                        shows+=("$title")
                        ;;
                'link')
                        link="$VALUE"
                        shows+=("$link")
                        ;;
        esac
done < $feedrfile

total=${#shows[*]}
let showcount=$total/2-2
  echo "$(date "+%m%d%Y %T") findr.txt udpated with $showcount shows" >> $logfile

j=0


read -a readr -d "" < $findrfile

let countr=${#readr[@]}-1

for ((i=5; i<=$(( $total + 1 )); i++)); do
  until [ $j -gt $countr ]
   do
     if [[ ${shows[$i-1]} == ${readr[$j]} ]]; then
           linkr=$( echo "${shows[$i]}" |  sed 's/\&amp;/\&/g')
           wget --load-cookies $cookies -N --trust-server-names --content-disposition $linkr -P ${readr[j+1]}
           echo "$(date "+%m%d%Y %T") Found ${shows[$i-1]}" >> $logfile
     fi
     j=$(( j+2))
  done
  j=0
done
