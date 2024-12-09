USE SpClone;
GO

CREATE OR ALTER PROCEDURE showColumns
    @tableName VARCHAR(50)
AS BEGIN
    DECLARE @sql NVARCHAR(MAX);
    
    SET @sql = N'SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
                 FROM INFORMATION_SCHEMA.COLUMNS
                 WHERE TABLE_SCHEMA = SCHEMA_NAME() AND TABLE_NAME = @tableName';
    
    EXEC sp_executesql @sql, N'@tableName NVARCHAR(50)', @tableName;
END;
GO



-- Find All
CREATE OR ALTER PROCEDURE findAll 
    @tableName NVARCHAR(50),
    @offset INT = 0,
    @limit INT = 999999
AS BEGIN
    DECLARE @query NVARCHAR(MAX);
    SET @query = N'SELECT * FROM ' + @tableName + ' ORDER BY id OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY';
    EXEC sp_executesql @query, N'@offset INT, @limit INT', @offset, @limit;
END;
GO


-- Find All By Field
CREATE OR ALTER PROCEDURE findAllByField 
    @tableName NVARCHAR(50),
    @columnName NVARCHAR(50),
    @value NVARCHAR(255)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);
    SET @query = N'SELECT * FROM ' + @tableName + ' WHERE ' + @columnName + ' = @value';
    EXEC sp_executesql @query, N'@value NVARCHAR(255)', @value;
END;
GO



CREATE OR ALTER PROCEDURE checkUniqueValue 
    @tableName NVARCHAR(50),
    @columnName NVARCHAR(50),
    @value NVARCHAR(255),
    @isUnique BIT OUTPUT
AS BEGIN
    DECLARE @query NVARCHAR(MAX);

    SET @query = N'IF EXISTS (SELECT 1 FROM ' + QUOTENAME(@tableName) + 
                 ' WHERE ' + QUOTENAME(@columnName) + ' = @value) BEGIN
                    SET @isUnique = 0;
                END ELSE BEGIN
                    SET @isUnique = 1;
                END';
    EXEC sp_executesql @query, N'@value NVARCHAR(255), @isUnique BIT OUTPUT', @value, @isUnique OUTPUT;
END;
GO


-- Check Unique Value for Update
CREATE OR ALTER PROCEDURE checkUniqueValueForUpdate 
    @tableName NVARCHAR(50),
    @columnName NVARCHAR(50),
    @value NVARCHAR(255),
    @id INT,
    @isUnique BIT OUTPUT
AS BEGIN
    DECLARE @query NVARCHAR(MAX);

    SET @query = N'IF EXISTS (SELECT 1 FROM ' + QUOTENAME(@tableName) + 
                 ' WHERE ' + QUOTENAME(@columnName) + ' = @value AND id != @id) BEGIN
                    SET @isUnique = 0;
                END ELSE BEGIN
                    SET @isUnique = 1;
                END';
    EXEC sp_executesql @query, N'@value NVARCHAR(255), @id INT, @isUnique BIT OUTPUT', @value, @id, @isUnique OUTPUT;
END;
GO


-- Check if Value Exists
CREATE OR ALTER PROCEDURE checkExist 
    @tableName NVARCHAR(50),
    @columnName NVARCHAR(50),
    @value NVARCHAR(255),
    @isExist BIT OUTPUT
AS BEGIN

    DECLARE @query NVARCHAR(MAX);
    SET @query = N'IF EXISTS (SELECT 1 FROM ' + @tableName + ' WHERE ' + @columnName + ' = @value) BEGIN
                        SET @isExist = 1;
                    END
                    ELSE BEGIN
                        SET @isExist = 0;
                    END';
    EXEC sp_executesql @query, N'@value NVARCHAR(255), @isExist BIT OUTPUT', @value, @isExist OUTPUT;
END;
GO


