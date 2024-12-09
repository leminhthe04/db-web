EXEC findAll 'Products';
GO


CREATE OR ALTER PROCEDURE findProductBreaking
    @offset INT, @limit INT
AS BEGIN
    SELECT * FROM ProductInfos PI 
    ORDER BY PI.seller_id, PI.store_id, PI.product_id
    OFFSET @offset ROWS
    FETCH NEXT @limit ROWS ONLY;
END;
GO


CREATE OR ALTER PROCEDURE getProductsWithCategoryBranch
    @category_id INT,
    @offset INT = 0,
    @limit INT = 9999999
AS BEGIN

    WITH getListCategory AS (
        SELECT 
            C.id AS category_id,
            C.name AS category_name
            -- CAST(C.name AS NVARCHAR(MAX)) AS category_path
        FROM Categories C
        WHERE C.id = @category_id

        UNION ALL

        SELECT 
            C.id AS category_id, C.name AS category_name
            -- CAST(LC.category_path + ' > ' + 
            --      C.name AS NVARCHAR(MAX)) AS category_path
        FROM Categories C
        INNER JOIN getListCategory LC 
        ON C.larger_cate_id = LC.category_id
    )

    SELECT PI.product_id, PI.product_name, PI.price, PI.quantity, PI.category_id, PI.category_name,
           PI.seller_id, PI.seller_name, PI.buying_count, PI.avg_rating,
           PI.store_id, PI.store_name, PI.status, PI.brand
    FROM ProductInfos PI
    INNER JOIN getListCategory LC
    ON PI.category_id = LC.category_id
    ORDER BY PI.category_id, PI.seller_id, PI.store_id, PI.product_id
    OFFSET @offset ROWS
    FETCH NEXT @limit ROWS ONLY;

END;
GO


EXEC showColumns 'ProductInfos';
GO

EXEC getProductsWithCategoryBranch 1;
GO

-- EXEC findProuctBreaking 10, 10;
-- GO

-- SELECT * FROM Products;
-- GO

-- Thủ tục insertProduct
CREATE OR ALTER PROCEDURE insertProduct 
    @seller_id INT,
    @store_id INT,
    @name NVARCHAR(50),
    @brand NVARCHAR(50),
    @price DECIMAL(10, 2),
    @description TEXT,
    @quantity INT,
    @category_id INT,
    @status NVARCHAR(20),
    @id  INT OUTPUT
AS
BEGIN
    
    IF EXISTS (SELECT 1 FROM Products WHERE name = @name AND seller_id = @seller_id AND store_id = @store_id) BEGIN
        RAISERROR('This Store already has this product name!', 16, 1);
        RETURN;
    END

    IF @category_id IS NOT NULL BEGIN
        DECLARE @isExistCategory BIT;
        EXEC checkExist 'categories', 'id', @category_id, @isExistCategory OUTPUT;
        IF @isExistCategory = 0 BEGIN
            RAISERROR('Category not found', 16, 1);
            RETURN;
        END
    END
    
    INSERT INTO Products (seller_id, store_id, name, brand, price, description, quantity, category_id, status)
    VALUES (@seller_id, @store_id, @name, @brand, @price, @description, @quantity, @category_id, @status);

    SET @id = SCOPE_IDENTITY();
END;
GO


DECLARE @id INT = 0;
EXEC insertProduct 2, 3, 'Product 2331', 'Brand 1', 1000, 'Description 1', 10, 1, 'Available', @id OUTPUT;
SELECT @id;
GO


-- Thủ tục updateProductName
CREATE OR ALTER PROCEDURE updateProductName
    @id INT, @name NVARCHAR(50)
AS
BEGIN

    DECLARE @isExist BIT;
    EXEC checkExist 'products', 'id', @id, @isExist OUTPUT;
    IF @isExist = 0 BEGIN
        RAISERROR('Product not found', 16, 1);
        RETURN;
    END

    DECLARE @seller_id INT, @store_id INT;
    SELECT @seller_id = seller_id, @store_id = store_id FROM Products WHERE id = @id;

    IF EXISTS (SELECT 1 FROM Products 
               WHERE name = @name 
                 AND seller_id = @seller_id 
                 AND store_id = @store_id
                 AND id != @id) BEGIN
        RAISERROR('This Store already has this product name!', 16, 1);
        RETURN;
    END

    EXEC updateFieldById 'products', @id, 'name', @name; 
END;
GO

-- SELECT * FROM ProductInfos;
-- GO

-- EXEC updateProductName 1, 'New Product Name';

-- Thủ tục updateProductPrice
CREATE OR ALTER PROCEDURE updateProductPrice
    @id INT, @price DECIMAL(10, 2)
AS BEGIN EXEC updateFieldById 'products', @id, 'price', @price; END;
GO

-- Thủ tục updateProductDescription
CREATE OR ALTER PROCEDURE updateProductDescription
    @id INT, @description TEXT
AS BEGIN EXEC updateFieldById 'products', @id, 'description', @description; END;
GO

-- Thủ tục updateProductDescription
CREATE OR ALTER PROCEDURE updateProductBrand
    @id INT, @brand NVARCHAR(50)
AS BEGIN EXEC updateFieldById 'products', @id, 'brand', @brand; END;
GO

-- Thủ tục updateProductQuantity
CREATE OR ALTER PROCEDURE updateProductQuantity
    @id INT, @quantity INT
AS BEGIN EXEC updateFieldById 'products', @id, 'quantity', @quantity; END;
GO

-- Thủ tục updateProductCategoryId
CREATE OR ALTER PROCEDURE updateProductCategoryId
    @id INT, 
    @category_id INT
AS BEGIN
    IF @category_id IS NOT NULL BEGIN
        DECLARE @isExistCategory BIT; 
        EXEC checkExist 'categories', 'id', @category_id, @isExistCategory OUTPUT;
        IF @isExistCategory = 0 BEGIN
            RAISERROR('Category not found', 16, 1);
            RETURN;
        END
    END

    EXEC updateFieldById 'products', @id, 'category_id', @category_id;
END;
GO

-- Thủ tục updateProductStatus
CREATE OR ALTER PROCEDURE updateProductStatus
    @id INT, @status NVARCHAR(20)
AS BEGIN
    IF @status NOT IN ('Available', 'Stop Selling', 'Sold Out') BEGIN
        RAISERROR('Status must be "Available", "Stop Selling" or "Sold Out"', 16, 1); 
        RETURN;
    END
    EXEC updateFieldById 'products', @id, 'status', @status; 
END;
GO


SELECT * FROM ProductInfos;
GO




-- -- Thủ tục findByNameHasToken
-- CREATE OR ALTER PROCEDURE findByNameHasToken
--     @token VARCHAR(255)
-- AS
-- BEGIN
--     EXEC findByFieldHasToken 'products', 'name', @token; 
-- END;
-- GO


SELECT *
FROM products
ORDER BY seller_id, store_id, id;


SELECT *
FROM products
ORDER BY seller_id, store_id, id -- Cần có ORDER BY để sử dụng OFFSET-FETCH
OFFSET 10 ROWS              -- Bắt đầu từ bản ghi thứ 11 (OFFSET là số lượng bản ghi cần bỏ qua)
FETCH NEXT 10 ROWS ONLY;    -- Lấy 10 bản ghi tiếp theo