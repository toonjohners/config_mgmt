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
cp html/openet.jpg $FILES/html/



##
cat html/indexheader > $FILES/html/index.html


#### Make HTML Tables ####

echo "
<H2>Audit Summary</H2>
<table border=1 summary="Audit Summary" role="presentation">
<tr><td class="td_column">OS Version</td><td>$OS</td></tr>
<tr><td class="td_column">Collection Date</td><td>$NOW</td></tr>
<tr><td class="td_column">Number of nodes</td><td>$NUMHOSTS</td></tr>
<tr><td class="td_column">Number of Dates with Changes</td><td>$DAYCHANGE</td></tr>
<tr><td class="td_column">Number of Changes Found</td><td>$NUMCHANGE</td></tr>
</table>
" >> $FILES/html/index.html

echo "------------------------------------------------------------------------------------------------------------------------------------------------------" "<br>" >> $FILES/html/index.html

echo "<H2>Table of Contents</h2>
<ul id="toc">
<span style=font-size:18px>1 Operating System </span> <a href=#></a><br>
<span style=font-size:10px>1.1 Overall Current Configuration View</span> <a href=#></a><br>
<span style=font-size:10px>1.2 Individual Current Configuration View</span> <a href=#></a><br>
<span style=font-size:10px>1.3 Differences in Current Configuration</span> <a href=#></a><br>
<span style=font-size:10px>1.4 Configuration Changes Made</span> <a href=#></a><br>
</ul> 
" >> $FILES/html/index.html



#### Making Table & Links to Server Pages ###


echo "
<a name="overall_config"></a>
<H2>1.1 Overall Current Configuration View</H2>
             <table border=1 id="hosts" summary="hosts">
             <tr><th scope="col">Host Name</th>
             <th scope="col">Details</th></tr>
" >> $FILES/html/index.html



for token in `cat $TMPFILES/hosts`;
do
    echo "<td scope="row">$token</td><td><a href="$token.html">View</a></td></tr>" >> $FILES/html/index.html

done
echo "</table>" >> $FILES/html/index.html


#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
        cat html/indexheader > $FILES/html/$token.html
                echo "<H2>SERVER: $token</h2>" >> $FILES/html/$token.html


                for file in `cat .audit_files`;
                do
                                if [ -f $CURRCONFIG/${file}_$token ]
                                then
                        echo "<table border=1 id="$file" summary="overall">" >> $FILES/html/$token.html
                        echo "<tr><th scope="col">$file</th>" >> $FILES/html/$token.html
                        echo "<tr><td>" >> $FILES/html/$token.html
                        sed 's/$/<br>/' $CURRCONFIG/${file}_$token >> $FILES/html/$token.html
                        echo "</td></tr>" >> $FILES/html/$token.html
                                                echo "<br>" >> $FILES/html/$token.html
                                fi
        done
done


#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
                for file in `cat .audit_files`;
                do
                                if [ -f $CURRCONFIG/${file}_$token ]
                                then
                                        cat html/indexheader > $FILES/html/${file}_$token.html
                                                echo "<H2>SERVER: $token</h2>" >> $FILES/html/${file}_$token.html
                        echo "<table border=1 id="$file" summary="overall">" >> $FILES/html/${file}_$token.html
                        echo "<tr><th scope="col">$file</th>" >> $FILES/html/${file}_$token.html
                        echo "<tr><td>" >> $FILES/html/${file}_$token.html
                        sed 's/$/<br>/' $CURRCONFIG/${file}_$token >> $FILES/html/${file}_$token.html
                        echo "</td></tr>" >> $FILES/html/${file}_$token.html
                                                echo "<br>" >> $FILES/html/${file}_$token.html
                                fi
        done
done



#### Making Links to Each Config Pages ###
#### This is the Headers for the Columns ###
echo "
<a name="indiv_config"></a>
<H2>1.2 Individual Current Configuration View</H2>
             <table border=1 id="config" summary="config">
             <tr><th scope="col">Host Name</th> " >> $FILES/html/index.html

                         for config in `cat .audit_files` ; do
                         echo "<th scope="col">$config</th>" >> $FILES/html/index.html
                         done

echo "</tr>" >> $FILES/html/index.html

##################################################
### This is for the links to each config page ####

for token in `cat $TMPFILES/hosts`;
do
        echo "<td scope="row">$token</td>" >> $FILES/html/index.html

                for config in `cat .audit_files`; do
                        echo "<td><a href="${config}_$token.html">$config</a></td>" >> $FILES/html/index.html
                done
        echo "</tr>" >> $FILES/html/index.html
done

echo "</table>" >> $FILES/html/index.html

echo "---------------------------------------------------------------------------------------------------------------------------" "<br>" >> $FILES/html/index.html






#### Making Links to Each Config Pages ###
#### This is the Headers for the Columns ###
echo "
<a name="audit_config"></a>
<H2>1.3 Audit: Differences in Current Configuration</H2>
             <table border=1 id="config" summary="config">
             <tr><th scope="col">Host Name</th> " >> $FILES/html/index.html
			 
			 for config in `cat .audit_config` ; do
			 echo "<th scope="col">${config}</th>" >> $FILES/html/index.html
			 done

