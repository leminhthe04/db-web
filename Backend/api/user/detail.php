<?php

require_once __DIR__ . '/../../controller/UserController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

if (!isset($_GET['id'])) {
    setStatusCodeAndEchoJson(400, 'User ID is required', null);
    exit;
}

$id = intval($_GET['id']);
$userController = new UserController();
$respone = $userController->getById($id);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>