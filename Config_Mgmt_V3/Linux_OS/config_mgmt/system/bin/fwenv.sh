#!/bin/bash
#Author: John McCormack
#Date: 16/01/2014
#
#

## date format ##
NOW=`date +"%d_%b_%Y.%H.%M"`
TIME=`date '+DATE: %d/%m/%y TIME:%H:%M:%S'`

HTML="../files/html"
CONFIG="../files/config"
HOST=`hostname`
OS=$(cat /etc/redhat-release)


############### Source FW Profile 
. html/env_cpm41.sh

INSTALL_HISTORY=`cat $FUSIONWORKS_HOME/install.history`
PIDS=`ls -l $FUSIONWORKS_HOME/config/log/`




cat html/indexheader > ../files/html/overview.html

echo "

<div class="tabletitle">FunsionWorks Environment Overview</div>
<table border=1 summary="system overview" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<tr><td class="tableheader">OS_Version</td>
<td class="bg0">$OS</td>
<tr><td class="tableheader">Collection Date</td>
<td class="bg0">$NOW</td>
<tr><td class="tableheader">Hostname</td>
<td class="bg0">$HOST</td>
<tr><td class="tableheader">Fusionworks Home</td>
<td class="bg0">$FUSIONWORKS_HOME</td>
<tr><td class="tableheader">Fusionworks Prod</td>
<td class="bg0">$FUSIONWORKS_PROD</td>
<tr><td class="tableheader">JAVA Home</td>
<td class="bg0">$JAVA_HOME</td>
<tr><td class="tableheader">Install History</td>
<td class="bg0"><pre>$INSTALL_HISTORY</pre></td>
<tr><td class="tableheader">Running PIDs</td>
<td class="bg0"><pre>$PIDS</pre></td>


</td></tr>
</table>

" >> ../files/html/overview.html