echo "</tr>" >> $FILES/html/index.html

##################################################
### This is for the links to each config page ####

for token in `cat $TMPFILES/hosts`;
do
	echo "<td scope="row">$token</td>" >> $FILES/html/index.html
		
		for config in `cat .audit_config`; do
			echo "<td><a href="${config}_${token}_audit.html">$config</a></td>" >> $FILES/html/index.html
		done
	echo "</tr>" >> $FILES/html/index.html
done

echo "</table>" >> $FILES/html/index.html

echo "---------------------------------------------------------------------------------------------------------------------------" "<br>" >> $FILES/html/index.html




#### Make Each HTML Page for Servers ####
#### Create Server file ####
for token in `cat $TMPFILES/hosts`;
do
                for file in `cat .audit_config`;
                do
				if [ -f $AUDITOS/${file}_$token ]
				then
				        cat html/indexheader > $FILES/html/${file}_${token}_audit.html
						echo "<H2>SERVER: $token</h2>" >> $FILES/html/${file}_${token}_audit.html
                        echo "<table border=1 id="$file" summary="overall">" >> $FILES/html/${file}_${token}_audit.html
                        echo "<tr><th scope="col">$file</th>" >> $FILES/html/${file}_${token}_audit.html
                        echo "<tr><td>" >> $FILES/html/${file}_${token}_audit.html
                        sed 's/$/<br>/' $AUDITOS/${file}_$token >> $FILES/html/${file}_${token}_audit.html
                        echo "</td></tr>" >> $FILES/html/${file}_${token}_audit.html
						echo "<br>" >> $FILES/html/${file}_${token}_audit.html
				fi
        done
done





###### Checking for Changes #######
#####Adding the changes to a date temp file
echo $DATECHG > $TMPFILES/DATES


#### Adding a table for the changes found #####
echo "
<a name="change_config"></a>
<H2>1.4 Configuration Changes Made</H2>
             <table border=1 id="change" summary="change">
             <tr><th scope="col">Date</th>
             <th scope="col">Details</th></tr>
" >> $FILES/html/index.html




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
test=`pwd | awk -F"/"  '{ print  $(NF-1)}'`
cat $mfile > ../../../tmp/changes/${test}_${mfile}
cd ../../../../bin/
done
done


##################################################
### This is for the links to each Date page ####

for token in `cat $TMPFILES/DATES`;
do
    echo "<td scope="row">$token</td><td><a href="$token.html">View</a></td></tr>" >> $FILES/html/index.html

done
echo "</table>" >> $FILES/html/index.html
echo "---------------------------------------------------------------------------------------------------------------------------" "<br>" >> $FILES/html/index.html


#############################################################
###### Creating Main page (By DATE) for Config Changes ######



for file in `ls $TMPFILES/changes | grep diff`; do
	DATE=`echo $file | cut -c 1-11`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`
	
	cat html/indexheader > $FILES/html/$DATE.html
	
	echo "
	<a name="date_change"></a>
	<H2>Changes Made to Configuration: $DATE </H2>
             <table border=1 id="datechange" summary="datechange">
             <tr><th scope="col">Host</th>
			 <th scope="col">Config Changed</th>
             <th scope="col">Details</th></tr>
	" >> $FILES/html/$DATE.html

done
	

for file in `ls $TMPFILES/changes | grep diff`; do
	DATE=`echo $file | cut -c 1-11`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`
	
	
	echo "<td scope="row">$HOSTER</td><td>$CONFIG</td><td><a href="${DATE}_${CONFIG}_$HOSTER.html">View</a></td></tr>" >> $FILES/html/$DATE.html
	
done


###################################################
###### Creating each page for Config Changes ######


for file in `ls $TMPFILES/changes/`; do
	## Local Variables###
	DIFF=`echo $file | grep diff`
	BEFORE=`echo $file | grep before`
	AFTER=`echo $file | grep after`
	DATE=`echo $file | cut -c 1-11`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`	
	
	cat html/indexheader > $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
	echo "<H2>SERVER: $HOSTER - $CONFIG - $DATE </h2>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html

done

	
for file in `ls $TMPFILES/changes/`; do
	## Local Variables###
	DIFF=`echo $file | grep diff`
	BEFORE=`echo $file | grep before`
	AFTER=`echo $file | grep after`
	DATE=`echo $file | cut -c 1-11`
	CONFIG=`echo $file | awk -F "_" '{print $4}'`
	HOSTER=`echo $file | awk -F "_" '{print $NF}'`
	 
						echo "<table border=1 align=left id="$file" summary="$CONFIG">" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
                        echo "<tr><th scope="col">$file</th>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						echo "<tr><td>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						sed 's/$/<br>/' $TMPFILES/changes/${file} >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
                        echo "</td></tr>" >> $FILES/html/${DATE}_${CONFIG}_$HOSTER.html
						


done


### Clean up temp files ###

rm -rf $TMPFILES/*




