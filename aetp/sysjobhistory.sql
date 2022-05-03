SET STATISTICS TIME ON
GO

SELECT j.name JobName,h.step_name StepName, 
convert(datetime2,cast(h.run_date as varchar(8))+ ' ' + (STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':')),111) start_timestamp,
h.run_duration run_duration_hhmmss,
right(cast(1000000+h.run_duration as varchar),2)+left(right(cast(1000000+h.run_duration as varchar),4),2)*60+left(right(cast(1000000+h.run_duration as varchar),6),2)*60*60,
case h.run_status when 0 then 'failed'
when 1 then 'Succeded' 
when 2 then 'Retry' 
when 3 then 'Cancelled' 
when 4 then 'In Progress' 
end as ExecutionStatus, 
h.message MessageGenerated
FROM 
msdb.dbo.sysjobhistory h inner join msdb.dbo.sysjobs j ON (j.job_id = h.job_id)