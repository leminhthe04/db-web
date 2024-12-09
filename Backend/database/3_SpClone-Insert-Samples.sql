USE SpClone;
GO

-- Procedure for clear all records in all tables
CREATE OR ALTER PROCEDURE clearAllData
AS BEGIN

    DECLARE @sql NVARCHAR(MAX) = '';

    -- Disable all foreign key constraints temporarily
    SELECT @sql += 'ALTER TABLE [' + OBJECT_NAME(parent_object_id) + 
                '] NOCHECK CONSTRAINT [' + name + '];' + CHAR(13)
    FROM sys.foreign_keys;
    EXEC sp_executesql @sql;

    -- Delete all data from all tables
    SET @sql = '';
    SELECT @sql += 'DELETE FROM [' + SCHEMA_NAME(schema_id) + 
                '].[' + name + '];' + CHAR(13)
    FROM sys.tables;
    EXEC sp_executesql @sql;

    -- Re-enable all foreign key constraints
    SET @sql = '';
    SELECT @sql += 'ALTER TABLE [' + OBJECT_NAME(parent_object_id) + 
                '] CHECK CONSTRAINT [' + name + '];' + CHAR(13)
    FROM sys.foreign_keys;
    EXEC sp_executesql @sql;

END;
GO


EXECUTE clearAllData;
GO


--  /////////////// INSERTING SAMPLE DATA ///////////////////


SET IDENTITY_INSERT Users ON; -- to insert id explicitly
INSERT INTO Users (id, citizen_id, fname, lname, dob, sex, phone, email) 
VALUES
-- user 1 to 10 are sellers
(1, '123456789012', 'Nguyen Van', 'Mot',  '1990-01-01', 'M', '0123456789', 'a@example.com'),
(2, '234567890123', 'Tran Thi',   'Hai',  '1991-02-02', 'F', '0234567890', 'b@example.com'),
(3, '345678901234', 'Le Van',     'Ba',   '1992-03-03', 'M', '0345678901', 'c@example.com'),
(4, '456789012345', 'Pham Thi',   'Bon',  '1993-04-04', 'F', '0456789012', 'd@example.com'),
(5, '567890123456', 'Nguyen Van', 'Nam',  '1994-05-05', 'M', '0567890123', 'e@example.com'),
(6, '678901234567', 'Tran Thi',   'Sau',  '1995-06-06', 'F', '0678901234', 'f@example.com'),
(7, '789012345678', 'Le Van',     'Bay',  '1996-07-07', 'M', '0789012345', 'g@example.com'),
(8, '890123456789', 'Pham Thi',   'Tam',  '1997-08-08', 'F', '0890123456', 'h@example.com'),
(9, '901234567890', 'Nguyen Van', 'Chin', '1998-09-09', 'M', '0901234567', 'i@example.com'),
(10,'012345678901', 'Tran Thi',   'Muoi', '1999-10-10', 'F', '0012345678', 'j@example.com'),

-- user 11 to 20 are buyers
(11, '112233445566', 'Nguyen Thi Muoi', 'Mot',  '1994-01-01', 'F', '0911223344', 'k@example.com'),
(12, '223344556677', 'Tran Van Muoi',   'Hai',  '1983-02-02', 'M', '0922334455', 'l@example.com'),
(13, '334455667788', 'Le Thi Muoi',     'Ba',   '1996-03-03', 'F', '0933445566', 'm@example.com'),
(14, '445566778899', 'Pham Van Muoi',   'Bon',  '1980-04-04', 'M', '0944556677', 'n@example.com'),
(15, '556677889900', 'Hoang Thi Muoi',  'Lam',  '1995-05-05', 'F', '0955667788', 'o@example.com'),
(16, '667788990011', 'Bui Van Muoi',    'Sau',  '1982-06-06', 'M', '0966778899', 'p@example.com'),
(17, '778899001122', 'Do Thi Muoi',     'Bay',  '1993-07-07', 'F', '0977889900', 'q@example.com'),
(18, '889900112233', 'Pham Van Muoi',   'Tam',  '1981-08-08', 'M', '0988990011', 'r@example.com'),
(19, '99011223344', 'Nguyen Van Muoi',  'Chin', '1989-09-09', 'M', '0990011223', 's@example.com'),
(20, '001122334455', 'Vu Thi Hai',      'Muoi', '1997-10-10', 'F', '0900112233', 't@example.com');
SET IDENTITY_INSERT Users OFF;
GO

