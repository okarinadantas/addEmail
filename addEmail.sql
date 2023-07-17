USE adventureworks2019;
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'addnewemail')
BEGIN
    DROP PROCEDURE addnewemail;
END
GO

CREATE PROCEDURE addnewemail  
    @emailNew VARCHAR(50) = 'email-generico@gmail.com'
AS
BEGIN
    BEGIN TRAN addemail;

    SET IDENTITY_INSERT [Person].[EmailAddress] ON;

    INSERT INTO [Person].[EmailAddress] 
    (
        [BusinessEntityID],
        [EmailAddressID],
        [EmailAddress],
        [rowguid],
        [ModifiedDate]
    )
    VALUES
    (
        (SELECT MAX([BusinessEntityID]) + 1 FROM [Person].[EmailAddress]), 
        (SELECT MAX([EmailAddressID]) + 1 FROM [Person].[EmailAddress]),
        'email-generico@gmail.com', 
        NEWID(), 
        GETDATE() 
    );

    SET IDENTITY_INSERT [Person].[EmailAddress] OFF;

    DECLARE @emailCount INT;

    SELECT @emailCount = Count(*) 
    FROM [Person].[EmailAddress] 
    WHERE [EmailAddress] = 'email-generico@gmail.com';

    IF @emailCount > 1 
    BEGIN
        ROLLBACK TRAN addemail;
        PRINT 'This email is already in use.';
    END
    ELSE
    BEGIN
        COMMIT TRAN addemail;
        PRINT 'Email added successfully.';
    END;
END;
GO

-- Test the stored procedure
-- EXEC addnewemail 'email-generico@gmail.com';

-- SELECT statement to verify the inserted email address
-- SELECT * FROM [Person].[EmailAddress] WHERE [EmailAddress] = 'email-generico@gmail.com';
