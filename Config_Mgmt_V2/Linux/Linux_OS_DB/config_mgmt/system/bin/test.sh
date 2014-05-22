#!/bin/bash
#Author: John McCormack
#Date: 19/11/2012
#
#

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



. $CURRCONFIG/.installed


sqlplus -s /nolog <<EOF >/dev/null
connect $ORA_USER/$ORA_PASS@$ORACLE_SID
#set heading on
#set feedback off
set echo off
set termout off
set linesize 200
set heading on pages 0 trimspool on lines 120 feedback off echo off termout off

### Oracle Version ####
spool ../files/currentconfig/ora_version.lis_$HOST
select * from v\$version where banner like 'Oracle%';
spool off

### Other Version Info ###
spool ../files/currentconfig/ora_otherversion.lis_$HOST
select * from v\$version where banner not like 'Oracle%';
spool off

### Installed Options ###
spool ../files/currentconfig/ora_options.lis_$HOST
set linesize 200
select * from v\$option;
spool off

### DBA Registry ###
spool ../files/currentconfig/ora_registry.lis_$HOST
select comp_name, status from dba_registry;
spool off


### User Privileges ###
spool ../files/currentconfig/ora_userpriv.lis_$HOST
select * from session_privs;
spool off





##################  Daily Stats #####################

###### Large Segment Sizes #####
###### Show Segment sizes greater than 500MB ######

set linesize 2000
set pagesize 2000
spool ../files/audit_results/ORACLE/ora_segments.lis_$HOST
select substr(OWNER,1,15) owner, substr(SEGMENT_NAME,1,30) segment_name, segment_type,tablespace_name, sum(bytes)/1024/1025 bt 
from dba_segments group by OWNER, SEGMENT_NAME, tablespace_name, segment_type
    having sum(bytes)>500*1024*1024  order by sum(bytes) desc;

spool off



### TableSpaces Details ###

spool ../files/audit_results/ORACLE/ora_tablespace.lis_$HOST

SET lines 132 pages 66 feedback off
COLUMN tablespace_name        format a15             heading 'Tablespace|(TBS)|Name'
COLUMN autoextensible         format a6              heading 'Can|Auto|Extend'
COLUMN files_in_tablespace    format 999             heading 'Files|In|TBS'
COLUMN total_tablespace_space format 99,999,999,999 heading 'Total|Current|TBS|Space'
COLUMN total_used_space       format 99,999,999,999 heading 'Total|Current|Used|Space'
COLUMN total_tablespace_free_space format 99,999,999,999 heading 'Total|Current|Free|Space'
COLUMN total_used_pct              format 999.99      heading 'Total|Current|Used|PCT'
COLUMN total_free_pct              format 999.99      heading 'Total|Current|Free|PCT'
COLUMN max_size_of_tablespace      format 99,999,999,999 heading 'TBS|Max|Size'
COLUMN total_auto_used_pct         format 999.99      heading 'Total|Max|Used|PCT'
COLUMN total_auto_free_pct         format 999.99      heading 'Total|Max|Free|PCT'

TTITLE left _date center Tablespace Space Utilization Status Report skip 2




WITH tbs_auto AS
     (SELECT DISTINCT tablespace_name, autoextensible
                 FROM dba_data_files
                WHERE autoextensible = 'YES'),
     files AS
     (SELECT   tablespace_name, COUNT (*) tbs_files,
               SUM (BYTES) total_tbs_bytes
          FROM dba_data_files
      GROUP BY tablespace_name),
     fragments AS
     (SELECT   tablespace_name, COUNT (*) tbs_fragments,
               SUM (BYTES) total_tbs_free_bytes,
               MAX (BYTES) max_free_chunk_bytes
          FROM dba_free_space
      GROUP BY tablespace_name),
     AUTOEXTEND AS
     (SELECT   tablespace_name, SUM (size_to_grow) total_growth_tbs
          FROM (SELECT   tablespace_name, SUM (maxbytes) size_to_grow
                    FROM dba_data_files
                   WHERE autoextensible = 'YES'
                GROUP BY tablespace_name
                UNION
                SELECT   tablespace_name, SUM (BYTES) size_to_grow
                    FROM dba_data_files
                   WHERE autoextensible = 'NO'
                GROUP BY tablespace_name)
      GROUP BY tablespace_name)
SELECT a.tablespace_name,
       CASE tbs_auto.autoextensible
          WHEN 'YES'
             THEN 'YES'
          ELSE 'NO'
       END AS autoextensible,
       files.tbs_files files_in_tablespace,
       files.total_tbs_bytes total_tablespace_space,
       (files.total_tbs_bytes - fragments.total_tbs_free_bytes
       ) total_used_space,
       fragments.total_tbs_free_bytes total_tablespace_free_space,
       (  (  (files.total_tbs_bytes - fragments.total_tbs_free_bytes)
           / files.total_tbs_bytes
          )
        * 100
       ) total_used_pct,
       ((fragments.total_tbs_free_bytes / files.total_tbs_bytes) * 100
       ) total_free_pct,
       AUTOEXTEND.total_growth_tbs max_size_of_tablespace,
       (  (  (  AUTOEXTEND.total_growth_tbs
              - (AUTOEXTEND.total_growth_tbs - fragments.total_tbs_free_bytes
                )
             )
           / AUTOEXTEND.total_growth_tbs
          )
        * 100
       ) total_auto_used_pct,
       (  (  (AUTOEXTEND.total_growth_tbs - fragments.total_tbs_free_bytes)
           / AUTOEXTEND.total_growth_tbs
          )
        * 100
       ) total_auto_free_pct
  FROM dba_tablespaces a, files, fragments, AUTOEXTEND, tbs_auto
 WHERE a.tablespace_name = files.tablespace_name
   AND a.tablespace_name = fragments.tablespace_name
   AND a.tablespace_name = AUTOEXTEND.tablespace_name
   AND a.tablespace_name = tbs_auto.tablespace_name(+);
   
spool off
TTITLE off

###### PGA Sessions ####

 

set linesize 200
set pagesize 300
spool ../files/audit_results/ORACLE/ora_pgasessions.lis_$HOST
select vs.program, s.sid, sn.name, round(s.value/1024/1024, 2) mb 
	from v\$statname sn, v\$sesstat s, v\$session vs 
	where sn.statistic# = s.statistic# and vs.sid = s.sid and sn.name = 'session pga memory';
spool off





exit;
EOF


