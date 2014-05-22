#!/bin/bash
#Author: John McCormack
#Date: 16/01/2014
#
#

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

ocli_lst()
{
  local nextlvellist
  local curdir
  local rc

  CUR_DIR+="/$1"
  nextlvellist=`ocli cd $CUR_DIR\; ls | awk 'BEGIN{exit_code=1}
                                                {if (NF!=0){
                                                        if(NF==2){cc=substr($2,2,length($2)-2);
                                                                if(cc!=0){print $1; exit_code=0}
                                                        } else{
                                                                print $1; exit_code=0}
                                                        }
                                                }
                                             END{exit exit_code}'`
#  echo "result for $CUR_DIR is \"$nextlvellist\""
  rc=$?
  if [ $rc -eq 1 ]; then
    leaflist+=" $CUR_DIR"
  else
    if [ "$2" = "1" -o $rc = 0 ]; then
      leaflist+=" $CUR_DIR"
    fi
#    echo "leaflist is now \"$leaflist\""
    for fn in $nextlvellist; do
      ocli_lst $fn
    done
  fi
  CUR_DIR=`dirname $CUR_DIR`
}



ocli cd configuration/

for i in `ocli ls | grep -v 'decision-tables\|logs\|security\|solution-modules\|statistics'`; do

CUR_DIR=/configuration/$i

leaflist=""

lst=`ocli cd $CUR_DIR\; ls | awk 'BEGIN{exit_code=1}
                                        {if (NF!=0){exit_code=0}
                                        if(NF==2){cc=substr($2,2,length($2)-2);
                                        if(cc!=0){print $1}}else{print $1}}
                                  END{exit exit_code}'`
for fn in $lst; do
  ocli_lst $fn 1
done

#echo $leaflist


rm -rf $i
rm -rf ../files/config/$i
mkdir $i

currentfile="="
currentdir="="
for component in $leaflist; do
  token2=`echo $component | cut -d/ -f3`
  token3=`echo $component | cut -d/ -f4`
  token4=`echo $component | cut -d/ -f5`
  newdir=$token2/$token3
  newfile=$newdir/$token4
  if [ $newdir != $currentdir ]; then
    mkdir -p $newdir
    currentdir=$newdir
  fi
  if [ "$token4" = "" ]; then
    continue
  fi
  if [ $newfile != $currentfile ]; then
    echo "New file: $newfile, component: $component"
    currentfile=$newfile
    echo >> $currentfile
    echo "Component $component" >> $currentfile
    echo "=========" >> $currentfile
    echo >> $currentfile
  fi
  ocli show $component >> $currentfile
done

mv $i ../files/config 

done

exit 0
