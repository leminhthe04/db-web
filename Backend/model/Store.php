<?php

require_once __DIR__ . '/../database/database.php';
require_once __DIR__ . '/../lib/utils.php';

class Store {

    private $conn;

    public function __construct() {
        $this->conn = Database::connect(); // get connection from database.php
    }


    public function getBySellerId($seller_id) {
        try{
            $stmt = $this->conn->prepare("EXEC getBySellerId :seller_id");
            $stmt->bindValue(':seller_id', $seller_id, PDO::PARAM_INT);
            $stmt->execute();
            $arr = fetch($stmt);
            $stmt->closeCursor();
            return $arr;
        } catch (PDOException $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }        
    }

    public function getBySellerIdStoreId($seller_id, $store_id) {
        try{
            $stmt = $this->conn->prepare("EXEC getBySellerIdStoreId :seller_id, :store_id");
            $stmt->bindValue(':seller_id', $seller_id, PDO::PARAM_INT);
            $stmt->bindValue(':store_id', $store_id, PDO::PARAM_INT);
            $stmt->execute();
            $result = fetch($stmt);
            $stmt->closeCursor();
            return $result;
        } catch (PDOException $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }
}

?>