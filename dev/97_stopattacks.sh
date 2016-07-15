#!/bin/bash - 

echo `date '+%Y%m%d%H%M%S'` $0  starting

grep 'Failed password for root from.*ssh2' /var/log/secure | sed 's/.*from //;s/ port.*//;' | sort | uniq -c | sort -nr | 
  grep ' [0-9]\{2,9\} ' | 
while read haxor; do 
	echo $haxor 
	hackip=$(echo "$haxor" | sed 's/.* //'); 
	echo should block IP $hackip
	firewall-cmd --list-rich-rules | grep '"'"$hackip"'"' 
	if [ $? -eq 0 ]; then 
		echo already blocked 
	else 
		echo here we go 
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="'"$hackip"'" port port=22 protocol=tcp reject'
	fi

done

