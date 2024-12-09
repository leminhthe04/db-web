<?php
require_once __DIR__ . '/../model/User.php';

class UserController {

    private function phoneNumberIsValidFormat($phone) {
        return preg_match('/^0[0-9]{9}$/', $phone);
    }
    private function emailIsValidFormat($email) {
        return filter_var($email, FILTER_VALIDATE_EMAIL);
    }
    private function passwordIsValidFormat($password) {
        return strlen($password) >= 8 && strlen($password) <= 30;
    }
    private function roleIsValidValue($role) {
        return in_array($role, ['admin', 'customer']);
    }
    private function nameIsValidFormat($name) {
        return strlen($name) >= 5 && strlen($name) <= 50;
    }
    private function sexIsValidValue($sex) {
        return in_array($sex, ['M', 'F']);
    }
    private function fieldAreValid($name, $sex, $password, $email, $phone, $role) {
        if (!$this->nameIsValidFormat($name))
            return ["message" => "Name must be between 5 and 50 characters"];
        if (!$this->sexIsValidValue($sex))
            return ["message" => "Sex must be 'M' or 'F'"];
        if (!$this->emailIsValidFormat($email))
            return ["message" => "Email is invalid"];
        if (!$this->phoneNumberIsValidFormat($phone))
            return ["message" => "Phone is invalid"];
        if (!$this->passwordIsValidFormat($password))
            return ["message" => "Password must be between 8 and 30 characters"];
        if (!$this->roleIsValidValue($role))
            return ["message" => "Role is invalid"];
        return ["message" => "Valid"];
    }

    public function getAll() {
        $user = new User();
        $res = $user->getAll(); // a fetch array or null
        if ($res){
            return getResponseArray(200, "Found users", $res);
        }
        
        return getResponseArray(200, "There is no user in system now", []);
    }

    public function getById($id) {
        $user = new User();
        $res = $user->getById($id);

        if ($res) {
            return getResponseArray(200, "User found", $res);
        }
        return getResponseArray(404, "User not found", null);
    }

    public function insertUser($name, $sex, $password, $email, $phone, $role, $avatar, $address) {
        
        // check some field are valid in private functions, if not return error message for the first invalid field
        $validMessage = $this->fieldAreValid($name, $sex, $password, $email, $phone, $role)['message'];
        if ($validMessage !== "Valid") {
            return getResponseArray(400, $validMessage, null);
        }
        
        // hash password:
        $password = password_hash($password, PASSWORD_ARGON2ID);
        
        $user = new User();
        return $user->insertUser($name, $sex, $password, $email, $phone, $role, $avatar, $address);
    }

    public function authenticateUserByEmail($email, $password) {
        $user = new User();
        $res = $user->getByEmail($email);

        if (!$res) {
            return getResponseArray(401, "Email not exist", null);
        }
    
        // because res is 2D array and phone is unique, so res[0] is the only record
        if (password_verify($password, $res[0]['password'])) {
            return getResponseArray(200, "Login successfully", $res);
        }

        return getResponseArray(401, "Password is incorrect", null);
    }

    public function authenticateUserByPhone($phone, $password) {
        $user = new User();
        $res = $user->getByPhone($phone);

        if (!$res) {
            return getResponseArray(401, "Phone not exist", null);
        }
    
        // because res is 2D array and phone is unique, so res[0] is the only record
        if (password_verify($password, $res[0]['password'])) {
            return getResponseArray(200, "Login successfully", $res);
        }

        return getResponseArray(401, "Password is incorrect", null);
    }


    public function changeUserPassword($id, $currentPassword, $newPassword) {
        $user = new User();
        $res = $user->getById($id);
        if (!$res) {
            return getResponseArray(404, "User not found", null);
        }

        if (!password_verify($currentPassword, $res[0]['password'])) {
            return getResponseArray(401, "Current password is incorrect", null);
        }

        if (!$this->passwordIsValidFormat($newPassword)) {
            return getResponseArray(400, "New password must be between 8 and 30 characters", null);
        }

        $newPassword = password_hash($newPassword, PASSWORD_ARGON2ID);
        return $user->updatePassword($id, $newPassword);
    }

    public function updateUserName($id, $name) {
        if (!$this->nameIsValidFormat($name)) {
            return getResponseArray(400, "Name must be between 5 and 50 characters", null);
        }
        $user = new User();
        return $user->updateName($id, $name);
    }

    public function updateUserEmail($id, $email) {
        if (!$this->emailIsValidFormat($email)) {
            return getResponseArray(400, "Email is invalid", null);
        }
        $user = new User();
        return $user->updateEmail($id, $email);
    }

    public function updateUserPhone($id, $phone) {
        if (!$this->phoneNumberIsValidFormat($phone)) {
            return getResponseArray(400, "Phone is invalid", null);
        }
        $user = new User();
        return $user->updatePhone($id, $phone);
    }

    public function updateUserSex($id, $sex) {
        if (!$this->sexIsValidValue($sex)) {
            return getResponseArray(400, "Sex must be 'M' or 'F'", null);
        }
        $user = new User();
        return $user->updateSex($id, $sex);
    }

    public function updateUserRole($id, $role) {
        if (!$this->roleIsValidValue($role)) {
            return getResponseArray(400, "Role is invalid", null);
        }
        $user = new User();
        return $user->updateRole($id, $role);
    }

    public function updateUserAvatar($id, $avatar) {
        $user = new User();
        return $user->updateAvatar($id, $avatar);
    }

    public function updateUserAddress($id, $address) {
        $user = new User();
        return $user->updateAddress($id, $address);
    }


    public function deleteUser($id) {
        $user = new User();
        return $user->deleteById($id);
    }

    public function deleteAllUsers() {
        $user = new User();
        return $user->deleteAll();
    }
}

?>