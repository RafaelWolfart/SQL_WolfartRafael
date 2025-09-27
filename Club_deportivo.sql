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

-- Inscripciones 
INSERT INTO inscripciones (id_socio, id_disciplina, fecha_inscripcion) VALUES
(1, 1, '2023-02-01'),
(1, 2, '2023-02-15'),
(2, 4, '2022-12-05'),
(3, 1, '2024-03-15'),
(3, 3, '2024-04-10'), 
(4, 2, '2024-06-10'),
(5, 3, '2021-08-20');

-- Pagos mensuales
INSERT INTO pagos_mensuales (id_socio, mes, año, monto, fecha_pago) VALUES
(1, 1, 2025, 8000.00, '2025-01-10'),
(1, 2, 2025, 8000.00, '2025-02-10'),
(2, 1, 2025, 7500.00, '2025-01-12'),
(3, 1, 2025, 8000.00, '2025-01-15'),
(3, 2, 2025, 8000.00, '2025-02-15'),
(4, 2, 2025, 7000.00, '2025-02-08'),
(5, 1, 2025, 8500.00, '2025-01-05');

CREATE VIEW vista_socios_activos AS
SELECT s.id_socio, s.nombre, s.apellido, d.nombre AS disciplina, i.fecha_inscripcion
FROM socios s
JOIN inscripciones i ON s.id_socio = i.id_socio
JOIN disciplinas d ON i.id_disciplina = d.id_disciplina;

CREATE VIEW vista_pagos_socios AS
SELECT s.nombre, s.apellido, p.mes, p.año, p.monto, p.fecha_pago
FROM socios s
JOIN pagos_mensuales p ON s.id_socio = p.id_socio;

CREATE VIEW vista_disciplinas_entrenadores AS
SELECT d.nombre AS disciplina, e.nombre AS entrenador, e.apellido
FROM disciplinas d
LEFT JOIN entrenadores e ON d.id_entrenador = e.id_entrenador;

CREATE VIEW vista_socios_morosos AS
SELECT s.id_socio, s.nombre, s.apellido, s.dni
FROM socios s
WHERE s.id_socio NOT IN (
    SELECT p.id_socio
    FROM pagos_mensuales p
    WHERE p.año = YEAR(CURDATE()) AND p.mes = MONTH(CURDATE())
);

CREATE VIEW vista_resumen_disciplinas AS
SELECT d.id_disciplina, d.nombre AS disciplina, d.cupo_maximo,
    COUNT(i.id_socio) AS socios_inscriptos
FROM disciplinas d
LEFT JOIN inscripciones i ON d.id_disciplina = i.id_disciplina
GROUP BY d.id_disciplina, d.nombre, d.cupo_maximo;


DELIMITER //
CREATE FUNCTION calcular_edad(fecha_nac DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION monto_total_pagado(idSocio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(monto) INTO total
    FROM pagos_mensuales
    WHERE id_socio = idSocio;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE registrar_pago (
    IN p_id_socio INT,
    IN p_mes TINYINT,
    IN p_anio YEAR,
    IN p_monto DECIMAL(10,2)
)
BEGIN
    INSERT INTO pagos_mensuales (id_socio, mes, año, monto, fecha_pago)
    VALUES (p_id_socio, p_mes, p_anio, p_monto, NOW());
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE inscribir_socio (
    IN p_id_socio INT,
    IN p_id_disciplina INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM inscripciones
        WHERE id_socio = p_id_socio AND id_disciplina = p_id_disciplina
    ) THEN
        INSERT INTO inscripciones (id_socio, id_disciplina, fecha_inscripcion)
        VALUES (p_id_socio, p_id_disciplina, NOW());
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE reporte_pagos_por_mes (
    IN p_mes TINYINT,
    IN p_anio YEAR
)
BEGIN
    SELECT p_mes AS mes, p_anio AS año, SUM(monto) AS total_recaudado
    FROM pagos_mensuales
    WHERE mes = p_mes AND año = p_anio;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER validar_cupo_inscripcion
BEFORE INSERT ON inscripciones
FOR EACH ROW
BEGIN
    DECLARE cantidad INT;
    DECLARE max_cupo INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM inscripciones
    WHERE id_disciplina = NEW.id_disciplina;
    
    SELECT cupo_maximo INTO max_cupo
    FROM disciplinas
    WHERE id_disciplina = NEW.id_disciplina;
    
    IF cantidad >= max_cupo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay cupo disponible en esta disciplina';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER actualizar_edad
BEFORE INSERT ON socios
FOR EACH ROW
BEGIN
    SET NEW.edad = TIMESTAMPDIFF(YEAR, STR_TO_DATE(NEW.fecha_nacimiento, '%d/%m/%Y'), CURDATE());
END //
DELIMITER ;


-- Caso de prueba función calcular_edad
SELECT calcular_edad('2000-05-15');

-- Caso de prueba función monto_total_pagado
SELECT s.nombre, s.apellido, monto_total_pagado(s.id_socio) AS total_pagado
FROM socios s
WHERE s.id_socio = 1;

-- Caso de prueba procedimiento registrar_pago
CALL registrar_pago(2, 9, 2025, 5000.00);

-- Caso de prueba procedimiento inscribir_socio
CALL inscribir_socio(1, 3);

-- Caso de prueba reporte_pagos_por_mes
CALL reporte_pagos_por_mes(2, 2025);