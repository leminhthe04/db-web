<?php

require_once __DIR__ . '/../model/Seller.php';

class SellerController {

    public function get($offset, $limit) {
        $seller = new Seller();
        $res = $seller->get($offset, $limit); // a fetch array or null
        if ($res){
            return getResponseArray(200, "Found sellers", $res);
        }
        
        return getResponseArray(200, "There is no seller in system now", []);    
    }

    public function getById($id) {
        $seller = new Seller();
        $res = $seller->getById($id);

        if ($res) {
            return getResponseArray(200, "Seller found", $res);
        }
        return getResponseArray(404, "Seller not found", null);    
    
    }

    public function getStatisticById($id) {
        $seller = new Seller();
        $res = $seller->getStatisticById($id);

        if ($res) {
            return getResponseArray(200, "Seller statistic found", $res);
        }
        return getResponseArray(404, "Seller statistic not found", null);    
    }
}

?>