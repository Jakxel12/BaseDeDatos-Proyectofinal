--consultas
SELECT id_alumno 
FROM historial_alumnos_grupos
WHERE fecha_fin IS NOT NULL;
--Obtener las matriculas de alumnos con el historial de grupos:
SELECT 
    m.id_matricula, 
    a.nombre_alumno, 
    h.id_grupo, 
    g.nombre_grupo
FROM 
    matriculas m
JOIN 
    historial_alumnos_grupos h ON m.id_alumno = h.id_alumno
JOIN 
    alumnos a ON h.id_alumno = a.id_alumno
JOIN 
    grupos g ON h.id_grupo = g.id_grupo;
--Consultar el curso más popular (el curso con más matriculas):
SELECT nombre_curso 
FROM cursos 
WHERE id_curso = (
    SELECT id_curso 
    FROM matriculas 
    GROUP BY id_curso 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);
