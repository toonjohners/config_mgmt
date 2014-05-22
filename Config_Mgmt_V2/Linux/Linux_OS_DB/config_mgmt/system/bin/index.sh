#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#
#date '+%d_%m_%y_%H.%M'
## date format ##
NOW=`date +"%d_%b_%Y-%H.%M"`
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
cat html/indexheader > $FILES/html/sar.html
cat html/indexheader > $FILES/html/ora_overview.html
cat html/indexheader > $FILES/html/ora_health.html
cat html/indexheader > $FILES/html/ora_rac.html




#### Make HTML Tables ####

######################################################################
######################################################################
#####															######
#####			OVERVIEW PAGE & SNAPSHOT DETAILS				######				
#####															######
######################################################################
######################################################################


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



		#### IOSTAT###

		cat html/indexheader >> $FILES/html/iostat.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/iostat.html

		echo "
		<div class="tabletitle">IOSTAT</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/iostat.html
		if [ -f $FILES/audit_results/HOSTINFO/iostat_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/iostat_$node >> $FILES/html/iostat.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/iostat.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/iostat.html



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
		
		
		#### SAR ###

		cat html/indexheader >> $FILES/html/sar.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/sar.html

		echo "
		<div class="tabletitle">SAR</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/sar.html
		if [ -f $FILES/audit_results/HOSTINFO/sar_$node ]
		then
		cat $FILES/audit_results/HOSTINFO/sar_$node >> $FILES/html/sar.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/sar.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/sar.html


done


######################################################################
######################################################################
######################################################################
#####															######
#####			SERVER CONFIGURATION DETAILS					######				
#####															######
######################################################################
######################################################################



#### Making Table & Links to Server Pages ###
cat html/indexheader > $FILES/html/overall_config.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="overall_config"></a>
<div class="tabletitle">Overall Current Configuration View</div>
<tr><td class="tableheader">Configuration</td>
<td class="bg2">Host</td>
<td class="bg2">Details</td>


" >> $FILES/html/overall_config.html



for token in `cat $TMPFILES/hosts`;
do
    echo "<tr><td class="tableheader"></td><td class="bg0">$token</td><td class="bg0"><a href="$token.html">View</a></td></tr>" >> $FILES/html/overall_config.html

done
echo "</table>" >> $FILES/html/overall_config.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> $FILES/html/overall_config.html


#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
        cat html/indexheader > $FILES/html/$token.html
                echo "<div class="tabletitle">SERVER: $token</div>" >> $FILES/html/$token.html


                for file in `cat .audit_files`;
                do
                        if [ -f $CURRCONFIG/${file}_$token ]
                        then
						echo "<table border=1 summary="config_overall" role="presentation">" >> $FILES/html/$token.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> $FILES/html/$token.html
						echo "<tr><td class="tableheader">$file</td>" >> $FILES/html/$token.html
                        echo "<tr><td class="bg0">" >> $FILES/html/$token.html
						echo "<pre>" >> $FILES/html/$token.html
                        sed 's/$/<br>/' $CURRCONFIG/${file}_$token >> $FILES/html/$token.html
						echo "</pre>" >> $FILES/html/$token.html
                        echo "</td></tr>" >> $FILES/html/$token.html
						echo "</table>" >> $FILES/html/$token.html
                        echo "<br>" >> $FILES/html/$token.html
                        fi
        done
done

###############################################################################################################################################


#### Making Links to Each Config Pages ###
#### This is the Headers for the Columns ###

echo "
<br>
<br>
<div class="tabletitle">Individual Configuration View</div>" >> $FILES/html/overall_config.html


for node in `cat $TMPFILES/hosts`;
do
                echo "
                <table border=1 summary="config_overall" role="presentation">
                <table class=coltable width=""100%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
                <div class="tabletitle">SERVER: $node</div>
                <th class="tableheader" width=""60%"">Details</th>" >> $FILES/html/overall_config.html
                         for config in `cat .audit_files` ; do
                         echo "<td class=""bg2""><a href="${config}_$node.html">$config</a></td>" >> $FILES/html/overall_config.html
                         done

                echo "</tr> </table>" >> $FILES/html/overall_config.html
                echo "
                <br>
                <br>" >> $FILES/html/overall_config.html


done


#### Make Each HTML Page for each Config ####
#### Create Config HTML file ####
for token in `cat $TMPFILES/hosts`;
do
                for file in `cat .audit_files`;
                do
                        
						cat html/indexheader > $FILES/html/${file}_$token.html
						echo "<div class="tabletitle">SERVER: $token</div>" >> $FILES/html/${file}_$token.html
						echo "<table border=1 summary="config_overall" role="presentation">" >> $FILES/html/${file}_$token.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> $FILES/html/${file}_$token.html
						echo "<tr><td class="tableheader">$file</td>" >> $FILES/html/${file}_$token.html
						echo "<tr><td class="bg0">" >> $FILES/html/${file}_$token.html
						if [ -f $CURRCONFIG/${file}_$token ]
                        then
						echo "<pre>" >> $FILES/html/${file}_$token.html
                        sed 's/$/<br>/' $CURRCONFIG/${file}_$token >> $FILES/html/${file}_$token.html
						echo "</pre>" >> $FILES/html/${file}_$token.html
						fi
                        echo "</td></tr>" >> $FILES/html/${file}_$token.html
						echo "</table>" >> $FILES/html/${file}_$token.html
                        echo "<br>" >> $FILES/html/${file}_$token.html
                        
        done
done

############################################################################################################################################################



#### Making Links to Each Config Pages ###
#### This is the Headers for the Columns ###

cat html/indexheader > $FILES/html/audit.html



echo "
<br>
<br>
<div class="tabletitle">CONFIGURATION AUDIT</div>
<br> <br>" >> $FILES/html/audit.html


for node in `cat $TMPFILES/hosts`;
do
                echo "
                <table border=1 summary="config_overall" role="presentation">
                <table class=coltable width=""40%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
                <div class="tabletitle">SERVER: $node</div>
                <div class="tabletitle">Items Missing or Differing</div>
                <th class="tableheader" width=""40%"">Details</th>" >> $FILES/html/audit.html
                        for config in `cat .audit_config` ; do
                        if [[ -s $AUDITOS/${config}_$node ]]
                        then
                        echo "<tr><td class=""bg2""><a href="${config}_${node}_audit.html">$config</a></td>" >> $FILES/html/audit.html
                        fi
                        done

                echo "</tr> </table>" >> $FILES/html/audit.html
                echo "
                <br>
                <br>" >> $FILES/html/audit.html
				echo "
				<HR align=left width=""100%"" color=#ffffff SIZE=1>
				<br>
				<br> " >> $FILES/html/audit.html
done


#### Make Each HTML Page for Servers ####
#### Create Server file ####

for token in `cat $TMPFILES/hosts`;
do
                for file in `cat .audit_config`;
                do
				if [ -s $AUDITOS/${file}_$token ]
				then
						cat html/indexheader > $FILES/html/${file}_${token}_audit.html
						echo "<div class="tabletitle">SERVER: $token</div>" >> $FILES/html/${file}_${token}_audit.html
						echo "<table border=1 summary="config_overall" role="presentation">" >> $FILES/html/${file}_${token}_audit.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> $FILES/html/${file}_${token}_audit.html
						echo "<tr><td class="tableheader">$file</td>" >> $FILES/html/${file}_${token}_audit.html
						echo "<tr><td class="bg0">" >> $FILES/html/${file}_${token}_audit.html
						echo "<pre>" >> $FILES/html/${file}_${token}_audit.html
                        sed 's/$/<br>/' $AUDITOS/${file}_$token >> $FILES/html/${file}_${token}_audit.html
						echo "</pre>" >> $FILES/html/${file}_${token}_audit.html
                        echo "</td></tr>" >> $FILES/html/${file}_${token}_audit.html
						echo "</table>" >> $FILES/html/${file}_${token}_audit.html
                        echo "<br>" >> $FILES/html/${file}_${token}_audit.html
				fi
				done
done

####################################################################################################################################

###### Checking for Changes #######
#####Adding the changes to a date temp file
echo $DATECHG > $TMPFILES/DATES


####### This is creating the changes temp files #####
####### Easier to parse out the results ########

echo > $TMPFILES/CFGCHGS
for subdir in $DATECHG; do
	folder=`basename $subdir`
	for file in ${CHANGES}/$subdir/*; do
		echo $file >> $TMPFILES/CFGCHGS
	done
done

mkdir $TMPFILES/changes


for file in `cat $TMPFILES/CFGCHGS`; do
	for mfile in `ls $file` ; do
		cd $file
		new=`pwd | awk -F"/"  '{ print  $(NF-1)}'`
		cat $mfile > ../../../tmp/changes/${new}_${mfile}
	cd ../../../../bin/
	done
done



#### Adding a DATE Table & Links for the changes found #####
cat html/indexheader > $FILES/html/changes.html
echo "<div class=""tabletitle"">Configuration Changes Found</div><br>
<table border=1 summary=""changes"" role=""presentation"">
<table class=coltable width=""100%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<tr><td class=""tableheader"">DATE</td>" >> $FILES/html/changes.html

for token in `cat $TMPFILES/DATES`;
do
	echo "<tr><td class=""bg2""><a href=""$token.html"">$token</a></td>" >> $FILES/html/changes.html
done
echo "</tr> </table><br><br>" >> $FILES/html/changes.html
echo "
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> $FILES/html/changes.html


#############################################################
###### Creating Main page (By DATE) for Config Changes ######


for file in `ls $TMPFILES/changes | grep diff`; do
        DATE=`echo $file | cut -c 1-17`
        CONFIG=`echo $file | awk -F "_" '{print $4}'`
        HOSTER=`echo $file | awk -F "_" '{print $NF}'`
        cat html/indexheader > $FILES/html/$DATE.html
        echo "<div class=""tabletitle""><a id=""link_$DATE"">Date Of Change: $DATE</a></div><br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1><br><br>
        <table border=1 summary=""changes"" role=""presentation"">
        <table class=coltable width=""100%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
        <tr><td class=""tableheader"">Host</td><td class=""tableheader"">Configuration</td><td class=""tableheader"">Details</td>" >> $FILES/html/$DATE.html
done
	
	
for file in `ls $TMPFILES/changes | grep diff`; do
	DATE=`echo $file | cut -c 1-17`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`
	
	echo "<tr><td class=""bg2"">$HOSTER</td><td class=""bg2"">$CONFIG</td><td class=""bg2""><a href="${DATE}_${CONFIG}_$HOSTER.html">View</a></td></tr>" >> $FILES/html/$DATE.html
	
done



###################################################
###### Creating each page for Config Changes ######


for file in `ls $TMPFILES/changes/`; do
	## Local Variables###
	DIFF=`echo $file | grep diff`
	BEFORE=`echo $file | grep before`
	AFTER=`echo $file | grep after`
	DATE=`echo $file | cut -c 1-17`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`	
	
	cat html/indexheader > $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
	
	echo "<div class=""tabletitle""><a id=""link_$DATE"">SERVER: $HOSTER</a></div><br>
		<div class=""tabletitle""><a id=""link_$DATE"">Configuration: $CONFIG</a></div><br>
		<div class=""tabletitle""><a id=""link_$DATE"">Date Of Change: $DATE</a></div><br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1><br><br>"  >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html

		
done
	
		
for file in `ls $TMPFILES/changes/`; do
	## Local Variables###
	DIFF=`echo $file | grep diff`
	BEFORE=`echo $file | grep before`
	AFTER=`echo $file | grep after`
	DATE=`echo $file | cut -c 1-17`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`
						echo "<div class=""tabletitle""><a id=""link_$DATE"">FILE: $file </a></div><br>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<table border=1 summary=""changes"" role=""presentation"">
							<table class=coltable width=""100%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
							<tr><td class=""tableheader"">Details</td>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<tr><td class="bg0">" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<pre>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						sed 's/$/<br>/' $TMPFILES/changes/${file} >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<pre>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
                        echo "</td></tr>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "</table>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<br>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html


done




######################################################################
######################################################################
#####															######
#####							ORACLE DETAILS					######				
#####															######
######################################################################
######################################################################


for node in `cat $TMPFILES/hosts`;
do
		#### Version Info ###

		cat html/indexheader >> $FILES/html/ora_overview.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/ora_overview.html

		echo "
		<div class="tabletitle">Oracle Version</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_overview.html
		if [ -f ../files/currentconfig/ora_version.lis_$node ]
		then
		cat ../files/currentconfig/ora_version.lis_$node >> $FILES/html/ora_overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_overview.html



		
		### Other Version Info ###

		echo "
		<div class="tabletitle">Other Version Info</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_overview.html
		if [ -f ../files/currentconfig/ora_otherversion.lis_$node ]
		then
		cat ../files/currentconfig/ora_otherversion.lis_$node >> $FILES/html/ora_overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_overview.html


		
		
		### Installed Options ###

		echo "
		<div class="tabletitle">Installed Options</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_overview.html
		if [ -f ../files/currentconfig/ora_options.lis_$node ]
		then
		cat ../files/currentconfig/ora_options.lis_$node >> $FILES/html/ora_overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_overview.html



		
		### DBA Registry ###

		echo "
		<div class="tabletitle">DBA Registry</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_overview.html
		if [ -f ../files/currentconfig/ora_registry.lis_$node ]
		then
		cat ../files/currentconfig/ora_registry.lis_$node >> $FILES/html/ora_overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_overview.html

	

		
		### USER Privileges ###

		echo "
		<div class="tabletitle">USER Privileges</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_overview.html
		if [ -f ../files/currentconfig/ora_userpriv.lis_$node ]
		then
		cat ../files/currentconfig/ora_userpriv.lis_$node >> $FILES/html/ora_overview.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_overview.html

		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/ora_overview.html
		
		
		
		###############################
		###		Health Checks		###
		###############################
		
		#### TableSpaces ###

		cat html/indexheader >> $FILES/html/ora_health.html

		echo "
		<div class="tabletitle">SERVER: $node</div>
		<br>
		<br>" >> $FILES/html/ora_health.html

		echo "
		<div class="tabletitle">TableSpace Info</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_health.html
		if [ -f ../files/audit_results/ORACLE/ora_tablespace.lis_$node ]
		then
		cat ../files/audit_results/ORACLE/ora_tablespace.lis_$node >> $FILES/html/ora_health.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_health.html
		
		
		
		#### Large Segment Sizes ###

		cat html/indexheader >> $FILES/html/ora_health.html

		echo "
		<div class="tabletitle">Segment sizes greater than 500MB</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_health.html
		if [ -f ../files/audit_results/ORACLE/ora_segments.lis_$node ]
		then
		cat ../files/audit_results/ORACLE/ora_segments.lis_$node >> $FILES/html/ora_health.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_health.html
		

		#### PGA Sessions ###

		cat html/indexheader >> $FILES/html/ora_health.html

		echo "
		<div class="tabletitle">PGA Sessions</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_health.html
		if [ -f ../files/audit_results/ORACLE/ora_pgasessions.lis_$node ]
		then
		cat ../files/audit_results/ORACLE/ora_pgasessions.lis_$node >> $FILES/html/ora_health.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_health.html

		
		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/ora_health.html
		

done


#### Version Info ###

		cat html/indexheader >> $FILES/html/ora_rac.html

		echo "
		<div class="tabletitle">RAC FWDB2</div>
		<br>
		<br>" >> $FILES/html/ora_rac.html

		echo "
		<div class="tabletitle">FWDB1 Environment Details</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_rac.html
		if [ -f ../files/currentconfig/ora.rac.fwdb1 ]
		then
		cat ../files/currentconfig/ora.rac.fwdb1 >> $FILES/html/ora_rac.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_rac.html
		
		cat html/indexheader >> $FILES/html/ora_rac.html
		
		
		echo "
		<br>
		<br>
		<br>
		<HR align=left width=""100%"" color=#ffffff SIZE=1>
		<br>
		<br> " >> $FILES/html/ora_rac.html
		

		echo "
		<div class="tabletitle">RAC FWDB2</div>
		<br>
		<br>" >> $FILES/html/ora_rac.html

		echo "
		<div class="tabletitle">FWDB2 Environment Details</div>
		<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
		<tr class="bg0">
		<th class="tableheader" width="60%">Details</th>
		</tr>
		<tr class="bg1">
		<td width="60%">
		<pre> " >> $FILES/html/ora_rac.html
		if [ -f ../files/currentconfig/ora.rac.fwdb2 ]
		then
		cat ../files/currentconfig/ora.rac.fwdb2 >> $FILES/html/ora_rac.html
		fi
		echo "
		</pre>
		</td>
		</tr>
		</table>" >> $FILES/html/ora_rac.html




### Clean up temp files ###

rm -rf $TMPFILES/*
