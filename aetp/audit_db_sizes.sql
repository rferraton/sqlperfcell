-- Databases Files Sizes Analysis
WITH Tmaster as
(
select compatibility_level compatibility_level_master
from sys.databases
where name='master')
select
cast(getdate() as smalldatetime) extract_date,
CAST( SERVERPROPERTY( 'MachineName' ) AS varchar( 30 ) ) HostName,
CAST( SERVERPROPERTY( 'InstanceName' ) AS varchar( 30 ) ) InstanceName,
CAST( SERVERPROPERTY( 'ProductVersion' ) AS varchar( 30 ) ) Version,
CAST( SERVERPROPERTY( 'Edition' ) AS varchar( 30 ) ) Edition,
mf.database_id,
db.name dbname,
db.compatibility_level,
compatibility_level_master,
db.collation_name,
db.recovery_model_desc,
db.page_verify_option_desc,
type type_id,
type_desc,
file_id,
mf.name file_name,
physical_name,
left(physical_name,1) logical_drive,
is_master_key_encrypted_by_server,
is_auto_create_stats_on,
is_auto_update_stats_on,
is_auto_shrink_on,
cast(size as float) *8 /1024 sizeMo,
ceiling(growth * case when is_percent_growth=1 then (cast(size as float)*8.0/1024)/100 else (8.0 /1024) end) growth_in_MB,
is_percent_growth
from 
sys.master_files mf inner join sys.databases db on mf.database_id=db.database_id
cross join Tmaster
go
