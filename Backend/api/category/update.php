<?php

require_once __DIR__ . '/../../controller/CategoryController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$jsonData = file_get_contents('php://input');

$data = json_decode($jsonData, true);

if (!$data) {
    setStatusCodeAndEchoJson(400, 'Invalid JSON', null);
    exit;
}

$id = isset($_GET['id']) ? intval($_GET['id']) : null;
if (!$id) {
    setStatusCodeAndEchoJson(400, 'Category ID is required', null);
    exit;
}


$name = $data['new_name'] ?? null;
if(!$name){
    setStatusCodeAndEchoJson(400, 'New name is required', null);
    exit;
}

$categoryController = new CategoryController();
$response = $categoryController->updateCategoryName($id, $name);
setStatusCodeAndEchoJson($response['code'], $response['message'], $response['data']);
?>