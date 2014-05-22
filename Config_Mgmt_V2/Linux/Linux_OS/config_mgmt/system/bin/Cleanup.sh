#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#

## date format ##
NOW=`date +"%d_%b_%Y"`
TIME=`date '+DATE: %d/%m/%y TIME:%H:%M:%S'`

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

rm -rf $CURRCONFIG/*
rm -rf $CHANGES/*
rm -rf $FILES/audit_results/OS/*  
rm -rf $FILES/changes/*    
rm -rf $FILES/currentconfig/*      
rm -rf $FILES/html/*      
rm -rf $FILES/log/*         
rm -rf $FILES/masterlists/*      
rm -rf $CURRCONFIG/.installed
rm -rf $FILES/audit_results/HOSTINFO/*