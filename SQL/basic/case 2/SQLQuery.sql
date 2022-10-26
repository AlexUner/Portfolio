-------------------------CHOOSE-FROM-0-TO-6----------------------------------//<
DECLARE @MyCounter int;
SET @MyCounter = 6;		
-------------------SELECT-DISTINCT-FROM-ORDER-BY-----------------------------//0
IF @MyCounter = 0       
SELECT DISTINCT * 
FROM Categories 
ORDER BY CategoryName; 
-----------------------------TOP-PERCENT-------------------------------------//1
IF @MyCounter = 1 
SELECT TOP(27)PERCENT ProductName, Price 
FROM Products  
ORDER BY Price;
-------------------------------WHERE-IN--------------------------------------//2
IF @MyCounter = 2                       
SELECT ProductName, Price  
FROM Products  
WHERE Price  > 100 AND Price < 200 AND Category IN (4);
-----------------------------LIKE-BETWEEN------------------------------------//3
IF @MyCounter = 3                       
SELECT ProductName, Price  
FROM Products  
WHERE Category LIKE 1 AND Price BETWEEN 100 AND 150;--170;
-----------------------------------ALL---------------------------------------//4
IF @MyCounter = 4                       
SELECT *  
FROM Products  
WHERE Category = ALL(SELECT CategoryId FROM Categories WHERE Category LIKE 1);
------------------------------IS-(NOT)-NULL----------------------------------//5
IF @MyCounter = 5                       
SELECT *  
FROM Categories  
WHERE CategoryId IS NOT NULL; --IS NULL;
--------------------------INSERT-UPDATE-SELECT-------------------------------//6
IF @MyCounter = 6 BEGIN 

INSERT INTO Products  
VALUES (1, 'EvriDay', 50);

UPDATE Products SET ProductName = 'Expencive Milk', Price = 500
WHERE ProductName='EvriDay';

DELETE FROM Products  
WHERE ProductName='Expencive Milk'; 

SELECT *  
FROM Products;
END