-- SELECT * FROM Users;


INSERT INTO BankAccounts (user_id, bank_name, account_number) 
VALUES
-- user 1 has 2 bank accounts
(1,  'Vietcombank',  '123456789'),
(1,  'OCB',          '003948219482904'), 

(2,  'Techcombank',  '234567890'),
(3,  'Vietinbank',   '345678901'),
(4,  'BIDV',         '456789012'),
(5,  'Agribank',     '567890123'),
(6,  'MB Bank',      '678901234'),
(7,  'ACB',          '789012345'),
(8,  'SHB',          '890123456'),
(9,  'VPBank',       '901234567'),
(10, 'Sacombank',    '012345678'),
(11, 'Vietcombank',  '112233445566'),
(12, 'Techcombank',  '223344556677'),

-- user 13 has 3 bank accounts
(13, 'Vietinbank',   '334455667788'),
(13, 'Sacombank',    '3958204894'),
(13, 'MB Bank',      '30383958305'), 

(14, 'BIDV',         '445566778899'),
(15, 'Agribank',     '556677889900'),
(16, 'MB Bank',      '667788990011'),
(17, 'ACB',          '778899001122'),
(18, 'SHB',          '889900112233'),
(19, 'VPBank',       '990011223344'),
(20, 'Sacombank',    '001122334455');
GO

-- SELECT * FROM BankAccounts;


-- User id from 1 to 10 are sellers
INSERT INTO Sellers (id, tax_id)
VALUES
(1, 'TAX001'), (2, 'TAX002'), (3, 'TAX003'), (4, 'TAX004'),
(5, 'TAX005'), (6, 'TAX006'), (7, 'TAX007'), (8, 'TAX008'),
(9, 'TAX009'), (10, 'TAX010');
GO

-- SellerInfos is a view joined from Users and Sellers
-- SELECT * FROM SellerInfos;


SET IDENTITY_INSERT Stores ON;
INSERT INTO Stores (id, seller_id, name, road_number, ward, district, city, description)
VALUES
-- seller 1 has 2 stores
(1, 1,   'Store A1', '10 DBP', 'Ward 1', 'District 1', 'City A', 'Description A1'),
(2, 1,   'Store A2', '11 DBP', 'Ward 1', 'District 1', 'City A', 'Description A2'), 

(3, 2,   'Store B',  '11 LBB', 'Ward 9', 'District 3', 'City B', 'Description B'),

-- seller 3 has 3 stores
(4, 3,   'Store C1', '13 CBT', 'Ward 3', 'District 5', 'City C', 'Description C1'),
(5, 3,   'Store C2', '14 CBT', 'Ward 3', 'District 5', 'City C', 'Description C2'),
(6, 3,   'Store C3', '15 CBT', 'Ward 93','District 5', 'City C', 'Description C3'), 

(7, 4,   'Store D',  '40 ABC', 'Ward 4', 'District 4', 'City D', 'Description D'),
(8, 5,   'Store E',  '50 BCD', 'Ward 5', 'District 5', 'City E', 'Description E'),
(9, 6,   'Store F',  '60 CDE', 'Ward 6', 'District 6', 'City F', 'Description F'),
(10, 7,  'Store G',  '70 DEF', 'Ward 7', 'District 7', 'City G', 'Description G'),
(11, 8,  'Store H',  '80 EFG', 'Ward 8', 'District 8', 'City H', 'Description H'),
(12, 9,  'Store I',  '90 FGH', 'Ward 9', 'District 9', 'City I', 'Description I'),
(13, 10, 'Store J', '100 GHI', 'Ward 10','District 10','City J', 'Description J');
SET IDENTITY_INSERT Stores OFF;
GO

-- SELECT * FROM Stores;


SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (id, name, larger_cate_id)
VALUES 
-- insert the largest categories first to avoid recursive FK violation
(1,  'Electronics',     NULL),
(2,  'Books',           NULL),
(3,  'Fashion',         NULL),
(4,  'Home Appliances', NULL),
(5,  'Beauty',          NULL), 

