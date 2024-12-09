<?php

require_once __DIR__ . '/../../controller/StoreController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

if (!isset($_GET['seller_id'])) {
    setStatusCodeAndEchoJson(400, 'Seller ID is required', null);
    exit;
}

$seller_id = intval($_GET['seller_id']);
$storeController = new StoreController();
$respone = $storeController->getBySellerId($seller_id);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
