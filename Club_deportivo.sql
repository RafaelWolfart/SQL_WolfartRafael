CREATE DATABASE IF NOT EXISTS club_deportivo;
USE club_deportivo;

CREATE TABLE IF NOT EXISTS club_deportivo.socios (
    id_socio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    dni INT NOT NULL UNIQUE,
    telefono VARCHAR(20) UNIQUE DEFAULT NULL,
    email VARCHAR(150) UNIQUE DEFAULT NULL
);

ALTER TABLE club_deportivo.socios ADD COLUMN edad INT UNSIGNED DEFAULT NULL;
ALTER TABLE club_deportivo.socios ADD COLUMN fecha_inscripcion_club DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE club_deportivo.socios ADD COLUMN fecha_nacimiento DATE NOT NULL;

CREATE TABLE disciplinas (
    id_disciplina INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    cupo_maximo INT NOT NULL
);

CREATE TABLE entrenadores (
    id_entrenador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    especialidad VARCHAR(50),
    telefono VARCHAR(20)
);

ALTER TABLE club_deportivo.disciplinas
ADD id_entrenador INT,
ADD FOREIGN KEY (id_entrenador) REFERENCES entrenadores(id_entrenador)
    ON DELETE SET NULL;

CREATE TABLE club_deportivo.inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT NOT NULL,
    id_disciplina INT NOT NULL,
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE,
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina) ON DELETE CASCADE,
    UNIQUE (id_socio, id_disciplina)
);

CREATE TABLE club_deportivo.pagos_mensuales (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT NOT NULL,
    mes TINYINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    año YEAR NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE
);

-- Entrenadores
INSERT INTO entrenadores (nombre, apellido, especialidad, telefono) VALUES
('Héctor', 'Bianchi', 'Fútbol', '1134567890'),
('Mariana', 'Díaz', 'Natación', '1145678901'),
('Ricardo', 'Guzmán', 'Tenis', '1156789012'),
('Lorena', 'Paredes', 'Básquet', '1167890123');

-- Disciplinas (se relacionan con entrenadores por id_entrenador AUTO_INCREMENT)
INSERT INTO disciplinas (nombre, descripcion, cupo_maximo, id_entrenador) VALUES
('Fútbol', 'Entrenamientos y torneos de fútbol amateur', 30, 1),
('Natación', 'Clases en pileta olímpica y torneos internos', 20, 2),
('Tenis', 'Escuela de tenis para todas las edades', 15, 3),
('Básquet', 'Entrenamientos y liga interna de básquet', 25, 4);

-- Socios
INSERT INTO socios (nombre, apellido, dni, telefono, email, edad, fecha_inscripcion_club, fecha_nacimiento) VALUES
('Carlos', 'Pérez', 30123456, '1122334455', 'carlos.perez@example.com', 35, '2023-01-15', '1988-04-10'),
('María', 'Fernández', 27890123, '1123456789', 'maria.fernandez@example.com', 40, '2022-11-20', '1983-07-25'),
('Julián', 'Gómez', 33222111, '1134567890', 'julian.gomez@example.com', 28, '2024-03-10', '1996-02-18'),
('Lucía', 'Martínez', 35444333, '1145678901', 'lucia.martinez@example.com', 22, '2024-06-01', '2002-10-05'),
('Federico', 'Sosa', 28999888, '1156789012', 'federico.sosa@example.com', 45, '2021-08-12', '1979-01-30');

-- Inscripciones (usando ids generados automáticamente)
INSERT INTO inscripciones (id_socio, id_disciplina, fecha_inscripcion) VALUES
(1, 1, '2023-02-01'), -- Carlos en Fútbol
(1, 2, '2023-02-15'), -- Carlos en Natación
(2, 4, '2022-12-05'), -- María en Básquet
(3, 1, '2024-03-15'), -- Julián en Fútbol
(3, 3, '2024-04-10'), -- Julián en Tenis
(4, 2, '2024-06-10'), -- Lucía en Natación
(5, 3, '2021-08-20'); -- Federico en Tenis

-- Pagos mensuales
INSERT INTO pagos_mensuales (id_socio, mes, año, monto, fecha_pago) VALUES
(1, 1, 2025, 8000.00, '2025-01-10'),
(1, 2, 2025, 8000.00, '2025-02-10'),
(2, 1, 2025, 7500.00, '2025-01-12'),
(3, 1, 2025, 8000.00, '2025-01-15'),
(3, 2, 2025, 8000.00, '2025-02-15'),
(4, 2, 2025, 7000.00, '2025-02-08'),
(5, 1, 2025, 8500.00, '2025-01-05');

