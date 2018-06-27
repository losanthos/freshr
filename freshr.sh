#!/bin/bash

declare -a shows
shows=()

wget --load-cookies <pathto>/cookies.txt '<rss url>' -o <pathtowgetlog> -O <pathto>/feedr.txt > /dev/null

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
done < /home/plex/bin/feedr.txt

total=${#shows[*]}
let showcount=$total/2-2
  echo "$(date "+%m%d%Y %T") findr.txt udpated with $showcount shows" >> <pathto>/freshr.log

j=0


read -a readr -d "" < <pathto>/findr.txt

let countr=${#readr[@]}-1

for ((i=5; i<=$(( $total + 1 )); i++)); do
  until [ $j -gt $countr ]
   do
     if [[ ${shows[$i-1]} == ${readr[$j]} ]]; then
           linkr=$( echo "${shows[$i]}" |  sed 's/\&amp;/\&/g')
           wget --load-cookies <pathto>/cookies.txt -N --trust-server-names --content-disposition $linkr -P ${readr[j+1]}
           echo "$(date "+%m%d%Y %T") Found ${shows[$i-1]}" >> <pathto>/freshr.log
     fi
     j=$(( j+2))
  done
  j=0
done
