<?php

require_once __DIR__ . '/../database/database.php';
require_once __DIR__ . '/../lib/utils.php';

class Product {

    private $conn;

    public function __construct() {
        $this->conn = Database::connect(); // get connection from database.php
    }


    public function getBraking(@offset, @limit) {
        $stmt = $this->conn->prepare("EXEC findProductBreaking @offset = :offset, @limit = :limit");
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;        
    }

    public function getById($id) {
        $stmt = $this->conn->prepare("EXEC findById 'products', :id");
        $stmt->bindValue(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;
    }

    public function getAllBranchByCategoryId($category_id, $offset, $limit) {
        if ($offset == null) $offset = 0;
        if ($limit == null) $limit = 9999999;
        $stmt = $this->conn->prepare("EXEC getProductsWithCategoryBranch @category_id = :category_id, @offset = :offset, @limit = :limit");
        $stmt->bindValue(':category_id', $category_id, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;
    }


    // INSERT INTO products(name, price, description, quantity, category_id, status) VALUES
    //  (_name, _price, _description, _quantity, _category_id, _status);
    public function insertProduct($seller_id, $store_id, $name, $brand, 
                    $price, $description, $quantity, $category_id, $status) {

        try {
            $stmt = $this->conn->prepare("EXEC insertProduct ?, ?, ?, ?, ?, ?, ?, ?, ?");
            $stmt->execute([$seller_id, $store_id, $name, $brand,
                            $price, $description, $quantity, $category_id, $status]);

            $product_id = $stmt->fetch(PDO::FETCH_ASSOC)['id'];
            $stmt->closeCursor();
            return getResponseArray(201, "Product created", ["id" => $product_id]);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateName($id, $name) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductName ?, ?");
            $stmt->execute([$id, $name]);
            $stmt->closeCursor();
            return getResponseArray(200, "Name updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updatePrice($id, $price) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductPrice ?, ?");
            $stmt->execute([$id, $price]);
            $stmt->closeCursor();
            return getResponseArray(200, "Price updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }

    public function updateDescription($id, $description) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductDescription ?, ?");
            $stmt->execute([$id, $description]);
            $stmt->closeCursor();
            return getResponseArray(200, "Description updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateBrand($id, $brand) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductBrand ?, ?");
            $stmt->execute([$id, $brand]);
            $stmt->closeCursor();
            return getResponseArray(200, "Brand updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateQuantity($id, $quantity) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductQuantity ?, ?");
            $stmt->execute([$id, $quantity]);
            $stmt->closeCursor();
            return getResponseArray(200, "Quantity updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }    
    }

    public function updateCategoryId($id, $category_id) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductCategoryId ?, ?");
            $stmt->execute([$id, $category_id]);
            $stmt->closeCursor();
            return getResponseArray(200, "Category updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateStatus($id, $status) {
        try {
            $stmt = $this->conn->prepare("EXEC updateProductStatus ?, ?");
            $stmt->execute([$id, $status]);
            $stmt->closeCursor();
            return getResponseArray(200, "Status updated", null);
        } catch (PDOexception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function deleteById($id) {

        // Actually, we just soft delete the product by setting its status to 'Stop Selling'
        $updateStatusResponse = $this->updateStatus($id, 'Stop Selling');
        if ($updateStatusResponse['code'] != 200) {
            return $updateStatusResponse;
        }

        return getResponseArray(200, "Product soft deleted (by changing status to 'Stop Selling')", null);

        // try {
        //     $stmt = $this->conn->prepare("CALL deleteById('products', ?);");
        //     $stmt->bind_param("i", $id);
        //     $stmt->execute();
        //     $stmt->close();
        //     return getResponseArray(200, "Product deleted", null);
        // } catch (mysqli_sql_exception $e) {
        //     return getResponseArray(400, $e->getMessage(), null);
        // }
    }

    // public function deleteAll() {
    //     mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        
    //     // Actually, we just soft delete all products by setting their status to 'Stop Selling'
    //     try {
    //         $stmt = $this->conn->prepare("CALL updateValueForWholeColumn('products', 'status', 'Stop Selling')");
    //         $stmt->execute();
    //         $stmt->close();
    //         return getResponseArray(200, "All products soft deleted (by changing status to 'Stop Selling')", null);
    //     } catch (mysqli_sql_exception $e) {
    //         return getResponseArray(400, $e->getMessage(), null);
    //     }
        
        // mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        // try {
        //     $stmt = $this->conn->prepare("CALL deleteAll('products')");
        //     $stmt->execute();
        //     $stmt->close();
        //     return getResponseArray(200, "All products deleted", null);
        // } catch (mysqli_sql_exception $e) {
        //     return getResponseArray(400, $e->getMessage(), null);
        // }
    // }

    // public function searchProductByToken($token){
    //     mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
       
    //     try {
    //         $stmt = $this->conn->prepare("CALL findByNameHasToken(?);");
    //         $stmt->bind_param("s", $token);
    //         $stmt->execute();
    //         $table = $stmt->get_result();
    //         $arr = fetch($table);
    //         if ($table) $table->free();
    //         $stmt->close();
    //         return $arr;
    //     } catch (mysqli_sql_exception $e) {
    //         return getResponseArray(400, $e->getMessage(), null);
    //     }
    // }
}

?>