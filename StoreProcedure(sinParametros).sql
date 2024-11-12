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
