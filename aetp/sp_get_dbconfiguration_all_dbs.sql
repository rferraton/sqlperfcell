USE DBATOOLS
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_get_dbconfiguration_all_dbs]
-- SQL 2016+
 

AS BEGIN
 

IF (SELECT count(*) FROM tempdb.sys.objects WHERE name = '##DBCONFIG_ALLDB')=1 BEGIN
DROP TABLE ##DBCONFIG_ALLDB;
END

CREATE TABLE ##DBCONFIG_ALLDB (
snapdate datetime,
srv nvarchar(1000),
sv nvarchar(1000),
dbname sysname,
configuration_id tinyint,
configuration_name nvarchar(1000),
configuration_value nvarchar(1000)
);


EXECUTE master.sys.sp_MSforeachdb
'USE [?];
IF DB_ID(''?'') <> 2
BEGIN
INSERT INTO ##DBCONFIG_ALLDB
SELECT 
getdate() as snapdate,
cast(serverproperty(''MachineName'') as nvarchar(1000)) svr,
cast(@@servicename as nvarchar(1000)) sv, 
''?'' dbname,
configuration_id, 
name configuration_name, 
cast([value] as nvarchar(1000)) configuration_value
FROM sys.database_scoped_configurations WITH (NOLOCK)
;

END
'
;

SELECT * FROM ##DBCONFIG_ALLDB
 
END
GO