#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#
#
#



## date format ##
NOW=`date +"%d_%b_%Y:%H.%M"`

## Directories ##
HOME="../"
BIN=$HOME/bin
FILES=$HOME/files
CURRCONFIG=$FILES/currentconfig
CHANGES=$FILES/changes
CONFIG=$HOME/config
REPORTS=$HOME/reports
TMPFILES=$FILES/tmp
HOST=`hostname`
AUDITOS=$FILES/audit_results/OS/





### Checking for .audit_file ###

if [ ! -f .audit_config ]; then
    echo ".audit_config File not found!"
        echo "Make sure you are running this from the bin/ directory"
    exit 0
fi




### Creating the Matserlist of Collected Data ###

for token in `cat .audit_config`;
do
                line=`basename $token`
                                sort $CURRCONFIG/$line* > $TMPFILES/mastertest
                                sort -u $TMPFILES/mastertest > $TMPFILES/master
                                grep -v ^\# $TMPFILES/master | grep '.' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u > $FILES/masterlists/$line"_masterlist"
				done



### Sorting & Cleaning up the Collected Data ###

for token in `cat .audit_config`;
do
        for realfile in $CURRCONFIG/$token*;
        do
                line=`basename $realfile`
                grep -v ^\# $realfile | grep '.' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u > $TMPFILES/$line
        done;
done



### Finding Difference between the Masterlist & Collected Data ###


for token in `cat .audit_config`;
do
        for realfile in $TMPFILES/$token*;
        do
                line=`basename $realfile`
                diff $FILES/masterlists/$token"_masterlist" $realfile | grep ">\|<" > $FILES/audit_results/OS/$line
        done;
done



### Clean up temp files ###

rm -rf $TMPFILES/*
