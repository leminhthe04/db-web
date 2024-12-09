<?php

require_once __DIR__ . '/../model/Seller.php';

class SellerController {

    public function get($offset, $limit) {
        $seller = new Seller();
        $res = $seller->get($offset, $limit); // a fetch array or null

        if (isset($res['code'])){
            return $res;
        }
        if ($res){ // if there is at least 1 seller
            return getResponseArray(200, "Found sellers", $res);
        }
        return getResponseArray(200, "There is no seller in system now", []);    
    }

    public function getById($id) {
        $seller = new Seller();
        $res = $seller->getById($id);

        if (isset($res['code'])){
            return $res;
        }    
            
        return getResponseArray(200, "Seller found", $res);
    }

    public function getStatisticById($id, $from_date, $to_date) {
        $seller = new Seller();
        $res = $seller->getStatisticById($id, $from_date, $to_date);

        if (isset($res['code'])){
            return $res;
        }

        $orders = $res['orders'];
        unset($res['orders']);

        $data = array();
        $count_store = 0;
        foreach ($orders as $order) {
            $store_id = $order['store_id'];
            if(!isset($data[$store_id])) {
                $data[$store_id] = array(
                    "store_id" => $store_id,
                    "store_name" => $order['store_name'],
                    "revenue" => $order['revenue'],
                    "count_order" => $order['count_order'],
                    "orders" => array()
                );
                $count_store++;
            }

            $data[$store_id]['orders'][] = array(
                "order_id" => $order['order_id'],
                "order_revenue" => $order['order_revenue'],
                "packing_date" => $order['packing_date'],
            );
            
        }
        
        $res['count_store'] = $count_store;
        $res['stores_statistic'] = array_values($data);
        return getResponseArray(200, "Seller statistic found", $res);
    }
}








?>