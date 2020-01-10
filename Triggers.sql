-------- 3 ENTREGABLE IISSI 1 - RESTAURANTE SEVILLA --------

/*
Contiene la creación de todos los triggers y los casos de prueba necesarios para su prueba.
*/

-------- TRIGGERS ASOCIADOS A REGLAS DE NEGOCIO --------
/* RN001. Una misma mesa no puede ser reservada por más de un cliente y no puede hacer
una reserva si el nº de personas es mayor a la capacidad de las mesa */
CREATE OR REPLACE TRIGGER TR_exclusividad_mesas BEFORE INSERT ON Reservas FOR EACH ROW
DECLARE
disponibilidad SMALLINT;
capacidad_mesa SMALLINT;
BEGIN
	SELECT disponible INTO disponibilidad FROM Mesas WHERE idMesa = :NEW.mesa;
	SELECT capacidad INTO capacidad_mesa FROM Mesas WHERE idMesa = :NEW.mesa;
    IF (disponibilidad <> 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La mesa elegida ya se encuentra reservada');
    END IF;
	IF (capacidad_mesa < :NEW.numPersonas) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La mesa elegida tiene una capacidad inferior a ' ||:NEW.numPersonas|| ' personas');
    END IF;
END;
/

/* Prueba del trigger 1 */
EXECUTE insertReservas(TO_DATE('2019-12-11-09:46', 'YYYY-MM-DD-hh24:mi'), 4, 1, 1);
EXECUTE insertReservas(TO_DATE('2019-12-11-09:46', 'YYYY-MM-DD-hh24:mi'), 5, 1, 1);

/* RN002. Un cliente no puede realizar más de una reserva en una miasma hora */
CREATE OR REPLACE TRIGGER TR_derecho_reserva BEFORE INSERT ON Reservas FOR EACH ROW
DECLARE 
    contador SMALLINT;
BEGIN
    SELECT COUNT(*) INTO contador FROM Reservas WHERE (usuario = :NEW.usuario AND fecha = :NEW.fecha);
    IF (contador > 0) THEN
        RAISE_APPLICATION_ERROR(-20003, 'No puede reservar más de una mesa en la misma hora');
    END IF;
END;
/

/* Prueba del trigger 2 */
EXECUTE insertReservas(TO_DATE('2019-12-11-09:46', 'YYYY-MM-DD-hh24:mi'), 4, 1, 1);
EXECUTE insertReservas(TO_DATE('2019-12-11-09:46', 'YYYY-MM-DD-hh24:mi'), 4, 2, 1);

/* RN003. Un cliente puede hacer, como máximo, 2 reservas al día */
CREATE TRIGGER TR_limite_reservas BEFORE INSERT ON Reservas FOR EACH ROW
DECLARE
    contador INTEGER;
BEGIN
    SELECT COUNT(*) INTO contador FROM Reservas WHERE (usuario = :NEW.usuario AND TO_CHAR(fecha, 'YYYY/MM/DD') = TO_CHAR(:NEW.fecha, 'YYYY/MM/DD'));
    IF (contador > 1) THEN
        RAISE_APPLICATION_ERROR(-20004, 'No puede realizar más de 2 reservas al día');
    END IF;
END;
/

/* Prueba del trigger 3 */
EXECUTE insertReservas(TO_DATE('2019-12-11-14:00', 'YYYY-MM-DD-hh24:mi'), 4, 7, 1);
EXECUTE insertReservas(TO_DATE('2019-12-11-22:00', 'YYYY-MM-DD-hh24:mi'), 4, 7, 1);

/* RN004. Un producto nulo no puede incluirse en el menú */
CREATE TRIGGER TR_producto_disponible BEFORE UPDATE OR INSERT ON ProductoMenu FOR EACH ROW
DECLARE
    disponible SMALLINT;
BEGIN 
    SELECT disponibilidad INTO disponible FROM Productos WHERE idProducto = :NEW.idProducto;
    IF (disponible = 0) THEN
        RAISE_APPLICATION_ERROR(-20005, 'Producto no disponible');
    END IF;
END;
/

/* Prueba del trigger 4 */
EXECUTE insertProductoMenu ('Bebida', 4, 2);

-------- TRIGGERS ASOCIADOS A REQUISITOS --------
/* Cambia la disponibilidad de la mesa cuando es reservada */
CREATE TRIGGER TR_cambia_disponibilidad AFTER INSERT ON Reservas FOR EACH ROW
DECLARE
    mesaReservada SMALLINT;
BEGIN 
    SELECT idMesa INTO mesaReservada FROM Mesas WHERE idMesa = :NEW.mesa;
    UPDATE Mesas SET disponible = 0 WHERE idMesa = mesaReservada;
END;
/
