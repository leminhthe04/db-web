CREATE TYPE storeBoxesType AS TABLE (
    store_id INT,
    box_id INT,
    total_revenue DECIMAL(10, 2),
    packing_date DATE
);
GO

CREATE TYPE storeRevenuesType AS TABLE (
    store_id INT,
    store_name NVARCHAR(50),
    num_box INT,
    revenue DECIMAL(10, 2)
);
GO


-- main procedure to print statistic for a given seller
CREATE OR ALTER PROCEDURE getSellerStatistic 
    @seller_id INT,
    -- default start date and end date if not provided, show statistic all time
    @start_date DATE = '2000-01-01',
    @end_date DATE = '2030-12-31'
AS BEGIN

    -- validate input
    IF NOT EXISTS (SELECT * FROM SellerInfos WHERE id = @seller_id)
    BEGIN
        RAISERROR('Seller ID %d does not exist', 16, 1, @seller_id);
        RETURN;
    END;

    DECLARE @seller_name NVARCHAR(50);
    DECLARE @seller_phone NVARCHAR(50);
    DECLARE @seller_email NVARCHAR(50);

    SELECT @seller_name = CONCAT(S.fname, ' ', S.lname), 
           @seller_phone = S.phone, 
           @seller_email = S.email
    FROM SellerInfos S    -- this is a view, join from Users and Sellers, please see views.sql
    WHERE id = @seller_id
    
    
    -- initialize some variables
    DECLARE @total_revenue DECIMAL(10, 2) = 0;
    DECLARE @total_order INT = 0;

    -- get all stores id of this seller
    DECLARE @storesOfThisSeller TABLE (
        store_id INT
    );
    INSERT INTO @storesOfThisSeller
        SELECT S.id
        FROM Stores S
        WHERE S.seller_id = @seller_id;


    -- get only stores (and their boxes information) 
    -- have boxes created in the given time interval of this seller
    DECLARE @storeHasBoxes storeBoxesType; -- this type is defined at the top of this file
    INSERT INTO @storeHasBoxes
        SELECT DISTINCT P.store_id, B.id AS box_id, B.total_price, B.packing_date
              FROM ProductsInBoxes PIB, Products P, Boxes B
              WHERE P.seller_id = @seller_id -- filter product by seller first for better performance
                AND PIB.product_id = P.id 
                AND PIB.box_id = B.id
                AND B.packing_date BETWEEN @start_date AND @end_date; -- filter box by given interval time

    -- outer join from @storesOfThisSeller and @storeHasBoxes to get all stores of this seller. 
    -- stores not having boxes will have NULL values for box_id, total_revenue, packing_date 
    DECLARE @allStores storeBoxesType;
    INSERT INTO @allStores
        SELECT S.store_id, SHB.box_id, SHB.total_revenue, SHB.packing_date
        FROM @storesOfThisSeller S
        LEFT JOIN @storeHasBoxes SHB ON S.store_id = SHB.store_id;

    -- SELECT * FROM @allStores;

    -- since have all boxes of all stores of this seller,
    -- now compute the statistic for each store
    SET ANSI_WARNINGS OFF; -- the warning is just using aggregate function with NULL values
    -- it makes the output ugly, so turn it off temporarily for this query
    DECLARE @storeRevenues storeRevenuesType; -- this type is defined at the top of this file
    INSERT INTO @storeRevenues
        SELECT Ss.store_id, S.name, 
               ISNULL(COUNT(Ss.box_id), 0), ISNULL(SUM(Ss.total_revenue), 0)
        FROM @allStores Ss, Stores S
        WHERE Ss.store_id = S.id
        GROUP BY Ss.store_id, S.name;
    SET ANSI_WARNINGS ON;


    -- in case this seller has not sold any product yet :<
    -- all found tables above are empty -> SUM will return NULL
    SELECT @total_order = ISNULL(SUM(num_box), 0),
           @total_revenue = ISNULL(SUM(revenue), 0)
    FROM @storeRevenues;


    SELECT S.store_id, S.store_name, S.num_box AS count_order, S.revenue,
           A.box_id AS order_id, A.total_revenue AS order_revenue, A.packing_date
    FROM @storeRevenues S, @allStores A
    WHERE S.store_id = A.store_id
    ORDER BY S.store_id, A.packing_date;

END;
GO



EXECUTE getSellerStatistic 5, '2024-01-01', '2025-12-31';