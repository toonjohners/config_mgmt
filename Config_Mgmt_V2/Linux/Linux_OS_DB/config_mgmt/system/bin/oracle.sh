#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#

## date format ##
NOW=`date +"%d_%b_%Y:%H.%M"`
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


sqlplus "marciog/marciog@dpr1121s" @oracle.sql



