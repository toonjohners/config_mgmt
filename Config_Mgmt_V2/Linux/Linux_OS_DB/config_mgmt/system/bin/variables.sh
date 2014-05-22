#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#
#date '+%d_%m_%y_%H.%M'
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

./1test.sh
cat html/indexheader > $FILES/html/ora_overview.html





echo "
<div class="tabletitle">SERVER: $node</div>
<br>
<br>

<div class="tabletitle">Oracle Base Version</div>
<table class="coltable" width=""60%"" id="table_4" border="0" cellspacing="1" cellpadding="1">
<tr class="bg0">
<th class="tableheader" width=""60%"">Details</th>
</tr>
<tr class="bg1">
<td width=""60%"">
<pre> " >> $FILES/html/ora_overview.html

if [ -f ../files/currentconfig/ora_version.lis ]
then
cat ../files/currentconfig/ora_version.lis >> $FILES/html/ora_overview.html
fi
echo "
</pre>
</td>
</tr>
</table>" >> $FILES/html/ora_overview.html