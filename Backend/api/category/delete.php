<?php

require_once __DIR__ . '/../../controller/CategoryController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$id = isset($_GET['id']) ? intval($_GET['id']) : null;
if (!$id) {
    setStatusCodeAndEchoJson(400, 'Category ID is required', null);
    exit;
}

$categoryController = new CategoryController();
$respone = $categoryController->deleteCategory($id);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>