-- Find By Id
CREATE OR ALTER PROCEDURE findById 
    @tableName NVARCHAR(255),
    @id INT
AS
BEGIN
    DECLARE @isExist BIT;
    EXEC checkExist @tableName, 'id', @id, @isExist OUTPUT;
    
    IF @isExist = 0 BEGIN
        RAISERROR('Record not found', 16, 1);
        RETURN;
    END

    DECLARE @query NVARCHAR(MAX);
    SET @query = N'SELECT * FROM ' + @tableName + ' WHERE id = @id';
    EXEC sp_executesql @query, N'@id INT', @id;
END;
GO


-- Find By Unique Field
CREATE OR ALTER PROCEDURE findByUniqueField 
    @tableName NVARCHAR(255),
    @columnName NVARCHAR(255),
    @value NVARCHAR(255)
AS
BEGIN
    DECLARE @isExist BIT;
    EXEC checkExist @tableName, @columnName, @value, @isExist OUTPUT;
    
    IF @isExist = 0 BEGIN
        RAISERROR('Record not found', 16, 1);
        RETURN;
    END

    DECLARE @query NVARCHAR(MAX);
    SET @query = N'SELECT * FROM ' + @tableName + ' WHERE ' + @columnName + ' = @value';
    EXEC sp_executesql @query, N'@value NVARCHAR(255)', @value;
END;
GO


-- Update Field By Id
CREATE OR ALTER PROCEDURE updateFieldById 
    @tableName NVARCHAR(255),
    @id INT,
    @columnName NVARCHAR(255),
    @value NVARCHAR(255)
AS
BEGIN
    DECLARE @isExist BIT;
    EXEC checkExist @tableName, 'id', @id, @isExist OUTPUT;
    
    IF @isExist = 0 BEGIN
        RAISERROR('Record not found', 16, 1);
        RETURN;
    END

    DECLARE @query NVARCHAR(MAX);
    SET @query = N'UPDATE ' + @tableName + ' SET ' + @columnName + ' = @value WHERE id = @id';
    EXEC sp_executesql @query, N'@value NVARCHAR(255), @id INT', @value, @id;
END;
GO


-- Delete By Id
CREATE OR ALTER PROCEDURE deleteById 
    @tableName NVARCHAR(255),
    @id INT
AS
BEGIN
    DECLARE @isExist BIT;
    EXEC checkExist @tableName, 'id', @id, @isExist OUTPUT;

    SELECT @isExist;
    IF @isExist = 0   BEGIN
        RAISERROR('Record not found', 16, 1);
        RETURN;
    END

    DECLARE @query NVARCHAR(MAX);
    SET @query = N'DELETE FROM ' + @tableName + ' WHERE id = @id';
    EXEC sp_executesql @query, N'@id INT', @id;
END;
GO

-- Delete All
CREATE OR ALTER PROCEDURE deleteAll 
    @tableName NVARCHAR(50)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);
    SET @query = N'DELETE FROM ' + @tableName;
    EXEC sp_executesql @query;
END;
GO

-- Update Value For Whole Column
CREATE OR ALTER PROCEDURE updateValueForWholeColumn 
    @tableName NVARCHAR(255),
    @columnName NVARCHAR(255),
    @value NVARCHAR(255)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);
    SET @query = N'UPDATE ' + @tableName + ' SET ' + @columnName + ' = @value';
    EXEC sp_executesql @query, N'@value NVARCHAR(255)', @value;
END;
GO


-- Find By Field Has Token
CREATE OR ALTER PROCEDURE findByFieldHasToken 
    @tableName NVARCHAR(255),
    @columnName NVARCHAR(255),
    @token NVARCHAR(255)
AS
BEGIN
    DECLARE @query NVARCHAR(MAX);
    SET @query = N'SELECT * FROM ' + @tableName + ' WHERE ' + @columnName + ' LIKE ''%' + @token + '%''';
    EXEC sp_executesql @query;
END;
GO