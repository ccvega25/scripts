#!/bin/bash

read -p "Which directory do you want to start from (full path)? : " startat

find "$startat" -not -path "*/\.*" -type f >> dupfinder_allfiles

#locate "$startat" > dupfinder_allfiles

while read A
  do
	while read B
	  do 
	  	if [[ "$A" == "$B" ]]
	  	  then
	  	  	break
	  	  else
	  	    if [[ "${A##*/}" == "${B##*/}" ]]
	  	      then
	  	        C=`md5sum "$A"`
	  	        D=`md5sum "$B"`
	  	        if [[ "${C%% *}" == "${D%% *}" ]]
	  	          then  	        
	  	          	echo "$A" >> results
	  	        	echo "$B" >> results
	  	        	E=`du "$B" | cut -f1`
	  	        	echo Size: "$E"K >> results
	  	        	echo $E >> sizes
	  	        fi
	  	    fi
	  	fi      
	  done < dupfinder_allfiles
  done < dupfinder_allfiles

total=0
while read size
  do
    total=`expr $total + $size`
  done < sizes
echo Total duplicate size: $totalK >> results
  
rm dupfinder_allfiles
rm sizes
echo Done!