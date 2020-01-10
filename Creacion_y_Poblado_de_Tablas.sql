-------- 3 ENTREGABLE IISSI 1 - RESTAURANTE SEVILLA --------

/*
Contiene la creación de las tablas, secuencias y procedimientos de INSERT y de UPDATE así
como el poblado de las tablas mediante INSERT y mediante procedimientos. 
*/

-------- CREACIÓN DE TABLAS ----------- 
CREATE TABLE Cartas (     
    idCarta SMALLINT PRIMARY KEY,   
    temporada DATE NOT NULL
);

CREATE TABLE Productos (     
    idProducto SMALLINT PRIMARY KEY,     
    nombre VARCHAR2(100) NOT NULL, 
    descripcion VARCHAR2(200) NOT NULL,     
    tipoProducto VARCHAR2(100) NOT NULL, 
    disponibilidad SMALLINT NOT NULL,     
    precioProducto FLOAT NOT NULL
);

CREATE TABLE ProductoCarta (
    idProductoCarta SMALLINT PRIMARY KEY,
    idCarta SMALLINT,
    idProducto SMALLINT,
    FOREIGN KEY(idCarta) REFERENCES Cartas ON DELETE SET NULL,
    FOREIGN KEY(idProducto) REFERENCES Productos ON DELETE SET NULL
);

CREATE TABLE Menus (     
    idMenu SMALLINT PRIMARY KEY,      
    precio FLOAT NOT NULL UNIQUE,
    carta SMALLINT,
    FOREIGN KEY(carta) REFERENCES Cartas ON DELETE SET NULL
);

CREATE TABLE ProductoMenu (
    idProductoMenu SMALLINT PRIMARY KEY,
    tipoPlato VARCHAR2(50),
    idProducto SMALLINT,
    idMenu SMALLINT,
    FOREIGN KEY (idProducto) REFERENCES Productos ON DELETE SET NULL,
    FOREIGN KEY (idMenu) REFERENCES Menus ON DELETE SET NULL
);

CREATE TABLE Alergenos (     
    idAlergeno SMALLINT PRIMARY KEY,     
    nombre VARCHAR2(100) NOT NULL, 
    descripcion VARCHAR2(200) NOT NULL
);

CREATE TABLE Contiene (     
    OIDContiene SMALLINT PRIMARY KEY,     
    idProducto SMALLINT, 
    idAlergeno SMALLINT,
    FOREIGN KEY(idProducto) REFERENCES Productos ON DELETE SET NULL,
    FOREIGN KEY(idAlergeno) REFERENCES Alergenos ON DELETE SET NULL
);

CREATE TABLE Usuarios (     
    idUsuario SMALLINT PRIMARY KEY,     
    clase VARCHAR2(50) NOT NULL, 
    nombre VARCHAR2(100) NOT NULL,     
    apellidos VARCHAR2(100) NOT NULL, 
    telefono VARCHAR2(15) NOT NULL CHECK (LENGTH (telefono) = 9),
    carta SMALLINT,
    FOREIGN KEY(carta) REFERENCES Cartas ON DELETE SET NULL
);

CREATE TABLE Comandas (     
    idComanda SMALLINT PRIMARY KEY,     
    fecha DATE NOT NULL,    
    importe FLOAT NOT NULL, 
    usuario SMALLINT,
    FOREIGN KEY(usuario) REFERENCES Usuarios ON DELETE SET NULL
);

CREATE TABLE Mesas (     
    idMesa SMALLINT PRIMARY KEY,     
    disponible SMALLINT NOT NULL, 
    capacidad SMALLINT NOT NULL CHECK (capacidad <= 10)
);

CREATE TABLE Reservas (     
    idReserva SMALLINT PRIMARY KEY,     
    fecha DATE NOT NULL,      
    numPersonas SMALLINT NOT NULL CHECK (numPersonas <= 10),
    mesa SMALLINT,     
    usuario SMALLINT,
    FOREIGN KEY(mesa) REFERENCES Mesas ON DELETE SET NULL, 
    FOREIGN KEY(usuario) REFERENCES Usuarios ON DELETE SET NULL
);

