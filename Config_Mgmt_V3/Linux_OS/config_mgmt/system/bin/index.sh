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


### Clean up temp files ###

rm -rf $TMPFILES/*
