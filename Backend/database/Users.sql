-- Thủ tục insertUser


EXECUTE showColumns 'users';
GO 

CREATE OR ALTER PROCEDURE insertUser 
    @lname NVARCHAR(50),
    @fname NVARCHAR(50),
    @citizen_id CHAR(20),
    @dob DATE,
    @sex CHAR(1),
    @email NVARCHAR(50),
    @phone CHAR(10)
AS
BEGIN
    DECLARE @isUniqueEmail BIT;
    DECLARE @isUniquePhone BIT;
    DECLARE @isUniqueCitizenId BIT;

    EXEC checkUniqueValue 'users', 'email', @email, @isUniqueEmail OUTPUT;
    IF @isUniqueEmail = 0 BEGIN
        RAISERROR('Email already exists in another account!', 16, 1);
        RETURN;
    END;

    EXEC checkUniqueValue 'users', 'phone', @phone, @isUniquePhone OUTPUT;
    IF @isUniquePhone = 0 BEGIN
        RAISERROR('Phone number already exists in another account!', 16, 1);
        RETURN;
    END;

    EXEC checkUniqueValue 'users', 'citizen_id', @citizen_id, @isUniqueCitizenId OUTPUT;
    IF @isUniqueCitizenId = 0 BEGIN
        RAISERROR('Citizen ID already exists in another account!', 16, 1);
        RETURN;
    END;

    INSERT INTO users (lname, fname, citizen_id, dob, sex, email, phone)
    VALUES (@lname, @fname, @citizen_id, @dob, @sex, @email, @phone);

    SELECT SCOPE_IDENTITY();
END;
GO


-- Thủ tục updateUserName
CREATE OR ALTER PROCEDURE updateUserFname @id INT, @fname NVARCHAR(50)
AS BEGIN EXEC updateFieldById 'users', @id, 'fname', @fname; END;
GO


-- Thủ tục updateUserName
CREATE OR ALTER PROCEDURE updateUserLname @id INT, @lname NVARCHAR(50)
AS BEGIN EXEC updateFieldById 'users', @id, 'lname', @lname; END;
GO


-- Thủ tục updateUserSex
CREATE OR ALTER PROCEDURE updateUserSex @id INT, @sex CHAR(1)
AS BEGIN EXEC updateFieldById 'users', @id, 'sex', @sex; END;
GO

-- Thủ tục updateUserEmail
CREATE OR ALTER PROCEDURE updateUserEmail @id INT, @email NVARCHAR(50)
AS BEGIN
    DECLARE @isUniqueEmail BIT;
    
    EXEC checkUniqueValueForUpdate 'users', 'email', @email, @id, @isUniqueEmail OUTPUT;
    IF @isUniqueEmail = 0 BEGIN
        RAISERROR('Email already exists in another account!', 16, 1);
        RETURN;
    END

    EXEC updateFieldById 'users', @id, 'email', @email;
END;
GO

-- Thủ tục updateUserPhone
CREATE OR ALTER PROCEDURE updateUserPhone @id INT, @phone CHAR(10)
AS BEGIN
    DECLARE @isUniquePhone BIT;
    
    EXEC checkUniqueValueForUpdate 'users', 'phone', @phone, @id, @isUniquePhone OUTPUT;
    IF @isUniquePhone = 0  BEGIN
        RAISERROR('Phone number already exists in another account!', 16, 1);
        RETURN;
    END

    EXEC updateFieldById 'users', @id, 'phone', @phone;
END;
GO


-- -- Thủ tục updateUser
-- CREATE OR ALTER PROCEDURE updateUser 
--     @id INT,
--     @name NVARCHAR(50),
--     @sex CHAR(1),
--     @password NVARCHAR(255),
--     @email NVARCHAR(50),
--     @phone CHAR(10),
--     @role NVARCHAR(10),
--     @avt_url TEXT,
--     @address TEXT
-- AS
-- BEGIN
--     EXEC updateUserName @id, @name;
--     EXEC updateUserSex @id, @sex;
--     EXEC updateUserPassword @id, @password;
--     EXEC updateUserEmail @id, @email;
--     EXEC updateUserPhone @id, @phone;
--     EXEC updateUserRole @id, @role;
--     EXEC updateUserAvtUrl @id, @avt_url;
--     EXEC updateUserAddress @id, @address;
-- END;
-- GO




