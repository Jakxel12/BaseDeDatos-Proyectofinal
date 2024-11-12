--Crear base de datos
Create database Universidad
--Hacer uso de la base de datos
use Universidad

-- Tabla de cursos
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY
);

-- Tabla de profesores
CREATE TABLE profesores (
    id_profesor INT PRIMARY KEY
);

-- Tabla de grupos
CREATE TABLE grupos (
    id_grupo INT PRIMARY KEY,
    id_profesor INT,
    id_curso INT,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

-- Tabla de historial de profesores en grupos (cambios de profesor en un grupo)
CREATE TABLE historial_profesores_grupos (
    id_historial INT PRIMARY KEY,
    id_grupo INT,
    id_profesor INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo),
    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor)
);

-- Tabla de tipos de tarea
CREATE TABLE tipos_de_tarea (
    id_tipotarea INT PRIMARY KEY
);

-- Tabla de horarios
CREATE TABLE horarios (
    id_horario INT PRIMARY KEY,
    id_profesor INT,
    id_grupo INT,
    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
);

-- Tabla de tipos de cancelación
CREATE TABLE tipos_de_cancelacion (
    id_tipocancelacion INT PRIMARY KEY
);

-- Tabla de clases
CREATE TABLE clases (
    id_clase INT PRIMARY KEY,
    id_tipocancelacion INT,
    id_horario INT,
    id_tipotarea INT,
    id_profesor INT,
    FOREIGN KEY (id_tipocancelacion) REFERENCES tipos_de_cancelacion(id_tipocancelacion),
    FOREIGN KEY (id_horario) REFERENCES horarios(id_horario),
    FOREIGN KEY (id_tipotarea) REFERENCES tipos_de_tarea(id_tipotarea),
    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor)
);

-- Tabla de alumnos
CREATE TABLE alumnos (
    id_alumno INT PRIMARY KEY
);

-- Tabla de matrículas
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY,
    id_curso INT,
    id_alumno INT,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

-- Tabla de historial de alumnos en grupos (cambios de grupo de un alumno)
CREATE TABLE historial_alumnos_grupos (
    id_historial INT PRIMARY KEY,
    id_alumno INT,
    id_grupo INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
);

-- Tabla de alumnos en grupos
CREATE TABLE alumnos_en_grupos (
    id_alumnoengrupo INT PRIMARY KEY,
    id_matricula INT,
    FOREIGN KEY (id_matricula) REFERENCES matriculas(id_matricula)
);

-- Tabla de asistencia
CREATE TABLE asistencia (
    id_asistencia INT PRIMARY KEY,
    id_clase INT,
    id_alumnoengrupo INT,
    FOREIGN KEY (id_clase) REFERENCES clases(id_clase),
    FOREIGN KEY (id_alumnoengrupo) REFERENCES alumnos_en_grupos(id_alumnoengrupo)
);

-- Tabla de cancelaciones de clases
CREATE TABLE cancelaciones_clases (
    id_cancelacion INT PRIMARY KEY,
    id_clase INT,
    fecha_cancelacion DATE,
    motivo_cancelacion VARCHAR(255),
    FOREIGN KEY (id_clase) REFERENCES clases(id_clase)
);

-- Tabla de sustituciones de profesores en clases
CREATE TABLE sustituciones (
    id_sustitucion INT PRIMARY KEY,
    id_clase INT,
    id_profesor_original INT,
    id_profesor_sustituto INT,
    fecha DATE,
    FOREIGN KEY (id_clase) REFERENCES clases(id_clase),
    FOREIGN KEY (id_profesor_original) REFERENCES profesores(id_profesor),
    FOREIGN KEY (id_profesor_sustituto) REFERENCES profesores(id_profesor)
);

-- Tabla de historial de grupos (cierre de grupos)
CREATE TABLE historial_grupos (
    id_historial INT PRIMARY KEY,
    id_grupo INT,
    fecha_cierre DATE,
    motivo_cierre VARCHAR(255),
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo)
);
