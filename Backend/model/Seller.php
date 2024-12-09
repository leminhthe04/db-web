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
        try{
            $stmt = $this->conn->prepare("EXEC findById 'SellerInfos', :id");
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $arr = fetch($stmt);
            $stmt->closeCursor();
            return $arr;
        } catch (PDOException $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function getStatisticById($id, $from_date, $to_date) {
        $seller_name = "";
        $seller_phone = "";
        $seller_email = "";
        $seller_revenue = 0;
        $count_order = 0;

        try {                                  
            $stmt = $this->conn->prepare("EXEC getSellerStatistic :id, :from_date, :to_date,
                    :seller_name, :seller_phone, :seller_email, :count_order, :seller_revenue");
            $stmt->bindValue(':id', $id, PDO::PARAM_INT);
            $stmt->bindValue(':from_date', $from_date, PDO::PARAM_STR);
            $stmt->bindValue(':to_date', $to_date, PDO::PARAM_STR);

            $stmt->bindParam(':seller_name', $seller_name, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 50);
            $stmt->bindParam(':seller_phone', $seller_phone, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 50);
            $stmt->bindParam(':seller_email', $seller_email, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 50);
            $stmt->bindParam(':seller_revenue', $seller_revenue, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 50);
            $stmt->bindParam(':count_order', $count_order, PDO::PARAM_STR | PDO::PARAM_INPUT_OUTPUT, 50);
            $stmt->execute();
            $arr = fetch($stmt);
            $stmt->closeCursor();

            $result = array(
                "seller_name" => $seller_name,
                "seller_phone" => $seller_phone,
                "seller_email" => $seller_email,
                "seller_revenue" => $seller_revenue,
                "count_order" => $count_order,
                "orders" => $arr
            );
            return $result;
        } catch (PDOException $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }
}

?>