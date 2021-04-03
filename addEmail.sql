USE adventureworks2019 

GO 

if exists (select 1 from sys.objects where name = 'addnewemail')
begin

drop procedure addnewemail
end

go

declare
@emailNew VARCHAR(50) = 'karinadantasluiz@gmail.com'


BEGIN

   BEGIN TRAN addemail 
      

	  SET IDENTITY_INSERT [Person].[EmailAddress] ON;

INSERT INTO
   [Person].[emailaddress] 
   (
   [BusinessEntityID],
	[EmailAddressID],
	[EmailAddress],
	[rowguid],
	[ModifiedDate]
   )
VALUES
   (
    (SELECT MAX ([BusinessEntityID]) + 1 FROM [Person].[EmailAddress]), 
	(SELECT MAX ([EmailAddressID]) + 1 FROM [Person].[EmailAddress]),
	'karinadantasluiz@gmail.com', 
	Newid(), 
	Getdate() 
   )
	SET IDENTITY_INSERT [Person].[EmailAddress] OFF;

SELECT
   @emailNew = Count(*) 
FROM
   [Person].[emailaddress] 
WHERE
   [emailaddress] = 'karinadantasluiz@gmail.com' 
   
   IF @emailNew > 1 
   BEGIN
      ROLLBACK TRAN addemail PRINT 'this e-mail already in use' 
   END
   ELSE
      BEGIN
         COMMIT TRAN addemail PRINT 'e-mail added succesfully' 
      END
END;


--exec addnewemail 'karinadantasluiz@gmail.com'
 

 --select * from [Person].[EmailAddress] 
 --where [EmailAddress] =  'karinadantasluiz@gmail.com'
