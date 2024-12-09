USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'SpClone')
    DROP DATABASE SpClone;
GO

CREATE DATABASE SpClone;
GO

USE SpClone;
GO

CREATE TABLE Users (
    id              INT                 IDENTITY(1,1)            PRIMARY KEY,
    citizen_id      CHAR(12)            UNIQUE                      NOT NULL,
    fname           NVARCHAR(50)                                    NOT NULL,
    lname           NVARCHAR(20)                                    NOT NULL, 
    dob             DATE                                            NOT NULL,
    sex             NVARCHAR(5)                                     NOT NULL,
    phone           CHAR(10)            UNIQUE                      NOT NULL,
    email           NVARCHAR(255)       UNIQUE                      NOT NULL,
    creation_date   DATETIME            DEFAULT GETDATE(),

    CHECK (sex IN ('M', 'F', 'Other')),
    CHECK (phone NOT LIKE '%[^0-9]%' AND phone LIKE '0%'),
    CHECK (email LIKE '%@%.%')
);
GO

CREATE TABLE BankAccounts (
    user_id         INT                                             NOT NULL,
    bank_name       VARCHAR(20)                                     NOT NULL,
    account_number  VARCHAR(50)                                     NOT NULL,

    CONSTRAINT FK_BankAccounts_Users 
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,

    PRIMARY KEY (user_id, bank_name, account_number)
);
GO

CREATE TABLE Sellers (
    id              INT                                          PRIMARY KEY,
    tax_id          NVARCHAR(15)            UNIQUE                  NOT NULL,

    CONSTRAINT FK_Sellers_Users
    FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE
);
GO

CREATE TABLE Stores ( --  weeak entity of Sellers
    id              INT             IDENTITY(1,1)                   NOT NULL,
    seller_id       INT                                             NOT NULL,
    name            NVARCHAR(20)                                    NOT NULL,
    -- address
    road_number     NVARCHAR(20)                                    NOT NULL,
    ward            NVARCHAR(20)                                    NOT NULL,
    district        NVARCHAR(20)                                    NOT NULL,
    city            NVARCHAR(20)                                    NOT NULL,

    creation_date   DATETIME        DEFAULT GETDATE()               NOT NULL,
    description     NVARCHAR(MAX),

    CONSTRAINT FK_Stores_Sellers
    FOREIGN KEY (seller_id) REFERENCES Sellers(id) ON DELETE CASCADE,
    
    PRIMARY KEY (id, seller_id)
);
GO

CREATE TABLE Categories (
    id              INT             IDENTITY(1,1)                 PRIMARY KEY,
    name            NVARCHAR(20)    UNIQUE                          NOT NULL,
    -- recursive reference
    larger_cate_id  INT             DEFAULT NULL, 
);
-- because the recursive reference, need to add FK after table creating
ALTER TABLE Categories ADD 
    CONSTRAINT FK_Categories_Categories
    FOREIGN KEY (larger_cate_id) REFERENCES Categories(id);
GO

CREATE TABLE Products (
    id              INT             IDENTITY(1,1)                PRIMARY KEY,
    seller_id       INT                                             NOT NULL,
    store_id        INT                                             NOT NULL,
    name            NVARCHAR(20)                                    NOT NULL,
    brand           NVARCHAR(20),
    price           DECIMAL(10,2)                                   NOT NULL,
    quantity        INT                                             NOT NULL,
    description     NVARCHAR(MAX),
    buying_count    INT             DEFAULT 0                       NOT NULL,
    rating_count    INT             DEFAULT 0                       NOT NULL,
    
    avg_rating      DECIMAL(5,2)    DEFAULT 0.0                     NOT NULL, 
    category_id     INT,
    status          VARCHAR(20)     DEFAULT 'Available',

    CHECK (status IN ('Available', 'Stop Selling', 'Sold Out')),

    UNIQUE(seller_id, store_id, name),

    CONSTRAINT FK_Products_Stores
    FOREIGN KEY (store_id, seller_id) REFERENCES Stores(id, seller_id),

    CONSTRAINT FK_Products_Categories
    FOREIGN KEY (category_id) REFERENCES Categories(id)
    ON DELETE SET DEFAULT
);
GO

CREATE TABLE Carts (
    id              INT             IDENTITY(1,1)                PRIMARY KEY,
   -- derived attribute
    total_items     INT             DEFAULT 0                        NOT NULL
);
GO

