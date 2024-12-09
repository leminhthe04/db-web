<?php
// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);


require_once __DIR__.'/lib/utils.php';

$uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];


// header("Access-Control-Allow-Origin: http://localhost:5173");
header("Access-Control-Allow-Methods: POST, GET, PUT, OPTIONS"); 
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// header("Access-Control-Allow-Credentials: true");



// $uri = str_replace('/Assignment/Backend', '', $uri);
////////////////////// USER APIs //////////////////////
if ($method == 'OPTIONS') {
    // CORS preflight request
    http_response_code(200);
    exit;
}


// if (preg_match('/\/api\/hi$/', $uri)){
//     require __DIR__.'/api/hi.php';
//     exit;
// } 

if (preg_match('/\/api\/user\/all$/', $uri)){
    require __DIR__.'/api/user/getAll.php';
    exit;
}

if (preg_match('/\/api\/user\/detail\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/user/detail.php';
    exit;
}

if (preg_match('/\/api\/user\/create$/', $uri)){
    require __DIR__.'/api/user/signup.php';
    exit;
}

if (preg_match('/\/api\/user\/update\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/user/update.php';
    exit;
}

if (preg_match('/\/api\/user\/delete\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/user/delete.php';
    exit;
}


if (preg_match('/\/api\/user\/delete\/all$/', $uri)){
    require __DIR__.'/api/user/deleteAll.php';
    exit;
}


////////////////////// CATEGORY APIs //////////////////////

if (preg_match('/\/api\/category\/get$/', $uri)){
    require __DIR__.'/api/category/getAll.php';
    exit;
}

if (preg_match('/\/api\/category\/detail\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/category/detail.php';
    exit;
}

// if (preg_match('/\/api\/category\/create$/', $uri)){
//     require __DIR__.'/api/category/create.php';
//     exit;
// }

// if (preg_match('/\/api\/category\/update\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/category/update.php';
//     exit;
// }

// if (preg_match('/\/api\/category\/delete\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/category/delete.php';
//     exit;
// }

// if (preg_match('/\/api\/category\/delete\/all$/', $uri)){
//     require __DIR__.'/api/category/deleteAll.php';
//     exit;
// }


///////////////////////////// PRODUCT APIs /////////////////////////////

if (preg_match('/\/api\/product\/get$/', $uri)){
    require __DIR__.'/api/product/get.php';
    exit;
}

if (preg_match('/\/api\/product\/detail\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/product/detail.php';
    exit;
}

// if (preg_match('/\/api\/product\/available$/', $uri)){
//     require __DIR__.'/api/product/getAllAvailable.php';
//     exit;
// }

// if (preg_match('/\/api\/product\/stopselling$/', $uri)){
//     require __DIR__.'/api/product/getAllStopSelling.php';
//     exit;
// }

// if (preg_match('/\/api\/product\/soldout$/', $uri)){
//     require __DIR__.'/api/product/getAllSoldOut.php';
//     exit;
// }

if (preg_match('/\/api\/product\/get\/category\/(\d+)$/', $uri, $matches)){
    $_GET['category_id'] = $matches[1];
    require __DIR__.'/api/product/getAllByCategory.php';
    exit;
}


if (preg_match('/\/api\/product\/create$/', $uri)){
    require __DIR__.'/api/product/create.php';
    exit;
}

if (preg_match('/\/api\/product\/update\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/product/update.php';
    exit;
}

if (preg_match('/\/api\/product\/delete\/(\d+)$/', $uri, $matches)){
    $_GET['id'] = $matches[1];
    require __DIR__.'/api/product/delete.php';
    exit;
}


//////////////////////////// STORE APIs /////////////////////////////

if (preg_match('/\/api\/store\/get\/seller\/(\d+)$/', $uri, $matches)){
    $_GET['seller_id'] = $matches[1];
    require __DIR__.'/api/store/getBySeller.php';
    exit;
}

if (preg_match('/\/api\/store\/detail\/seller\/(\d+)\/(\d+)$/', $uri, $matches)){
    $_GET['seller_id'] = $matches[1];
    $_GET['store_id'] = $matches[2];
    require __DIR__.'/api/store/getBySellerById.php';
    exit;
}



// if (preg_match('/\/api\/product\/delete\/all$/', $uri)){
//     require __DIR__.'/api/product/deleteAll.php';
//     exit;
// }


// if (preg_match('/\/api\/product\/search$/', $uri)){
//     require __DIR__.'/api/product/search.php';
//     exit;
// }

// if (preg_match('/\/api\/product\/review\/(\d+)$/', $uri, $matches)){
//     $_GET['product_id'] = $matches[1];
//     require __DIR__.'/api/product/postReview.php';
//     exit;
// }


///////////////////////////// PRODUCT IMAGE APIs //////////////////////

// if (preg_match('/\/api\/product-image\/all$/', $uri)){
//     require __DIR__.'/api/productImage/getAll.php';
//     exit;
// }

// if (preg_match('/\/api\/product-image\/detail\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/productImage/detail.php';
//     exit;
// }

// if (preg_match('/\/api\/product-image\/product\/(\d+)$/', $uri, $matches)){
//     $_GET['product_id'] = $matches[1];
//     require __DIR__.'/api/productImage/getAllByProductId.php';
//     exit;
// }

// if (preg_match('/\/api\/product-image\/create$/', $uri)){
//     require __DIR__.'/api/productImage/create.php';
//     exit;
// }

// if (preg_match('/\/api\/product-image\/delete\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/productImage/delete.php';
//     exit;
// }


///////////////////////////// REVIEW APIs /////////////////////////////

// if (preg_match('/\/api\/review\/all$/', $uri)){
//     require __DIR__.'/api/review/getAll.php';
//     exit;
// }

// if (preg_match('/\/api\/review\/detail\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/review/detail.php';
//     exit;
// }

// if (preg_match('/\/api\/review\/product\/(\d+)$/', $uri, $matches)){
//     $_GET['product_id'] = $matches[1];
//     require __DIR__.'/api/review/getAllByProductId.php';
//     exit;
// }

// if (preg_match('/\/api\/review\/user\/(\d+)$/', $uri, $matches)){
//     $_GET['user_id'] = $matches[1];
//     require __DIR__.'/api/review/getAllByUserId.php';
//     exit;
// }

// if (preg_match('/\/api\/review\/create$/', $uri)){
//     require __DIR__.'/api/review/create.php';
//     exit;
// }

// if (preg_match('/\/api\/review\/update\/(\d+)$/', $uri, $matches)){
//     $_GET['id'] = $matches[1];
//     require __DIR__.'/api/review/update.php';
//     exit;
// }


// echo $uri;

setStatusCodeAndEchoJson(404, 'Endpoint not found', null);
?>
