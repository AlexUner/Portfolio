CREATE DATABASE Lab1db;
GO
USE Lab1db;
GO
CREATE TABLE Categories (
	CategoryId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_CategoryId PRIMARY KEY,
	CategoryName VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Products (
	ProductId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ProductId PRIMARY KEY,
	Category INT NOT NULL DEFAULT (1),
	ProductName VARCHAR(100) NOT NULL,
	Price MONEY NULL
);
GO

ALTER TABLE Products ADD CONSTRAINT FK_Category
FOREIGN KEY (Category)
REFERENCES Categories (CategoryId)
ON DELETE SET DEFAULT
ON UPDATE NO ACTION
GO

INSERT INTO Categories (CategoryName) VALUES 
('milk'), ('coffee'), ('eggs'), ('meat')
GO

INSERT INTO Products (Category, ProductName, Price) VALUES 
(1, 'Korovka', 120),
(1, 'barmolad', 160),
(2, 'bestcafe', 99),
(2, 'lastquick', 188),
(3, 'A1', 60),
(3, 'C0', 80),
(4, 'chicken', 160),
(4, 'pork', 180),
(4, 'bear', 810)