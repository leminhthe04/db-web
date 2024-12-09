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

$seller_id = $data['seller_id'];
if (!$seller_id) {
    setStatusCodeAndEchoJson(400, 'Seller ID is required', null);
    exit;
}

$store_id = $data['store_id'];
if (!$store_id) {
    setStatusCodeAndEchoJson(400, 'Store ID is required', null);
    exit;
}

$name = $data['name'] ?? null;
if (!$name) {
    setStatusCodeAndEchoJson(400, 'Name is required', null);
    exit;
}

$brand = $data['brand'] ?? null;

$price = $data['price'] ?? null;
if ($price === null) {
    setStatusCodeAndEchoJson(400, 'Price is required', null);
    exit;
}

$description = $data['description'] ?? null;

$quantity = $data['quantity'] ?? null;
if ($quantity === null) {
    setStatusCodeAndEchoJson(400, 'Quantity is required', null);
    exit;
}

$category_id = $data['category_id'] ?? null;
$status = $data['status'] ?? null;



// print_r($image_urls);


$productController = new ProductController();
$respone = $productController->insertProduct($seller_id, $store_id, $name, $brand, 
                        $price, $description, $quantity, $category_id, $status);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>