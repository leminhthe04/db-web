<?php

require_once __DIR__ . '/../../controller/StoreController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');


if (!isset($_GET['seller_id'])) {
    setStatusCodeAndEchoJson(400, 'Seller ID is required', null);
    exit;
}

$seller_id = intval($_GET['seller_id']);

if (!isset($_GET['store_id'])) {
    setStatusCodeAndEchoJson(400, 'Store ID is required', null);
    exit;
}

$store_id = intval($_GET['store_id']);

$storeController = new StoreController();
$respone = $storeController->getBySellerIdById($seller_id, $store_id);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