(6,  'Mobiles',         1),
(7,  'Laptops',         1),
(8,  'Novels',          2),
(9,  'Textbooks',       2),
(10, 'Clothing',        3),
(11, 'Cleanser',        5),
(12, 'Sunscreen',       5),
(13, 'Pot',             4),
(14, 'Washing Machine', 4),
(15, 'Refrigerator',    4),
(16, 'Samsung',         1),
(17, 'Iphone',          1),
(18, 'Dress',          10),
(19, 'Pants',          10),
(20, 'Database',        9);
SET IDENTITY_INSERT Categories OFF;
GO

SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (id, name, larger_cate_id) VALUES
(21, 'Ao dai', 18),
(22, 'Jean', 19),
(23, 'Sleeve less', 19),
(24, 'Short dress', 18);
SET IDENTITY_INSERT Categories OFF;

-- SELECT * FROM Categories;


SET IDENTITY_INSERT Products ON;
INSERT INTO Products (id, seller_id, store_id, name, brand, price, quantity, description, category_id)
VALUES
(1,   1,  1,  'Product A', 'Brand A', 100.00, 10, 'Description A',     1),
(2,   1,  1,  'Product B', 'Brand B', 200.00, 20, 'Description B',  NULL),
(3,   1,  2,  'Product C', 'Brand C', 150.00, 15, 'Description C',     3),
(4,   1,  2,  'Product D', 'Brand D', 250.00, 25, 'Description D',     4),
(5,   1,  2,  'Product E', 'Brand E', 300.00, 30, 'Description E',     5),

(6,   2,  3,  'Product F', 'Brand F', 120.00, 12, 'Description F',     6),

(7,   3,  4,  'Product G', 'Brand G', 170.00, 17, 'Description G',     7),
(8,   3,  5,  'Product H', 'Brand H', 220.00, 22, 'Description H',  NULL),
(9,   3,  5,  'Product I', 'Brand I', 180.00, 18, 'Description I',     9),
(10,  3,  6,  'Product J', 'Brand J', 400.00, 40, 'Description J',    10),

(11,  4,  7,  'Product K', 'Brand K', 300.00, 30, 'Description K',     1),
(12,  4,  7,  'Product L', 'Brand L', 350.00, 35, 'Description L',     2),

(13,  5,  8,  'Product M', 'Brand M', 400.00, 40,  NULL,               3),

(14,  6,  9,  'Product N', 'Brand N', 450.00, 45, 'Description N',     4),

(15,  7, 10,  'Product O', 'Brand O', 500.00, 50, 'Description O',     5),
(16,  7, 10,  'Product P', 'Brand P', 250.00, 25, 'Description P',     6),
(17,  7, 10,  'Product Q', 'Brand Q', 300.00, 30, 'Description Q',  NULL),

(18,  8, 11,  'Product R', 'Brand R', 350.00, 35, 'Description R',     8),

(19,  9, 12,  'Product S', 'Brand S', 400.00, 40, 'Description S',     9),
(20,  9, 12,  'Product T', 'Brand T', 450.00, 45, 'Description T',    10),

(21, 10, 13,  'Product U', 'Brand U', 500.00, 50, 'Description U',  NULL),
(22, 10, 13,  'Product V', 'Brand V', 250.00, 25, 'Description V',     2),
(23, 10, 13,  'Product W', 'Brand W', 300.00, 30,  NULL,               3),
(24, 10, 13,  'Product X', 'Brand X', 350.00, 35, 'Description X',     4),
(25, 10, 13,  'Product Y', 'Brand Y', 400.00, 40, 'Description Y',     5),
(26, 10, 13,  'Product Z', 'Brand Z', 450.00, 45, 'Description Z',     6);
SET IDENTITY_INSERT Products OFF;
GO

SET IDENTITY_INSERT Products ON;
INSERT INTO Products (id, seller_id, store_id, name, price, quantity, category_id) VALUES
(30, 1, 1, 'A Fashion shirt', 15000.00, 50, 3),
(31, 1, 1, 'A Fashinn hat', 20000.00, 40, 3),
(32, 1, 1, 'A Clothing', 30000.00, 30, 10),
(33, 2, 3, 'A pretty Dress', 15000.00, 39, 18),
(34, 2, 3, 'A Pants', 20000.00, 40, 19),
(35, 2, 3, 'A Sleeve less pants', 30000.00, 30, 23),
(36, 2, 3, 'A Short dress', 15000.00, 39, 24),
(37, 3, 4, 'A Cleanser', 20000.00, 40, 11),
(38, 3, 5, 'A Sunscreen', 30000.00, 30, 12),
(39, 3, 6, 'A Pot', 15000.00, 39, 13),
(47, 4, 7, 'A Washing Machine', 20000.00, 40, 14),
(48, 5, 8, 'A Refrigerator', 30000.00, 30, 15),
(42, 3, 6, 'A Samsung', 15000.00, 39, 16),
(43, 3, 6, 'A Iphone', 20000.00, 40, 17),
(44, 3, 6, 'A Dress', 30000.00, 30, 18),
(45, 7, 10, 'A Pants', 15000.00, 39, 19),
(46, 10, 13, 'A Database', 20000.00, 40, 20);
SET IDENTITY_INSERT Products OFF;


