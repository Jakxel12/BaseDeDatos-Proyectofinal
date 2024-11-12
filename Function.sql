-- Primera Función: udfEstadoGrupo
CREATE FUNCTION dbo.udfEstadoGrupo(@Activo BIT) -- Define la función con un parámetro de entrada "@Activo" de tipo "BIT".
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

    
-- Tercera Función: udfNombreProfesor

    
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

--Tabla grupos: Utilizada para la función udfEstadoGrupo.--
--Tabla clases: Utilizada para la función udfDescripcionCancelacion.--
--Tabla profesores: Utilizada para la función udfNombreProfesor. 
