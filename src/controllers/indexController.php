<?php
include_once(__DIR__ . '/../models/userModel.php');
session_start();
$userModel = new UserModel();
if (!$userModel->isLoggedIn()) {
    header('Location: ../views/loginView.php');
    exit();
}
header('Location: ../views/indexView.php');
exit();

?>