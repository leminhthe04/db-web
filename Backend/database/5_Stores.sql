USE SpClone;
GO

CREATE OR ALTER PROCEDURE getBySellerId
    @seller_id INT,
    @offset INT = 0,
    @limit INT = 9999
AS BEGIN

    DECLARE @isExistSeller BIT;
    EXEC checkExist 'sellers', 'id', @seller_id, @isExistSeller OUTPUT;

    IF @isExistSeller = 0 BEGIN
        RAISERROR('Seller does not exist!', 16, 1);
        RETURN;
    END

    SELECT * FROM stores 
    WHERE seller_id = @seller_id 
    ORDER BY id 
    OFFSET @offset ROWS
    FETCH NEXT @limit ROWS ONLY;

END;
GO

CREATE OR ALTER PROCEDURE getBySellerIdStoreId
    @seller_id INT,
    @store_id INT
AS BEGIN

    DECLARE @isExistSeller BIT;
    EXEC checkExist 'sellers', 'id', @seller_id, @isExistSeller OUTPUT;

    IF @isExistSeller = 0 BEGIN
        RAISERROR('Seller does not exist!', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM stores WHERE seller_id = @seller_id AND id = @store_id) BEGIN
        RAISERROR('Store does not exist!', 16, 1);
        RETURN;
    END

    SELECT * FROM stores WHERE seller_id = @seller_id AND id = @store_id;

END;
GO



-- CREATE OR ALTER PROCEDURE getStoreStatistic
--     @seller_id INT,
--     @store_id INT,
--     @from_date DATE = '1000-01-01',
--     @to_date DATE = '3000-01-01'
-- AS BEGIN
--     DECLARE @isExistSeller BIT;
--     EXEC checkExist 'sellers', 'id', @seller_id, @isExistSeller OUTPUT;

--     IF @isExistSeller = 0 BEGIN
--         RAISERROR('Seller does not exist!', 16, 1);
--         RETURN;
--     END;

--     IF NOT EXISTS (SELECT * FROM stores WHERE seller_id = @seller_id AND id = @store_id) BEGIN
--         RAISERROR('Store does not exist!', 16, 1);
--         RETURN;
--     END;

    
--     WITH storeBoxes AS (

--         SELECT DISTINCT B.id AS box_id, B.total_price, B.packing_date
--               FROM ProductsInBoxes PIB, Products P, Boxes B
--               WHERE P.seller_id = @seller_id -- filter product by seller first for better performance
--                 AND P.store_id = @store_id
--                 AND PIB.product_id = P.id 
--                 AND PIB.box_id = B.id
--                 AND B.packing_date BETWEEN @from_date AND @to_date
--     )
--     SELECT box_id, SUM(total_price) AS total_revenue, packing_date
--     FROM storeBoxes
--     GROUP BY box_id, packing_date;

-- END;


-- EXEC getStoreStatistic 3, 5;


-- SELECT * FROM boxes;