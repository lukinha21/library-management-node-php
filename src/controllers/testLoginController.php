<?php
include_once(__DIR__ . '/../models/userModel.php');
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userModel = new UserModel();
    $isLoggedIn = $userModel->login($_POST['login'], $_POST['senha']);
    if ($isLoggedIn) {
        header('Location: ../views/indexView.php');
    } else {
        header('Location: ../views/loginView.php');
    }
    exit();
}
?>