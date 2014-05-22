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

CORES=

/bin/date > $FILES/audit_results/HOSTINFO/date_$HOST
/usr/sbin/dmidecode -t system | grep 'Manufacturer\|Product\|Serial Number' > $FILES/audit_results/HOSTINFO/system_$HOST
last | grep 'system boot' | sed -n 2p > $FILES/audit_results/HOSTINFO/lastreboot_$HOST
uptime > $FILES/audit_results/HOSTINFO/uptime_$HOST
cat /proc/meminfo > $FILES/audit_results/HOSTINFO/meminfo_$HOST
cat /proc/cpuinfo > $FILES/audit_results/HOSTINFO/cpuinfo_$HOST
vmstat > $FILES/audit_results/HOSTINFO/vmstat_$HOST
echo Running iostat.....
iostat 3 3 > $FILES/audit_results/HOSTINFO/iostat_$HOST
ps -ef > $FILES/audit_results/HOSTINFO/process_$HOST
ps auxf | sort -nr -k 4 | head -10 | grep -v USER > $FILES/audit_results/HOSTINFO/memutil_$HOST
ps auxf | sort -nr -k 3 | head -10 | grep -v USER > $FILES/audit_results/HOSTINFO/cpuutil_$HOST
free -m > $FILES/audit_results/HOSTINFO/free_m_$HOST
df -h > $FILES/audit_results/HOSTINFO/diskusage_$HOST
/sbin/fdisk -l > $FILES/audit_results/HOSTINFO/fdisk_$HOST
cat ../files/log/run_$HOST.log | grep 'DATE\|found\|#' > $FILES/audit_results/HOSTINFO/foundlog_$HOST
cat ../files/log/run_$HOST.log  > $FILES/audit_results/HOSTINFO/log_$HOST
echo Running sar.....
sar 5 5 > $FILES/audit_results/HOSTINFO/sar_$HOST
/sbin/sysctl -A | grep vm.nr_hugepages > $FILES/audit_results/HOSTINFO/hpages1_$HOST
cat /proc/meminfo | grep Huge > $FILES/audit_results/HOSTINFO/hpages2_$HOST
cat /etc/sysctl.conf | grep vm.nr_hugepages > $FILES/audit_results/HOSTINFO/hpages3_$HOST



