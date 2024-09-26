CREATE PROCEDURE dta.PA_LOG_TRACK(
	@sourceSchema nvarchar(128),
	@tableName nvarchar(128),
	@processCode varchar(3), -- (IMP)ort (INS)sert (UPD)ate 
	@stepCode varchar(3),   -- (INI/END)
	@rows int = NULL,
	@status varchar(max) = 'Success'
)
AS
  DECLARE @existe INT	= 0
  
  SET @processCode = UPPER(@processCode) 
  SET @stepCode	   = UPPER(@stepCode) 
  
  SELECT @existe = count(1)
    FROM dta.log_upsert 
   WHERE source_schema = @sourceSchema
     AND table_name = @tableName

  IF @existe = 0 INSERT INTO dta.log_upsert(source_schema, table_name) values (@sourceSchema, @tableName)
  
  IF @processCode='IMP'
    BEGIN
      IF @stepCode='INI' 
         UPDATE dta.log_upsert 
            SET import_start = GETDATE() 
          WHERE table_name = @tableName 
      ELSE 
         UPDATE dta.log_upsert 
            SET import_end  = GETDATE(),
            	import_rows = @rows,
            	status      = @status
          WHERE table_name = @tableName 
    END
  ELSE IF @processCode='UPD'
    BEGIN
      IF @stepCode='INI' 
         UPDATE dta.log_upsert 
            SET update_start = GETDATE() 
          WHERE table_name = @tableName 
      ELSE 
         UPDATE dta.log_upsert 
            SET update_end  = GETDATE(),
            	update_rows = @rows,
            	status      = @status
          WHERE table_name = @tableName 
    END
  ELSE IF @processCode='INS'
    BEGIN
      IF @stepCode='INI' 
         UPDATE dta.log_upsert 
            SET insert_start = GETDATE() 
          WHERE table_name = @tableName 
      ELSE 
         UPDATE dta.log_upsert 
            SET insert_end  = GETDATE(),
            	insert_rows = @rows,
            	status      = @status
          WHERE table_name = @tableName 
    END