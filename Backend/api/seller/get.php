<?php

require_once __DIR__ . '/../../controller/SellerController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$json_data = file_get_contents('php://input');

$data = json_decode($json_data, true);

$offset = $data['offset'] ?? 0;
$limit = $data['limit'] ?? 999999;

$sellerController = new SellerController();
$respone = $sellerController->get($offset, $limit);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);

?>



