--Crear base de datos
Create database Universidad
--Hacer uso de la base de datos
use Universidad

------------------------------------------------------------------------Crear tablas------------------------------------------------------------------------

  
-- Tabla de cursos
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY
);

-- Tabla de profesores
CREATE TABLE profesores (
    id_profesor INT PRIMARY KEY,
);

-- Tabla de grupos
CREATE TABLE grupos (
    id_grupo INT PRIMARY KEY,
    id_profesor INT,
    id_curso INT,
    activo bit DEFAULT 1,
    FOREIGN KEY (id_profesor) REFERENCES profesores(id_profesor),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

-- Tabla de historial de profesores en grupos (cambios de profesor en un grupo)
CREATE TABLE historial_profesores_grupos (
	id_historial INT IDENTITY(1,1),
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
	id_historial INT IDENTITY(1,1) PRIMARY KEY, 
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


-------------------------------------------------------------------------INSERCION-------------------------------------------------------------------------------------
-- Insertar un curso
INSERT INTO cursos (id_curso)
VALUES (1);

-- Insertar un profesor
INSERT INTO profesores (id_profesor, nombre)
VALUES (1, 'Juan Pérez');
INSERT INTO profesores (id_profesor, nombre)
VALUES (2, 'Pedro Rios');

-- Insertar un grupo
INSERT INTO grupos (id_grupo, id_profesor, id_curso, activo)
VALUES (1, 1, 1, 1);
select * from grupos
-- Insertar un alumno
INSERT INTO alumnos (id_alumno)
VALUES (1);

-- Insertar una matrícula
INSERT INTO matriculas (id_matricula, id_curso, id_alumno)
VALUES (1, 1, 1);
select * from matriculas

--insertar historial alumnos grupos
insert into historial_alumnos_grupos (id_historial,id_alumno, id_grupo, fecha_inicio, fecha_fin) values (1, 1, 1, '2024-08-08', '2024-11-10')

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
SET id_curso = 1
WHERE id_matricula = 1;

--------------------------------------Eliiminar--------------------------------------------

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

----------------------------------------------------------------------------consultas---------------------------------------------------------------------------
SELECT id_alumno 
FROM historial_alumnos_grupos
WHERE fecha_fin IS NOT NULL;
--Obtener las matriculas de alumnos con el historial de grupos:
SELECT 
    m.id_matricula, 
    h.id_grupo
FROM 
    matriculas m
JOIN 
    historial_alumnos_grupos h ON m.id_alumno = h.id_alumno
JOIN 
    alumnos a ON h.id_alumno = a.id_alumno
JOIN 
    grupos g ON h.id_grupo = g.id_grupo;
--Consultar el curso más popular (el curso con más matriculas):
SELECT id_curso
FROM cursos
WHERE id_curso IN (
    SELECT TOP 100 PERCENT id_curso
    FROM matriculas
    GROUP BY id_curso
    ORDER BY COUNT(*) DESC
);


----------------------------------------------------------------------------vistas-------------------------------------------------------------------------
CREATE VIEW VistaGruposActivos AS
SELECT 
    id_grupo,
    id_profesor,
    id_curso,
    activo
FROM grupos
WHERE activo = 1;


select * from VistaGruposActivos;
------------------------------------------------------------------------Funciones------------------------------------------------------------------------
-- Primera Función: udfEstadoGrupo
CREATE FUNCTION dbo.udfEstadoGrupo(@Activo BIT) --Define la función con un parámetro de entrada "@Activo" de tipo "BIT"
RETURNS NVARCHAR(20) -- Indica que la función devolverá un valor de tipo "NVARCHAR" con un máximo de 20 caracteres.
AS
BEGIN
    -- Declara una variable "@Estado" de tipo "NVARCHAR(20)" para almacenar el resultado.
    DECLARE @Estado NVARCHAR(20);
    
    -- Asigna un valor a "@Estado" basado en el valor de "@Activo".
    SET @Estado = CASE 
        WHEN @Activo = 1 THEN 'Activo'      -- Si "@Activo" es 1, asigna 'Activo'.
        WHEN @Activo = 0 THEN 'Inactivo'    -- Si "@Activo" es 0, asigna 'Inactivo'.
        ELSE '**Desconocido**'              -- Si "@Activo" tiene un valor diferente, asigna '**Desconocido**'.
    END;
    
    RETURN @Estado; -- Devuelve el valor de "@Estado" como resultado de la función.
END;
GO
--hacer select a la funcion
select dbo.udfEstadoGrupo (1);
    
-- Segunda Función: udfDescripcionCancelacion
    
CREATE FUNCTION dbo.udfDescripcionCancelacion(@TipoCancelacion INT) -- Define la función con un parámetro de entrada "@TipoCancelacion".
RETURNS NVARCHAR(50) -- Indica que la función devolverá un valor de tipo "NVARCHAR" con un máximo de 50 caracteres.
AS
BEGIN
    -- Declara una variable "@Descripcion" de tipo "NVARCHAR(50)" para almacenar el resultado.
    DECLARE @Descripcion NVARCHAR(50);

    -- Asigna un valor a "@Descripcion" basado en el valor de "@TipoCancelacion".
    SET @Descripcion = CASE 
        WHEN @TipoCancelacion = 1 THEN 'Motivo personal'   -- Si es 1, asigna 'Motivo personal'.
        WHEN @TipoCancelacion = 2 THEN 'Problema técnico'  -- Si es 2, asigna 'Problema técnico'.
        WHEN @TipoCancelacion = 3 THEN 'Clima adverso'     -- Si es 3, asigna 'Clima adverso'.
        WHEN @TipoCancelacion = 4 THEN 'Reunión urgente'   -- Si es 4, asigna 'Reunión urgente'.
        ELSE 'Otro'                                        -- Para cualquier otro valor, asigna 'Otro'.
    END;

    RETURN @Descripcion; -- Devuelve el valor de "@Descripcion" como resultado de la función.
END;

GO
--hacer select a la funcion
select dbo.udfDescripcionCancelacion (1);
    
-- Tercera Función: udfNombreProfesor
ALTER TABLE profesores ADD nombre NVARCHAR(100);

CREATE FUNCTION dbo.udfNombreProfesor(@IdProfesor INT) -- Define la función con un parámetro de entrada "@IdProfesor".
RETURNS NVARCHAR(100) -- Indica que la función devolverá un valor de tipo "NVARCHAR" con un máximo de 100 caracteres.
AS
BEGIN
    -- Declara una variable "@Nombre" de tipo "NVARCHAR(100)" para almacenar el resultado.
    DECLARE @Nombre NVARCHAR(100);

    -- Realiza una consulta para obtener el nombre del profesor basado en el "id_profesor".
    SELECT @Nombre = nombre -- Asigna el valor del campo "nombre" a la variable "@Nombre".
    FROM profesores         -- Utiliza la tabla "profesores".
    WHERE id_profesor = @IdProfesor; -- Condición para buscar por "id_profesor".

    -- Si no se encuentra un nombre, devuelve '**No encontrado**'.
    RETURN ISNULL(@Nombre, '**No encontrado**');
END;
GO
--hacer select a la funcion
select dbo.udfNombreProfesor(1);

--Tabla grupos: Utilizada para la función udfEstadoGrupo.--
--Tabla clases: Utilizada para la función udfDescripcionCancelacion.--
--Tabla profesores: Utilizada para la función udfNombreProfesor. 

------------------------------------------------------------------------store procedure con parametros------------------------------------------------------------------------
--crear procedimiento
sp_help 'historial_profesores_grupos';

CREATE PROCEDURE sp_cambiar_profesor_grupo
(
    @p_id_grupo INT,
    @p_id_profesor_nuevo INT,
    @p_fecha_cambio DATE
)
AS
BEGIN
    -- Iniciar transacción
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Declaración de variables locales
        DECLARE @v_id_profesor_actual INT;

        -- 1. Obtener el profesor actual del grupo
        SELECT @v_id_profesor_actual = id_profesor
        FROM grupos
        WHERE id_grupo = @p_id_grupo;

        -- Verificar que el grupo existe y tiene un profesor asignado
        IF @v_id_profesor_actual IS NULL
        BEGIN
            THROW 50001, 'Grupo no encontrado o sin profesor asignado', 1;
        END
        
        -- 2. Comprobar si el profesor ha cambiado
        IF @v_id_profesor_actual <> @p_id_profesor_nuevo
        BEGIN
            -- 3. Cerrar el registro en historial para el profesor actual
            UPDATE historial_profesores_grupos
            SET fecha_fin = @p_fecha_cambio
            WHERE id_grupo = @p_id_grupo
              AND fecha_fin IS NULL;

            -- 4. Insertar un nuevo registro en historial para el nuevo profesor
            INSERT INTO historial_profesores_grupos (id_grupo, id_profesor, fecha_inicio, fecha_fin)
            VALUES (@p_id_grupo, @p_id_profesor_nuevo, @p_fecha_cambio, NULL);

            -- 5. Actualizar el grupo con el nuevo profesor
            UPDATE grupos
            SET id_profesor = @p_id_profesor_nuevo
            WHERE id_grupo = @p_id_grupo;
        END

        -- Confirmar la transacción
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Revertir la transacción en caso de error
        ROLLBACK;

        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;

DECLARE @id_grupo INT = 1;           -- ID del grupo que deseas actualizar
DECLARE @id_profesor_nuevo INT = 2;  -- ID del nuevo profesor
DECLARE @fecha_cambio DATE = '2024-11-11'; -- Fecha del cambio de profesor

EXEC sp_cambiar_profesor_grupo 
    @p_id_grupo = @id_grupo, 
    @p_id_profesor_nuevo = @id_profesor_nuevo, 
    @p_fecha_cambio = @fecha_cambio;

------------------------------------------------------------------------StoreProcedure sin parametros------------------------------------------------------------------------


-- Se crea un procedimiento almacenado llamado sp_GetClassDetails sin parámetros de entrada
CREATE PROCEDURE GetClassDetails
AS
BEGIN
    -- Inicio de la instrucción SELECT para definir los campos que se obtendrán en la consulta
    SELECT 
        c.id_clase,                 -- Selecciona el ID de la clase de la tabla 'clases'
        p.id_profesor,              -- Selecciona el ID del profesor de la tabla 'profesores'
        c.id_tipocancelacion,       -- Selecciona el ID del tipo de cancelación de la clase
        c.id_horario,               -- Selecciona el ID del horario de la clase
        c.id_tipotarea,             -- Selecciona el ID del tipo de tarea de la clase
        c.id_profesor               -- Selecciona nuevamente el ID del profesor desde la tabla 'clases'
    FROM 
        clases c                    -- Tabla principal de la consulta
    JOIN 
        profesores p ON c.id_profesor = p.id_profesor; -- JOIN para relacionar la tabla 'clases' con 'profesores' usando el ID de profesor
END;
GO
-- Ejecuta el procedimiento almacenado creado para mostrar los detalles de las clases
EXEC GetClassDetails

------------------------------------------------------------------------Trigger------------------------------------------------------------------------
-- Tabla de auditoría para registrar cambios en la tabla 'grupos'
	 -- ID único para cada registro en la auditoría
	 -- ID del grupo que sufrió el cambio
	 -- ID del profesor asignado en el grupo en el momento del cambio
	 -- ID del curso asignado en el grupo en el momento del cambio
	 -- Estado de actividad del grupo en el momento del cambio
	 -- Tipo de acción realizada: 'INSERT', 'UPDATE', o 'DELETE'
	 -- Fecha y hora del cambio
	 -- Nombre del usuario que realiza el cambio (si es aplicable)
CREATE TABLE auditoria_grupos (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    id_grupo INT, 
    id_profesor INT, 
    id_curso INT,
    activo bit default 1,
    accion VARCHAR(50), 
    fecha_cambio DATETIME DEFAULT GETDATE(), 
    usuario VARCHAR(100) 
);

-- Trigger para registrar inserciones en la tabla 'grupos'
CREATE TRIGGER tr_insert_grupos
ON grupos
AFTER INSERT --Disparador se ativa despues de hacer incerciones en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron insertados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'INSERT' -- Especifica la acción como 'INSERT'
    FROM inserted; -- Usa la tabla 'inserted' para obtener los valores nuevos
END;

-- Trigger para registrar actualizaciones en la tabla 'grupos'
CREATE TRIGGER tr_update_grupos
ON grupos
AFTER UPDATE --Disparador se ativa despues de hacer actualizaciones en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron actualizados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'UPDATE' -- Especifica la acción como 'UPDATE'
    FROM inserted; -- Usa la tabla 'inserted' para obtener los valores después de la actualización
END;

-- Trigger para registrar eliminaciones en la tabla 'grupos'
CREATE TRIGGER tr_delete_grupos
ON grupos
AFTER DELETE --Disparador se ativa despues de hacer bajas en tabla 'grupos'
AS
BEGIN
    -- Inserta en la tabla de auditoría la información de los registros que fueron eliminados
    INSERT INTO auditoria_grupos (id_grupo, id_profesor, id_curso, activo, accion)
    SELECT id_grupo, id_profesor, id_curso, activo, 'DELETE' -- Especifica la acción como 'DELETE'
    FROM deleted; -- Usa la tabla 'deleted' para obtener los valores antes de la eliminación
END;


