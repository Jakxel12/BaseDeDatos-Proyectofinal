CREATE VIEW VistaEmpleados AS
SELECT IdEmpleado, Nombre, Departamento, Salario
FROM Empleados
WHERE Activo = 1;
