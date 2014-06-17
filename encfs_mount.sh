#!/bin/bash

#Read CSV file and list volumes

num=0

while IFS="," read name crypt mountpt
 do
	num=$(($num+1))
	names[$num]=$name
	crypts[$num]=$crypt
	mountpts[$num]=$mountpt 

 done < encfs2.csv

echo EncFS Volumes:
for index in ${!names[*]}
do
    printf "%10d: %s\n" $index ${names[$index]}
done

#Ask for volumes to mount

IFS=" " read -rp "Enter numbers, space separated (Ex: 1 2 3...): " mount_nums

#Mount volumes

for item in ${mount_nums[*]}
do
     echo Volume: ${names[$item]}
     encfs ${crypts[$item]} ${mountpts[$item]} && \
     printf "%s\n\n" "${names[$item]} mounted at ${mountpts[$item]}" && \
     mounted[$item]=$item
done

#Ask for cd to a mounted volume

echo Which directory would you like to go to?
printf "%10d: %s\n" 0 "None"

for dir in ${mounted[*]}
do
    printf "%10d: %s: %s\n" ${mounted[$dir]} ${names[$dir]} ${mountpts[$dir]}
done

read -p "Enter number: " cd

if [ $cd -eq 0 ]
then
  echo Done.
else
  cd ${mountpts[cd]} && echo Done. 
fi  


