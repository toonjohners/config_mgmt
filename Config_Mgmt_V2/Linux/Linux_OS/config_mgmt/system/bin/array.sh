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




function diff_dir {
        if [ -d $CHANGES/$NOW ]
        then
                        echo Directory $CHANGES/$NOW already exists
        else
                        mkdir $CHANGES/$NOW
        fi
}


{
if [ -f $CURRCONFIG/.installed ]; then
    echo "This System has Already been installed!
                  Run the CHECK Script to check against the Current Configuration"
        echo "#######################################" >> $FILES/log/run_$HOST.log
        echo Timestamp >> $FILES/log/run_$HOST.log
        echo $TIME >> $FILES/log/run_$HOST.log
        echo INSTALL File RAN..... FAILED! System already installed >> $FILES/log/run_$HOST.log
    exit 0
fi

}




## Time Ran ##
echo "#######################################" >> $FILES/log/run_$HOST.log
echo Timestamp >> $FILES/log/run_$HOST.log
echo $TIME >> $FILES/log/run_$HOST.log
echo INSTALL.......DONE! >> $FILES/log/run_$HOST.log




################## Main Install script ###############################



commands=(`cat /etc/redhat-release > $CURRCONFIG/OS_Version_$HOST`
		`uname -r > $CURRCONFIG/uname_$HOST`
		`grep -v ^\# /etc/resolv.conf | grep '.' > $CURRCONFIG/resolv.conf_$HOST`
		`last | grep 'reboot\|crash\|system boot' | awk '{print $1,$2,$3,$5,$6,$7,$8}' > $CURRCONFIG/last_boot_$HOST`
		`lastb > $CURRCONFIG/lastb_boot_$HOST`
		`/sbin/lsmod | awk '{print $1}' > $CURRCONFIG/lsmod_$HOST`
		`/sbin/modprobe -l > $CURRCONFIG/modprobe__$HOST`
		`cat /etc/modprobe.conf > $CURRCONFIG/modprobe.conf_$HOST`
		`rpm -qa > $CURRCONFIG/rpm_pkgs_$HOST`
		`cat /etc/redhat-release > $CURRCONFIG/OS_Version_$HOST`
		`cat /proc/cpuinfo | grep 'processor\|vendor_id\|cpu family\|model\|model name\|cache size' > $CURRCONFIG/cpuinfo_$HOST`
		`cat /proc/meminfo | grep 'MemTotal\|SwapTotal\|HugePages_Total\|Hugepagesize' > $CURRCONFIG/meminfo_$HOST`
		`netstat -r > $CURRCONFIG/netstat_routes_$HOST`
		`/sbin/ifconfig | grep -v 'packets\|collisions\|bytes' > $CURRCONFIG/ifconfig_$HOST`
		`mount > $CURRCONFIG/df_H_$HOST`
		`cat /etc/fstab >> $CURRCONFIG/fstab_$HOST`
		`for f in /proc/net/bonding/* ; do echo; echo "------<$f>------"; cat "$f"; done > $CURRCONFIG/bond_config_$HOST`
		`cat /etc/ssh/sshd_config > $CURRCONFIG/sshd_config_$HOST`
		`grep -v ^\# /etc/security/limits.conf | grep '.' > $CURRCONFIG/limits_conf_$HOST`
		`grep -v ^\# /etc/sysctl.conf | grep '.' > $CURRCONFIG/sysctl_conf_$HOST`
		`java -version >  $CURRCONFIG/java_version_$HOST 2>&1`
		`grep -v ^\# /etc/nsswitch.conf | grep '.' >  $CURRCONFIG/nsswitch.conf_$HOST`
		`grep -v ^\# /etc/hosts | grep '.' >  $CURRCONFIG/hosts_$HOST`
		`grep -v ^\# /etc/sysctl.conf | grep '.' > $CURRCONFIG/sysctl_conf_$HOST`
		)


printf "%s\n" "${commands[@]}"
echo "Install Done"
~