CREATE TABLE ProductsInCarts (
    cart_id         INT                                             NOT NULL,
    product_id      INT                                             NOT NULL,
    quantity        INT                                             NOT NULL,

    CONSTRAINT FK_ProductsInCarts_Carts
    FOREIGN KEY (cart_id) REFERENCES Carts(id),

    CONSTRAINT FK_ProductsInCarts_Products
    FOREIGN KEY (product_id) REFERENCES Products(id),

    PRIMARY KEY (product_id, cart_id)
);
GO

CREATE TABLE Buyers (
    id              INT                                          PRIMARY KEY,
    cart_id         INT                                             NOT NULL,

    CONSTRAINT FK_Buyers_Users
    FOREIGN KEY (id) REFERENCES Users(id),

    CONSTRAINT FK_Buyers_Carts
    FOREIGN KEY (cart_id) REFERENCES Carts(id)
);
GO


CREATE TABLE DeliveryPhones (
    buyer_id        INT                                             NOT NULL,
    phone_number    CHAR(10)                                        NOT NULL,

    CHECK (phone_number NOT LIKE '%[^0-9]%' AND phone_number LIKE '0%'),

    CONSTRAINT FK_DeliveryPhones_Buyers
    FOREIGN KEY (buyer_id) REFERENCES Buyers(id),

    PRIMARY KEY (buyer_id, phone_number)
);
GO

CREATE TABLE DeliveryAddresses (
    id              INT                IDENTITY(1,1)             PRIMARY KEY,
    buyer_id        INT                                             NOT NULL,
    road_number     NVARCHAR(20)                                    NOT NULL,
    ward            NVARCHAR(20)                                    NOT NULL,
    district        NVARCHAR(20)                                    NOT NULL,
    city            NVARCHAR(20)                                    NOT NULL,

    CONSTRAINT FK_DeliveryAddresses_Buyers
    FOREIGN KEY (buyer_id) REFERENCES Buyers(id),

    UNIQUE (id, buyer_id) -- used for the foreign key in Orders table
);
GO

CREATE TABLE Reviews (
    buyer_id        INT                                             NOT NULL,
    product_id      INT                                             NOT NULL,
    time            DATETIME            DEFAULT GETDATE()           NOT NULL,
    rating          INT                                             NOT NULL,
    text            NVARCHAR(MAX)       DEFAULT NULL,

    CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT FK_Reviews_Buyers
    FOREIGN KEY (buyer_id) REFERENCES Buyers(id),
    

    CONSTRAINT FK_Reviews_Products
    FOREIGN KEY (product_id) REFERENCES Products(id),

    PRIMARY KEY (buyer_id, product_id, time),    
);
GO


CREATE TABLE Discounts (
    id              INT                 IDENTITY(1,1)            PRIMARY KEY,
    code            VARCHAR(50)                                     NOT NULL,
    quantity        INT                                             NOT NULL,
    release_date    DATETIME            DEFAULT GETDATE(),
    start_date      DATETIME                                        NOT NULL,
    expiration_date DATETIME                                        NOT NULL
);
GO

CREATE TABLE StoreDiscounts (
    id              INT                                          PRIMARY KEY,
    -- Ex: discount 10000.00
    amount          DECIMAL(10,2)                                   NOT NULL, 
    seller_id       INT                                             NOT NULL,
    store_id        INT                                             NOT NULL,

    CONSTRAINT FK_StoreDiscounts_Discounts
    FOREIGN KEY (id) REFERENCES Discounts(id),

    CONSTRAINT FK_StoreDiscounts_Stores
    FOREIGN KEY (store_id, seller_id) REFERENCES Stores(id, seller_id)
);
GO

CREATE TABLE SystemDiscounts (
    id              INT                                          PRIMARY KEY,
    max_amount      DECIMAL(10,2)                                   NOT NULL,
    percentage      INT                                             NOT NULL,
    min_bill_amt    DECIMAL(10,2)       DEFAULT 0                   NOT NULL,

    CHECK (percentage BETWEEN 0 AND 100),

    CONSTRAINT FK_SystemDiscounts_Discounts
    FOREIGN KEY (id) REFERENCES Discounts(id)
);
GO
CREATE TABLE ShippingDiscounts (
    id              INT                                          PRIMARY KEY,
    max_amount      DECIMAL(10,2)                                   NOT NULL,

    CONSTRAINT FK_ShippingDiscounts_Discounts
    FOREIGN KEY (id) REFERENCES Discounts(id)
);
GO

