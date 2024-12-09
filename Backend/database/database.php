<?php
define('DB_HOST', 'MY-LEGION-PC\SQLEXPRESS');  // Tên máy chủ và tên instance của SQL Server
define('DB_NAME', 'SpClone');  // Tên cơ sở dữ liệu

header('Content-Type: text/html; charset=UTF-8');

// singleton pattern
class Database {

    private static $conn = null;

    public static function connect() {
        if (self::$conn === null) {

            // DSN (Data Source Name) cho Windows Authentication
            $dsn = "sqlsrv:Server=" . DB_HOST . ";Database=" . DB_NAME;

            // Kết nối với SQL Server sử dụng Windows Authentication (không cần user/pass)
            self::$conn = new PDO($dsn);

            self::$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            // echo "Connected successfully using Windows Authentication<br>";
        }
        return self::$conn;
    }
}
?>