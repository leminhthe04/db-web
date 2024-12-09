<?php

require_once __DIR__ . '/../../controller/UserController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

$id = isset($_GET['id']) ? intval($_GET['id']) : null;
if (!$id) {
    setStatusCodeAndEchoJson(400, 'User ID is required', null);
    exit;
}

$userController = new UserController();
$respone = $userController->deleteUser($id);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>