CREATE DATABASE IF NOT EXISTS club_deportivo;

CREATE TABLE IF NOT EXISTS club_deportivo.socios (
    id_socio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    dni INT NOT NULL UNIQUE,
    telefono VARCHAR(20) UNIQUE DEFAULT NULL,
    email VARCHAR(150) UNIQUE DEFAULT NULL,
);

ALTER TABLE club_deportivo.socios ADD COLUMN fecha_inscripcion_club DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE club_deportivo.socios ADD COLUMN fecha_nacimiento VARCHAR(10) NOT NULL;

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

ALTER TABLE disciplinas
ADD FOREIGN KEY (id_entrenador) REFERENCES entrenadores(id_entrenador)
    ON DELETE SET NULL;

CREATE TABLE inscripciones (
    id_inscripcion INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT NOT NULL,
    id_disciplina INT NOT NULL,
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE,
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas(id_disciplina) ON DELETE CASCADE,
    UNIQUE (id_socio, id_disciplina)
);

CREATE TABLE pagos_mensuales (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_socio INT NOT NULL,
    mes TINYINT NOT NULL CHECK (mes BETWEEN 1 AND 12),
    año YEAR NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE
);

