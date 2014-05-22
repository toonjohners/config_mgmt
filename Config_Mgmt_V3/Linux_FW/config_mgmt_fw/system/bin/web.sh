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







############### Source FW Profile 
. html/env_cpm41.sh



############### OCLI Session
ocli() {
$FUSIONWORKS_PROD/bin/ocli -x $SESSION_ID $@
}
trim() {
echo $1
}
CONN="connect Administrator/Openet01"
SESSION_ID=$(trim `$FUSIONWORKS_PROD/bin/ocli -g $CONN | cut -d":" -f2`)


################ Get Configuration Menus and add to Navagation page

cp -f html/navbar.html_orig html/navbar.html

ocli connect Administrator/Openet01
ocli cd configuration/

for i in `ocli ls`; do 
	echo "<TR><TD><FONT face=Arial color=#ffffff size=-1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp <a href=nav_$i.html target="data_frame"> - $i </FONT></TD></TR>" >> html/navbar.html 
done



################ Get Configuration Menus and add to Navagation page
echo "<TR><TD><FONT face=Arial color=#ffffff size=-1>&nbsp;&nbsp;&nbsp;</FONT></TD></TR>" >> html/navbar.html
echo "<TR><TD><FONT face=Arial color=#ffffff size=-1>&nbsp;&nbsp;&nbsp;</FONT></TD></TR>" >> html/navbar.html
echo "<TR><TD><FONT face=Arial color=#ffffff size=-1>&nbsp;&nbsp;&nbsp;Changes Found</FONT></TD></TR>" >> html/navbar.html

for i in `ls -tr ../files/changes`; do 
	echo "<TR><TD><FONT face=Arial color=#ffffff size=-1>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp <a href=$i.html target="data_frame"> - $i </FONT></TD></TR>" >> html/navbar.html 
done
	
echo " </TBODY>
</TABLE>
</BODY>
</HTML> " >> html/navbar.html

rm -rf ../files/html
cp -R html ../files/



###############################################################


#### Making Table & Links to Configuration Pages ###

for i in `ocli ls`; do 
cat html/indexheader > ../files/html/nav_$i.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="overall_config"></a>
<div class="tabletitle">$i Configuration View</div>
<tr><td class="tableheader">$i Configuration</td>
<td class="bg2">$i</td>
<td class="bg2">Details</td>


" >> ../files/html/nav_$i.html



for token in `ls ../files/config/$i/`;
	do
		echo "<tr><td class="tableheader"></td><td class="bg0">$token</td><td class="bg0"><a href="$token.html">View</a></td></tr>" >> ../files/html/nav_$i.html
	done

echo "</table>" >> ../files/html/nav_$i.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> ../files/html/nav_$i.html



for token in `ls ../files/config/$i/`;
do
        cat html/indexheader > ../files/html/$token.html
		echo "
		<table border=1 summary="config_overall" role="presentation">
		<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
		<a name="overall_config"></a>
		<div class="tabletitle">$token Configuration View</div>
		<tr><td class="tableheader">$token Configuration</td>
		<td class="bg2">$i</td>
		<td class="bg2">Details</td>
		" >> ../files/html/$token.html
				
		for file in `ls ../files/config/$i/$token`;
		do
		echo "<tr><td class="tableheader"></td><td class="bg0">$file</td><td class="bg0"><a href=""#"V_$file">View</a></td></tr>" >> ../files/html/$token.html
		done
		echo "<div class="tabletitle">Configuration: $token</div>" >> ../files/html/$token.html
		
                for file in `ls ../files/config/$i/$token`;
                do
						echo "<table border=1 summary="config_overall" role="presentation">" >> ../files/html/$token.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> ../files/html/$token.html
						echo "<tr><td class="tableheader"><a id="V_$file">$file</a></td>" >> ../files/html/$token.html
                        echo "<tr><td class="bg0">" >> ../files/html/$token.html
						echo "<pre>" >> ../files/html/$token.html
                        sed 's/$/<br>/' ../files/config/$i/$token/$file >> ../files/html/$token.html
						echo "</pre>" >> ../files/html/$token.html
                        echo "</td></tr>" >> ../files/html/$token.html
						echo "</table>" >> ../files/html/$token.html
                        echo "<br>" >> ../files/html/$token.html
				done
			
done

done







###############################################################


#### Making Table & Links to Configuration Pages ###

for i in `ls -tr ../files/changes`; do 
cat html/indexheader > ../files/html/$i.html

echo "
<table border=1 summary="config_overall" role="presentation">
<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
<a name="overall_config"></a>
<div class="tabletitle">$i Configuration Changes</div>
<tr><td class="tableheader">$i Changes</td>
<td class="bg2">$i</td>
<td class="bg2">Details</td>


" >> ../files/html/$i.html




for token in `ls -tr ../files/changes/$i/`;
	do
		echo "<tr><td class="tableheader"></td><td class="bg0">$token</td><td class="bg0"><a href="$token.html">View</a></td></tr>" >> ../files/html/$i.html
	done

echo "</table>" >> ../files/html/$i.html

echo "
<br>
<br>
<br>
<HR align=left width=""100%"" color=#ffffff SIZE=1>
<br>
<br> " >> ../files/html/$i.html



for token in `ls -tr ../files/changes/$i/`;
do
        cat html/indexheader > ../files/html/$token.html
		echo "
		<table border=1 summary="config_overall" role="presentation">
		<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">
		<a name="overall_config"></a>
		<div class="tabletitle">$token Configuration View</div>
		<tr><td class="tableheader">$token Configuration</td>
		<td class="bg2">$i</td>
		<td class="bg2">Details</td>
		" >> ../files/html/$token.html
				
		for file in `ls -tr ../files/changes/$i/$token`;
		do
		echo "<tr><td class="tableheader"></td><td class="bg0">$file</td><td class="bg0"><a href=""#"V_$file">View</a></td></tr>" >> ../files/html/$token.html
		done
		echo "<div class="tabletitle">Configuration: $token</div>" >> ../files/html/$token.html
		
                for file in `ls -tr ../files/changes/$i/$token`;
                do
						echo "<table border=1 summary="config_overall" role="presentation">" >> ../files/html/$token.html
						echo "<table class=coltable width=""60%"" id=""table_0"" border=""0"" cellspacing=""1"" cellpadding=""1"">" >> ../files/html/$token.html
						echo "<tr><td class="tableheader"><a id="V_$file">$file</a></td>" >> ../files/html/$token.html
                        echo "<tr><td class="bg0">" >> ../files/html/$token.html
						echo "<pre>" >> ../files/html/$token.html
                        sed 's/$/<br>/' ../files/changes/$i/$token/$file >> ../files/html/$token.html
						echo "</pre>" >> ../files/html/$token.html
                        echo "</td></tr>" >> ../files/html/$token.html
						echo "</table>" >> ../files/html/$token.html
                        echo "<br>" >> ../files/html/$token.html
				done
			
done

done



############### Run Environment Check
./fwenv.sh

exit 0