-------- CREACIÓN DE SECUENCIAS --------
CREATE SEQUENCE sec_cartas;
CREATE OR REPLACE TRIGGER crea_oid_cartas
BEFORE INSERT ON Cartas
FOR EACH ROW
BEGIN 
SELECT sec_cartas.NEXTVAL INTO :NEW.idCarta FROM DUAL;
END;
/

CREATE SEQUENCE sec_productos;
CREATE OR REPLACE TRIGGER crea_oid_productos
BEFORE INSERT ON Productos
FOR EACH ROW
BEGIN 
SELECT sec_productos.NEXTVAL INTO :NEW.idProducto FROM DUAL;
END;
/

CREATE SEQUENCE sec_producto_carta;
CREATE OR REPLACE TRIGGER crea_oid_producto_carta
BEFORE INSERT ON ProductoCarta
FOR EACH ROW
BEGIN
SELECT sec_producto_carta.NEXTVAL INTO :NEW.idProductoCarta FROM DUAL;
END;
/

CREATE SEQUENCE sec_menus;
CREATE OR REPLACE TRIGGER crea_oid_menus
BEFORE INSERT ON Menus
FOR EACH ROW
BEGIN 
SELECT sec_menus.NEXTVAL INTO :NEW.idMenu FROM DUAL;
END;
/

CREATE SEQUENCE sec_producto_menu;
CREATE OR REPLACE TRIGGER crea_oid_producto_menu
BEFORE INSERT ON ProductoMenu
FOR EACH ROW
BEGIN
SELECT sec_producto_menu.NEXTVAL INTO :NEW.idProductoMenu FROM DUAL;
END;
/

CREATE SEQUENCE sec_alergenos;
CREATE OR REPLACE TRIGGER crea_oid_alergenos
BEFORE INSERT ON Alergenos
FOR EACH ROW
BEGIN 
SELECT sec_alergenos.NEXTVAL INTO :NEW.idAlergeno FROM DUAL;
END;
/

CREATE SEQUENCE sec_contiene;
CREATE OR REPLACE TRIGGER crea_oid_contiene
BEFORE INSERT ON Contiene
FOR EACH ROW
BEGIN 
SELECT sec_contiene.NEXTVAL INTO :NEW.OIDContiene FROM DUAL;
END;
/

CREATE SEQUENCE sec_usuarios;
CREATE OR REPLACE TRIGGER crea_oid_usuarios
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN 
SELECT sec_usuarios.NEXTVAL INTO :NEW.idUsuario FROM DUAL;
END;
/

CREATE SEQUENCE sec_comandas;
CREATE OR REPLACE TRIGGER crea_oid_comandas
BEFORE INSERT ON Comandas
FOR EACH ROW
BEGIN 
SELECT sec_comandas.NEXTVAL INTO :NEW.idComanda FROM DUAL;
END;
/

CREATE SEQUENCE sec_mesas;
CREATE OR REPLACE TRIGGER crea_oid_mesas
BEFORE INSERT ON Mesas
FOR EACH ROW
BEGIN 
SELECT sec_mesas.NEXTVAL INTO :NEW.idMesa FROM DUAL;
END;
/

CREATE SEQUENCE sec_reservas;
CREATE OR REPLACE TRIGGER crea_oid_reservas
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN 
SELECT sec_reservas.NEXTVAL INTO :NEW.idReserva FROM DUAL;
END;
/

-------- PROCEDIMIENTOS --------
/* Procedimientos de INSERT */
CREATE OR REPLACE PROCEDURE insertCartas
(temporada IN DATE) AS 
BEGIN
INSERT INTO Cartas (temporada)
VALUES (temporada);
END insertCartas;
/

CREATE OR REPLACE PROCEDURE insertProductos 
(nombre IN VARCHAR2, descripcion IN VARCHAR2, tipoProducto IN VARCHAR2, disponibilidad IN SMALLINT, precioProducto IN FLOAT) AS 
BEGIN
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) 
VALUES (nombre, descripcion, tipoProducto, disponibilidad, precioProducto);
END insertProductos;
/

