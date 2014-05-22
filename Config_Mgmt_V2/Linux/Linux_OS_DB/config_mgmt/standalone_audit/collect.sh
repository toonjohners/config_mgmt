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
		echo "Collecting Processed Files......."
		cd ../system/bin
		./snapshot.sh
		cd ../../standalone_audit/
		tar -cf ${HOST}_files.tar ../system/files
		echo "#######################################" >> ../system/files/log/run_$HOST.log
		echo Timestamp >> ../system/files/log/run_$HOST.log
		echo $TIME >> ../system/files/log/run_$HOST.log
		echo "Collection file Ran.... Current Files collected." >> ../system/files/log/run_$HOST.log 
		echo "Collected files are here: ${HOST}_files.tar"
		exit 0
	else
		echo "There is No Install found!  
		Running the INSTALLER Script to build the configurtaion.. "
		cd ../
		./INSTALLER
		cd system/bin
                ./snapshot.sh
                cd ../../standalone_audit/
		tar -cf ${HOST}_files.tar ../system/files
		echo "Collected files are here: ${HOST}_files.tar"
		exit 0
fi
}




