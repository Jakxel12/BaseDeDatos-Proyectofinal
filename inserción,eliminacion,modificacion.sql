------------------------------------INSERCION---------------------------------------
-- Insertar un curso
INSERT INTO cursos (id_curso)
VALUES (1);

-- Insertar un profesor
INSERT INTO profesores (id_profesor, nombre)
VALUES (1, 'Juan Pérez');

-- Insertar un grupo
INSERT INTO grupos (id_grupo, id_profesor, id_curso, activo)
VALUES (1, 1, 1, 1);

-- Insertar un alumno
INSERT INTO alumnos (id_alumno)
VALUES (1);

-- Insertar una matrícula
INSERT INTO matriculas (id_matricula, id_curso, id_alumno)
VALUES (1, 1, 1);

--------------------------------------MODIFICAR-------------------------------------------

-- Actualizar el nombre de un profesor
UPDATE profesores
SET nombre = 'Carlos López'
WHERE id_profesor = 1;

-- Cambiar el estado de un grupo a inactivo
UPDATE grupos
SET activo = 0
WHERE id_grupo = 1;

-- Cambiar el curso asociado a una matrícula
UPDATE matriculas
SET id_curso = 2
WHERE id_matricula = 1;

--------------------------------------EMILINAR--------------------------------------------

-- Eliminar un curso
DELETE FROM cursos
WHERE id_curso = 1;

-- Eliminar un profesor
DELETE FROM profesores
WHERE id_profesor = 1;

-- Eliminar un grupo
DELETE FROM grupos
WHERE id_grupo = 1;

-- Eliminar un alumno
DELETE FROM alumnos
WHERE id_alumno = 1;