CREATE OR REPLACE PROCEDURE insertProductoCarta
(idCarta IN SMALLINT, idProducto IN SMALLINT) AS
BEGIN
INSERT INTO ProductoCarta (idCarta, idProducto) 
VALUES (idCarta, idProducto);
END insertProductoCarta;
/

CREATE OR REPLACE PROCEDURE insertMenus
(precio IN FLOAT, carta IN SMALLINT) AS
BEGIN
INSERT INTO Menus (precio, carta) 
VALUES (precio, carta);
END insertMenus;
/

CREATE OR REPLACE PROCEDURE insertProductoMenu
(tipoPlato IN VARCHAR2, idProducto IN SMALLINT, idMenu IN SMALLINT) AS
BEGIN
INSERT INTO ProductoMenu (tipoPlato, idProducto, idMenu) 
VALUES (tipoPlato, idProducto, idMenu);
END insertProductoMenu;
/

CREATE OR REPLACE PROCEDURE insertAlergenos
(nombre in VARCHAR2, descripcion IN VARCHAR2) AS 
BEGIN
INSERT INTO Alergenos (nombre, descripcion) 
VALUES (nombre, descripcion);
END insertAlergenos;
/

CREATE OR REPLACE PROCEDURE insertContiene 
(idProducto IN SMALLINT, idAlergeno IN SMALLINT) AS 
BEGIN
INSERT INTO Contiene (idProducto, idAlergeno) 
VALUES (idProducto, idAlergeno);
END insertContiene;
/

CREATE OR REPLACE PROCEDURE insertUsuarios
(clase IN VARCHAR2, nombre IN VARCHAR2, apellidos IN VARCHAR2, telefono IN VARCHAR2, carta IN SMALLINT) AS 
BEGIN
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta)
VALUES (clase, nombre, apellidos, telefono, carta);
END insertUsuarios;
/

CREATE OR REPLACE PROCEDURE insertComandas
(fecha IN DATE, importe IN FLOAT, usuario IN SMALLINT) AS 
BEGIN
INSERT INTO Comandas (fecha, importe, usuario) 
VALUES (fecha, importe, usuario);
END insertComandas;
/

CREATE OR REPLACE PROCEDURE insertMesas
(disponible IN SMALLINT, capacidad IN SMALLINT) AS 
BEGIN
INSERT INTO Mesas (disponible, capacidad) 
VALUES (disponible, capacidad);
END insertMesas;
/

CREATE OR REPLACE PROCEDURE insertReservas
(fecha IN DATE, numPersonas IN SMALLINT, mesa IN SMALLINT, usuario IN SMALLINT) AS 
BEGIN
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) 
VALUES (fecha, numPersonas, mesa, usuario);
END insertReservas;
/

/* Procedimientos de UPDATE */
CREATE OR REPLACE PROCEDURE updateCartas
(idCarta IN SMALLINT, temporada IN DATE) AS 
BEGIN
UPDATE Cartas SET temporada = temporada WHERE idCarta = idCarta;
END updateCartas;
/

CREATE OR REPLACE PROCEDURE updateProductos
(idProducto IN SMALLINT, nombre IN VARCHAR2, descripcion IN VARCHAR2, tipoProducto IN VARCHAR2, disponibilidad IN SMALLINT, precioProducto IN FLOAT) AS 
BEGIN
UPDATE Productos SET nombre = nombre, descripcion = descripcion, tipoProducto = tipoProducto, disponibilidad = disponibilidad, precioProducto = precioProducto WHERE idProducto = idProducto;
END updateProductos;
/

CREATE OR REPLACE PROCEDURE updateProductoCarta 
(idProductoCarta IN SMALLINT, idCarta IN SMALLINT, idProducto IN SMALLINT) AS
BEGIN
UPDATE ProductoCarta SET idCarta = idCarta, idProducto = idProducto WHERE idProductoCarta = idProductoCarta;
END updateProductoCarta;
/

CREATE OR REPLACE PROCEDURE updateMenus
(idMenu IN SMALLINT, precio IN FLOAT, carta in SMALLINT) AS
BEGIN
UPDATE Menus SET precio = precio, carta = carta WHERE idMenu = idMenu;
END updateMenus;
/

