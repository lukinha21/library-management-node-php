-- Esquema do banco "bibliotec" (MySQL 8 / MariaDB).
-- Derivado das consultas SQL presentes no código:
--   API Node   -> src/models/autor-model.js, categoria-model.js, livro-model.js, exemplar-model.js
--   Módulo PHP -> src/models/userModel.php, usuarioModel.php, sistemaModel.php, ReservaModel.php
-- Os nomes de tabelas e colunas são exatamente os usados nas consultas.
-- Os tipos e tamanhos foram inferidos pelo uso (o repositório não traz o script original).
-- Colunas que apontam para tabelas que o código nunca consulta (idEditora, idPrateleira,
-- Funcionario_Pessoa_idPessoa) ficaram como INT simples, sem chave estrangeira.

CREATE DATABASE IF NOT EXISTS bibliotec CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bibliotec;

-- autor-model.js
CREATE TABLE IF NOT EXISTS autor (
    idAutor INT AUTO_INCREMENT PRIMARY KEY,
    nome    VARCHAR(150) NOT NULL
);

-- categoria-model.js (consultada como idcategoria e idCategoria; o MySQL não diferencia maiúsculas em colunas)
CREATE TABLE IF NOT EXISTS categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL
);

-- livro-model.js (status: 1 = Ativo, 0 = Inativo) e ReservaModel.php
CREATE TABLE IF NOT EXISTS livro (
    idLivro     INT AUTO_INCREMENT PRIMARY KEY,
    titulo      VARCHAR(200) NOT NULL,
    ISBN        VARCHAR(20),
    status      TINYINT NOT NULL DEFAULT 1,
    sinopse     TEXT,
    URLimagem   VARCHAR(500),
    idAutor     INT NOT NULL,
    idCategoria INT NOT NULL,
    FOREIGN KEY (idAutor)     REFERENCES autor (idAutor),
    FOREIGN KEY (idCategoria) REFERENCES categoria (idCategoria)
);

-- exemplar-model.js
CREATE TABLE IF NOT EXISTS exemplar (
    idExemplar     INT AUTO_INCREMENT PRIMARY KEY,
    num_serie      VARCHAR(50),
    status         TINYINT NOT NULL DEFAULT 1,
    ano_publi      INT,
    data_aquisicao DATE,
    idLivro        INT NOT NULL,
    idEditora      INT,
    idPrateleira   INT,
    FOREIGN KEY (idLivro) REFERENCES livro (idLivro)
);

-- ReservaModel.php (getLeitores)
CREATE TABLE IF NOT EXISTS pessoa (
    idPessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome     VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS leitor (
    Pessoa_idPessoa INT PRIMARY KEY,
    FOREIGN KEY (Pessoa_idPessoa) REFERENCES pessoa (idPessoa)
);

-- userModel.php, usuarioModel.php, sistemaModel.php
-- nivel_priv: 0 = funcionário, 1 = acesso ao sistema (ver loginController.php)
CREATE TABLE IF NOT EXISTS usuario (
    idUsuario                   INT AUTO_INCREMENT PRIMARY KEY,
    login                       VARCHAR(50) NOT NULL,
    senha                       VARCHAR(255) NOT NULL,
    Funcionario_Pessoa_idPessoa INT,
    Leitor_Pessoa_idPessoa      INT,
    nivel_priv                  INT NOT NULL DEFAULT 0,
    ativo                       TINYINT NOT NULL DEFAULT 1
);

-- ReservaModel.php (cadastrarReserva). idReserva não é usado pelo código; existe só como chave primária.
CREATE TABLE IF NOT EXISTS reserva (
    idReserva              INT AUTO_INCREMENT PRIMARY KEY,
    data_reserva           DATE NOT NULL,
    Leitor_Pessoa_idPessoa INT NOT NULL,
    Livro_idLivro          INT NOT NULL,
    data_limite            DATE NOT NULL,
    FOREIGN KEY (Leitor_Pessoa_idPessoa) REFERENCES leitor (Pessoa_idPessoa),
    FOREIGN KEY (Livro_idLivro)          REFERENCES livro (idLivro)
);
