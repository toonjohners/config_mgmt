#!/bin/bash
#Author: John McCormack
#Date: 16/01/2014
#
#

## date format ##
NOW=`date +"%d_%b_%Y.%H.%M"`
TIME=`date '+DATE: %d/%m/%y TIME:%H:%M:%S'`

HTML="../files/html"
CONFIG="../files/config"
num=0

############### Source FW Profile
. html/env_cpm41.sh


IFS=$'\n'

if [[ -n $(diff -r ../files/config ../files/config_1/) ]]; then
	FILES=`diff -r ../files/config ../files/config_1/ | grep diff | awk '{print $3}'`
    echo > .diff
	mkdir ../files/changes/$NOW
else
    echo "No Changes Found!" 
fi
 
if [ -d ../files/changes/$NOW ]
    then
		for i in `diff -r ../files/config ../files/config_1/ | grep diff | awk '{print $3,$4}'`; do
			echo "sdiff $i" >> .diff
		done

		for a in `cat .diff` ; do
			FILE=`echo $a  | awk -F "/" '{print $NF}'`
			BEFORE=`echo $a | awk '{print $2}'`
			AFTER=`echo $a | awk '{print $3}'`
			mkdir ../files/changes/$NOW/$FILE
			eval $a > ../files/changes/$NOW/$FILE/$FILE.diff
			cp $BEFORE ../files/changes/$NOW/$FILE/$FILE.before
			cp $AFTER ../files/changes/$NOW/$FILE/$FILE.after
			#echo $BEFORE
			#echo $AFTER
			cp $AFTER $BEFORE
		done
		
fi

rm -rf .diff