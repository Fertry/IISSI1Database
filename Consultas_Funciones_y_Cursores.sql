-------- 3 ENTREGABLE IISSI 1 - RESTAURANTE SEVILLA --------

/*
Contiene la creación y prueba de las consultas, cursores y funciones asociados a requisitos funcionales.
*/

-------- CONSULTAS --------
/* Cuenta todos los objetos que hay en cada tabla */
SELECT count(idCarta) FROM Cartas;
SELECT count(idProducto) FROM Productos;
SELECT count(idProductoCarta) FROM ProductoCarta;
SELECT count(idMenu) FROM Menus;
SELECT count(idProductoMenu) FROM ProductoMenu;
SELECT count(idAlergeno) FROM Alergenos;
SELECT count(OIDContiene) FROM Contiene;
SELECT count(idUsuario) FROM Usuarios;
SELECT count(idComanda) FROM Comandas;
SELECT count(idMesa) FROM Mesas;
SELECT count(idReserva) FROM Reservas;

/* Consultas asociadas a requisitos funcionales */

/* RF1 - Listado de reservas dado un idUsuario */
SELECT * FROM Reservas R, Usuarios U WHERE R.usuario = U.idUsuario;

/* RF2 - Listado de comandas emitidas por cada maître */
SELECT * FROM Comandas C, Usuarios U WHERE C.usuario = U.idUsuario ORDER BY importe DESC;

/* RF3 - Listado de alergenos asociados a productos */
SELECT idProducto, nombre FROM Contiene C, Alergenos A WHERE C.idAlergeno = A.idAlergeno;

/* RF4 - Listado de todos los productos */
SELECT * FROM Productos WHERE disponibilidad > 0 ORDER BY precioProducto DESC; 

/* RF5 - Sumatorio del importe de todas las comandas del mes */
SELECT SUM(importe) FROM Comandas WHERE TO_CHAR(fecha, 'yyyy/mm') = TO_CHAR(SYSDATE, 'yyyy/mm');

-------- CURSORES --------
SET SERVEROUTPUT ON

/* RF6 - Listado de reservas por antigüedad */
-- Las tres reservas más antiguas
CREATE OR REPLACE PROCEDURE cursorUno IS
BEGIN
    DECLARE
        CURSOR cUno IS
        SELECT fecha, numPersonas FROM Reservas ORDER BY fecha; 
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Las tres reservas mas antiguas'); 
            FOR fila IN cUno LOOP
                EXIT WHEN cUno%ROWCOUNT >3;
                DBMS_OUTPUT.PUT_LINE(fila.fecha||' '||fila.numPersonas) ; 
            END LOOP;
    END;
END cursorUno;
/

/* RF7 - Listado de productos ordenados alfabéticamente */
-- Los tres primeros productos por orden alfabético
CREATE OR REPLACE PROCEDURE cursorDos IS
BEGIN
    DECLARE
        CURSOR cDos IS
        SELECT idProducto, nombre FROM Productos ORDER BY nombre; 
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Los tres primeros productos por orden alfabético'); 
            FOR fila IN cDos LOOP
                EXIT WHEN cDos%ROWCOUNT >3;
                DBMS_OUTPUT.PUT_LINE(fila.idProducto||' '||fila.nombre) ; 
            END LOOP;
    END;
END cursorDos;
/

/* RF8 - Listado de comandas por fecha */
-- Las tres comandas mas recientes
CREATE OR REPLACE PROCEDURE cursorTres IS
BEGIN
    DECLARE
        CURSOR cTres IS
        SELECT importe, fecha FROM Comandas ORDER BY fecha DESC; 
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Las tres comandas mas recientes'); 
            FOR fila IN cTres LOOP
                EXIT WHEN cTres%ROWCOUNT >3;
                DBMS_OUTPUT.PUT_LINE(fila.fecha||' '||fila.importe) ; 
            END LOOP;
    END;
END cursorTres;
/

--SET SERVEROUTPUT OFF

/* PRUEBA DE CURSORES */
EXECUTE cursorUno;
EXECUTE cursorDos;
EXECUTE cursorTres;

-------- FUNCIONES --------
/* RF9 - Detalles de usuario con id */
/* Pasas una id de usuario y devuelve el nombre del usuario */
CREATE OR REPLACE FUNCTION obtenerNombreConId (idu Usuarios.idUsuario%TYPE)
RETURN VARCHAR2 IS nombreU Usuarios.nombre%TYPE;
BEGIN
    SELECT DISTINCT nombre INTO nombreU FROM Usuarios WHERE idUsuario = idu;
RETURN (nombreU);
END obtenerNombreConId;
/

/* RF10 - Comandas por fecha */
/* Pasas una fecha y devuelve la suma de todas las comandas para esa fecha */
CREATE OR REPLACE FUNCTION obtenerComandasPorFecha (fechaIntroducida IN Comandas.fecha%TYPE)
RETURN FLOAT IS 
total Comandas.importe%TYPE;
BEGIN
    SELECT SUM(importe) INTO total FROM Comandas WHERE (TO_CHAR(fecha, 'yyyy/mm/dd') = TO_CHAR(fechaIntroducida, 'yyyy/mm/dd'));
RETURN (total);
END obtenerComandasPorFecha;
/

/* RF11 - Capacidad de las mesas por id */
/* Pasas el id de una mesa y devuelve la capacidad máxima de dicha mesa  */
CREATE OR REPLACE FUNCTION obtenerCapacidadConId (idm Mesas.idMesa%TYPE)
RETURN VARCHAR2 IS capacidadM Mesas.capacidad%TYPE;
BEGIN
    SELECT DISTINCT capacidad INTO capacidadM FROM Mesas WHERE idMesa = idm;
RETURN (capacidadM);
END obtenerCapacidadConId;
/

/* RF12 - Descripción de alergenos por nombre */
/* Pasas un nombre de un alérgeno y devuelve su descripción asociada */
CREATE OR REPLACE FUNCTION obtenerDescripcionConNombre (nombreA Alergenos.nombre%TYPE)
RETURN VARCHAR2 IS descripcionA Alergenos.descripcion%TYPE;
BEGIN
    SELECT DISTINCT descripcion INTO descripcionA FROM Alergenos WHERE nombre = nombreA;
RETURN (descripcionA);
END obtenerDescripcionConNombre;
/

/* PRUEBA DE FUNCIONES */
SELECT obtenerNombreConId(1) FROM DUAL;
SELECT obtenerComandasPorFecha(TO_DATE('2020/01/11', 'yyyy/mm/dd')) FROM DUAL;
SELECT obtenerCapacidadConId(4) FROM DUAL;
SELECT obtenerDescripcionConNombre('Lactosa') FROM DUAL;
