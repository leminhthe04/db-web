<?php

require_once __DIR__ . '/../database/database.php';
require_once __DIR__ . '/../lib/utils.php';


class Seller {

    private $conn;

    public function __construct() {
        $this->conn = Database::connect(); // get connection from database.php
    }


    public function getAll($offset, $limit) {
        $stmt = $this->conn->prepare("EXEC findAll 'SellerInfos', :offset, :limit");
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;
    }

    public function getById($id) {
        $stmt = $this->conn->prepare("EXEC findById 'SellerInfos', :id");
        $stmt->bindValue(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;
    }




}

?>