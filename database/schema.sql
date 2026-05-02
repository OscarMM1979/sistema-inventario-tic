-- Sistema de Gestion y Monitoreo de Inventario TIC
-- Alcaldia de Santiago de Cali
-- Version: v1.0 | Fecha: 31/03/2026
-- ============================================================

-- 1. TABLAS PADRE (sin dependencias)
-- Tabla: usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL COMMENT 'Nombre completo del usuario',
    correo VARCHAR(100) NOT NULL UNIQUE COMMENT 'Correo electronico institucional',
    rol VARCHAR(50) DEFAULT 'tecnico' COMMENT 'Rol: admin, tecnico, supervisor',
    contrasena VARCHAR(255) NOT NULL COMMENT 'Contrasena encriptada',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABLAS HIJO (con claves foraneas)
-- Tabla: equipos
CREATE TABLE equipos (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_equipo VARCHAR(100) NOT NULL COMMENT 'Nombre o identificacion del equipo',
    tipo VARCHAR(50) NOT NULL COMMENT 'Tipo: computador, impresora, servidor, etc',
    estado VARCHAR(50) NOT NULL COMMENT 'Estado: activo, inactivo, mantenimiento, baja',
    ubicacion VARCHAR(100) COMMENT 'Ubicacion fisica en la entidad',
    id_usuario INT NOT NULL COMMENT 'Usuario responsable del equipo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_equipos_usuario FOREIGN KEY (id_usuario) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: mantenimientos
CREATE TABLE mantenimientos (
    id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL COMMENT 'Fecha en que se realizo el mantenimiento',
    descripcion TEXT COMMENT 'Detalle de trabajos realizados',
    tipo_mantenimiento VARCHAR(50) NOT NULL COMMENT 'Tipo: preventivo, correctivo, predictivo',
    id_equipo INT NOT NULL COMMENT 'Equipo al que se le realizo mantenimiento',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_mantenimientos_equipo FOREIGN KEY (id_equipo) 
        REFERENCES equipos(id_equipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: alertas
CREATE TABLE alertas (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    tipo_alerta VARCHAR(50) NOT NULL COMMENT 'Tipo: critica, advertencia, informativa',
    descripcion TEXT COMMENT 'Descripcion detallada de la alerta',
    fecha TIMESTAMP NOT NULL COMMENT 'Momento en que se genero la alerta',
    id_equipo INT NOT NULL COMMENT 'Equipo que genero la alerta',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_alertas_equipo FOREIGN KEY (id_equipo) 
        REFERENCES equipos(id_equipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: monitoreo
CREATE TABLE monitoreo (
    id_monitoreo INT AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP NOT NULL COMMENT 'Fecha y hora de la recoleccion',
    estado_equipo VARCHAR(50) NOT NULL COMMENT 'Estado detectado del equipo',
    alerta_detectada BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Indica si se detecto anomalia',
    id_equipo INT NOT NULL COMMENT 'Equipo monitoreado',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_monitoreo_equipo FOREIGN KEY (id_equipo) 
        REFERENCES equipos(id_equipo) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- INDICES
CREATE INDEX idx_equipo_usuario ON equipos(id_usuario);
CREATE INDEX idx_mantenimiento_fecha ON mantenimientos(fecha);
CREATE INDEX idx_mantenimiento_equipo ON mantenimientos(id_equipo);
CREATE INDEX idx_alerta_fecha ON alertas(fecha);
CREATE INDEX idx_alerta_tipo ON alertas(tipo_alerta);
CREATE INDEX idx_alerta_equipo ON alertas(id_equipo);
CREATE INDEX idx_monitoreo_fecha ON monitoreo(fecha);
CREATE INDEX idx_monitoreo_equipo ON monitoreo(id_equipo);