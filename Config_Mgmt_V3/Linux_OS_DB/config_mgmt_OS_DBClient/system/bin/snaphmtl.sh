#!/bin/bash
#Author: John McCormack
#Date: 15/12/2013
#
#
#date '+%d_%m_%y_%H.%M'
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


#### Clean up old reports###
rm -rf $FILES/html/*

#### Copy HTML Files 
cp html/* $FILES/html/


#### Run Snapshot Script and create HTML Pages ### 
#./snapshot.sh
cat html/indexheader > $FILES/html/overview.html
cat html/indexheader > $FILES/html/meminfo.html
cat html/indexheader > $FILES/html/cpuinfo.html
cat html/indexheader > $FILES/html/processes.html
cat html/indexheader > $FILES/html/memutil.html
cat html/indexheader > $FILES/html/cpuutil.html
cat html/indexheader > $FILES/html/diskusage.html
cat html/indexheader > $FILES/html/fdisk.html
cat html/indexheader > $FILES/html/foundlog.html
cat html/indexheader > $FILES/html/log.html
cat html/indexheader > $FILES/html/hugepages.html




#### Make HTML Tables ####

#### Overview Page ####


echo "

<div class="tabletitle">AUDIT & Change Details</div>
<table border=1 summary="system overview" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<tr><td class="tableheader">OS_Version</td>
<td class="bg0">$OS</td>
<tr><td class="tableheader">Collection Date</td>
<td class="bg0">$NOW</td>
<tr><td class="tableheader">Number of nodes</td>
<td class="bg0">$NUMHOSTS</td>
<tr><td class="tableheader">Number of Dates with Changes</td>
<td class="bg0">$DAYCHANGE</td>
<tr><td class="tableheader">Number of Changes Found</td>
<td class="bg0">$NUMCHANGE</td>
</td></tr>
</table>

" >> $FILES/html/overview.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> $FILES/html/overview.html




######## Loop to bring in each server html files ######

for node in `cat $TMPFILES/hosts`;
do

		##### Overview of Each Server #####

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>

		<div class="tabletitle">Manufacturer Details</div>
		<table class="coltable" width=""60%"" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width=""60%"">Details</th>
		</tr>
		<tr class="bg1">
		<td width=""60%"">
		<pre> " >> $FILES/html/overview.html
		if [ -f $FILES/audit_results/HOSTINFO/system_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/system_$node >> $FILES/html/overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>
		<div class="tabletitle">Date and Timezone</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/overview.html
		if [ -f $FILES/audit_results/HOSTINFO/date_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/date_$node >> $FILES/html/overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>

		<div class="tabletitle">Last System Boot Time</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/overview.html
		if [ -f $FILES/audit_results/HOSTINFO/lastreboot_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/lastreboot_$node >> $FILES/html/overview.html
		fi
		echo " 
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>
		<div class="tabletitle">Uptime</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/overview.html
		if [ -f $FILES/audit_results/HOSTINFO/uptime_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/uptime_$node >> $FILES/html/overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/overview.html
		
		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/overview.html



		#### MEMORY INFO ###


		cat html/indexheader >> $FILES/html/meminfo.html


		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/meminfo.html



		echo "
		<div class="tabletitle">Memory Information</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/meminfo.html
		if [ -f $FILES/audit_results/HOSTINFO/meminfo_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/meminfo_$node >> $FILES/html/meminfo.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/meminfo.html


		echo "
		<div class="tabletitle">VM STAT</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/meminfo.html
		if [ -f $FILES/audit_results/HOSTINFO/vmstat_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/vmstat_$node >> $FILES/html/meminfo.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/meminfo.html

		echo "
		<div class="tabletitle">Free Memory</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/meminfo.html
		if [ -f $FILES/audit_results/HOSTINFO/free_m_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/free_m_$node >> $FILES/html/meminfo.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/meminfo.html


		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/meminfo.html




		#### CPU INFO ###


		cat html/indexheader >> $FILES/html/cpuinfo.html


		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/cpuinfo.html



		echo "
		<div class="tabletitle">CPU Information</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/cpuinfo.html
		if [ -f $FILES/audit_results/HOSTINFO/cpuinfo_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/cpuinfo_$node >> $FILES/html/cpuinfo.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/cpuinfo.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/cpuinfo.html


		#### Processes ###


		cat html/indexheader >> $FILES/html/processes.html


		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/processes.html



		echo "
		<div class="tabletitle">Processes</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/processes.html
		if [ -f $FILES/audit_results/HOSTINFO/process_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/process_$node >> $FILES/html/processes.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/processes.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/processes.html




		#### Memory Consumption ###

		cat html/indexheader >> $FILES/html/memutil.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/memutil.html



		echo "
		<div class="tabletitle">Memory Consumption: Top 10 Memory Processes</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/memutil.html
		if [ -f $FILES/audit_results/HOSTINFO/memutil_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/memutil_$node >> $FILES/html/memutil.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/memutil.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/memutil.html


		#### CPU Consumption ###

		cat html/indexheader >> $FILES/html/cpuutil.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/cpuutil.html



		echo "
		<div class="tabletitle">CPU Consumption: Top 10 CPU Processes</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/cpuutil.html
		if [ -f $FILES/audit_results/HOSTINFO/cpuutil_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/cpuutil_$node >> $FILES/html/cpuutil.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/cpuutil.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/cpuutil.html



		#### Disk Usage ###

		cat html/indexheader >> $FILES/html/diskusage.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/diskusage.html



		echo "
		<div class="tabletitle">Disk Usage</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/diskusage.html
		if [ -f $FILES/audit_results/HOSTINFO/diskusage_$node ] 
		then
		cat $FILES/audit_results/HOSTINFO/diskusage_$node >> $FILES/html/diskusage.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/diskusage.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/diskusage.html


		#### Local Disk ###

		cat html/indexheader >> $FILES/html/fdisk.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/fdisk.html



		echo "
		<div class="tabletitle">Local Disks</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/fdisk.html
		if [ -f $FILES/audit_results/HOSTINFO/fdisk_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/fdisk_$node >> $FILES/html/fdisk.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/fdisk.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/fdisk.html


		#### Found Logs ###

		cat html/indexheader >> $FILES/html/foundlog.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/foundlog.html

		echo "
		<div class="tabletitle">Changes Found</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/foundlog.html
		if [ -f $FILES/audit_results/HOSTINFO/foundlog_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/foundlog_$node >> $FILES/html/foundlog.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/foundlog.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/foundlog.html

		
		
		#### Found Logs ###

		cat html/indexheader >> $FILES/html/log.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/log.html

		echo "
		<div class="tabletitle">Full Log</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/log.html
		if [ -f $FILES/audit_results/HOSTINFO/log_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/log_$node >> $FILES/html/log.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/log.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/log.html#
		
		
		#### Hugepages ####
		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>

		<div class="tabletitle">HugePages - Current Configuration Value </div>
		<table class="coltable" width=""60%"" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width=""60%"">Details</th>
		</tr>
		<tr class="bg1">
		<td width=""60%"">
		<pre> " >> $FILES/html/hugepages.html
		if [ -f $FILES/audit_results/HOSTINFO/hpages1_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/hpages1_$node >> $FILES/html/hugepages.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>
		<div class="tabletitle">HugePages - Current Usage</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/hugepages.html
		if [ -f $FILES/audit_results/HOSTINFO/hpages2_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/hpages2_$node >> $FILES/html/hugepages.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>
		<div class="tabletitle">HugePages - Value in sysctl.conf</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/hugepages.html
		if [ -f $FILES/audit_results/HOSTINFO/hpages3_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/hpages3_$node >> $FILES/html/hugepages.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>
		<br>
		<br>" >> $FILES/html/hugepages.html
		
		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/hugepages.html
		


done
