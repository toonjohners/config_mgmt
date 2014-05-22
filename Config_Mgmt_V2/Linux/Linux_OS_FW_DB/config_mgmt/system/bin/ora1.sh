#!/bin/sh
 
ORACLE_SID=gpodb01
export ORACLE_SID
  
sqlplus -s /nolog <<EOF
   
connect /as sysdba
set linesize 200
set lines 200 trimspool on   
set echo off termout off

col service for a14
col username for a25
col default_tablespace for a15
col temporary_tablespace for a15
col profile for a20
col account_status for a20

spool FW_SOURCE_PROFILES.lis
prompt ***  FW_SOURCE_PROFILES  ***
prompt ----------------------------
prompt
select profile,resource_name,resource_type,limit
from dba_profiles
order by profile;
spool off

spool FW_SOURCE_SCHEMAS.lis
prompt ***  FW_SOURCE_SCHEMAS  ***
prompt ---------------------------
prompt
select username,account_status,default_tablespace,
temporary_tablespace,profile from dba_users
order by username;
spool off

spool FW_SOURCE_ROLE_PRIVS.lis
prompt ***  FW_SOURCE_ROLE_PRIVS  ***
prompt ------------------------------
prompt
select grantee, granted_role, admin_option, default_role
from DBA_ROLE_PRIVS
order by grantee;
spool off

spool FW_SOURCE_DB_JOB_CLASSES.lis
prompt ***  FW_SOURCE_DB_JOB_CLASSES  ***
prompt ----------------------------------
prompt
select job_class_name,resource_consumer_group,service,
logging_level,log_history from dba_scheduler_job_classes
order by job_class_name;
spool off

spool FW_SOURCE_DB_JOBS.lis
prompt ***  FW_SOURCE_DB_JOBS  ***
prompt ---------------------------
prompt
select distinct owner SCHEMA, count(*) JOB_COUNT  
from dba_scheduler_jobs where owner not like '%SYS%' 
group by owner order by owner;
select owner, job_name, job_class from dba_scheduler_jobs 
where owner not like '%SYS%'
order by owner, job_name, job_class;
spool off

spool FW_SOURCE_SERVICES.lis
prompt ***  FW_SOURCE_SERVICES  ***
prompt ----------------------------
prompt
set linesize 300
select service_id, name SERVICE_NAME, failover_method, failover_type from DBA_SERVICES;
spool off

spool FW_SOURCE_TABLES.lis
prompt ***  FW_SOURCE_TABLES  ***
prompt --------------------------
prompt
select distinct owner SCHEMA, count(*) TABLE_COUNT  
from dba_tables where owner not like '%SYS%' 
group by owner order by owner;
spool off

spool FW_SOURCE_TABLE_PARTS_COUNT.lis
prompt ***  FW_SOURCE_TABLE_PARTS_COUNT  ***
prompt -------------------------------------
prompt
select distinct table_owner SCHEMA, count(*) TABLE_PARTS_COUNT  
from dba_tab_partitions where table_owner not like '%SYS%' 
group by table_owner order by table_owner;
spool off

spool FW_SOURCE_INDEXES.lis
prompt ***  FW_SOURCE_INDEXES  ***
prompt ---------------------------
prompt
select distinct owner SCHEMA, count(*) INDEX_COUNT  
from dba_indexes where owner not like '%SYS%' 
group by owner order by owner;
prompt
select distinct status, count(*) RECORDS
from dba_indexes where owner not like '%SYS%'
group by status order by status;
spool off

spool FW_SOURCE_INDEX_PARTS_COUNT.lis
prompt ***  FW_SOURCE_INDEX_PARTS_COUNT  ***
prompt -------------------------------------
prompt
select distinct index_owner SCHEMA, count(*) INDEX_PARTS_COUNT  
from dba_ind_partitions where index_owner not like '%SYS%' 
group by index_owner order by index_owner;
prompt
select distinct status, count(*) RECORDS
from dba_ind_partitions where index_owner not like '%SYS%'
group by status order by status;
spool off

spool FW_SOURCE_TRIGGERS.lis
prompt ***  FW_SOURCE_TRIGGERS ***
prompt ---------------------------
prompt
select distinct owner SCHEMA, count(*) TRIGGER_COUNT  
from dba_triggers where owner not like '%SYS%' 
group by owner order by owner;
prompt
select distinct status, count(*) RECORDS
from dba_triggers where owner not like '%SYS%'
group by status order by status;
spool off

spool FW_SOURCE_CONSTRAINTS.lis
prompt ***  FW_SOURCE_CONSTRAINTS  ***
prompt -------------------------------
prompt
select distinct owner SCHEMA, count(*) CONSTRAINT_COUNT  
from dba_constraints where owner not like '%SYS%' 
group by owner order by owner;
prompt
select distinct status, count(*) RECORDS
from dba_constraints where owner not like '%SYS%'
group by status order by status;
spool off

spool FW_SOURCE_SEQUENCES.lis
prompt ***  FW_SOURCE_SEQUENCES  ***
prompt -----------------------------
prompt
select distinct sequence_owner SCHEMA, count(*) SEQUENCE_COUNT  
from dba_sequences where sequence_owner not like '%SYS%' 
group by sequence_owner order by sequence_owner;
spool off

spool FW_SOURCE_OBJECT_TYPES.lis
prompt ***  FW_SOURCE_OBJECT_TYPES  ***
prompt --------------------------------
prompt
select distinct owner SCHEMA,  object_type, count(*) OBJ_TYPE_COUNT  
from dba_objects where owner not like '%SYS%' 
group by owner, object_type order by owner, object_type;
prompt
select distinct status, count(*) RECORDS
from dba_objects where owner not like '%SYS%'
group by status order by status;
spool off

disconnect
quit
EOF

