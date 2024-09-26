CREATE VIEW dta.dictionary
AS
SELECT   sourceSchema= s.name,  
         sourceTable = d.name,
         sourceColumn = c.name,
         dataType = t.Name,
         column_id = c.column_id,
         [maxLength]	= c.max_length,
         [precision]	= c.precision,
         scale			= c.scale,
         id_nullable	= c.is_nullable,
         primary_key	= ISNULL(i.is_primary_key, 0)
    FROM sys.tables d
    LEFT JOIN sys.columns c
      ON d.object_id = c.object_id
   INNER JOIN sys.types t
      ON c.user_type_id = t.user_type_id
    LEFT OUTER JOIN sys.index_columns ic
      ON ic.object_id = c.object_id
    AND ic.index_id  = 1
     AND ic.column_id = c.column_id
    LEFT OUTER JOIN sys.indexes i
      ON ic.object_id = i.object_id
     AND ic.index_id = i.index_id
     AND i.index_id = 1
     AND i.is_primary_key = 1 
   INNER JOIN sys.schemas s 
      ON s.schema_id = d.schema_id;