CREATE OR REPLACE PROCEDURE updateProductoMenu
(idProductoMenu IN SMALLINT, tipoPlato IN VARCHAR2, idProducto IN SMALLINT, idMenu IN SMALLINT) AS
BEGIN
UPDATE ProductoMenu SET tipoPlato = tipoPlato, idProducto = idProducto, idMenu = idMenu WHERE idProductoMenu = idProductoMenu;
END updateProductoMenu;
/

CREATE OR REPLACE PROCEDURE updateAlergenos
(idAlergeno IN SMALLINT, nombre in VARCHAR2, descripcion IN VARCHAR2) AS 
BEGIN
UPDATE Alergenos SET nombre = nombre, descripcion = descripcion WHERE idAlergeno = idAlergeno;
END updateAlergenos;
/

CREATE OR REPLACE PROCEDURE updateContiene
(OIDContiene IN SMALLINT, idProducto IN SMALLINT, idAlergeno IN SMALLINT) AS 
BEGIN
UPDATE Contiene SET idProducto = idProducto, idAlergeno = idAlergeno WHERE OIDContiene = OIDContiene;
END updateContiene;
/

CREATE OR REPLACE PROCEDURE updateUsuarios
(idUsuario IN SMALLINT, clase IN VARCHAR2, nombre IN VARCHAR2, apellidos IN VARCHAR2, telefono IN VARCHAR2, carta IN SMALLINT) AS 
BEGIN
UPDATE Usuarios SET clase = clase, nombre = nombre, apellidos = apellidos, telefono = telefono, carta = carta WHERE idUsuario = idUsuario;
END updateUsuarios;
/

CREATE OR REPLACE PROCEDURE updateComandas
(idComanda IN SMALLINT, fecha IN DATE, importe IN FLOAT, usuario IN SMALLINT) AS 
BEGIN
UPDATE Comandas SET fecha = fecha, importe = importe, usuario = usuario WHERE idComanda = idComanda;
END updateComandas;
/

CREATE OR REPLACE PROCEDURE updateMesas
(idMesa IN SMALLINT, disponible IN SMALLINT, capacidad IN SMALLINT) AS 
BEGIN
UPDATE Mesas SET disponible = disponible, capacidad = capacidad WHERE idMesa = idMesa;
END updateMesas;
/

CREATE OR REPLACE PROCEDURE updateReservas
(idReserva IN SMALLINT, fecha IN DATE, numPersonas IN SMALLINT, mesa IN SMALLINT, usuario IN SMALLINT) AS 
BEGIN
UPDATE Reservas SET fecha = fecha, numPersonas = numPersonas, mesa = mesa, usuario = usuario WHERE idReserva = idReserva;
END updateReservas;
/

-------- CASOS DE PRUEBA --------
/* Datos de Cartas */
/* Mediante procedimientos: */
EXECUTE insertCartas(TO_DATE('2020/01/01','yyyy/mm/dd'));

/* Mediante INSERTS: */
/*
INSERT INTO Cartas (temporada) VALUES (TO_DATE('2020/01/01','yyyy/mm/dd'));
*/

/* Datos de Productos */
/* Mediante procedimientos: */
EXECUTE insertProductos('Macarrones', 'Macarrones con tomate', 'PASTA', 1, 9);
EXECUTE insertProductos('Pechuga de Pollo', 'Pechuga de pollo a la carbonara', 'CARNE', 1, 5);
EXECUTE insertProductos('Mousse de Chocolate', 'Mousse de Chocolate', 'POSTRE', 1, 4);
EXECUTE insertProductos('Estrella Galicia', 'Cerveza', 'BEBIDA', 1, 1);
EXECUTE insertProductos('Cruzcampo', 'Cerveza', 'BEBIDA', 0, 1);

/* Mediante INSERTS: */
/*
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) VALUES ('Macarrones', 'Macarrones con tomate', 'PRIMERPLATO', 1, 9);
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) VALUES ('Pechuga de pollo', 'Pechuga de pollo a la carbonara', 'SEGUNDOPLATO', 1, 5);
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) VALUES ('Mousse de Chocolate', 'Mousse de chocolate', POSTRE, 1, 4);
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) VALUES ('Estrella Galicia', 'Cerveza', 'BEBIDA', 1, 1);
INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto) VALUES ('Cruzcampo', 'Cerveza', 'BEBIDA', 0, 1);
*/