SET IDENTITY_INSERT Products ON;
INSERT INTO Products (id, seller_id, store_id, name, price, quantity, category_id) VALUES
(49, 1, 1, 'An Ao dai Viet Nam', 15000.00, 50, 21),
(55, 1, 1, 'An Ao dai Cach tan', 15000.00, 50, 21),
(51, 7, 10, 'A Black Jean', 15000.00, 50, 22),
(52, 7, 10, 'A Blue Jean', 15000.00, 50, 22),
(53, 7, 10, 'A Sleeve less Jean', 15000.00, 50, 23),
(54, 7, 10, 'A blue Short Dress', 15000.00, 50, 24);
SET IDENTITY_INSERT Products OFF;



SELECT seller_id, id FROM Stores;

SELECT * FROM Categories WHERE id IN (3, 10, 18, 19, 21, 22, 23, 24)

SELECT P.id, P.name AS category
FROM Products P
ORDER BY P.id;



SET IDENTITY_INSERT Carts ON;
INSERT INTO Carts (id)
VALUES 
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);
SET IDENTITY_INSERT Carts OFF;
GO

-- SELECT * FROM Carts;


-- User id from 11 to 20 are buyers
INSERT INTO Buyers (id, cart_id)
VALUES 
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5), 
(16, 6), (17, 7), (18, 8), (19, 9), (20, 10);
GO

-- SELECT * FROM BuyerInfos; -- View



INSERT INTO ProductsInCarts (cart_id, product_id, quantity)
VALUES
(1, 3, 5), (1, 12, 6), (1, 20, 1),  (1,1,1),

(2, 8, 4), (2, 17, 3), (2, 9, 3), (2, 21, 8),  

(3, 4, 4),  

(4, 21, 1), (4, 6, 2),  

(5, 8, 1),  

(6, 9, 7), (6, 3, 7), (6, 6, 5), (6, 7, 7),  
(6, 10, 7), (6, 8, 3),  

(7, 7, 4), (7, 8, 8), (7, 4, 8),  

(8, 9, 9), (8, 3, 9),  

(9, 12, 10), (9, 13, 10), (9, 10, 10), (9, 11, 10),  

(10, 11, 11);
GO


-- SELECT PC.cart_id, PC.product_id, P.name, P.price, PC.quantity, P.store_id
-- FROM ProductsInCarts PC, Products P
-- WHERE PC.product_id = P.id
-- ORDER BY cart_id, product_id;
 

INSERT INTO DeliveryPhones (buyer_id, phone_number) 
VALUES
(11, '0911223344'), (11, '0111111111'),

(12, '0922334455'), (12, '0922344455'),
(12, '0922335455'), (12, '0922333455'),

(13, '0933445566'), (13, '0933445567'), (13, '0933445568'),
(13, '0933445569'), (13, '0933445510'),
(13, '0933445511'), (13, '0933445512'),

(14, '0111111111'),

(15, '0933445512'),

(16, '0966778899'), (16, '0966778999'), (16, '0966779999'),

(17, '0977889900'),

(18, '0988990011'),

(19, '0990011223'),

(20, '0900112233');
GO

-- SELECT * FROM DeliveryPhones;

SET IDENTITY_INSERT DeliveryAddresses ON;
INSERT INTO DeliveryAddresses (id, buyer_id, road_number, ward, district, city)
VALUES
(1, 11, '123 Le Lai',         'Ward 1',  'District 1', 'Ho Chi Minh City'),
(2, 11, '124 Le Lai',         'Ward 1',  'District 1', 'Ho Chi Minh City'),
(3, 11, '125 Le Lai',         'Ward 1',  'District 1', 'Ho Chi Minh City'),

