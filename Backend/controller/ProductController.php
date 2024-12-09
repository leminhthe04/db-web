<?php

require_once __DIR__ . '/../model/Product.php';
require_once __DIR__ . '/../model/Category.php';

class ProductController {

    private function statusIsValidValue($status) {
        return $status == null  ||
               in_array($status, ['Available', 'Stop Selling', 'Sold Out']);
    }
    private function nameIsValidFormat($name) {
        return strlen($name) >= 5 && strlen($name) <= 50;
    }
    private function priceIsValidValue($price) {
        return is_numeric($price) && $price >= 0;
    }
    // private function categoryIdIsValidValue($category_id) {
    //     if (!$category_id) return true;
    //     $category = new Category();
    //     $res = $category->getById($category_id);
    //     return $res ? true : false;
    // }
    private function quantityIsValidValue($quantity) {
        return is_int($quantity) && $quantity >= 0;
    }

    private function fieldAreValid($name, $price, $quantity, $status) {
        if (!$this->nameIsValidFormat($name))
            return ["message" => "Name must be between 5 and 50 characters"];
        if (!$this->priceIsValidValue($price))
            return ["message" => "Price must be a positive number"];
        if (!$this->quantityIsValidValue($quantity))
            return ["message" => "Quantity must be a non-negative integer"];
        if (!$this->statusIsValidValue($status))
            return ["message" => "Status must be 'Available', 'Stop Selling' or 'Sold Out'"];
        return ["message" => "Valid"];
    }

    public function get($offset, $limit) {
        $offset = $offset ?? 0;
        $limit = $limit ?? 9999999;
        $product = new Product();
        $res = $product->getBraking($offset, $limit); // a fetch array or null
        if ($res){
            return getResponseArray(200, "Found products", $res);
        }
        
        return getResponseArray(200, "There is no product in system now", []);
    }

    public function getById($id) {
        $product = new Product();
        $res = $product->getById($id);

        if ($res) {
            return getResponseArray(200, "Product found", $res);
        }
        return getResponseArray(404, "Product not found", null);
    }

    // public function getAllAvailable() {
    //     $product = new Product();
    //     $res = $product->getAllAvailable();
    //     if ($res) {
    //         return getResponseArray(200, "Found available products", $res);
    //     }
    //     return getResponseArray(200, "There is no available product now", []);
    // }

    // public function getAllStopSelling() {
    //     $product = new Product();
    //     $res = $product->getAllStopSelling();
    //     if ($res) {
    //         return getResponseArray(200, "Found stop selling products", $res);
    //     }
    //     return getResponseArray(200, "There is no stop selling product now", []);
    // }

    // public function getAllSoldOut() {
    //     $product = new Product();
    //     $res = $product->getAllSoldOut();
    //     if ($res) {
    //         return getResponseArray(200, "Found sold out products", $res);
    //     }
    //     return getResponseArray(200, "There is no sold out product now", []);
    // }

    public function getAllByCategory($category_id, $offset, $limit) {
        $product = new Product();
        $res = $product->getAllBranchByCategoryId($category_id, $offset, $limit);
        if ($res) {
            return getResponseArray(200, "Found products in category branch", $res);
        }
        return getResponseArray(200, "There is no product in this category branch now", []);
    }


    public function insertProduct($seller_id, $store_id, $name, $brand, 
                            $price, $description, $quantity, $category_id, $status) {
        
        // check some field are valid in private functions, if not return error message for the first invalid field
        $validMessage = $this->fieldAreValid($name, $price, $quantity, $status)['message'];
        if ($validMessage !== "Valid") {
            return getResponseArray(400, $validMessage, null);
        }
        
        if (!$status) {
            $status = $quantity == 0 ? "Sold Out" : "Available";
        }

        if ($status === "Sold Out"  &&  $quantity > 0) {
            return getResponseArray(400, "Quantity and status 'Sold Out' are unreasonable", null);
        }

        if ($status === "Available" && $quantity == 0) {
            return getResponseArray(400, "Quantity and status 'Available' are unreasonable", null);
        }

        $product = new Product();
        $respone = $product->insertProduct($seller_id, $store_id, $name, $brand, 
                            $price, $description, $quantity, $category_id, $status);

        // $product_id = $respone['data']['id'];
        return $respone;
    }

    public function updateProductName($id, $name) {
        if (!$this->nameIsValidFormat($name)) {
            return getResponseArray(400, "Name must be between 5 and 50 characters", null);
        }

        $product = new Product();
        return $product->updateName($id, $name);
    }

    public function updateProductPrice($id, $price) {
        if (!$this->priceIsValidValue($price)) {
            return getResponseArray(400, "Price must be a positive number", null);
        }

        $product = new Product();
        return $product->updatePrice($id, $price);
    }

    public function updateProductQuantity($id, $quantity) {
        if (!$this->quantityIsValidValue($quantity)) {
            return getResponseArray(400, "Quantity must be a non-negative integer", null);
        }

        $product = new Product();

        $currentProductStatus = $product->getById($id)[0]['status'];
        if($quantity == 0 && $currentProductStatus == 'Available') {
            $product->updateStatus($id, 'Sold Out');
        } else if ($quantity > 0 && $currentProductStatus == 'Sold Out') {
            $product->updateStatus($id, 'Available');
        }
        return $product->updateQuantity($id, $quantity);
    }

    public function updateProductDescription($id, $description) {
        $product = new Product();
        return $product->updateDescription($id, $description);
    }

    public function updateProductBrand($id, $brand) {
        $product = new Product();
        return $product->updateBrand($id, $brand);
    }

    public function updateProductStatus($id, $status) {
        if (!$this->statusIsValidValue($status)) {
            return getResponseArray(400, "Status must be 'Available', 'Stop Selling' or 'Sold Out'", null);
        }
        
        $product = new Product();

        $currentProductQuantity = $product->getById($id)[0]['quantity'];

        if ($status == 'Sold Out' && $currentProductQuantity > 0) {
            return getResponseArray(400, "Current quantity of this product is greater than 0, cannot set status to 'Sold Out'", null);
        } else if($status == 'Available' && $currentProductQuantity == 0) {
            return getResponseArray(400, "Current quantity of this product is 0, cannot set status to 'Available'", null);
        }

        return $product->updateStatus($id, $status);
    }


    public function updateProductCategory($id, $category_id) {
        // if (!$this->categoryIdIsValidValue($category_id)) {
        //     return getResponseArray(400, "Category not exist", null);
        // }

        $product = new Product();
        return $product->updateCategoryId($id, $category_id);
    }


    public function deleteProduct($id) {
        $product = new Product();
        return $product->deleteById($id);
    }

    // public function deleteAllProducts() {
    //     $product = new Product();
    //     return $product->deleteAll();
    // }

    // public function searchProducts($key){

    //     $tokens = array_filter(explode(' ', trim($key)));

    //     $product = new Product();

    //     $res = [];
    //     foreach ($tokens as $_ => $token) {
    //         $thisTokenProducts = $product->searchProductByToken($token);
    //         $existedProductIds = array_column($res, 'id');
    //         foreach ($thisTokenProducts as $p) {
    //             if (!in_array($p['id'], $existedProductIds)) {
    //                 $res[]  = $p;
    //             }
    //         }
    //     }

    //     if ($res){
    //         return getResponseArray(200, "Found products", $res);
    //     }
    //     return getResponseArray(200, "There is no product match your search", []);
    // }

}

?>