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


## OS_Version ##
echo > $TMPFILES/OS_Version1_$HOST
echo "########### OS Version ###########" >> $TMPFILES/OS_Version1_$HOST
cat /etc/redhat-release >> $TMPFILES/OS_Version1_$HOST

FILEDIFF=`diff $CURRCONFIG/OS_Version_$HOST $TMPFILES/OS_Version1_$HOST | grep ">\|<" >> $TMPFILES/OS_Version_diff_$HOST`

if [[ -s $TMPFILES/OS_Version_diff_$HOST ]];
    then
        diff_dir
		mkdir $CHANGES/$NOW/OS_Version
		cp $CURRCONFIG/OS_Version_$HOST $CHANGES/$NOW/OS_Version/OS_Version_before_$HOST
		cp $TMPFILES/OS_Version1_$HOST $CHANGES/$NOW/OS_Version/OS_Version_after_$HOST
		cp $TMPFILES/OS_Version_diff_$HOST $CHANGES/$NOW/OS_Version/OS_Version_diff_$HOST
		cp $TMPFILES/OS_Version1_$HOST $CURRCONFIG/OS_Version_$HOST
		echo Difference found in OS_Version_$HOST
		echo Difference found in OS_Version_$HOST >> $FILES/log/run_$HOST.log
    else
		echo No Differences to OS_Version_$HOST
        echo No Differences to OS_Version_$HOST >> $FILES/log/run_$HOST.log
fi




#################################################################################################
#################################################################################################

## uname ##
echo > $TMPFILES/uname1_$HOST
echo "########### Uname ###########" >> $TMPFILES/uname1_$HOST
uname -a >> $TMPFILES/uname1_$HOST

FILEDIFF=`diff $CURRCONFIG/uname_$HOST $TMPFILES/uname1_$HOST | grep ">\|<" >> $TMPFILES/uname_diff_$HOST`