(4, 12, '456 Nguyen Du',      'Ward 2',  'District 3',            'Hanoi'),
(5, 12, '457 Nguyen Du',      'Ward 2',  'District 3',            'Hanoi'),
(6, 12, '456 Nguyen Du',      'Ward 3',  'District 3',            'Hanoi'),

(7, 13, '789 Tran Phu',       'Ward 3',  'District 5',          'Da Nang'),

(8, 14, '101 Hai Ba Trung',   'Ward 4',  'District 7', 'Ho Chi Minh City'),
(9, 14, '102 Hai Ba Trung',   'Ward 4',  'District 7', 'Ho Chi Minh City'),

(10, 15, '202 Le Quang Dao',   'Ward 5',  'District 8',            'Hanoi'),
(11, 15, '202 Le Quang Dao',   'Ward 5',  'District 8',              'HCM'),

(12, 16, '303 Kim Ma',         'Ward 6',  'District 9', 'Ho Chi Minh City'),

(13, 17, '404 Tran Thi Lan',   'Ward 7',  'District 4',          'Ha Long'),

(14, 18, '505 Bui Thi Xuan',   'Ward 8',  'District 2',          'Da Nang'),

(15, 19, '606 Phan Chu Trinh', 'Ward 9',  'District 10','Ho Chi Minh City'),

(16, 20, '707 Nguyen Thi',     'Ward 10', 'District 6',            'Hanoi');
SET IDENTITY_INSERT DeliveryAddresses OFF;
GO

-- SELECT * FROM DeliveryAddresses;


SET IDENTITY_INSERT Discounts ON;
INSERT INTO Discounts (id, code, quantity, start_date, expiration_date)
VALUES
-- these discounts will be system discounts
(1,  'system1', 100, '2024-11-01', '2024-12-01'),
(2,  'system2', 200, '2024-11-01', '2024-12-15'),
(3,  'system3', 150, '2024-11-01', '2024-11-30'),
(4,  'system3', 120, '2024-10-01', '2024-11-01'),
(5,  'system4', 180, '2024-11-05', '2024-12-05'),

-- these discounts will be store discounts
(6,  'store11', 100, '2024-11-01', '2024-12-01'),
(7,  'store12', 200, '2024-11-01', '2024-12-15'),
(8,  'store13', 150, '2024-11-01', '2024-11-30'),
(9,  'store14', 120, '2024-10-01', '2024-11-01'),
(10, 'store15', 180, '2024-11-05', '2024-12-05'),

(11, 'store21', 100, '2024-11-05', '2024-12-05'),
(12, 'store22', 100, '2024-11-05', '2024-12-05'),
(13, 'store23', 100, '2024-11-05', '2024-12-05'),
(14, 'store24', 100, '2024-11-05', '2024-12-05'),

(15, 'store31', 100, '2024-11-05', '2024-12-05'),
(16, 'store32', 100, '2024-11-05', '2024-12-05'),
(17, 'store33', 100, '2024-11-05', '2024-12-05'),
(18, 'store34', 100, '2024-11-05', '2024-12-05'),
(19, 'store35', 100, '2024-11-05', '2024-12-05'),

(20, 'store41', 100, '2024-11-05', '2024-12-05'),
(21, 'store42', 100, '2024-11-05', '2024-12-05'),

(22, 'store51', 100, '2024-11-05', '2024-12-05'),
(23, 'store52', 100, '2024-11-05', '2024-12-05'),
(24, 'store53', 100, '2024-11-05', '2024-12-05'),
-- only first 5 stores have discount

-- these discounts will be shipping discounts
(25, 'ship1', 50, '2024-11-05', '2024-12-05'),
(26, 'ship2', 50, '2024-11-05', '2024-12-05'),
(27, 'ship3', 50, '2024-11-05', '2024-12-05'),
(28, 'ship4', 50, '2024-11-05', '2024-12-05'),
(29, 'ship5', 50, '2024-11-05', '2024-12-05'),
(30, 'ship6', 50, '2024-11-05', '2024-12-05'),
(31, 'ship7', 50, '2024-11-05', '2024-12-05'),
(32, 'ship8', 50, '2024-11-05', '2024-12-05'),
(33, 'ship9', 50, '2024-11-05', '2024-12-05'),
(34, 'ship10',50, '2024-11-05', '2024-12-05');
SET IDENTITY_INSERT Discounts OFF;
GO

