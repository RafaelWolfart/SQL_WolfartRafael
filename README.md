# SQL_WolfartRafael

# Descripción del Proyecto

# Proyecto: Club Deportivo Posadas

---

## Introducción

El presente proyecto consiste en el diseño y desarrollo de una base de datos para el **Club Deportivo Posadas**, con el objetivo de gestionar de manera eficiente la información relacionada con socios, disciplinas, entrenadores, inscripciones y pagos mensuales.

La solución busca optimizar el almacenamiento y la consulta de datos, permitiendo al club contar con herramientas que faciliten la administración diaria y la toma de decisiones estratégicas.

---

## Objetivos

- Diseñar una base de datos relacional que modele la realidad del Club Deportivo Posadas.
- Gestionar la información de socios, entrenadores y disciplinas de manera ordenada y confiable.
- Registrar inscripciones de socios en diferentes disciplinas, controlando cupos disponibles.
- Administrar los pagos mensuales y generar reportes financieros.
- Automatizar procesos mediante funciones, procedimientos almacenados, vistas y triggers.

---

## Situación Problemática

El club enfrenta dificultades en la **gestión manual de información**, lo que genera problemas como:

- Duplicación o pérdida de datos de socios.
- Falta de control sobre los cupos máximos de las disciplinas.
- Demoras en el registro y control de pagos mensuales.
- Ausencia de reportes confiables que permitan conocer el estado financiero del club.

Estos problemas afectan la eficiencia operativa y dificultan la planificación.

---

## Modelo de Negocio

El **Club Deportivo Posadas** ofrece a sus socios la posibilidad de inscribirse en distintas disciplinas deportivas (fútbol, natación, tenis, básquet, etc.), cada una con cupos limitados y entrenadores responsables.

Los socios abonan mensualmente una cuota por participar en las disciplinas, y el club debe:

- Llevar control de inscripciones.
- Controlar que no se excedan los cupos.
- Registrar pagos y generar reportes de recaudación.
- Detectar socios morosos para la gestión administrativa.

---

## Listado de Tablas

### Socios

| Campo                  | Tipo de Dato       | Descripción                                       |
| ---------------------- | ------------------ | ------------------------------------------------- |
| id_socio (PK)          | INT AUTO_INCREMENT | Identificador único del socio.                    |
| nombre                 | VARCHAR(50)        | Nombre del socio.                                 |
| apellido               | VARCHAR(80)        | Apellido del socio.                               |
| dni                    | INT UNIQUE         | Documento nacional de identidad, único por socio. |
| telefono               | VARCHAR(20)        | Número de teléfono (opcional, único).             |
| email                  | VARCHAR(150)       | Correo electrónico (opcional, único).             |
| edad                   | INT UNSIGNED       | Edad del socio (calculada automáticamente).       |
| fecha_inscripcion_club | DATETIME           | Fecha en la que se inscribió en el club.          |
| fecha_nacimiento       | DATE               | Fecha de nacimiento del socio.                    |

**Uso:** almacena la información principal de los socios del club.

---

### Disciplinas

| Campo              | Tipo de Dato       | Descripción                           |
| ------------------ | ------------------ | ------------------------------------- |
| id_disciplina (PK) | INT AUTO_INCREMENT | Identificador único de la disciplina. |
| nombre             | VARCHAR(50)        | Nombre de la disciplina (ej. Fútbol). |
| descripcion        | TEXT               | Breve detalle de la disciplina.       |
| cupo_maximo        | INT                | Cantidad máxima de socios permitidos. |
| id_entrenador (FK) | INT                | Relación con el entrenador a cargo.   |

**Uso:** define las disciplinas ofrecidas en el club y sus cupos máximos.

---

### Entrenadores

| Campo              | Tipo de Dato       | Descripción                         |
| ------------------ | ------------------ | ----------------------------------- |
| id_entrenador (PK) | INT AUTO_INCREMENT | Identificador único del entrenador. |
| nombre             | VARCHAR(50)        | Nombre del entrenador.              |
| apellido           | VARCHAR(50)        | Apellido del entrenador.            |
| especialidad       | VARCHAR(50)        | Especialidad o deporte que entrena. |
| telefono           | VARCHAR(20)        | Número de contacto.                 |

**Uso:** almacena los entrenadores a cargo de cada disciplina.

---

### Inscripciones

| Campo               | Tipo de Dato       | Descripción                                |
| ------------------- | ------------------ | ------------------------------------------ |
| id_inscripcion (PK) | INT AUTO_INCREMENT | Identificador único de la inscripción.     |
| id_socio (FK)       | INT                | Socio inscrito en la disciplina.           |
| id_disciplina (FK)  | INT                | Disciplina en la que se inscribe el socio. |
| fecha_inscripcion   | DATETIME           | Fecha de inscripción.                      |

**Uso:** relaciona a los socios con las disciplinas en las que participan.

---

### Pagos Mensuales

