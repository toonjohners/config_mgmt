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




###########################################################################################################################################################


#### Making Table & Links to Server Pages ###
cat html/indexheader > $FILES/html/ora_config.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="ora_config"></a>
<div class="tabletitle">Overall Current Configuration View</div>
<tr><td class="tableheader">Configuration</td>
<td class="bg2">Host</td>
<td class="bg2">Details</td>


" >> $FILES/html/ora_config.html



for token in `cat $TMPFILES/hosts`;
do
    echo "<tr><td class="tableheader"></td><td class="bg0">$token</td><td class="bg0"><a href="$token.html">View</a></td></tr>" >> $FILES/html/ora_config.html

done
echo "</table>" >> $FILES/html/ora_config.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> $FILES/html/ora_config.html


#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
        cat html/indexheader > $FILES/html/$token.html
                echo "<div class="tabletitle">SERVER: $token</div>" >> $FILES/html/$token.html


                for file in `cat .audit_ora`;
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
<div class="tabletitle">Individual Configuration View</div>" >> $FILES/html/ora_config.html


for node in `cat $TMPFILES/hosts`;
do
                echo "
                <table border=1 summary="config_overall" role="presentation">
                <table class=coltable width=""100%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
                <div class="tabletitle">SERVER: $node</div>
                <th class="tableheader" width=""60%"">Details</th>" >> $FILES/html/ora_config.html
                         for config in `cat .audit_ora` ; do
                         echo "<td class=""bg2""><a href="${config}_$node.html">$config</a></td>" >> $FILES/html/ora_config.html
                         done

                echo "</tr> </table>" >> $FILES/html/ora_config.html
                echo "
                <br>
                <br>" >> $FILES/html/ora_config.html


done


#### Make Each HTML Page for each Config ####
#### Create Config HTML file ####
for token in `cat $TMPFILES/hosts`;
do
                for file in `cat .audit_ora`;
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




###########################################################################################################################################################


#### Making Table & Links to Server Pages ###
cat html/indexheader > $FILES/html/ora_snap.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="ora_snap"></a>
<div class="tabletitle">Overall Current Configuration View</div>
<tr><td class="tableheader">Configuration</td>
<td class="bg2">Host</td>
<td class="bg2">Details</td>


" >> $FILES/html/ora_snap.html



for token in `cat $TMPFILES/hosts`;
do
    echo "<tr><td class="tableheader"></td><td class="bg0">$token</td><td class="bg0"><a href="Ora_${token}.html">View</a></td></tr>" >> $FILES/html/ora_snap.html

done
echo "</table>" >> $FILES/html/ora_snap.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> $FILES/html/ora_snap.html


#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
        cat html/indexheader > $FILES/html/Ora_${token}.html
                echo "<div class="tabletitle">SERVER: $token</div>" >> $FILES/html/Ora_${token}.html


                for file in `cat .ora_snap`;
                do
                        if [ -f $CURRCONFIG/${file}_$token ]
                        then
						echo "<table border=1 summary="config_overall" role="presentation">" >> $FILES/html/Ora_${token}.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> $FILES/html/Ora_${token}.html
						echo "<tr><td class="tableheader">$file</td>" >> $FILES/html/Ora_${token}.html
                        echo "<tr><td class="bg0">" >> $FILES/html/Ora_${token}.html
						echo "<pre>" >> $FILES/html/Ora_${token}.html
                        sed 's/$/<br>/' $CURRCONFIG/${file}_$token >> $FILES/html/Ora_${token}.html
						echo "</pre>" >> $FILES/html/Ora_${token}.html
                        echo "</td></tr>" >> $FILES/html/Ora_${token}.html
						echo "</table>" >> $FILES/html/Ora_${token}.html
                        echo "<br>" >> $FILES/html/Ora_${token}.html
                        fi
        done
done






