<?php

require_once __DIR__ . '/../database/database.php';
require_once __DIR__ . '/../lib/utils.php';


class Seller {

    private $conn;

    public function __construct() {
        $this->conn = Database::connect(); // get connection from database.php
    }


    public function get($offset, $limit) {
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

    public function getStatisticById($id, $from_date, $to_date) {
        try {
            $stmt = $this->conn->prepare("EXEC getSellerStatistic :id, :from_date, :to_date");
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            $stmt->bindValue(':from_date', $from_date, PDO::PARAM_STR);
            $stmt->bindValue(':to_date', $to_date, PDO::PARAM_STR);
            $stmt->execute();
            $arr = fetch($stmt);
            
            echo json_encode($arr);
            
            $stmt->closeCursor();
            return $arr;
        } catch (PDOException $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }
}

?>