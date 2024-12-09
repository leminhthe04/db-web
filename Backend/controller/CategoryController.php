<?php

require_once __DIR__ . '/../model/Category.php';

class CategoryController {

    private function nameIsValidFormat($name) {
        return strlen($name) >= 3 && strlen($name) <= 50;
    }
    private function fieldAreValid($name) {
        if (!$this->nameIsValidFormat($name))
            return ["message" => "Name must be between 5 and 50 characters"];
        return ["message" => "Valid"];
    }

    public function getAll() {
        $category = new Category();
        $res = $category->getAll(); // a fetch array or null
        if ($res){
            return getResponseArray(200, "Found categories", $res);
        }
        
        return getResponseArray(200, "There is no category in system now", []);
    }

    public function getById($id) {
        $category = new Category();
        $res = $category->getById($id);

        if ($res) {
            return getResponseArray(200, "Category found", $res);
        }
        return getResponseArray(404, "Category not found", null);
    }

    public function insertCategory($name) {
        
        // check name are valid in private function, if not return error message
        $validMessage = $this->fieldAreValid($name)['message'];
        if ($validMessage !== "Valid") {
            return getResponseArray(400, $validMessage, null);
        }
        
        $category = new Category();
        return $category->insertCategory($name);
    }

    public function updateCategoryName($id, $name) {
        if (!$this->nameIsValidFormat($name)) {
            return getResponseArray(400, "Name must be between 5 and 50 characters", null);
        }
        $category = new Category();
        return $category->updateName($id, $name);
    }

    public function deleteCategory($id) {
        $category = new Category();
        return $category->deleteById($id);
    }

    public function deleteAllCategories() {
        $category = new Category();
        return $category->deleteAll();
    }
}

?>