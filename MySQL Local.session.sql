-- DROP DATABASE spotify;
CREATE DATABASE IF NOT EXISTS spotify;
USE spotify;
CREATE TABLE IF NOT EXISTS usuarios (
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
CREATE TABLE IF NOT EXISTS usuarios_premium (
    usuario_premium_id INT PRIMARY KEY,
    fecha_inicio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP NULL,
    nivel ENUM('BASICO', 'PREMIUM') DEFAULT 'BASICO',
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS suscripciones_premium (
    suscripcion_premium_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_premium_id INT NOT NULL,
    fecha_inicio_suscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin_suscripcion TIMESTAMP NULL,
    metodo_pago ENUM('TARJETA_CREDITO', 'PAYPAL', 'TRANSFERENCIA') NOT NULL,
    estado ENUM('ACTIVA', 'CANCELADA', 'SUSPENDIDA') DEFAULT 'ACTIVA',
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS tarjeta (
    tarjeta_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_premium_id INT NOT NULL,
    numero_tarjeta INT(16) NOT NULL,
    nombre_titular VARCHAR(100) NOT NULL,
    fecha_expiracion DATE NOT NULL,
    codigo_seguridad INT(4) NOT NULL,
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS paypal (
    paypal_id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_premium_id INT NOT NULL,
    email_paypal VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS registro_pago (
    registro_pago_id INT PRIMARY KEY AUTO_INCREMENT,
    tarjeta_id INT NOT NULL,
    paypal_id INT NOT NULL,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cantidad DECIMAL(10, 2) NOT NULL,
    metodo_pago ENUM('TARJETA_CREDITO', 'PAYPAL', 'TRANSFERENCIA') NOT NULL,
    estado_pago ENUM('COMPLETADO', 'PENDIENTE', 'FALLIDO') DEFAULT 'PENDIENTE',
    FOREIGN KEY (tarjeta_id) REFERENCES tarjeta(tarjeta_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (paypal_id) REFERENCES paypal(paypal_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS playlist_activa (
    playlist_activa_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    numero_canciones INT DEFAULT 0,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_premium_id INT NOT NULL,
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS playlist_borrada (
    playlist_borrada_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    numero_canciones INT DEFAULT 0,
    descripcion TEXT,
    playlist_activa_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_borrado TIMESTAMP NULL,
    usuario_premium_id INT NOT NULL,
    FOREIGN KEY (playlist_activa_id) REFERENCES playlist_activa(playlist_activa_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS artistas (
    artista_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    genero_musical VARCHAR(50),
    pais_origen VARCHAR(50),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS albumes (
    album_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    fecha_lanzamiento DATE,
    genero VARCHAR(50),
    artista_id INT NOT NULL,
    FOREIGN KEY (artista_id) REFERENCES artistas(artista_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS canciones (
    cancion_id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    duracion TIME,
    numero_reproducciones INT NOT NULL,
    genero VARCHAR(50),
    album_id INT NOT NULL,
    artista_id INT NOT NULL,
    FOREIGN KEY (album_id) REFERENCES albumes(album_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (artista_id) REFERENCES artistas(artista_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS cancion_added (
    cancion_added_id INT PRIMARY KEY AUTO_INCREMENT,
    cancion_id INT NOT NULL,
    playlist_activa_id INT NOT NULL,
    usuario_premium_id INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (playlist_activa_id) REFERENCES playlist_activa(playlist_activa_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_premium_id) REFERENCES usuarios_premium(usuario_premium_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Ejemplo de inserción de datos
SELECT *
FROM usuarios;