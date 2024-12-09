<?php

require_once __DIR__ . '/../../controller/ProductController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$jsonData = file_get_contents('php://input');

$data = json_decode($jsonData, true);

if (!$data) {
    setStatusCodeAndEchoJson(400, 'Invalid JSON', null);
    exit;
}

$offset = $data['offset'] ?? null;
$limit = $data['limit'] ?? null;



$productController = new ProductController();
$respone = $productController->get($offset, $limit);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
