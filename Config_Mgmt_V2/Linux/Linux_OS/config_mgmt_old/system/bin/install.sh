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

###### This is a marker to show that this file has already been run ######

echo > $CURRCONFIG/.installed
## Time Ran ##
echo "#######################################" >> $FILES/log/run_$HOST.log
echo Timestamp >> $FILES/log/run_$HOST.log
echo $TIME >> $FILES/log/run_$HOST.log
echo INSTALL.......DONE! >> $FILES/log/run_$HOST.log




################## Main Install script ###############################

echo > $CURRCONFIG/OS_Version_$HOST
echo "########### OS Version ###########" >> $CURRCONFIG/OS_Version_$HOST
cat /etc/redhat-release >> $CURRCONFIG/OS_Version_$HOST

echo > $CURRCONFIG/uname_$HOST
echo "########### Uname ###########" >> $CURRCONFIG/uname_$HOST
uname -a >> $CURRCONFIG/uname_$HOST

echo > $CURRCONFIG/resolv.conf_$HOST
echo "########### DNS Information ###########" >> $CURRCONFIG/resolv.conf_$HOST
grep -v ^\# /etc/resolv.conf | grep '.' >> $CURRCONFIG/resolv.conf_$HOST

echo > $CURRCONFIG/last_boot_$HOST
echo "########### Last Boot ###########" >> $CURRCONFIG/last_boot_$HOST
last | grep 'reboot\|crash\|system boot' | awk '{print $1,$2,$3,$5,$6,$7,$8}' >> $CURRCONFIG/last_boot_$HOST

echo > $CURRCONFIG/lastb_boot_$HOST
echo "########### Bad login attempts ###########" >> $CURRCONFIG/lastb_boot_$HOST
lastb >> $CURRCONFIG/lastb_boot_$HOST

echo > $CURRCONFIG/lsmod_$HOST
echo "########### Lsmod Info ###########" >> $CURRCONFIG/lsmod_$HOST
/sbin/lsmod | grep -v ipv6 >> $CURRCONFIG/lsmod_$HOST

echo > $CURRCONFIG/modprobe__$HOST
echo "########### modprobe Info ###########" >> $CURRCONFIG/modprobe__$HOST
/sbin/modprobe -l >> $CURRCONFIG/modprobe__$HOST

echo > $CURRCONFIG/modprobe.conf_$HOST
echo "########### modprobe config ###########" >> $CURRCONFIG/modprobe.conf_$HOST
cat /etc/modprobe.conf >> $CURRCONFIG/modprobe.conf_$HOST

echo > $CURRCONFIG/rpm_pkgs_$HOST
echo "########### Installed Packages ###########" >> $CURRCONFIG/rpm_pkgs_$HOST
rpm -qa >> $CURRCONFIG/rpm_pkgs_$HOST

echo > $CURRCONFIG/cpuinfo_$HOST
echo "########### CPU Info ###########" >> $CURRCONFIG/cpuinfo_$HOST
cat /proc/cpuinfo | grep 'processor\|vendor_id\|cpu family\|model\|model name\|cpu MHz\|cache size' >> $CURRCONFIG/cpuinfo_$HOST

echo > $CURRCONFIG/meminfo_$HOST
echo "########### Memory Info ###########" >> $CURRCONFIG/meminfo_$HOST
cat /proc/meminfo | grep 'MemTotal\|SwapTotal\|HugePages_Total\|Hugepagesize' >> $CURRCONFIG/meminfo_$HOST

echo > $CURRCONFIG/netstat_routes_$HOST
echo "########### Routing Information ###########" >> $CURRCONFIG/netstat_routes_$HOST
netstat -r >> $CURRCONFIG/netstat_routes_$HOST

echo > $CURRCONFIG/ifconfig_$HOST
echo "########### Network Information ###########" >> $CURRCONFIG/ifconfig_$HOST
/sbin/ifconfig | grep -v 'packets\|collisions\|bytes' >> $CURRCONFIG/ifconfig_$HOST

echo > $CURRCONFIG/df_H_$HOST
echo "########### Mount Information ###########" >> $CURRCONFIG/df_H_$HOST
mount >> $CURRCONFIG/df_H_$HOST

echo > $CURRCONFIG/fstab_$HOST
echo "########### FSTab Information ###########" >> $CURRCONFIG/fstab_$HOST
cat /etc/fstab >> $CURRCONFIG/fstab_$HOST

echo > $CURRCONFIG/bond_config_$HOST
echo "########### Bond Information ###########" >> $CURRCONFIG/bond_config_$HOST
cat /proc/net/bonding/* >> $CURRCONFIG/bond_config_$HOST

echo > $CURRCONFIG/sshd_config_$HOST
echo "########### SSH Information ###########" >> $CURRCONFIG/sshd_config_$HOST
cat /etc/ssh/sshd_config >> $CURRCONFIG/sshd_config_$HOST

echo > $CURRCONFIG/limits_conf_$HOST
echo "########### Security Limits ###########" >> $CURRCONFIG/limits_conf_$HOST
grep -v ^\# /etc/security/limits.conf | grep '.' >> $CURRCONFIG/limits_conf_$HOST

echo > $CURRCONFIG/sysctl_conf_$HOST
echo "########### Kernel Params ###########" >> $CURRCONFIG/sysctl_conf_$HOST
grep -v ^\# /etc/sysctl.conf | grep '.' >> $CURRCONFIG/sysctl_conf_$HOST

echo > $CURRCONFIG/java_version_$HOST
echo "########### JAVA Version ###########" >>  $CURRCONFIG/java_version_$HOST
java -version >>  $CURRCONFIG/java_version_$HOST 2>&1

echo > $CURRCONFIG/nsswitch.conf_$HOST
echo "########### Nsswitch ###########" >>  $CURRCONFIG/nsswitch.conf_$HOST
grep -v ^\# /etc/nsswitch.conf | grep '.' >>  $CURRCONFIG/nsswitch.conf_$HOST

echo > $CURRCONFIG/hosts_$HOST
echo "########### Hosts ###########" >>  $CURRCONFIG/hosts_$HOST
grep -v ^\# /etc/hosts | grep '.' >>  $CURRCONFIG/hosts_$HOST
#END