-- SELECT * FROM Discounts;


-- id from 6 to 24
INSERT INTO StoreDiscounts (id, amount, seller_id, store_id)
VALUES
-- store 1 of seller 1
(6, 10.00, 1, 1), (7, 5.00,  1, 1), (8, 2.00,  1, 1),
(9, 8.00,  1, 1), (10,12.00, 1, 1),

-- store 2 of seller 1
(11, 12.00, 1, 2), (12, 8.00,  1, 2),
(13, 10.00, 1, 2), (14, 5.00,  1, 2),

-- store 3 of seller 2
(15, 10.00, 2, 3), (16, 5.00,  2, 3), (17, 2.00,  2, 3), 
(18, 8.00,  2, 3), (19, 12.00, 2, 3),

-- store 4 of seller 3
(20, 10.00, 3, 4), (21, 5.00,  3, 4),

-- store 5 of seller 3
(22, 2.00,  3, 5), (23, 8.00,  3, 5), (24,12.00,  3, 5);
GO

-- SELECT * FROM StoreDiscountInfos; -- View


-- id from 1 to 5
INSERT INTO SystemDiscounts (id, max_amount, percentage, min_bill_amt)
VALUES
(1, 20.0,  5, 100.0), (2, 30.0, 10, 200.0),
(3, 40.0, 15, 300.0), (4, 50.0, 20, 400.0),
(5, 60.0, 25, 500.0);
GO

-- SELECT * FROM SystemDiscountInfos; -- View


-- id from 25 to 34
INSERT INTO ShippingDiscounts (id, max_amount)
VALUES
(25, 10.0), (26, 20.0), (27, 30.0), (28, 40.0),
(29, 50.0), (30, 60.0), (31, 70.0), (32, 80.0),
(33, 90.0), (34, 100.0);
GO

-- SELECT * FROM ShippingDiscountInfos; -- View


SET IDENTITY_INSERT ShippingPartners ON;
INSERT INTO ShippingPartners (id, name)
VALUES
(1, 'ViettelPost'),    (2, 'GiaoHangNhanh'),
(3, 'BuuDienVN'),        (4, 'J&T Express'),
(5, 'GrabExpress'),          (6, 'Ahamove'),
(7, 'Lalamove'),       (8, 'Sendo Express'),
(9, 'Shopee Express'),       (10, 'VnPost');
SET IDENTITY_INSERT ShippingPartners OFF;
GO

-- SELECT * FROM ShippingPartners;


-- discount id from 25 to 34, spartner id from 1 to 10
INSERT INTO DiscountForShippingPartners (discount_id, spartner_id)
VALUES
(25, 1), (25, 2), (25, 3), (25, 4), (25, 5),
(25, 6), (25, 7), (25, 8), (25, 9), (25, 10),

(26, 2), (26, 7), (26, 9), (26, 10),

(27, 1), (27, 3), (27, 5), (27, 7), (27, 9),

(28, 4), (28, 6),

(29, 1),

(30, 6),

(31, 3),

(32, 2), (32, 9),

(33, 4), (33, 7),

(34, 5), (34, 8);
GO

-- SELECT * FROM DiscountForShippingPartners;
-- ORDER BY discount_id, spartner_id;


SET IDENTITY_INSERT Orders ON;
INSERT INTO Orders (id, buyer_id, consignee_name, consignee_phone, consignee_address_id, total_price, sysdiscount_id, pay_method)
VALUES
(1, 11, 'Nguyen Thi K', '0111111111',  1,   500.00,    3,   'Cash'),
(2, 12, 'Tran Van L',   '0922333455',  4,  1500.00,    5, 'Credit'),
(3, 13, 'Le Thi M',     '0933445510',  7,  2500.00,    2,  'Debit'),
(4, 14, 'Pham Van N',   '0111111111',  8,  1000.00, NULL,   'Cash'),
(5, 15, 'Hoang Thi O',  '0933445512', 11,  1200.00,    4, 'Credit'),

-- buyer 16 created 3 orders
(6, 16, 'Bui Van P',    '0966778899', 12,  1600.00,    2,  'Debit'),
(7, 16, 'Do Thi Q',     '0966779999', 12,  1800.00,    1,   'Cash'),
(8, 16, 'Pham Van R',   '0966778999', 12,  2200.00, NULL, 'Credit'), 