CREATE TABLE ShippingPartners (
    id              INT                 IDENTITY(1,1)            PRIMARY KEY,
    name            NVARCHAR(255)       UNIQUE                      NOT NULL,
    join_date       DATETIME            DEFAULT GETDATE()           NOT NULL
);
GO

CREATE TABLE DiscountForShippingPartners (
    discount_id     INT                                             NOT NULL,
    spartner_id     INT                                             NOT NULL,

    CONSTRAINT FK_DiscountForShippingPartners_ShippingDiscounts
    FOREIGN KEY (discount_id) REFERENCES ShippingDiscounts(id),

    CONSTRAINT FK_DiscountForShippingPartners_ShippingPartners
    FOREIGN KEY (spartner_id) REFERENCES ShippingPartners(id),

    PRIMARY KEY (discount_id, spartner_id)
);
GO

CREATE TABLE Orders (
    id                      INT             IDENTITY(1,1)        PRIMARY KEY,
    buyer_id                INT                                     NOT NULL,
    consignee_name          NVARCHAR(50)                            NOT NULL,
    consignee_phone         CHAR(10)                                NOT NULL,
    consignee_address_id    INT                                     NOT NULL,
    -- derived attribute
    total_price             DECIMAL(10,2)    DEFAULT 0.0            NOT NULL, 
    sysdiscount_id          INT              DEFAULT NULL,
    pay_method              NVARCHAR(50)                            NOT NULL,
    creation_date           DATETIME         DEFAULT GETDATE()      NOT NULL,

    CHECK (pay_method IN ('Cash', 'Credit', 'Debit')),

    CONSTRAINT FK_Orders_DeliveryPhones
    FOREIGN KEY (buyer_id, consignee_phone) REFERENCES 
DeliveryPhones(buyer_id, phone_number),

    CONSTRAINT FK_Orders_DeliveryAddresses
    FOREIGN KEY (consignee_address_id, buyer_id) REFERENCES 
DeliveryAddresses(id, buyer_id),

    -- no needs this constraint because the above 2 foreign keys are enough
    -- FOREIGN KEY (buyer_id) REFERENCES Buyers(id),   

    CONSTRAINT FK_Orders_SystemDiscounts
    FOREIGN KEY (sysdiscount_id) REFERENCES SystemDiscounts(id)
);
GO

CREATE TABLE Boxes (
    id                  INT                 IDENTITY(1,1)        PRIMARY KEY,
    order_id            INT                                         NOT NULL,
    -- derived attribute
    total_price         DECIMAL(10,2)       DEFAULT 0.0             NOT NULL,
    storeDiscount_id    INT                 DEFAULT NULL,
    shippingDiscount_id INT                 DEFAULT NULL,
    shippingPartner_id  INT                                         NOT NULL,
    shipper_name        NVARCHAR(50)                                NOT NULL,
    shipper_phone       CHAR(10)                                    NOT NULL,
    predicted_delivery_date 
                        DATE                DEFAULT NULL,
    status              NVARCHAR(50)        DEFAULT 'Pending'       NOT NULL,
    caution             NVARCHAR(MAX),
    packing_date        DATETIME            DEFAULT GETDATE()       NOT NULL,

    CHECK (status IN ('Pending', 'Shipping', 'Delivered')),
    CHECK (shipper_phone NOT LIKE '%[^0-9]%' AND shipper_phone LIKE '0%'),

    CONSTRAINT FK_Boxes_Orders
    FOREIGN KEY (order_id) REFERENCES Orders(id),

    CONSTRAINT FK_Boxes_StoreDiscounts
    FOREIGN KEY (storeDiscount_id) REFERENCES StoreDiscounts(id),
    CONSTRAINT FK_Boxes_DiscountForShippingPartners
    FOREIGN KEY (shippingDiscount_id, shippingPartner_id) REFERENCES
DiscountForShippingPartners(discount_id, spartner_id)
);
GO


