<?php

require_once __DIR__ . '/../../controller/ProductController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$category_id = $_GET['category_id'] ?? null;
if (!$category_id) {
    setStatusCodeAndEchoJson(400, 'Category ID is required');
    exit();
}

$jsonData = file_get_contents('php://input');

$data = json_decode($jsonData, true);

if (!$data) {
    setStatusCodeAndEchoJson(400, 'Invalid JSON', null);
    exit;
}

$offset = $data['offset'] ?? null;
$limit = $data['limit'] ?? null;

$productController = new ProductController();
$respone = $productController->getAllByCategory($category_id, $offset, $limit);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
