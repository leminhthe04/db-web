<?php

require_once __DIR__ . '/../../controller/StoreController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

if (!isset($_GET['id'])) {
    setStatusCodeAndEchoJson(400, 'Seller ID is required', null);
    exit;
}

$json_data = file_get_contents('php://input');

$data = json_decode($json_data, true);

$offset = $data['offset'] ?? 0;
$limit = $data['limit'] ?? 999999;

$storeController = new StoreController();
$respone = $storeController->get($offset, $limit);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
