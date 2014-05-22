#!/bin/sh

ORACLE_SID=gpodb01
export ORACLE_SID

sqlplus -s /nolog <<EOF

connect gpofw1/gpofw1@gpodb01

spool db_name.lis
prompt ***  DB Name  ***
prompt ----------------------------
prompt
select name from v$database;
spool off




disconnect
quit
EOF
