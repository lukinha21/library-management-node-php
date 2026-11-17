<?php
include_once(__DIR__ . '/../models/userModel.php');

// Inicia a sessão
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userModel = new UserModel();
    $isLoggedIn = $userModel->login($_POST['login'], $_POST['senha']);

    if ($isLoggedIn) {
        // Usuário autenticado com sucesso, redireciona com base no nível de privilégio
        if ($_SESSION['nivel_priv'] == '0') {
            header('Location: ../controllers/FuncionarioController.php');
            exit();
        } else if ($_SESSION['nivel_priv'] == '1') {
            header('Location: ../controllers/indexController.php');
            exit();
        }
    }

    // Se chegou até aqui, significa que o login falhou
    header('Location: ../views/loginView.php', true, 302);
    exit();
}
?>
