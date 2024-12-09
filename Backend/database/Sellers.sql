CREATE OR ALTER FUNCTION getStoreStatistic (
    @fromDate DATE = '1900-01-01',
    @toDate DATE = '3000-12-31'
) RETURN
GO


CREATE OR ALTER PROCEDURE getStatistic
    @fromDate DATE = '1900-01-01',
    @toDate DATE = '3000-12-31'
AS BEGIN
    
    SELECT SI.id, CONCAT(SI.fname, ' ', SI.lname) AS seller_name, SUM(S.)
    FROM SellerInfos SI, Stores S

END;
GO




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


CREATE OR ALTER PROCEDURE printBoxesStatistic
    @boxesOfAStore storeBoxesType READONLY
AS BEGIN
    -- disable count affected rows on terminal. ex: (1 row affected), (2 rows affected),...
    SET NOCOUNT ON;

    DECLARE @tab CHAR(1) = CHAR(9);
    DECLARE @endl CHAR(1) = CHAR(13);

    -- use cursor to get boxes one by one to print out statistic
    DECLARE boxCursor CURSOR FOR
        SELECT B.box_id, B.total_revenue, B.packing_date
        FROM @boxesOfAStore B;
    OPEN boxCursor;

    DECLARE @v_box_id INT;
    DECLARE @v_total_price DECIMAL(10, 2);
    DECLARE @v_packing_date DATE;
    FETCH NEXT FROM boxCursor 
        INTO @v_box_id, @v_total_price, @v_packing_date;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @tab + @tab +
                'Order ID: ' + CAST(@v_box_id AS NVARCHAR(50)) + @tab +
                'Revenue: ' + CAST(@v_total_price AS NVARCHAR(50)) + @tab + @tab +
                'Packing Date: ' + CAST(@v_packing_date AS NVARCHAR(50));

        FETCH NEXT FROM boxCursor
            INTO @v_box_id, @v_total_price, @v_packing_date;
    END;
    PRINT @endl;

    CLOSE boxCursor;
    DEALLOCATE boxCursor;

    -- re-enable count affected rows on terminal
    SET NOCOUNT OFF;
END;
GO


CREATE OR ALTER PROCEDURE printStoresStatistic
    @storeRevenues storeRevenuesType READONLY,
    @allStores storeBoxesType READONLY
AS BEGIN
    SET NOCOUNT ON;

    DECLARE @tab CHAR(1) = CHAR(9);
    DECLARE @endl CHAR(1) = CHAR(13);

    -- use cursor for getting stores one by one to print out statistic 
    DECLARE storeCursor CURSOR FOR
        SELECT store_id, store_name, num_box, revenue
        FROM @storeRevenues;
    OPEN storeCursor;
    
    DECLARE @v_store_id INT;
    DECLARE @v_store_name NVARCHAR(50);
    DECLARE @v_store_num_box INT;
    DECLARE @v_store_revenue DECIMAL(10, 2);
    FETCH NEXT FROM storeCursor 
        INTO @v_store_id, @v_store_name, @v_store_num_box, @v_store_revenue;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @tab + 
              'Store ID: ' + CAST(@v_store_id AS NVARCHAR(50)) + @tab + 
              'Name: ' + @v_store_name + @tab + @tab +
              'Total Revenue: ' + CAST(@v_store_revenue AS NVARCHAR(50)) + @tab + @tab +
              'Total Order: ' + CAST(@v_store_num_box AS NVARCHAR(50));

        -- if store has box, print out the statistic of this store
        -- else pass printing boxes statistic for this one
        IF @v_store_num_box != 0 BEGIN
            -- filter boxes of the current store from many boxes of many stores in @allStores
            DECLARE @boxesOfThisStore storeBoxesType;
            DELETE @boxesOfThisStore;
            INSERT INTO @boxesOfThisStore
                SELECT *
                FROM @allStores S
                WHERE S.store_id = @v_store_id;

            -- pass the boxes filtered above to another procedure to print out
            EXECUTE printBoxesStatistic @boxesOfThisStore;
        END ELSE BEGIN 
            PRINT @endl
        END;

        FETCH NEXT FROM storeCursor 
            INTO @v_store_id, @v_store_name, @v_store_num_box, @v_store_revenue;
    END;

    CLOSE storeCursor;
    DEALLOCATE storeCursor;

    SET NOCOUNT OFF;
END;
GO



    -- validate input
IF NOT EXISTS (SELECT * FROM SellerInfos WHERE id = @seller_id)
BEGIN
    RAISERROR('Seller ID %d does not exist', 16, 1, @seller_id);
    RETURN;
END;
GO


-- main procedure to print statistic for a given seller
CREATE OR ALTER FUNCTION getSellerStatistic (
    @seller_id INT,
    -- default start date and end date if not provided, show statistic all time
    @start_date DATE = '2000-01-01',
    @end_date DATE = '2030-12-31'
) RETURNS @result TABLE (
    seller_id INT,
    seller_name NVARCHAR(50),
    seller_phone NVARCHAR(50),
    seller_email NVARCHAR(50),
    total_revenue DECIMAL(10, 2),
    total_order INT
) AS BEGIN


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
    -- DECLARE @storesOfThisSeller TABLE (
    --     store_id INT
    -- );
    -- INSERT INTO @storesOfThisSeller
    --     SELECT S.id
    --     FROM Stores S
    --     WHERE S.seller_id = @seller_id;


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
    -- DECLARE @allStores storeBoxesType;
    -- INSERT INTO @allStores
    --     SELECT S.store_id, SHB.box_id, SHB.total_revenue, SHB.packing_date
    --     FROM @storesOfThisSeller S
    --     LEFT JOIN @storeHasBoxes SHB ON S.store_id = SHB.store_id;

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


    PRINT  @endl + @endl + @endl + 
          'STATISTIC FOR SELLER ID=' + CAST(@seller_id AS NVARCHAR(50)) + 
          ' FROM ' + CAST(@start_date AS NVARCHAR(10)) + 
          ' TO '   + CAST(@end_date AS NVARCHAR(10)) + @endl + @endl +
          'Seller Name: ' + @seller_name + @tab + 
          'Phone: ' + @seller_phone + @tab + 
          'Email: ' + @seller_email + @endl + 
          'Total Revenue: ' + CAST(@total_revenue AS NVARCHAR(50)) + @tab + @tab +
          'Total Order: ' + CAST(@total_order AS NVARCHAR(50)) + @endl;

    -- split printing store statistics to another procedure
    EXECUTE printStoresStatistic @storeRevenues, @allStores;

    PRINT @endl + @endl + @endl;

    SET NOCOUNT OFF;
END;
GO

