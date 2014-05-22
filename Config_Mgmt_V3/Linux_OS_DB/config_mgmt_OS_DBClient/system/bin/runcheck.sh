#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#

## date format ##
NOW=`date +"%d_%b_%Y.%H.%M"`
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


## Get Host Names ##
cd $CURRCONFIG
HOSTNAME=$(echo " " `ls` | sed 's/ [^ ]*_/ /g' | awk '{for(i=1;i<=NF;i++){print $i}}' | sort -u)
cd ../../bin
echo $HOSTNAME | awk '{for(i=1;i<=NF;i++){print $i}}' > $TMPFILES/hosts

## Variables ##
## Number of Hosts ##
NUMHOSTS=$(wc -l $TMPFILES/hosts | awk '{print $1}')
OS=$(cat /etc/redhat-release)
HOSTLIST=$(cat $TMPFILES/hosts)
NUMCHANGE=$(ls -l $CHANGES/* | grep ^d | wc -l)
DAYCHANGE=$(ls $CHANGES | wc -l)
DATECHG=$(ls ../files/changes/ | awk '{print $1}')



## Functions ##
function diff_dir {
        if [ -d $CHANGES/$NOW ]
        then
                        echo Directory $CHANGES/$NOW already exists
        else
                        mkdir $CHANGES/$NOW
        fi
}

{
if [ ! -f $CURRCONFIG/.installed ]; then
    echo "You have not run the INSTALLER script yet!
                Go back and run the install to build a Current Configuration Set."
    exit 0
fi
}


################## Main Script ###########################################

## Time Ran ##
echo "#######################################" >> $FILES/log/run_$HOST.log
echo Timestamp >> $FILES/log/run_$HOST.log
echo $TIME >> $FILES/log/run_$HOST.log

echo Timestamp
echo $TIME


## Get Latest OS Configuration ##

commands=(`cat /etc/redhat-release > $TMPFILES/OS_Version1_$HOST`
		`uname -r > $TMPFILES/uname1_$HOST`
		`grep -v ^\# /etc/resolv.conf | grep '.' > $TMPFILES/resolv.conf1_$HOST`
		`last | grep 'reboot\|crash\|system boot' | awk '{print $1,$2,$3,$5,$6,$7,$8}' > $TMPFILES/last_boot1_$HOST`
		`lastb > $TMPFILES/lastb_boot1_$HOST`
		`/sbin/lsmod | awk '{print $1}' > $TMPFILES/lsmod1_$HOST`
		`/sbin/modprobe -l > $TMPFILES/modprobe_1_$HOST`
		`cat /etc/modprobe.conf > $TMPFILES/modprobe.conf1_$HOST`
		`rpm -qa > $TMPFILES/rpm_pkgs1_$HOST`
		`cat /proc/cpuinfo | grep 'processor\|vendor_id\|cpu family\|model\|model name\|cache size' > $TMPFILES/cpuinfo1_$HOST`
		`cat /proc/meminfo | grep 'MemTotal\|SwapTotal\|HugePages_Total\|Hugepagesize' > $TMPFILES/meminfo1_$HOST`
		`netstat -r > $TMPFILES/netstat_routes1_$HOST`
		`/sbin/ifconfig | grep -v 'packets\|collisions\|bytes' > $TMPFILES/ifconfig1_$HOST`
		`mount > $TMPFILES/df_H1_$HOST`
		`cat /etc/fstab > $TMPFILES/fstab1_$HOST`
		`for f in /proc/net/bonding/* ; do echo; echo "------<$f>------"; cat "$f"; done > $TMPFILES/bond_config1_$HOST`
		`cat /etc/ssh/sshd_config > $TMPFILES/sshd_config1_$HOST`
		`grep -v ^\# /etc/security/limits.conf | grep '.' > $TMPFILES/limits_conf1_$HOST`
		`grep -v ^\# /etc/sysctl.conf | grep '.' > $TMPFILES/sysctl_conf1_$HOST`
		`java -version >  $TMPFILES/java_version1_$HOST 2>&1`
		`grep -v ^\# /etc/nsswitch.conf | grep '.' >  $TMPFILES/nsswitch.conf1_$HOST`
		`grep -v ^\# /etc/hosts | grep '.' >  $TMPFILES/hosts1_$HOST`
		`for i in {0..9}; do if [ -e /etc/sysconfig/network-scripts/ifcfg-eth$i ]; then echo "------eth$i------"; echo eth$i; ethtool -i eth$i ; fi; done > $TMPFILES/firmware1_$HOST`
		`for i in {0..9}; do if [ -e /etc/sysconfig/network-scripts/ifcfg-eth$i ]; then echo "------eth$i------"; echo eth$i; ethtool eth$i ; fi; done > $TMPFILES/ethtool1_$HOST`
		`for i in {0..9}; do if [ -e /etc/sysconfig/network-scripts/ifcfg-eth$i ]; then echo "------eth$i------"; echo eth$i; ethtool -g eth$i | grep -A4 Pre; fi; done > $TMPFILES/ringbuffer1_$HOST`
		)


printf "%s\n" "${commands[@]}"





## Get the Latest Oracle Configuration

. $CURRCONFIG/.installed


sqlplus -s /nolog <<EOF >/dev/null
connect $ORA_USER/$ORA_PASS@$ORACLE_SID

#set heading on
#set feedback off
set echo off
set termout off
set linesize 200
set heading on pages 0 trimspool on lines 120 feedback off echo off termout off

### Oracle Version ####
spool ../files/tmp/ora_version.lis1_$HOST
select * from v\$version where banner like 'Oracle%';
spool off

### Other Version Info ###
spool ../files/tmp/ora_otherversion.lis1_$HOST
select * from v\$version where banner not like 'Oracle%';
spool off

### Installed Options ###
spool ../files/tmp/ora_options.lis1_$HOST
set linesize 200
select * from v\$option;
spool off

### DBA Registry ###
spool ../files/tmp/ora_registry.lis1_$HOST
select comp_name, status from dba_registry;
spool off


### User Privileges ###
spool ../files/tmp/ora_userpriv.lis1_$HOST
select * from session_privs;
spool off
exit;
EOF

















## Diff against Current Configuration 

for file in `cat .audit_files`; do 

	if [[ -s $CURRCONFIG/${file}_${HOST} ]];
	then
		diff $CURRCONFIG/${file}_${HOST} $TMPFILES/${file}1_${HOST} | grep ">\|<" >> $TMPFILES/${file}_diff_${HOST}
	fi
done




## If there is a Difference - Update the Current configuration and Pipe the differnces into the changes folder ##

for file in `cat .audit_files`; do 

if [[ -s $TMPFILES/${file}_diff_${HOST} ]];
    then
        diff_dir
		mkdir $CHANGES/$NOW/$file
		cp $CURRCONFIG/${file}_${HOST}  $CHANGES/$NOW/${file}/${file}_before_$HOST
		cp $TMPFILES/${file}1_$HOST $CHANGES/$NOW/${file}/${file}_after_$HOST
		cp $TMPFILES/${file}_diff_$HOST $CHANGES/$NOW/${file}/${file}_diff_$HOST
		cp $TMPFILES/${file}1_$HOST $CURRCONFIG/${file}_$HOST
		echo Difference found in ${file}_$HOST
		echo Difference found in ${file}_$HOST >> $FILES/log/run_$HOST.log
    else
		echo No Differences to ${file}_$HOST
        echo No Differences to ${file}_$HOST >> $FILES/log/run_$HOST.log
fi

done




# Temp Files Removed ##
## This Section needs to be at the bottom of the script ##

rm -rf $TMPFILES/*

#END

