-- create some common views for the database

USE SpClone;
GO

CREATE OR ALTER VIEW BuyerInfos AS
    SELECT U.id, U.citizen_id, U.fname, U.lname, U.sex, U.dob, U.phone, U.email, B.cart_id
    FROM Users U, Buyers B
    WHERE U.id = B.id;
GO

CREATE OR ALTER VIEW SellerInfos AS
    SELECT U.id, U.citizen_id, U.fname, U.lname, U.sex, U.dob, U.phone, U.email, S.tax_id
    FROM Users U, Sellers S
    WHERE U.id = S.id;
GO

CREATE OR ALTER VIEW StoreDiscountInfos AS
    SELECT D.id, D.code, D.quantity, D.release_date, D.start_date, D.expiration_date, SD.amount, SD.seller_id, SD.store_id
    FROM Discounts D, StoreDiscounts SD
    WHERE D.id = SD.id;
GO

CREATE OR ALTER VIEW SystemDiscountInfos AS
    SELECT D.id, D.code, D.quantity, D.release_date, D.start_date, D.expiration_date, SD.max_amount, SD.percentage, SD.min_bill_amt
    FROM Discounts D, SystemDiscounts SD
    WHERE D.id = SD.id;
GO

CREATE OR ALTER VIEW ShippingDiscountInfos AS
    SELECT D.id, D.code, D.quantity, D.release_date, D.start_date, D.expiration_date, SD.max_amount
    FROM Discounts D, ShippingDiscounts SD
    WHERE D.id = SD.id;
GO


CREATE OR ALTER VIEW ProductInfos AS
    SELECT P.id AS product_id, P.name AS product_name, P.price, P.quantity, P.category_id, C.name AS category_name,
           P.seller_id, CONCAT(SI.fname, ' ', SI.lname) AS seller_name, P.buying_count, P.avg_rating,
           P.store_id, S.name AS store_name, P.status, P.brand
    FROM Products P, Stores S, SellerInfos SI, Categories C
    WHERE P.store_id = S.id AND P.seller_id = SI.id AND P.category_id = C.id;
GO
