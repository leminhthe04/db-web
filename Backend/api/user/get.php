<?php

require_once __DIR__ . '/../../controller/UserController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');



$userController = new UserController();
$respone = $userController->getAll();
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>
