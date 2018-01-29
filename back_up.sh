#!/bin/bash
#
#Performs a back up of a directory to another directory and remote

#crontab -e
#55 23 * * * /mnt/c/Users/baras/Desktop/back_up.sh
#run every night

sed -i 's/\r$//' ./back_up.sh

sourcePath=$1
destinationPath=$2
compressFiles=$3
remote=$4

#get the date of the backup
d=$(date +%Y-%m-%d)
archieve_name="backup-$d.tar.gz"

#create a new directory if not exists
if [ ! -d $destinationPath ]; then
	mkdir $destinationPath
fi	

#creating log file if not exists
if [ ! -f /home/dimitris/log.txt ]; then
	touch /home/dimitris/log.txt
fi
	
#creating back up
if [ $compressFiles = true ]; then
	echo 'backing up files' >> /home/dimitris/log.txt
	tar cvfz  $destinationPath/$archieve_name $sourcePath
else
	echo 'copying files to destination...' >> /home/dimitris/log.txt
	cp -r $sourcePath $destinationPath
fi

#back up to remote if requested
back_up_to_remote () {
	drive upload -f "$destinationPath/" >> /home/dimitris/log.txt
}

if [ $remote = true ]; then
	back_up_to_remote
fi

# print log to file
status=$?
if [ $status != 0 ]; then
   echo "Copy Code: $status - Unsuccessful" >> /home/dimitris/log.txt
else
   echo "Copy Code: $status - Successful" >> /home/dimitris/log.txt
fi
