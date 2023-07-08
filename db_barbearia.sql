CREATE DATABASE barbearia;

DROP TABLE servicos;
DELETE FROM USUARIOS WHERE ID = 1;

USE barbearia;
# -------------- USUARIOS ---------------- #
CREATE TABLE USUARIOS(
	id INT PRIMARY KEY,
    nome varchar(45),
    sobrenome varchar(45),
    email varchar(60),
    nascimento date,
    telefone varchar(14)
);

ALTER TABLE USUARIOS DROP COLUMN id;

ALTER TABLE USUARIOS ADD id INT AUTO_INCREMENT PRIMARY KEY FIRST;

INSERT INTO usuarios (nome, sobrenome, email, nascimento, telefone)
VALUES  ('João', 'Silva', 'joaosilva@gmail.com', '1990-05-20', '(11) 977482910'),
('Pedro', 'Oliveira', 'pedrooliveira@gmail.com', '1985-08-15', '(11) 981239873'),
('Lucas', 'Santos', 'lucassantos@gmail.com', '1995-01-27', '(11) 982348921'),
('Gabriel', 'Lima', 'gabriellima@gmail.com', '1993-04-08', '(11) 973928319'),
('Rodrigo', 'Souza', 'rodrigosouza@gmail.com', '1988-11-30', '(11) 974928371'),
('Felipe', 'Vieira', 'felipevieira@gmail.com', '1996-06-22', '(11) 981239874'),
('Thiago', 'Pereira', 'thiagopereira@gmail.com', '1992-09-14', '(11) 981239875'),
('Marcelo', 'Alves', 'marceloalves@gmail.com', '1987-12-26', '(11) 981239876'),
('Juan', 'Pedro', 'Juanpedro@gmail.com', '1986-12-26', '(11) 947899876');

SELECT * FROM usuarios;

# -------------- AGENDAMENTOS ---------------- #
CREATE TABLE agendamentos(
	id INT AUTO_INCREMENT PRIMARY KEY,
    agendamento timestamp,
    data_agend date,
    hora_inicio time,
    hora_termino time,
    id_usuario int,
    foreign key (id_usuario) references usuarios(id)
);

ALTER TABLE agendamentos DROP COLUMN data_agend;

ALTER TABLE agendamentos ADD data_agend date after agendamento;

INSERT INTO agendamentos (agendamento, data_agend, hora_inicio, hora_termino, id_usuario)
VALUES 
(CURRENT_TIMESTAMP, '2023-05-20', '08:00:00', '09:00:00', 2),
(CURRENT_TIMESTAMP, '2023-05-20', '10:00:00', '11:00:00', 3),
(CURRENT_TIMESTAMP, '2023-05-20', '13:00:00', '14:00:00', 4),
(CURRENT_TIMESTAMP, '2023-05-21', '09:00:00', '10:00:00', 5),
(CURRENT_TIMESTAMP, '2023-05-21', '11:00:00', '12:00:00', 6),
(CURRENT_TIMESTAMP, '2023-05-21', '14:00:00', '15:00:00', 7),
(CURRENT_TIMESTAMP, '2023-05-22', '08:30:00', '09:30:00', 8),
(CURRENT_TIMESTAMP, '2023-05-22', '10:30:00', '11:30:00', 9),
(CURRENT_TIMESTAMP, '2023-05-22', '13:30:00', '14:30:00', 10),
(CURRENT_TIMESTAMP, '2023-05-23', '11:30:00', '12:30:00', 11);

SELECT * FROM agendamentos;

# -------------- PAGAMENTOS ---------------- #

CREATE TABLE pagamentos(
	id INT AUTO_INCREMENT PRIMARY KEY,
    pix tinyint(1),
    credito tinyint(1),
    aprovado tinyint(1),
    id_agend int,
    foreign key (id_agend) references agendamentos(id)
);

INSERT INTO pagamentos (pix, credito, aprovado, id_agend)
VALUES 
    (1, 0, 1, 2),
    (0, 1, 1, 3),
    (1, 0, 1, 4),
    (1, 0, 1, 5),
    (0, 1, 1, 6),
    (0, 1, 1, 7),
    (1, 0, 1, 8),
    (0, 1, 1, 9),
    (1, 0, 1, 10),
    (0, 1, 1, 11);

SELECT * FROM pagamentos;

# -------------- SERVIÇOS ---------------- #

CREATE TABLE servicos(
	id INT AUTO_INCREMENT PRIMARY KEY,
    tipo varchar(15),
    modelo varchar(20),
    duracao time
);

ALTER TABLE servicos ADD preco DECIMAL(10,2);

UPDATE servicos SET preco = 10.00 WHERE id = 10;

INSERT INTO servicos (tipo, modelo, duracao)
VALUES ('cabelo', 'pezinho', '00:10:00');

INSERT INTO servicos (tipo, modelo, duracao, preco)
VALUES ('barba', 'baibo', '00:15:00', 15.00);

INSERT INTO servicos (tipo, modelo, duracao, preco)
VALUES ('sombrancelha', 'limpeza', '00:05:00', 10.00);

SELECT * FROM servicos;

# -------------- SERVICOS_HAS_AGENDAMENTOS ---------------- #

CREATE TABLE servicos_has_agendamentos(
	servico_id int,
	agendamento_id int,
    foreign key (servico_id) references servicos(id),
    foreign key (agendamento_id) references agendamentos(id)
);

INSERT INTO servicos_has_agendamentos (servico_id, agendamento_id)
VALUES 
	(1, 2),
    (18, 2),
    (15, 3),
    (2, 4),
    (11, 4),
    (18, 4),
    (11, 5),
    (9, 6),
    (18, 7),
    (7, 8),
    (12, 8),
    (4, 9),
    (12, 9),
    (18, 9),
    (16, 10),
    (3, 10),
    (1, 11),
    (11, 11),
    (18, 11);

SELECT * FROM servicos_has_agendamentos;

# -------------- INNER JOIN's ---------------- #

# 1:n
SELECT u.nome, u.sobrenome, a.agendamento, a.data_agend, a.hora_inicio, a.hora_termino
FROM usuarios u
INNER JOIN agendamentos a ON u.id = a.id_usuario;

# 1:1
SELECT a.agendamento, a.data_agend, p.aprovado, p.pix, p.credito
FROM agendamentos a
INNER JOIN pagamentos p ON a.id_usuario = id_agend;

# n:m
SELECT a.id, a.agendamento, a.data_agend, s.id, s.tipo, s.modelo, s.preco
FROM agendamentos a
INNER JOIN servicos_has_agendamentos sa ON a.id = sa.agendamento_id
INNER JOIN servicos s ON sa.servico_id = s.id;

# LEFT
SELECT u.nome, u.sobrenome, a.data_agend, a.hora_inicio, a.hora_termino
FROM usuarios u
LEFT JOIN agendamentos a ON u.id = a.id_usuario;

# RIGHT
SELECT a.data_agend, a.hora_inicio, a.hora_termino, u.nome, u.sobrenome
FROM agendamentos a
RIGHT JOIN usuarios u ON a.id_usuario = u.id;

# FULL OUTER
			# SELECT *
			# FROM usuarios u
			# FULL OUTER JOIN agendamentos a
			# ON u.id = a.id_usuario;
SELECT *
FROM usuarios u
LEFT JOIN agendamentos a
ON u.id = a.id_usuario

UNION

SELECT *
FROM usuarios u
RIGHT JOIN agendamentos a
ON u.id = a.id_usuario

