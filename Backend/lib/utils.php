<?php

function setStatusCodeAndEchoJson($code, $msg, $data) {
    http_response_code($code);
    echo json_encode([
        'status' => $code,
        'msg' => $msg,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE);
}


function getResponseArray($code, $msg, $data) {
    return [
        'code' => $code,
        'message' => $msg,
        'data' => $data
    ];
}


// convert a query result to an associative array (2D-array)
// function fetch($sqlTable){
//     $res = [];
//     if (!$sqlTable || $sqlTable->num_rows == 0) {
//         return $res;
//     }
//     while ($row = $sqlTable->fetch_assoc()) {
//         $res[] = $row;
//     }
//     return $res;
// }


function fetch($sqlQuery) {
    $res = [];
    
    if (!$sqlQuery) {
        return $res;
    }
    
    while ($row = $sqlQuery->fetch(PDO::FETCH_ASSOC)) {
        $res[] = $row;
    }

    return $res;
}

?>