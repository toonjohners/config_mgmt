#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#

## date format ##
NOW=`date +"%d_%b_%Y..%H.%M"`
TIME=`date '+DATE: %d/%m/%y TIME:%H:%M:%S'`
HOST=`hostname`




{
if [ ! -d ../system/ ]; then
	echo "You are not running this from the correct directory!"
	echo "Be sure you are running this from the "standalone_audit" directory!"
	echo "Make sure that the Directory "../system/" exists."
	exit 0
fi
}

{
if [ -f ../system/files/currentconfig/.installed ]; then
		echo "There is an install found!"  
		echo "This may overwrite the Current Config"
		for file in `ls *.tar`; do
			cd ../
			tar -xf standalone_audit/$file
			cd standalone_audit/
			echo "#######################################" >> ../system/files/log/run_$HOST.log
			echo Timestamp >> ../system/files/log/run_$HOST.log
			echo $TIME >> ../system/files/log/run_$HOST.log
			echo "File extraction of $file done! " >> ../system/files/log/run_$HOST.log 
			echo "$file extracted"
			done
		exit 0
	else
		echo "There is No Install found!" 
		echo "Extracting the configuration "
		for file in `ls *.tar` ; do
			cd ../
			tar -xf standalone_audit/$file
			cd standalone_audit/
			echo "#######################################" >> ../system/files/log/run_$HOST.log
			echo Timestamp >> ../system/files/log/run_$HOST.log
			echo $TIME >> ../system/files/log/run_$HOST.log
			echo "File extraction of $file done! " >> ../system/files/log/run_$HOST.log 
			echo "$file extracted"
			done
		exit 0
fi
}




