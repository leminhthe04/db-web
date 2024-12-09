-- user-defined error code:

-- 45200: general successful operation
-- 45201: successful created
-- 45202: successful updated
-- 45204: successful deleted

-- 45400: invalid value for a given argument (wrong data type, wrong format, etc.)
-- 45401: duplicate unique value
-- 45404: not found



-- POST
-- DROP PROCEDURE IF EXISTS insertCategory;
-- DELIMITER // CREATE PROCEDURE insertCategory (
--     IN _name VARCHAR(50)
-- ) BEGIN

--     CALL checkUniqueValue('categories', 'name', _name, @isUniqueName);
--     IF NOT @isUniqueName THEN
--         SIGNAL SQLSTATE '45401' 
--                SET MESSAGE_TEXT = 'This category has been created before!';
--     END IF;


--     INSERT INTO categories(name) VALUES (_name);

--     SELECT LAST_INSERT_ID() AS id;
-- END // DELIMITER ;



-- PUT
-- DROP PROCEDURE IF EXISTS updateCategoryName;
-- DELIMITER // CREATE PROCEDURE updateCategoryName (IN _id INT, IN _name VARCHAR(50))
-- BEGIN 
--     CALL checkUniqueValueForUpdate('categories', 'name', _name, _id, @isUniqueName);
--     IF NOT @isUniqueName THEN
--         SIGNAL SQLSTATE '45401' 
--                SET MESSAGE_TEXT = 'This category has been created before!';
--     END IF;

--     CALL updateFieldById('categories', _id, 'name', _name); 
-- END // DELIMITER ;







-- CALL insertCategory('Fruits');

-- CALL insertCategory('Vegetables');

-- CALL insertCategory('Meat');

-- CALL insertCategory('Fish');

-- CALL insertCategory('Seafood');

-- CALL findAll('categories');

-- CALL updateCategoryName(1, 'Mangoes');

-- CALL deleteById('categories', 2);

-- CALL deleteAll('categories');