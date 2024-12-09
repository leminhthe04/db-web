<?php

require_once __DIR__ . '/../../controller/SellerController.php';
require_once __DIR__ . '/../../lib/utils.php';

header('Content-Type: application/json');

if (!isset($_GET['id'])) {
    setStatusCodeAndEchoJson(400, 'Category ID is required', null);
    exit;
}

$id = intval($_GET['id']);

$data_json = file_get_contents('php://input');

$data = json_decode($data_json, true);


$from_date = $data['from_date'];
if(!$from_date){
    return setStatusCodeAndEchoJson(400, 'From date is required', null);
}

$to_date = $data['to_date'];
if($!to_date){
    return setStatusCodeAndEchoJson(400, 'To date is required', null);
}


$sellerController = new SellerController();
$respone = $sellerController->getStatistic($id, $from_date, $to_date);
setStatusCodeAndEchoJson($respone['code'], $respone['message'], $respone['data']);
?>