CREATE TABLE ProductsInBoxes (
    box_id              INT                                     NOT NULL,
    product_id          INT                                     NOT NULL,
    quantity            INT                                     NOT NULL,
    -- derived attribute
    pay_price           DECIMAL(10,2)                           NOT NULL, 
    
    CONSTRAINT FK_ProductsInBoxes_Boxes
    FOREIGN KEY (box_id) REFERENCES Boxes(id),

    CONSTRAINT FK_ProductsInBoxes_Products
    FOREIGN KEY (product_id) REFERENCES Products(id),
    
    PRIMARY KEY (box_id, product_id)
);
GO


 ---------------------------- TRIGGERS ----------------------------

 -- Trigger for auto updating total_items in Carts table when ProductsInCarts table is changed
CREATE OR ALTER TRIGGER productInCartTrigger
ON ProductsInCarts
AFTER INSERT, DELETE, UPDATE
AS BEGIN

    UPDATE Carts
    SET total_items = ISNULL(T.total_quantity, 0)
    FROM Carts C
    LEFT JOIN (
        SELECT cart_id, SUM(quantity) AS total_quantity
        FROM ProductsInCarts
        GROUP BY cart_id
    ) T
    ON C.id = T.cart_id
    -- only update the carts that are affected by the trigger
    WHERE C.id IN (SELECT DISTINCT cart_id FROM INSERTED UNION 
                   SELECT DISTINCT cart_id FROM DELETED);
END;
GO


-- Trigger for auto updating rating_count and avg_rating in Products table when Reviews table is changed
CREATE OR ALTER TRIGGER reviewTrigger
ON Reviews
AFTER INSERT, DELETE, UPDATE
AS BEGIN

    UPDATE Products
    SET rating_count = ISNULL(T.total_rating, 0),
        avg_rating = ISNULL(T.avg_rating, 0.0)
    FROM Products P
    LEFT JOIN (
        SELECT product_id, COUNT(*) AS total_rating, AVG(CAST(rating AS FLOAT)) AS avg_rating
        FROM Reviews
        GROUP BY product_id
    ) T
    ON P.id = T.product_id
    -- only update the products that are affected by the trigger
    WHERE P.id IN (SELECT DISTINCT product_id FROM INSERTED UNION 
                   SELECT DISTINCT product_id FROM DELETED);
END;
GO



-- Trigger for auto updating total_price in Boxes table when ProductsInBoxes table is changed
-- (not apply store and shipping discount)
CREATE OR ALTER TRIGGER productInBoxesTrigger
ON ProductsInBoxes
AFTER INSERT, DELETE, UPDATE
AS BEGIN

    UPDATE Boxes
    SET total_price = ISNULL(T.total_price, 0)
    FROM Boxes B
    LEFT JOIN (
        SELECT box_id, SUM(pay_price) AS total_price
        FROM ProductsInBoxes
        GROUP BY box_id
    ) T
    ON B.id = T.box_id
    -- only update the boxes that are affected by the trigger
    WHERE B.id IN (SELECT DISTINCT box_id FROM INSERTED UNION 
                   SELECT DISTINCT box_id FROM DELETED);
END;
GO

-- Trigger for auto updating total_price in Orders table when Boxes table is changed
-- (not apply system discount)
CREATE OR ALTER TRIGGER boxesTrigger
ON Boxes
AFTER INSERT, DELETE, UPDATE
AS BEGIN

    UPDATE Orders
    SET total_price = ISNULL(T.total_price, 0)
    FROM Orders O
    LEFT JOIN (
        SELECT order_id, SUM(total_price) AS total_price
        FROM Boxes
        GROUP BY order_id
    ) T
    ON O.id = T.order_id
    -- only update the orders that are affected by the trigger
    WHERE O.id IN (SELECT DISTINCT order_id FROM INSERTED UNION 
                   SELECT DISTINCT order_id FROM DELETED);

END;
GO



















SELECT * FROM Orders;

SELECT * FROM Boxes
WHERE order_id = 1;


-- show all FK constraints
SELECT 
    f.name AS FK_Name,
    OBJECT_NAME(f.parent_object_id) AS Table_Name,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS Column_Name,
    OBJECT_NAME (f.referenced_object_id) AS Referenced_Table_Name,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS Referenced_Column_Name
FROM
    sys.foreign_keys AS f
    INNER JOIN sys.foreign_key_columns AS fc
    ON f.object_id = fc.constraint_object_id
ORDER BY
    FK_Name;