if [[ -s $TMPFILES/uname_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/uname
		cp $CURRCONFIG/uname_$HOST $CHANGES/$NOW/uname/uname_before_$HOST
		cp $TMPFILES/uname1_$HOST $CHANGES/$NOW/uname/uname_after_$HOST
		cp $TMPFILES/uname_diff_$HOST $CHANGES/$NOW/uname/uname_diff_$HOST
		cp $TMPFILES/uname1_$HOST $CURRCONFIG/uname_$HOST
		echo Difference found in uname_$HOST  >> $FILES/log/run_$HOST.log
		echo Difference found in uname_$HOST
    else
        echo No Differences to uname_$HOST  >> $FILES/log/run_$HOST.log
		echo No Differences to uname_$HOST
fi






#################################################################################################
#################################################################################################

## Resolv.conf ##
echo > $TMPFILES/resolv.conf1_$HOST
echo "########### DNS Information ###########" >> $TMPFILES/resolv.conf1_$HOST
grep -v ^\# /etc/resolv.conf | grep '.' >> $TMPFILES/resolv.conf1_$HOST

FILEDIFF=`diff $CURRCONFIG/resolv.conf_$HOST $TMPFILES/resolv.conf1_$HOST | grep ">\|<" >> $TMPFILES/resolv.conf_diff_$HOST`

if [[ -s $TMPFILES/resolv.conf_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/resolv.conf
		cp $CURRCONFIG/resolv.conf_$HOST $CHANGES/$NOW/resolv.conf/resolv.conf_before_$HOST
		cp $TMPFILES/resolv.conf1_$HOST $CHANGES/$NOW/resolv.conf/resolv.conf_after_$HOST
		cp $TMPFILES/resolv.conf_diff_$HOST $CHANGES/$NOW/resolv.conf/resolv.conf_diff_$HOST
		cp $TMPFILES/resolv.conf1_$HOST $CURRCONFIG/resolv.conf_$HOST
		echo Difference found in resolv.conf_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in resolv.conf_$HOST
    else
        echo No Differences to resolv.conf_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to resolv.conf_$HOST
fi


#################################################################################################
#################################################################################################

## LastBoot ##
echo > $TMPFILES/last_boot1_$HOST
echo "########### Last Boot ###########" >> $TMPFILES/last_boot1_$HOST
last | grep 'reboot\|crash\|system boot' | awk '{print $1,$2,$3,$5,$6,$7,$8}' >> $TMPFILES/last_boot1_$HOST


FILEDIFF=`diff $CURRCONFIG/last_boot_$HOST $TMPFILES/last_boot1_$HOST | grep ">\|<" >> $TMPFILES/last_boot_diff_$HOST`

if [[ -s $TMPFILES/last_boot_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/last_boot
		cp $CURRCONFIG/last_boot_$HOST $CHANGES/$NOW/last_boot/last_boot_before_$HOST
		cp $TMPFILES/last_boot1_$HOST $CHANGES/$NOW/last_boot/last_boot_after_$HOST
		cp $TMPFILES/last_boot_diff_$HOST $CHANGES/$NOW/last_boot/last_boot_diff_$HOST
		cp $TMPFILES/last_boot1_$HOST $CURRCONFIG/last_boot_$HOST
		echo Difference found in last_boot_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in last_boot_$HOST
    else
        echo No Differences to last_boot_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to last_boot_$HOST
fi


#################################################################################################
#################################################################################################


## Lastb Boot ##
echo > $TMPFILES/lastb_boot1_$HOST
echo "########### Bad login attempts ###########" >> $TMPFILES/lastb_boot1_$HOST
lastb >> $TMPFILES/lastb_boot1_$HOST


FILEDIFF=`diff $CURRCONFIG/lastb_boot_$HOST $TMPFILES/lastb_boot1_$HOST | grep ">\|<" >> $TMPFILES/lastb_boot_diff_$HOST`

if [[ -s $TMPFILES/lastb_boot_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/lastb_boot
		cp $CURRCONFIG/lastb_boot_$HOST $CHANGES/$NOW/lastb_boot/lastb_boot_before_$HOST
		cp $TMPFILES/lastb_boot1_$HOST $CHANGES/$NOW/lastb_boot/lastb_boot_after_$HOST
		cp $TMPFILES/lastb_boot_diff_$HOST $CHANGES/$NOW/lastb_boot/lastb_boot_diff_$HOST
		cp $TMPFILES/lastb_boot1_$HOST $CURRCONFIG/lastb_boot_$HOST
		echo Difference found in lastb_boot_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in lastb_boot_$HOST
    else
        echo No Differences to lastb_boot_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to lastb_boot_$HOST
fi

#################################################################################################
#################################################################################################


## lsmod ##
echo > $TMPFILES/lsmod1_$HOST
echo "########### Lsmod Info ###########" >> $TMPFILES/lsmod1_$HOST
/sbin/lsmod | awk '{print $1}'  >> $TMPFILES/lsmod1_$HOST


FILEDIFF=`diff $CURRCONFIG/lsmod_$HOST $TMPFILES/lsmod1_$HOST | grep ">\|<" >> $TMPFILES/lsmod_diff_$HOST`

if [[ -s $TMPFILES/lsmod_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/lsmod
		cp $CURRCONFIG/lsmod_$HOST $CHANGES/$NOW/lsmod/lsmod_before_$HOST
		cp $TMPFILES/lsmod1_$HOST $CHANGES/$NOW/lsmod/lsmod_after_$HOST
		cp $TMPFILES/lsmod_diff_$HOST $CHANGES/$NOW/lsmod/lsmod_diff_$HOST
		cp $TMPFILES/lsmod1_$HOST $CURRCONFIG/lsmod_$HOST
		echo Difference found in lsmod_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in lsmod_$HOST
    else
        echo No Differences to lsmod_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to lsmod_$HOST
fi

#################################################################################################
#################################################################################################


## modprobe ##
echo > $TMPFILES/modprobe1__$HOST
echo "########### modprobe Info ###########" >> $TMPFILES/modprobe1__$HOST
/sbin/modprobe -l >> $TMPFILES/modprobe1__$HOST


FILEDIFF=`diff $CURRCONFIG/modprobe__$HOST $TMPFILES/modprobe1__$HOST | grep ">\|<" >> $TMPFILES/modprobe__diff_$HOST`

if [[ -s $TMPFILES/modprobe__diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/modprobe_
		cp $CURRCONFIG/modprobe__$HOST $CHANGES/$NOW/modprobe_/modprobe__before_$HOST
		cp $TMPFILES/modprobe1__$HOST $CHANGES/$NOW/modprobe_/modprobe__after_$HOST
		cp $TMPFILES/modprobe__diff_$HOST $CHANGES/$NOW/modprobe_/modprobe__diff_$HOST
		cp $TMPFILES/modprobe1__$HOST $CURRCONFIG/modprobe__$HOST
		echo Difference found in modprobe__$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in modprobe__$HOST
    else
        echo No Differences to modprobe__$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to modprobe__$HOST
fi



#################################################################################################
#################################################################################################



## modprobe.conf ##
echo > $TMPFILES/modprobe.conf1_$HOST
echo "########### modprobe config ###########" >> $TMPFILES/modprobe.conf1_$HOST
cat /etc/modprobe.conf >> $TMPFILES/modprobe.conf1_$HOST


FILEDIFF=`diff $CURRCONFIG/modprobe.conf_$HOST $TMPFILES/modprobe.conf1_$HOST | grep ">\|<" >> $TMPFILES/modprobe.conf_diff_$HOST`

if [[ -s $TMPFILES/modprobe.conf_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/modprobe.conf
		cp $CURRCONFIG/modprobe.conf_$HOST $CHANGES/$NOW/modprobe.conf/modprobe.conf_before_$HOST
		cp $TMPFILES/modprobe.conf1_$HOST $CHANGES/$NOW/modprobe.conf/modprobe.conf_after_$HOST
		cp $TMPFILES/modprobe.conf_diff_$HOST $CHANGES/$NOW/modprobe.conf/modprobe.conf_diff_$HOST
		cp $TMPFILES/modprobe.conf1_$HOST $CURRCONFIG/modprobe.conf_$HOST
		echo Difference found in modprobe.conf_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in modprobe.conf_$HOST
    else
        echo No Differences to modprobe.conf_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to modprobe.conf_$HOST
fi



#################################################################################################
#################################################################################################

## rpm_pkgs ##
echo > $TMPFILES/rpm_pkgs1_$HOST
echo "########### Installed Packages ###########" >> $TMPFILES/rpm_pkgs1_$HOST
rpm -qa >> $TMPFILES/rpm_pkgs1_$HOST


FILEDIFF=`diff $CURRCONFIG/rpm_pkgs_$HOST $TMPFILES/rpm_pkgs1_$HOST | grep ">\|<" >> $TMPFILES/rpm_pkgs_diff_$HOST`

if [[ -s $TMPFILES/rpm_pkgs_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/rpm_pkgs
		cp $CURRCONFIG/rpm_pkgs_$HOST $CHANGES/$NOW/rpm_pkgs/rpm_pkgs_before_$HOST
		cp $TMPFILES/rpm_pkgs1_$HOST $CHANGES/$NOW/rpm_pkgs/rpm_pkgs_after_$HOST
		cp $TMPFILES/rpm_pkgs_diff_$HOST $CHANGES/$NOW/rpm_pkgs/rpm_pkgs_diff_$HOST
		cp $TMPFILES/rpm_pkgs1_$HOST $CURRCONFIG/rpm_pkgs_$HOST
		echo Difference found in rpm_pkgs_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in rpm_pkgs_$HOST
    else
        echo No Differences to rpm_pkgs_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to rpm_pkgs_$HOST
fi


#################################################################################################
#################################################################################################

## cpuinfo ##
echo > $TMPFILES/cpuinfo1_$HOST
echo "########### CPU Info ###########" >> $TMPFILES/cpuinfo1_$HOST
cat /proc/cpuinfo | grep 'processor\|vendor_id\|cpu family\|model\|model name\|cpu MHz\|cache size' >> $TMPFILES/cpuinfo1_$HOST


FILEDIFF=`diff $CURRCONFIG/cpuinfo_$HOST $TMPFILES/cpuinfo1_$HOST | grep ">\|<" >> $TMPFILES/cpuinfo_diff_$HOST`

if [[ -s $TMPFILES/cpuinfo_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/cpuinfo
		cp $CURRCONFIG/cpuinfo_$HOST $CHANGES/$NOW/cpuinfo/cpuinfo_before_$HOST
		cp $TMPFILES/cpuinfo1_$HOST $CHANGES/$NOW/cpuinfo/cpuinfo_after_$HOST
		cp $TMPFILES/cpuinfo_diff_$HOST $CHANGES/$NOW/cpuinfo/cpuinfo_diff_$HOST
		cp $TMPFILES/cpuinfo1_$HOST $CURRCONFIG/cpuinfo_$HOST
		echo Difference found in cpuinfo_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in cpuinfo_$HOST
    else
        echo No Differences to cpuinfo_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to cpuinfo_$HOST
fi



#################################################################################################
#################################################################################################

## meminfo ##
echo > $TMPFILES/meminfo1_$HOST
echo "########### Memory Info ###########" >> $TMPFILES/meminfo1_$HOST
cat /proc/meminfo | grep 'MemTotal\|SwapTotal\|HugePages_Total\|Hugepagesize' >> $TMPFILES/meminfo1_$HOST


FILEDIFF=`diff $CURRCONFIG/meminfo_$HOST $TMPFILES/meminfo1_$HOST | grep ">\|<" >> $TMPFILES/meminfo_diff_$HOST`

if [[ -s $TMPFILES/meminfo_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/meminfo
		cp $CURRCONFIG/meminfo_$HOST $CHANGES/$NOW/meminfo/meminfo_before_$HOST
		cp $TMPFILES/meminfo1_$HOST $CHANGES/$NOW/meminfo/meminfo_after_$HOST
		cp $TMPFILES/meminfo_diff_$HOST $CHANGES/$NOW/meminfo/meminfo_diff_$HOST
		cp $TMPFILES/meminfo1_$HOST $CURRCONFIG/meminfo_$HOST
		echo Difference found in meminfo_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in meminfo_$HOST
    else
        echo No Differences to meminfo_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to meminfo_$HOST
fi


#################################################################################################
#################################################################################################

## netstat_routes ##
echo > $TMPFILES/netstat_routes1_$HOST
echo "########### Routing Information ###########" >> $TMPFILES/netstat_routes1_$HOST
netstat -r >> $TMPFILES/netstat_routes1_$HOST


FILEDIFF=`diff $CURRCONFIG/netstat_routes_$HOST $TMPFILES/netstat_routes1_$HOST | grep ">\|<" >> $TMPFILES/netstat_routes_diff_$HOST`

if [[ -s $TMPFILES/netstat_routes_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/netstat_routes
		cp $CURRCONFIG/netstat_routes_$HOST $CHANGES/$NOW/netstat_routes/netstat_routes_before_$HOST
		cp $TMPFILES/netstat_routes1_$HOST $CHANGES/$NOW/netstat_routes/netstat_routes_after_$HOST
		cp $TMPFILES/netstat_routes_diff_$HOST $CHANGES/$NOW/netstat_routes/netstat_routes_diff_$HOST
		cp $TMPFILES/netstat_routes1_$HOST $CURRCONFIG/netstat_routes_$HOST
		echo Difference found in netstat_routes_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in netstat_routes_$HOST
    else
        echo No Differences to netstat_routes_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to netstat_routes_$HOST
fi




#################################################################################################
#################################################################################################

## ifconfig ##
echo > $TMPFILES/ifconfig1_$HOST
echo "########### Network Information ###########" >> $TMPFILES/ifconfig1_$HOST
/sbin/ifconfig | grep -v 'packets\|collisions\|bytes' >> $TMPFILES/ifconfig1_$HOST


FILEDIFF=`diff $CURRCONFIG/ifconfig_$HOST $TMPFILES/ifconfig1_$HOST | grep ">\|<" >> $TMPFILES/ifconfig_diff_$HOST`

if [[ -s $TMPFILES/ifconfig_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/ifconfig
		cp $CURRCONFIG/ifconfig_$HOST $CHANGES/$NOW/ifconfig/ifconfig_before_$HOST
		cp $TMPFILES/ifconfig1_$HOST $CHANGES/$NOW/ifconfig/ifconfig_after_$HOST
		cp $TMPFILES/ifconfig_diff_$HOST $CHANGES/$NOW/ifconfig/ifconfig_diff_$HOST
		cp $TMPFILES/ifconfig1_$HOST $CURRCONFIG/ifconfig_$HOST
		echo Difference found in ifconfig_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in ifconfig_$HOST
    else
        echo No Differences to ifconfig_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to ifconfig_$HOST
fi



#################################################################################################
#################################################################################################

## df_H ##
echo > $TMPFILES/df_H1_$HOST
echo "########### Mount Information ###########" >> $TMPFILES/df_H1_$HOST
mount >> $TMPFILES/df_H1_$HOST


FILEDIFF=`diff $CURRCONFIG/df_H_$HOST $TMPFILES/df_H1_$HOST | grep ">\|<" >> $TMPFILES/df_H_diff_$HOST`

if [[ -s $TMPFILES/df_H_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/df_H
		cp $CURRCONFIG/df_H_$HOST $CHANGES/$NOW/df_H/df_H_before_$HOST
		cp $TMPFILES/df_H1_$HOST $CHANGES/$NOW/df_H/df_H_after_$HOST
		cp $TMPFILES/df_H_diff_$HOST $CHANGES/$NOW/df_H/df_H_diff_$HOST
		cp $TMPFILES/df_H1_$HOST $CURRCONFIG/df_H_$HOST
		echo Difference found in df_H_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in df_H_$HOST
    else
        echo No Differences to df_H_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to df_H_$HOST
fi



#################################################################################################
#################################################################################################

## fstab ##
echo > $TMPFILES/fstab1_$HOST
echo "########### FSTab Information ###########" >> $TMPFILES/fstab1_$HOST
cat /etc/fstab >> $TMPFILES/fstab1_$HOST


FILEDIFF=`diff $CURRCONFIG/fstab_$HOST $TMPFILES/fstab1_$HOST | grep ">\|<" >> $TMPFILES/fstab_diff_$HOST`

if [[ -s $TMPFILES/fstab_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/fstab
		cp $CURRCONFIG/fstab_$HOST $CHANGES/$NOW/fstab/fstab_before_$HOST
		cp $TMPFILES/fstab1_$HOST $CHANGES/$NOW/fstab/fstab_after_$HOST
		cp $TMPFILES/fstab_diff_$HOST $CHANGES/$NOW/fstab/fstab_diff_$HOST
		cp $TMPFILES/fstab1_$HOST $CURRCONFIG/fstab_$HOST
		echo Difference found in fstab_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in fstab_$HOST
    else
        echo No Differences to fstab_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to fstab_$HOST
fi


#################################################################################################
#################################################################################################

## bond_config ##
echo > $TMPFILES/bond_config1_$HOST
echo "########### Bond Information ###########" >> $TMPFILES/bond_config1_$HOST
for f in /proc/net/bonding/* ; do echo; echo "------<$f>------"; cat "$f"; done >> $TMPFILES/bond_config1_$HOST


FILEDIFF=`diff $CURRCONFIG/bond_config_$HOST $TMPFILES/bond_config1_$HOST | grep ">\|<" >> $TMPFILES/bond_config_diff_$HOST`

if [[ -s $TMPFILES/bond_config_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/bond_config
		cp $CURRCONFIG/bond_config_$HOST $CHANGES/$NOW/bond_config/bond_config_before_$HOST
		cp $TMPFILES/bond_config1_$HOST $CHANGES/$NOW/bond_config/bond_config_after_$HOST
		cp $TMPFILES/bond_config_diff_$HOST $CHANGES/$NOW/bond_config/bond_config_diff_$HOST
		cp $TMPFILES/bond_config1_$HOST $CURRCONFIG/bond_config_$HOST
		echo Difference found in bond_config_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in bond_config_$HOST
    else
        echo No Differences to bond_config_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to bond_config_$HOST
fi


#################################################################################################
#################################################################################################

## sshd_config ##
echo > $TMPFILES/sshd_config1_$HOST
echo "########### SSH Information ###########" >> $TMPFILES/sshd_config1_$HOST
cat /etc/ssh/sshd_config >> $TMPFILES/sshd_config1_$HOST


FILEDIFF=`diff $CURRCONFIG/sshd_config_$HOST $TMPFILES/sshd_config1_$HOST | grep ">\|<" >> $TMPFILES/sshd_config_diff_$HOST`

if [[ -s $TMPFILES/sshd_config_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/sshd_config
		cp $CURRCONFIG/sshd_config_$HOST $CHANGES/$NOW/sshd_config/sshd_config_before_$HOST
		cp $TMPFILES/sshd_config1_$HOST $CHANGES/$NOW/sshd_config/sshd_config_after_$HOST
		cp $TMPFILES/sshd_config_diff_$HOST $CHANGES/$NOW/sshd_config/sshd_config_diff_$HOST
		cp $TMPFILES/sshd_config1_$HOST $CURRCONFIG/sshd_config_$HOST
		echo Difference found in sshd_config_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in sshd_config_$HOST
    else
        echo No Differences to sshd_config_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to sshd_config_$HOST
fi


#################################################################################################
#################################################################################################

## limits_conf ##
echo > $TMPFILES/limits_conf1_$HOST
echo "########### Security Limits ###########" >> $TMPFILES/limits_conf1_$HOST
grep -v ^\# /etc/security/limits.conf | grep '.' >> $TMPFILES/limits_conf1_$HOST


FILEDIFF=`diff $CURRCONFIG/limits_conf_$HOST $TMPFILES/limits_conf1_$HOST | grep ">\|<" >> $TMPFILES/limits_conf_diff_$HOST`

if [[ -s $TMPFILES/limits_conf_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/limits_conf
		cp $CURRCONFIG/limits_conf_$HOST $CHANGES/$NOW/limits_conf/limits_conf_before_$HOST
		cp $TMPFILES/limits_conf1_$HOST $CHANGES/$NOW/limits_conf/limits_conf_after_$HOST
		cp $TMPFILES/limits_conf_diff_$HOST $CHANGES/$NOW/limits_conf/limits_conf_diff_$HOST
		cp $TMPFILES/limits_conf1_$HOST $CURRCONFIG/limits_conf_$HOST
		echo Difference found in limits_conf_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in limits_conf_$HOST
    else
        echo No Differences to limits_conf_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to limits_conf_$HOST
fi


#################################################################################################
#################################################################################################

## sysctl_conf ##
echo > $TMPFILES/sysctl_conf1_$HOST
echo "########### Kernel Params ###########" >> $TMPFILES/sysctl_conf1_$HOST
grep -v ^\# /etc/sysctl.conf | grep '.' >> $TMPFILES/sysctl_conf1_$HOST


FILEDIFF=`diff $CURRCONFIG/sysctl_conf_$HOST $TMPFILES/sysctl_conf1_$HOST | grep ">\|<" >> $TMPFILES/sysctl_conf_diff_$HOST`

if [[ -s $TMPFILES/sysctl_conf_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/sysctl_conf
		cp $CURRCONFIG/sysctl_conf_$HOST $CHANGES/$NOW/sysctl_conf/sysctl_conf_before_$HOST
		cp $TMPFILES/sysctl_conf1_$HOST $CHANGES/$NOW/sysctl_conf/sysctl_conf_after_$HOST
		cp $TMPFILES/sysctl_conf_diff_$HOST $CHANGES/$NOW/sysctl_conf/sysctl_conf_diff_$HOST
		cp $TMPFILES/sysctl_conf1_$HOST $CURRCONFIG/sysctl_conf_$HOST
		echo Difference found in sysctl_conf_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in sysctl_conf_$HOST
    else
        echo No Differences to sysctl_conf_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to sysctl_conf_$HOST
fi


#################################################################################################
#################################################################################################

## java_version ##
echo > $TMPFILES/java_version1_$HOST
echo "########### JAVA Version ###########" >> $TMPFILES/java_version1_$HOST
java -version >> $TMPFILES/java_version1_$HOST 2>&1


FILEDIFF=`diff $CURRCONFIG/java_version_$HOST $TMPFILES/java_version1_$HOST | grep ">\|<" >> $TMPFILES/java_version_diff_$HOST`

if [[ -s $TMPFILES/java_version_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/java_version
		cp $CURRCONFIG/java_version_$HOST $CHANGES/$NOW/java_version/java_version_before_$HOST
		cp $TMPFILES/java_version1_$HOST $CHANGES/$NOW/java_version/java_version_after_$HOST
		cp $TMPFILES/java_version_diff_$HOST $CHANGES/$NOW/java_version/java_version_diff_$HOST
		cp $TMPFILES/java_version1_$HOST $CURRCONFIG/java_version_$HOST
		echo Difference found in java_version_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in java_version_$HOST
    else
        echo No Differences to java_version_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to java_version_$HOST
fi

#################################################################################################
#################################################################################################

## nsswitch.conf ##
echo > $TMPFILES/nsswitch.conf1_$HOST
echo "########### Nsswitch ###########" >> $TMPFILES/nsswitch.conf1_$HOST
grep -v ^\# /etc/nsswitch.conf | grep '.' >> $TMPFILES/nsswitch.conf1_$HOST 2>&1


FILEDIFF=`diff $CURRCONFIG/nsswitch.conf_$HOST $TMPFILES/nsswitch.conf1_$HOST | grep ">\|<" >> $TMPFILES/nsswitch.conf_diff_$HOST`

if [[ -s $TMPFILES/nsswitch.conf_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/nsswitch.conf
		cp $CURRCONFIG/nsswitch.conf_$HOST $CHANGES/$NOW/nsswitch.conf/nsswitch.conf_before_$HOST
		cp $TMPFILES/nsswitch.conf1_$HOST $CHANGES/$NOW/nsswitch.conf/nsswitch.conf_after_$HOST
		cp $TMPFILES/nsswitch.conf_diff_$HOST $CHANGES/$NOW/nsswitch.conf/nsswitch.conf_diff_$HOST
		cp $TMPFILES/nsswitch.conf1_$HOST $CURRCONFIG/nsswitch.conf_$HOST
		echo Difference found in nsswitch.conf_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in nsswitch.conf_$HOST
    else
        echo No Differences to nsswitch.conf_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to nsswitch.conf_$HOST
fi



#################################################################################################
#################################################################################################

## nsswitch.conf ##
echo > $TMPFILES/hosts1_$HOST
echo "########### Hosts ###########" >> $TMPFILES/hosts1_$HOST
grep -v ^\# /etc/hosts | grep '.' >> $TMPFILES/hosts1_$HOST 2>&1


FILEDIFF=`diff $CURRCONFIG/hosts_$HOST $TMPFILES/hosts1_$HOST | grep ">\|<" >> $TMPFILES/hosts_diff_$HOST`

if [[ -s $TMPFILES/hosts_diff_$HOST ]];
    then
                diff_dir
		mkdir $CHANGES/$NOW/hosts
		cp $CURRCONFIG/hosts_$HOST $CHANGES/$NOW/hosts/hosts_before_$HOST
		cp $TMPFILES/hosts1_$HOST $CHANGES/$NOW/hosts/hosts_after_$HOST
		cp $TMPFILES/hosts_diff_$HOST $CHANGES/$NOW/hosts/hosts_diff_$HOST
		cp $TMPFILES/hosts1_$HOST $CURRCONFIG/hosts_$HOST
		echo Difference found in hosts_$HOST >> $FILES/log/run_$HOST.log
		echo Difference found in hosts_$HOST
    else
        echo No Differences to hosts_$HOST >> $FILES/log/run_$HOST.log
		echo No Differences to hosts_$HOST
fi


## Temp Files Removed ##
## This Section needs to be at the bottom of the script ##

rm -rf $TMPFILES/*

#END



