<?php

require_once __DIR__ . '/../model/Store.php';

class StoreController {

    public function getBySellerId($seller_id) {
        $store = new Store();
        $res = $store->getBySellerId($seller_id);

        return $res ? 
            getResponseArray(200, "Stores found", $res) : 
            getResponseArray(404, "Store not found", null);
    }

    public function getBySellerIdById($seller_id, $store_id) {
        $store = new Store();
        $res = $store->getBySellerIdStoreId($seller_id, $store_id);

        return $res ? 
            getResponseArray(200, "Store found", $res) : 
            getResponseArray(404, "Store not found", null);
    }

}

?>