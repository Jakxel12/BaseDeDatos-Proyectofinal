CREATE VIEW VistaGruposActivos AS
SELECT 
    id_grupo,
    id_profesor,
    id_curso,
    activo
FROM grupos
WHERE activo = 1;
