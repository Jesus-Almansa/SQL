CREATE DATABASE cursoSQL;
use cursoSQL;
CREATE TABLE usuarios (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sexo ENUM('M', 'F', 'O') NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    ultimo_acceso DATETIME
);
CREATE TABLE usuarios_premium (
    usuario_premium_id INT PRIMARY KEY,
    fecha_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP NULL,
    nivel ENUM('BASICO', 'PREMIUM') DEFAULT 'BASICO',
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE suscripciones_premium (
    suscripcion_premium_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_premium_id INT NOT NULL,
    fecha_inicio_suscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin_suscripcion TIMESTAMP NULL,
    metodo_pago ENUM('TARJETA_CREDITO', 'PAYPAL', 'TRANSFERENCIA') NOT NULL,
    estado ENUM('ACTIVA', 'CANCELADA', 'SUSPENDIDA') DEFAULT 'ACTIVA',
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
SELECT *
FROM usuarios;
-- DROP DATABASE cursoSQL;