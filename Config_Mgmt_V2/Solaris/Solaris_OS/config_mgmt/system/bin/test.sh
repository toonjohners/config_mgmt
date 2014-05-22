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

#### Run 
./other.sh
cat html/indexheader > $FILES/html/overview.html






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


##### Overview of Each Server #####

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/system_$HOST >> $FILES/html/overview.html

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
cat $FILES/audit_results/HOSTINFO/date_$HOST >> $FILES/html/overview.html

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
cat $FILES/audit_results/HOSTINFO/lastreboot_$HOST >> $FILES/html/overview.html

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

cat $FILES/audit_results/HOSTINFO/uptime_$HOST >> $FILES/html/overview.html

echo "
</pre>
</td>
</tr>
</table>" >> $FILES/html/overview.html


#### MEMORY INFO ###


cat html/indexheader > $FILES/html/meminfo.html


echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/meminfo_$HOST >> $FILES/html/meminfo.html

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

cat $FILES/audit_results/HOSTINFO/vmstat_$HOST >> $FILES/html/meminfo.html

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

cat $FILES/audit_results/HOSTINFO/free_m_$HOST >> $FILES/html/meminfo.html

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


cat html/indexheader > $FILES/html/cpuinfo.html


echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/cpuinfo_$HOST >> $FILES/html/cpuinfo.html

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

cat html/indexheader > $FILES/html/iostat.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/iostat_$HOST >> $FILES/html/iostat.html

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


cat html/indexheader > $FILES/html/processes.html


echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/process_$HOST >> $FILES/html/processes.html

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

cat html/indexheader > $FILES/html/memutil.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
<br>
<br>" >> $FILES/html/memutil.html



echo "
<div class="tabletitle">Memory Consumption</div>
<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
<tr class="bg0">
<th class="tableheader" width="60%">Details</th>
</tr>
<tr class="bg1">
<td width="60%">
<pre> " >> $FILES/html/memutil.html

cat $FILES/audit_results/HOSTINFO/memutil_$HOST >> $FILES/html/memutil.html

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

cat html/indexheader > $FILES/html/cpuutil.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
<br>
<br>" >> $FILES/html/cpuutil.html



echo "
<div class="tabletitle">CPU Consumption</div>
<table class="coltable" width="60%" id="table_4" border="0" cellspacing="1" cellpadding="1">
<tr class="bg0">
<th class="tableheader" width="60%">Details</th>
</tr>
<tr class="bg1">
<td width="60%">
<pre> " >> $FILES/html/cpuutil.html

cat $FILES/audit_results/HOSTINFO/cpuutil_$HOST >> $FILES/html/cpuutil.html

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

cat html/indexheader > $FILES/html/diskusage.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/diskusage_$HOST >> $FILES/html/diskusage.html

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

cat html/indexheader > $FILES/html/fdisk.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/fdisk_$HOST >> $FILES/html/fdisk.html

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

cat html/indexheader > $FILES/html/foundlog.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/foundlog_$HOST >> $FILES/html/foundlog.html

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

cat html/indexheader > $FILES/html/log.html

echo "
<div class="tabletitle">SERVER: $HOST</div>
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

cat $FILES/audit_results/HOSTINFO/log_$HOST >> $FILES/html/log.html

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
<br> " >> $FILES/html/log.html
















#### Making Table & Links to Server Pages ###
cat html/indexheader > $FILES/html/overall_config.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="overall_config"></a>
<div class="tabletitle">1.1 Overall Current Configuration View</div>
<tr><td class="tableheader">Configuration</td>
<td class="bg0">Host</td>
<td class="bg0">Details</td>
<tr><td class="tableheader"></td>

" >> $FILES/html/overall_config.html



for token in `cat $TMPFILES/hosts`;
do
    echo "<td class="bg0">$token</td><td class="bg0"><a href="$token.html">View</a></td></tr>" >> $FILES/html/overall_config.html

done
echo "</table>" >> $FILES/html/overall_config.html



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
					#	echo "<td class="bg0">$file</td>" >> $FILES/html/$token.html
					#	echo "<tr><td class="tableheader">Details</td>" >> $FILES/html/$token.html
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






