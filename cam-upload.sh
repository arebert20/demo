#!/bin/bash
# GCLONE UPLOAD CRON TAB SCRIPT 
# chmod a+x /home/plex/scripts/rclone-upload.sh
# Type crontab -e and add line below (without #) and with correct path to the script
# * * * * * /home/plex/scripts/rclone-upload.sh >/dev/null 2>&1
# if you use custom config path add line bellow in line 20 after --log-file=$LOGFILE 
# --config=/path/rclone.conf (config file location)

if pidof -o %PPID -x "$0"; then
   exit 1
fi

LOGFILE="/volume1/DATA/gclone-upload.log"
FROM="/volume1/surveillance/CAM1/"
TO="gc:{0ABmaG5O0ELfHUk9PVA}/CAM_20_6/"

# CHECK FOR FILES IN FROM FOLDER THAT ARE OLDER THAN 5 MINUTES
if find $FROM* -type f -mmin +5 | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") GCLONE UPLOAD STARTED" | tee -a $LOGFILE
  # MOVE FILES OLDER THAN 5 MINUTES 
  gclone move "$FROM" "$TO" --filter "- *.conf" --exclude @SSRECMETA/ --transfers=5 --checkers=5 --delete-after --min-age 5m --log-file=$LOGFILE
  echo "$(date "+%d.%m.%Y %T") GCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi
exit
