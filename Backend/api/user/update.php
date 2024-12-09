<?php

require_once __DIR__ . '/../../controller/UserController.php';
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
    setStatusCodeAndEchoJson(400, 'User ID is required', null);
    exit;
}

$userController = new UserController();

$responses = [];

$name = $data['name'] ?? null;
if ($name) {
    $responses['name'] = $userController->updateUserName($id, $name);
}

$email = $data['email'] ?? null;
if ($email) {
    $responses['email'] = $userController->updateUserEmail($id, $email);
}

$phone = $data['phone'] ?? null;
if ($phone) {
    $responses['phone'] = $userController->updateUserPhone($id, $phone);
}

$sex = $data['sex'] ?? null;
if ($sex) {
    $responses['sex'] = $userController->updateUserSex($id, $sex);
}

$role = $data['role'] ?? null;
if ($role) {
    $responses['role'] = $userController->updateUserRole($id, $role);
}

$avatar = $data['avt_url'] ?? null;
if ($avatar) {
    $responses['avt_url'] = $userController->updateUserAvatar($id, $avatar);
}

$address = $data['address'] ?? null;
if ($address) {
    $responses['address'] = $userController->updateUserAddress($id, $address);
}

$fields = array_keys($responses);
$code = 200;
$message = '';
foreach ($fields as $field) {
    if ($responses[$field]['code'] != 200) {
        $code = $responses[$field]['code'];
    }
    $message .= $responses[$field]['message'] . "\n";
}

setStatusCodeAndEchoJson($code, $message, null);
?>