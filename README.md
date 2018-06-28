# freshr
bash script to read rss feed and grab torrent files for rtorrent

required apps: wget

this is a work in progress, but works so far; it's not at all user-friendly... maybe someday.

It will read an RSS feed, scan for specific text, and pull out the link that matches the text. It then saves that file to the location specified.

List of Files
--------------
*cookies.txt -- contains the web cookies used by the torrent site (authentication)

*findr.txt -- contains what you are looking for, and where you want to store the torrent; one per line: <text-to-search-for> <path to watch folder>

*feedr.txt -- contains the downloaded rss 

*freshr.sh -- code that executes; it gets the rss page (saving it in feedr.txt), then parses it into an array. From there, it searches the <title> codes for what you're looking for, and runs a wget on the associated link. You will have to edit this file, and set the path/user to the appropriate places, and put your rss url in as well.

*freshr.log -- basic logging for when the script is run


Once you're all setup, you'll just need to setup a cronjob for the script to run frequently enough get your stuff.