(9, 19, 'Nguyen Van S', '0990011223', 15,  2400.00,    2,  'Debit'),
(10,20, 'Vu Thi T',     '0900112233', 16,  2600.00,    4,   'Cash');
SET IDENTITY_INSERT Orders OFF;
GO

-- SELECT * FROM Orders;


SET IDENTITY_INSERT Boxes ON;
INSERT INTO Boxes (id, order_id, total_price, storeDiscount_id, shippingPartner_id,
                   shippingDiscount_id, shipper_name, shipper_phone, predicted_delivery_date, caution)
VALUES
-- order 1 includes 2 boxes (from 2 store)
(1, 1, 600.00,    6, 1,   25, 'Nguyen Shipper1', '0123456789', '2024-12-03',     'Handle with care'),
(2, 1, 700.00,   24, 5,   27,   'Tran Shipper2', '0987654321', '2024-12-05', 'Fragile, do not drop'),

(3, 2, 800.00, NULL, 2,   32,     'Le Shipper3', '0912345678', '2024-12-07',  'Keep away from heat'),

-- order 3 include 3 boxes
(4, 3, 900.00,    7, 3, NULL, 'Nguyen Shipper4', '0945678901', '2024-12-02',                   NULL),
(5, 3, 1000.00,   6, 3, NULL,   'Pham Shipper5', '0923456789', '2024-12-03',     'Perishable goods'),
(6, 3, 1100.00,   9, 9,   32, 'Nguyen Shipper6', '0934567890', '2024-12-06', 'Keep in a cool place'),

(7, 4, 1200.00,   6, 7,   25,   'Pham Shipper7', '0956789012', '2024-12-08',                   NULL),

(8, 5, 1300.00,   8, 1, NULL,     'Le Shipper8', '0967890123', '2024-12-04',        'Store upright'),
(9, 5, 1400.00,NULL, 4, NULL, 'Nguyen Shipper9', '0978901234', '2024-12-06',             'Keep dry'),

(10,6, 1500.00,   9, 7,   25,  'Pham Shipper10', '0989012345', '2024-12-10',     'Handle with care'),
(11,7, 1500.00,  22, 5,   25,  'Pham Shipper11', '0989012345', '2024-12-04',                   NULL),
(12,8, 1500.00,NULL,10,   25,  'Pham Shipper12', '0989012345', '2024-12-05',     'Handle with care'),
(13,9, 1500.00,  18, 3,   25,  'Pham Shipper13', '0989012345', '2024-12-10',     'Handle with care'),
(14,10,1500.00,  15, 6,   25,  'Pham Shipper14', '0989012345', '2024-12-06',                   NULL);
SET IDENTITY_INSERT Boxes OFF;
GO

-- SELECT * FROM Boxes;
DELETE FROM ProductsInBoxes;
INSERT INTO ProductsInBoxes (box_id, product_id, quantity, pay_price)
VALUES
(1,  2, 14,  400.00),  (1,  6, 18,  600.00),  (1,  9, 15,  300.00),
(2, 11,  5,  600.00),  (2, 25,  6,  400.00),  (2, 19,  7,  800.00),
(3, 26,  8,  900.00),  (4, 22,  9,  200.00),  (5,  5, 10,  150.00),
(5,  3,  1,  1000.00), (6, 23,  2,  1000.00), (7, 18,  1,  1000.00),
(8, 15,  1,  1000.00), (9,  6,  2,  1000.00), (9,  8,  3,  1000.00),
(10, 9,  6,  1000.00), (10, 5,  8,  1000.00), (10, 3,  4,  1000.00);
GO

-- SELECT * FROM ProductsInBoxes;