| Campo         | Tipo de Dato       | Descripción                         |
| ------------- | ------------------ | ----------------------------------- |
| id_pago (PK)  | INT AUTO_INCREMENT | Identificador único del pago.       |
| id_socio (FK) | INT                | Socio que realizó el pago.          |
| mes           | TINYINT            | Mes abonado (1 a 12).               |
| año           | YEAR               | Año abonado.                        |
| monto         | DECIMAL(10,2)      | Monto del pago.                     |
| fecha_pago    | DATETIME           | Fecha en la que se realizó el pago. |

**Uso:** registra las cuotas abonadas por cada socio.

---

## Vistas

### 1. vista_socios_activos

- **Descripción:** Muestra un listado de los socios que están inscriptos en alguna disciplina, incluyendo la fecha de inscripción.
- **Objetivo:** Permitir a la administración conocer qué socios se encuentran activos en actividades deportivas.
- **Tablas que lo componen:**
  - `socios`
  - `inscripciones`
  - `disciplinas`

---

### 2. vista_pagos_socios

- **Descripción:** Lista los pagos realizados por cada socio, mostrando nombre, apellido, monto y fecha de pago.
- **Objetivo:** Facilitar el seguimiento de los pagos efectuados por cada socio.
- **Tablas que lo componen:**
  - `socios`
  - `pagos_mensuales`

---

### 3. vista_disciplinas_entrenadores

- **Descripción:** Relaciona cada disciplina con su respectivo entrenador asignado.
- **Objetivo:** Ofrecer una visión clara de qué entrenadores están a cargo de cada disciplina.
- **Tablas que lo componen:**
  - `disciplinas`
  - `entrenadores`

---

### 4. vista_socios_morosos

- **Descripción:** Identifica los socios que no realizaron el pago de la cuota del mes actual.
- **Objetivo:** Ayudar al área administrativa a detectar y gestionar los socios con pagos atrasados.
- **Tablas que lo componen:**
  - `socios`
  - `pagos_mensuales`

---

### 5. vista_resumen_disciplinas

- **Descripción:** Muestra el nombre de la disciplina, su cupo máximo y la cantidad de inscriptos.
- **Objetivo:** Permitir un control de la ocupación de cada disciplina y verificar disponibilidad de cupos.
- **Tablas que lo componen:**
  - `disciplinas`
  - `inscripciones`

---

## Funciones

### 1. calcular_edad(fecha_nac DATE)

- **Descripción:** Calcula la edad exacta de un socio a partir de su fecha de nacimiento.
- **Objetivo:** Automatizar el cálculo de edad sin necesidad de ingresarla manualmente.
- **Tablas que lo componen:**
  - No depende de tablas directamente, solo de un parámetro de fecha.

---

### 2. monto_total_pagado(idSocio INT)

- **Descripción:** Retorna el monto total acumulado que un socio ha abonado en el club.
- **Objetivo:** Consultar de manera rápida los aportes económicos de un socio.
- **Tablas que lo componen:**
  - `pagos_mensuales`

---

## Stored Procedures

### 1. registrar_pago(p_id_socio, p_mes, p_anio, p_monto)

- **Descripción:** Inserta un nuevo registro de pago mensual realizado por un socio.
- **Objetivo:** Agilizar y estandarizar el registro de pagos.
- **Tablas que lo componen:**
  - `pagos_mensuales`

---

### 2. inscribir_socio(p_id_socio, p_id_disciplina)

- **Descripción:** Registra la inscripción de un socio en una disciplina, evitando duplicaciones.
- **Objetivo:** Garantizar que un socio pueda anotarse a una disciplina solo una vez.
- **Tablas que lo componen:**
  - `inscripciones`
  - `socios`
  - `disciplinas`

---

### 3. reporte_pagos_por_mes(p_mes, p_anio)

- **Descripción:** Genera un reporte con el total recaudado en un mes y año específicos.
- **Objetivo:** Brindar información financiera periódica para la gestión del club.
- **Tablas que lo componen:**
  - `pagos_mensuales`

---

## Triggers

### 1. validar_cupo_inscripcion

- **Descripción:** Antes de insertar una nueva inscripción, valida que la disciplina aún tenga cupos disponibles.
- **Objetivo:** Evitar que se supere el número máximo de socios permitidos en una disciplina.
- **Tablas que lo componen:**
  - `inscripciones`
  - `disciplinas`

---

### 2. actualizar_edad

- **Descripción:** Calcula automáticamente la edad de un socio en base a su fecha de nacimiento antes de insertarlo en la tabla.
- **Objetivo:** Mantener actualizada la información de edad de los socios sin intervención manual.
- **Tablas que lo componen:**
  - `socios`

---

# Conclusión

La base de datos del **Club Deportivo Posadas** cubre de manera integral la gestión de socios, disciplinas, entrenadores, pagos e inscripciones.  
Gracias al uso de **funciones, procedimientos, triggers y vistas**, se logra automatizar procesos clave, evitar errores humanos y contar con información clara y accesible para la administración del club.

---