/* Datos de ProductoCarta */
/* Mediante procedimientos: */
EXECUTE insertProductoCarta(1, 1);
EXECUTE insertProductoCarta(1, 2);
EXECUTE insertProductoCarta(1, 3);
EXECUTE insertProductoCarta(1, 4);

/* Mediante INSERTS: */
/*
INSERT INTO ProductoCarta (idCarta, idProducto) VALUES (1, 1);
INSERT INTO ProductoCarta (idCarta, idProducto) VALUES (1, 2);
INSERT INTO ProductoCarta (idCarta, idProducto) VALUES (1, 3);
INSERT INTO ProductoCarta (idCarta, idProducto) VALUES (1, 4);
*/

/* Datos de Menus */
/* Mediante procedimientos: */
EXECUTE insertMenus(18, 1);

/* Mediante INSERTS: */
/*
INSERT INTO Menus (precio, carta) VALUES (18, 1);
*/

/* Datos de ProductoMenu */
/* Mediante procedimientos: */
EXECUTE insertProductoMenu('PRIMERPLATO', 1, 1);
EXECUTE insertProductoMenu('SEGUNDOPLATO', 2, 1);
EXECUTE insertProductoMenu('POSTRE', 3, 1);
EXECUTE insertProductoMenu('BEBIDA', 4, 1); 

/* Mediante INSERTS: */
/*
INSERT INTO ProductoMenu (tipoPlato, idProducto, idMenu) VALUES ('PRIMERPLATO', 1, 1);
INSERT INTO ProductoMenu (tipoPlato, idProducto, idMenu) VALUES ('SEGUNDOPLATO', 2, 1);
INSERT INTO ProductoMenu (tipoPlato, idProducto, idMenu) VALUES ('POSTRE', 3, 1);
INSERT INTO ProductoMenu (tipoPlato, idProducto, idMenu) VALUES ('BEBIDA', 4, 1);
*/

/* Datos de Alergenos */
/* Mediante procedimientos: */
EXECUTE insertAlergenos('Lactosa', 'Lactosa');
EXECUTE insertAlergenos('Caseína', 'Caseína');
EXECUTE insertAlergenos('Gluten de trigo', 'Gluten de trigo');
EXECUTE insertAlergenos('Proteína de soja', 'Proteína de soja');

/* Mediante INSERTS: */
/*
INSERT INTO Alergenos (nombre, descripcion) VALUES ('Lactosa', 'Lactosa');
INSERT INTO Alergenos (nombre, descripcion) VALUES ('Caseína', 'Caseína');
INSERT INTO Alergenos (nombre, descripcion) VALUES ('Gluten de trigo', 'Gluten de trigo');
INSERT INTO Alergenos (nombre, descripcion) VALUES ('Proteína de soja', 'Proteína de soja');
*/

/* Datos de Contiene */
/* Mediante procedimientos: */
EXECUTE insertContiene(1, 1);
EXECUTE insertContiene(2, 2);
EXECUTE insertContiene(3, 3);
EXECUTE insertContiene(4, 4);

/* Mediante INSERTS: */
/*
INSERT INTO Contiene (idProducto, idAlergeno) VALUES (1, 1);
INSERT INTO Contiene (idProducto, idAlergeno) VALUES (2, 2);
INSERT INTO Contiene (idProducto, idAlergeno) VALUES (3, 3);
INSERT INTO Contiene (idProducto, idAlergeno) VALUES (4, 4);
*/

/* Datos de Usuarios */
/* Mediante procedimientos: */
EXECUTE insertUsuarios('GERENTE', 'Jose Manuel', 'Torres', '987567521', 1);
EXECUTE insertUsuarios('MAITRE', 'Miguel', 'Carrasco', '673334582', null);
EXECUTE insertUsuarios('CLIENTE', 'David', 'Fernandez', '756345987', null);
EXECUTE insertUsuarios('CLIENTE', 'María', 'Triguero', '683450986', null);
EXECUTE insertUsuarios('CLIENTE', 'Ana', 'Gonzalez', '351789054', null);