DELETE FROM Reviews;
INSERT INTO Reviews (buyer_id, product_id, time, rating, text)
VALUES
(11, 25, '2024-11-24 10:00:00', 5,                                  'Great product!'),
(11, 25, '2024-11-24 11:00:00', 4,                     'Good quality, fast delivery'),
(13, 4,  '2024-11-24 12:00:00', 3,            'Product as described but a bit small'),
(14, 5,  '2024-11-24 13:00:00', 2,            'Incorrect description, not satisfied'),
(15, 6,  '2024-11-24 14:00:00', 5,                               'Love this product'),
(16, 7,  '2024-11-24 15:00:00', 4,                                              NULL),
(17, 8,  '2024-11-24 16:00:00', 5,               'Excellent quality, will buy again'),
(18, 9,  '2024-11-24 17:00:00', 3, 'A little smaller than I thought, but still okay'),
(19, 10, '2024-11-24 18:00:00', 4,                  'Good product, reasonable price'),
(20, 11, '2024-11-24 19:00:05', 1,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:04', 2,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:03', 3,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:02', 4,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:01', 5,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:00', 3,                      'Quality is not as expected'),
(20, 11, '2024-11-24 19:00:06', 2,                      'Quality is not as expected');
GO

-- SELECT * FROM Reviews;

-- SELECT * FROM Products;


------------------------------------------ SELECT DATA ------------------------------------------------
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'SELECT * FROM [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.tables;

-- In ra câu lệnh SQL
EXEC sp_executesql @sql;


-- SELECT * FROM SellerInfos;
-- SELECT * FROM BuyerInfos;
-- SELECT * FROM StoreDiscountInfos;
-- SELECT * FROM SystemDiscountInfos;
-- SELECT * FROM ShippingDiscountInfos;

-- SELECT * FROM Users;
-- SELECT * FROM BankAccounts;
-- SELECT * FROM Sellers;
-- SELECT * FROM Stores;
-- SELECT * FROM Categories;
-- SELECT * FROM Products;
-- SELECT * FROM Buyers;
-- SELECT * FROM Carts;
-- SELECT * FROM ProductsInCarts;
-- SELECT * FROM DeliveryPhones;
-- SELECT * FROM DeliveryAddresses;
-- SELECT * FROM Discounts;
-- SELECT * FROM StoreDiscounts;
-- SELECT * FROM SystemDiscounts;
-- SELECT * FROM ShippingDiscounts;
-- SELECT * FROM ShippingPartners;
-- SELECT * FROM DiscountForShippingPartners;
-- SELECT * FROM Orders;
-- SELECT * FROM Boxes;
-- SELECT * FROM ProductsInBoxes;
-- SELECT * FROM Reviews;
---------------------------------------------------- Update Data ---------------------------------------------------

-- UPDATE Products
-- SET 
--     avg_rating = (
--         SELECT COALESCE(AVG(rating), 0)
--         FROM Reviews
--         WHERE Reviews.product_id = Products.id
--     ),
--     rating_count = (
--         SELECT COUNT(*)
--         FROM Reviews
--         WHERE Reviews.product_id = Products.id
--     ),
--     buying_count = (
--         SELECT COUNT(*)
--         FROM ProductsInBoxes p
--         WHERE p.product_id = Products.id
--     )
-- WHERE EXISTS (
--     SELECT 1
--     FROM Reviews
--     WHERE Reviews.product_id = Products.id
-- );


-- UPDATE Carts
-- SET total_items = (
--     SELECT COALESCE(SUM(quantity), 0)
--     FROM ProductsInCarts
--     WHERE ProductsInCarts.cart_id = Carts.id
-- );


-- WITH BoxTotals AS (
--     SELECT 
--         b.id AS box_id,
--         COALESCE(SUM(pib.total_price), 0) 
--         - COALESCE(sd.amount, 0) 
--         - COALESCE(shipd.max_amount, 0) AS total_price
--     FROM Orders pib
--     LEFT JOIN Boxes b ON b.order_id = pib.id
--     LEFT JOIN StoreDiscounts sd ON b.storeDiscount_id = sd.id
--     LEFT JOIN ShippingDiscounts shipd ON b.shippingDiscount_id = shipd.id
--     GROUP BY b.id, sd.amount, shipd.max_amount
-- )
-- UPDATE Boxes
-- SET total_price = bt.total_price
-- FROM BoxTotals bt
-- WHERE Boxes.id = bt.box_id;

-- UPDATE Orders
-- SET total_price = (
--     SELECT SUM(pb.pay_price) - SUM(pb.pay_price * (sd.percentage / 100.0))
--     FROM ProductsInBoxes pb
--     LEFT JOIN SystemDiscounts sd ON Orders.system_discount_id = sd.id
--     WHERE pb.order_id = Orders.id
-- )
-- WHERE EXISTS (
--     SELECT 1
--     FROM ProductsInBoxes pb
--     WHERE pb.order_id = Orders.id
-- );



