<?php
require_once __DIR__ . '/../database/database.php';
require_once __DIR__ . '/../lib/utils.php';

class User {

    private $conn;

    public function __construct() {
        $this->conn = Database::connect(); // get connection from database.php
    }


    public function getAll() {
        $stmt = $this->conn->prepare("EXEC findAll 'Users'");
        $stmt->execute();
        $arr = fetch($stmt);
        $stmt->closeCursor();
        return $arr;
    }

    public function getById($id) {
        $stmt = $this->conn->prepare("CALL findById('users', ?)");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $table = $stmt->get_result();
        $arr = fetch($table);
        if($table) $table->free();
        $stmt->close();
        return $arr;
    }

    public function getByEmail($email) {
        $stmt = $this->conn->prepare("CALL findByUniqueField('users', 'email', ?)");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $table = $stmt->get_result();
        $arr = fetch($table);
        if($table) $table->free();
        $stmt->close();
        return $arr;
    }

    public function getByPhone($phone) {
        $stmt = $this->conn->prepare("CALL findByUniqueField('users', 'phone', ?)");
        $stmt->bind_param("s", $phone);
        $stmt->execute();
        $table = $stmt->get_result();
        $arr = fetch($table);
        if($table) $table->free();
        $stmt->close();
        return $arr;
    }

    // CALL insertUser('Nguyen Van B', 'M', '123456', 'nguyenB@gmail.com', '0123456790', 'admin', 'avt_url', '192 ĐPB, Q.1, TP.HCM');
    public function insertUser($name, $sex, $password, $email, $phone, $role, $avatar, $address) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL insertUser(?, ?, ?, ?, ?, ?, ?, ?)");
            $stmt->bind_param("ssssssss", $name, $sex, $password, $email, $phone, $role, $avatar, $address);
            $stmt->execute();
            $result = $stmt->get_result();
            $res = getResponseArray(201, "User created", ["id" => $result->fetch_assoc()['id']]);
            $result->free();
            $stmt->close();
            return $res;
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updatePassword($id, $password) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserPassword(?, ?)");
            $stmt->bind_param("is", $id, $password);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Password updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateName($id, $name) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserName(?, ?)");
            $stmt->bind_param("is", $id, $name);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Name updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateSex($id, $sex) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserSex(?, ?)");
            $stmt->bind_param("is", $id, $sex);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Sex updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateEmail($id, $email) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserEmail(?, ?)");
            $stmt->bind_param("is", $id, $email);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Email updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updatePhone($id, $phone) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserPhone(?, ?)");
            $stmt->bind_param("is", $id, $phone);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Phone updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateRole($id, $role) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserRole(?, ?)");
            $stmt->bind_param("is", $id, $role);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Role updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateAvatar($id, $avt_url) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserAvtUrl(?, ?)");
            $stmt->bind_param("is", $id, $avt_url);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Avatar updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function updateAddress($id, $address) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL updateUserAddress(?, ?)");
            $stmt->bind_param("is", $id, $address);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "Address updated", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function deleteById($id) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL deleteById('users', ?);");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "User deleted", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }

    public function deleteAll() {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        try {
            $stmt = $this->conn->prepare("CALL deleteAll('users')");
            $stmt->execute();
            $stmt->close();
            return getResponseArray(200, "All users deleted", null);
        } catch (mysqli_sql_exception $e) {
            return getResponseArray(400, $e->getMessage(), null);
        }
    }
}

?>