/* Mediante INSERTS: */
/*
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta) VALUES ('GERENTE', 'Jose Manuel', 'Torres', '987567521', 1);
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta) VALUES ('MAITRE', 'Miguel', 'Carrasco', '673334582', null);
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta) VALUES ('CLIENTE', 'David', 'Fernandez', '756345987', null);
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta) VALUES ('CLIENTE', 'María', 'Triguero', '683450986', null);
INSERT INTO Usuarios (clase, nombre, apellidos, telefono, carta) VALUES ('CLIENTE', 'Ana', 'Gonzalez', '351789054', null);
*/

/* Datos de Comandas */
/* Mediante procedimientos: */
EXECUTE insertComandas(TO_DATE('2020/01/11','yyyy/mm/dd'), 21, 2);
EXECUTE insertComandas(TO_DATE('2020/01/11','yyyy/mm/dd'), 23, 2);
EXECUTE insertComandas(TO_DATE('2020/01/08','yyyy/mm/dd'), 24, 2);
EXECUTE insertComandas(TO_DATE('2020/01/09','yyyy/mm/dd'), 25, 2);
EXECUTE insertComandas(TO_DATE('2019/12/20','yyyy/mm/dd'), 26, 2);
EXECUTE insertComandas(TO_DATE('2019/12/21','yyyy/mm/dd'), 27, 2);

/* Mediante INSERTS: */
/*
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2020/01/11','yyyy/mm/dd'), 21, 2);
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2020/01/11','yyyy/mm/dd'), 23, 2);
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2020/01/08','yyyy/mm/dd'), 24, 2);
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2020/01/09','yyyy/mm/dd'), 25, 2);
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2019/12/20','yyyy/mm/dd'), 26, 2);
INSERT INTO Comandas (fecha, importe, usuario) VALUES (TO_DATE('2019/12/21','yyyy/mm/dd'), 27, 2);
*/

/* Datos de Mesas */
/* Mediante procedimientos: */
EXECUTE insertMesas(1, 4);
EXECUTE insertMesas(1, 4);
EXECUTE insertMesas(1, 6);
EXECUTE insertMesas(1, 8);
EXECUTE insertMesas(1, 10);
EXECUTE insertMesas(1, 10);
EXECUTE insertMesas(1, 8);
EXECUTE insertMesas(1, 8);

/* Mediante INSERTS: */
/*
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 4);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 4);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 6);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 8);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 10);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 12);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 8);
INSERT INTO Mesas (disponible, capacidad) VALUES (1, 8);
*/

/* Datos de Reservas */
/* Mediante procedimientos: */
EXECUTE insertReservas(TO_DATE('2020/01/11-13','yyyy/mm/dd-HH24'), 4, 1, 3);
EXECUTE insertReservas(TO_DATE('2020/01/11-13','yyyy/mm/dd-HH24'), 4, 2, 4);
EXECUTE insertReservas(TO_DATE('2020/01/08-20','yyyy/mm/dd-HH24'), 4, 3, 5);
EXECUTE insertReservas(TO_DATE('2020/01/09-14','yyyy/mm/dd-HH24'), 6, 4, 3);
EXECUTE insertReservas(TO_DATE('2020/02/16-15','yyyy/mm/dd-HH24'), 6, 5, 4);
EXECUTE insertReservas(TO_DATE('2020/02/20-21','yyyy/mm/dd-HH24'), 8, 6, 5);

/* Mediante INSERTS: */
/*
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/01/11-13','yyyy/mm/dd-HH24'), 4, 1, 3);
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/01/11-13','yyyy/mm/dd-HH24'), 4, 2, 4);
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/01/08-20','yyyy/mm/dd-HH24'), 4, 3, 5);
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/01/09-14','yyyy/mm/dd-HH24'), 6, 4, 3);
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/02/16-15','yyyy/mm/dd-HH24'), 6, 5, 4);
INSERT INTO Reservas (fecha, numPersonas, mesa, usuario) VALUES (TO_DATE('2020/02/20-21','yyyy/mm/dd-HH24'), 8, 6, 5);
*/
