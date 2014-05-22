#!/bin/sh


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
						{if (NF!=0){exit_code=0}
						if(NF==2){cc=substr($2,2,length($2)-2);
  						if(cc!=0){print $1}}else{print $1}}
					     END{exit exit_code}'`
  rc=$?
  if [ "$nextlvellist" = "" ]; then
    if [ $rc -eq 1 ]; then
      leaflist+=" $CUR_DIR"
    fi
  else
    if [ "$2" = "1" ]; then
      leaflist+=" $CUR_DIR"
    fi
    for fn in $nextlvellist; do
      ocli_lst $fn
    done
  fi
  CUR_DIR=`dirname $CUR_DIR`
}


CUR_DIR=/configuration/components/CTE

leaflist=""

lst=`ocli cd $CUR_DIR\; ls`
for fn in $lst; do
  ocli_lst $fn 1
done

# echo $leaflist


for component in $leaflist; do
  file=`basename $component`
  echo > File_$file
  echo "Component $component" > $file
  echo "=========" >> $file
  echo
  ocli show $component >> $file
done

exit 0
