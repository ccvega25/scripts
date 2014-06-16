#!/bin/bash 

# SET ALL THE VARIABLES!!

date=`date "+%Y-%m-%dT%H_%M_%S"`
homesource=/home/user/
hometarget=/media/backupdrive/backups/home/
mediasource=/var/media/
mediatarget=/media/backupdrive/backups/media/
logtemp=/var/log/rsync_backup/
logtarget=/home/user/backup/log/

# Home directory

rsync -aP \
  --delete \
  --delete-excluded \
  --exclude-from=/home/user/backup/exclude \
  --link-dest=$hometarget\current \
  --log-file=$logtemp\home-backup-$date \
  $homesource $hometarget\incomplete_back-$date \
  && mv $hometarget\incomplete_back-$date $hometarget\back-$date \
  && rm -f $hometarget\current \
  && ln -s $hometarget\back-$date $hometarget\current \
  && mv $logtemp\home-backup-$date $logtarget\home-backup-$date \
  && chown user $logtarget\home-backup-$date \
  && chgrp user $logtarget\home-backup-$date \
  && notify-send -t 43200000 "Home backup complete" "$date"
   
# Media directory

rsync -rltDP \
  --delete \
  --delete-excluded \
  --exclude-from=/home/user/backup/media_exclude \
  --link-dest=$mediatarget\current \
  --log-file=$logtemp\media-backup-$date \
  $mediasource $mediatarget\incomplete_back-$date \
  && mv $mediatarget\incomplete_back-$date $mediatarget\back-$date \
  && rm -f $mediatarget\current \
  && ln -s $mediatarget\back-$date $mediatarget\current \
  && mv $logtemp\media-backup-$date $logtarget\media-backup-$date \
  && chown user $logtarget\media-backup-$date \
  && chgrp user $logtarget\media-backup-$date \  
  && notify-send -t 43200000 "Media backup complete" "$date"
   
# VMware directory

rsync -aP \
  --log-file=$logtemp\vmware-backup-$date \
  /home/user/vmware/ /media/backupdrive/backups/vmware \
  && mv $logtemp\vmware-backup-$date $logtarget\vmware-backup-$date \
  && chown user $logtarget\vmware-backup-$date \
  && chgrp user $logtarget\vmware-backup-$date \
  && notify-send -t 43200000 "VMware backup complete" "$date"