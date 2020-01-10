-------- 3 ENTREGABLE IISSI 1 - RESTAURANTE SEVILLA --------

/*
Contiene las pruebas automáticas de las tablas.
*/

-------- PAQUETES PARA PRUEBAS AUTOMATICAS --------
/* Funcion que comprueba los resultados de las pruebas */	
/* Necesario para todas las pruebas automaticas */				
CREATE OR REPLACE
FUNCTION ASSERT_EQUALS (salida BOOLEAN,salidaEsperada BOOLEAN) RETURN VARCHAR2 AS
BEGIN
    IF (salida = salidaEsperada) THEN
        RETURN 'EXITO';
    ELSE
        RETURN 'FALLO';
    END IF;
END ASSERT_EQUALS;
/

/* Paquete de la tabla Alergeno */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_ALERGENOS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, nombreP VARCHAR2, descripcionP VARCHAR2, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idAlergenoP SMALLINT, nombreP VARCHAR2, descripcionP VARCHAR2, salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idAlergenoP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_ALERGENOS;
/

/* Cuerpo */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_ALERGENOS AS

    /* Inicializacion, vacia la tabla */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Alergenos;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, nombreP VARCHAR2, descripcionP VARCHAR2, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        alergeno Alergenos%ROWTYPE;
        idAlergenoP SMALLINT;
    BEGIN
        /* Insertar alergeno */
        INSERT INTO Alergenos(nombre, descripcion) VALUES (nombreP, descripcionP);
        
        /* Seleccionar alergeno y comprobar que los datos se insertaron correctamente */
        idAlergenoP := sec_alergenos.CURRVAL;
        SELECT * INTO alergeno FROM Alergenos WHERE idAlergeno = idAlergenoP;
        IF (alergeno.nombre <> nombreP AND alergeno.descripcion <> descripcionP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2, idAlergenoP SMALLINT, nombreP VARCHAR2, descripcionP VARCHAR2, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        alergeno Alergenos%ROWTYPE;
    BEGIN
    
        /* Actualizar alergeno */
        UPDATE Alergenos SET nombre = nombreP, descripcion = descripcionP WHERE idAlergeno = idAlergenoP;
        
        /* Seleccionar alergeno y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO alergeno FROM Alergenos WHERE idAlergeno = idAlergenoP;
        IF (alergeno.nombre <> nombreP AND alergeno.descripcion <> descripcionP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminacion */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idAlergenoP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroAlergeno INTEGER;
    BEGIN 
        
        /* Eliminar alergeno */
        DELETE FROM Alergenos WHERE idAlergeno = idAlergenoP;
        
        /* Verificar que alergeno no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroAlergeno FROM Alergenos WHERE idAlergeno = idAlergenoP;
        IF (numeroAlergeno <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_ALERGENOS;
/

/* Prueba del paquete Alergenos */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idAlergeno SMALLINT;
BEGIN
    PRUEBAS_ALERGENOS.inicializar;
    PRUEBAS_ALERGENOS.insertar('PRUEBA 1 - Insercion', 'Prueba', 'Lactosa', TRUE);
    idAlergeno := sec_alergenos.CURRVAL;
    PRUEBAS_ALERGENOS.actualizar('PRUEBA 2 - Actualizacion', idAlergeno, 'Lactosa', 'Azucar en la leche', TRUE);
    PRUEBAS_ALERGENOS.eliminar('PRUEBA 3 - Eliminacion', idAlergeno, TRUE);
END;
/

/* Paquete de la tabla Mesas */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_MESAS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, disponibleP VARCHAR2, capacidadP VARCHAR2, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idMesaP SMALLINT, disponibleP VARCHAR2, capacidadP VARCHAR2, salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idMesaP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_MESAS;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_MESAS AS

    /* Inicializacion, vacia la tabla */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Mesas;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, disponibleP VARCHAR2, capacidadP VARCHAR2, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        mesa Mesas%ROWTYPE;
        idMesaP SMALLINT;
    BEGIN
        /* Insertar mesa */
        INSERT INTO Mesas(disponible, capacidad) VALUES (disponibleP, capacidadP);
        
        /* Seleccionar mesa y comprobar que los datos se insertaron correctamente */
        idMesaP := sec_mesas.CURRVAL;
        SELECT * INTO mesa FROM Mesas WHERE idMesa = idMesaP;
        IF (mesa.disponible <> disponibleP AND mesa.capacidad <> capacidadP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2, idMesaP SMALLINT, disponibleP VARCHAR2, capacidadP VARCHAR2, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        mesa Mesas%ROWTYPE;
    BEGIN
    
        /* Actualizar mesa */
        UPDATE Mesas SET disponible = disponibleP, capacidad = capacidadP WHERE idMesa = idMesaP;
        
        /* Seleccionar mesa y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO mesa FROM Mesas WHERE idMesa = idMesaP;
        IF (mesa.disponible <> disponibleP AND mesa.capacidad <> capacidadP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminacion */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idMesaP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroMesa INTEGER;
    BEGIN 
        
        /* Eliminar mesa */
        DELETE FROM Mesas WHERE idMesa = idMesaP;
        
        /* Verificar que mesa no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroMesa FROM Mesas WHERE idMesa = idMesaP;
        IF (numeroMesa <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_MESAS;
/

/* Prueba del paquete Mesas */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idMesa SMALLINT;
BEGIN
    PRUEBAS_MESAS.inicializar;
    PRUEBAS_MESAS.insertar('PRUEBA 1 - Insercion', 1, 8, TRUE);
    idMesa := sec_mesas.CURRVAL;
    PRUEBAS_MESAS.actualizar('PRUEBA 2 - Actualizacion', idMesa, 0, 8, TRUE);
    PRUEBAS_MESAS.eliminar('PRUEBA 3 - Eliminacion', idMesa, TRUE);
END;
/

/* Paquete de la tabla Cartas */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_CARTAS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, temporadaP DATE, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idCartaP SMALLINT, temporadaP DATE, salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idCartaP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_CARTAS;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_CARTAS AS

    /* Inicializacion */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Cartas;
    END inicializar;

    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, temporadaP DATE, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        carta Cartas%ROWTYPE;
        idCartaP SMALLINT;
    BEGIN
        /* Insertar carta */
        INSERT INTO Cartas (temporada) VALUES (temporadaP);
        /* Seleccionar carta y comprobar que los datos se insertaron correctamente */
        idCartaP := sec_cartas.CURRVAL;
        SELECT * INTO carta FROM Cartas WHERE idCarta = idCartaP;
        IF (carta.temporada <> temporadaP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;

    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2, idCartaP SMALLINT, temporadaP DATE, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        carta Cartas%ROWTYPE;
    BEGIN
        /* Actualizar carta */
        UPDATE Cartas SET temporada = temporadaP WHERE idCarta = idCartaP;
        
        /* Seleccionar carta y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO carta FROM Cartas WHERE idCarta = idCartaP;
        IF (carta.temporada <> temporadaP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminacion */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idCartaP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroCarta INTEGER;
    BEGIN 
        /* Eliminar carta */
        DELETE FROM Cartas WHERE idCarta = idCartaP;
        /* Verificar que carta no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroCarta FROM Cartas WHERE idCarta = idCartaP;
        IF (numeroCarta <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;

END PRUEBAS_CARTAS;
/

/* Prueba del paquete Cartas */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idCarta SMALLINT;
BEGIN
    PRUEBAS_CARTAS.inicializar;
    PRUEBAS_CARTAS.insertar('PRUEBA 1 - Insercion',TO_DATE('2021/01/06', 'yyyy/mm/dd'), TRUE);
    idCarta := sec_cartas.CURRVAL;
    PRUEBAS_CARTAS.actualizar('PRUEBA 2 - Actualizacion', idCarta,TO_DATE('2022/03/06', 'yyyy/mm/dd') , TRUE);
    PRUEBAS_CARTAS.eliminar('PRUEBA 3 - Eliminacion', idCarta, TRUE);
END;
/

/* Paquete de la tabla Productos */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_PRODUCTOS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, nombreP VARCHAR2, descripcionP VARCHAR2, tipoProductoP VARCHAR2, disponibilidadP SMALLINT, 
    precioProductoP FLOAT, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idProductoP SMALLINT, nombreP VARCHAR2, descripcionP VARCHAR2, tipoProductoP VARCHAR2,
    disponibilidadP SMALLINT, precioProductoP FLOAT, salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idProductoP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_PRODUCTOS;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_PRODUCTOS AS

    /* Inicializacion */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Productos;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, nombreP VARCHAR2, descripcionP VARCHAR2, tipoProductoP VARCHAR2,
    disponibilidadP SMALLINT, precioProductoP FLOAT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        producto Productos%ROWTYPE;
        idProductoP SMALLINT;
    BEGIN
        /* Insertar producto */
        INSERT INTO Productos (nombre, descripcion, tipoProducto, disponibilidad, precioProducto)
        VALUES (nombreP, descripcionP, tipoProductoP, disponibilidadP, precioProductoP);
        
        /* Seleccionar producto y comprobar que los datos se insertaron correctamente */
        idProductoP := sec_productos.CURRVAL;
        SELECT * INTO producto FROM Productos WHERE idProducto = idProductoP;
        IF (producto.nombre <> nombreP AND producto.descripcion <> descripcionP AND producto.tipoProducto <> tipoProductoP 
        AND producto.disponibilidad <> disponibilidadP AND producto.precioProducto <> precioProductoP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2,idProductoP SMALLINT, nombreP VARCHAR2, descripcionP VARCHAR2, tipoProductoP VARCHAR2, 
    disponibilidadP SMALLINT, precioProductoP FLOAT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        producto Productos%ROWTYPE;
    BEGIN
        /* Actualizar producto */
        UPDATE Productos SET nombre = nombreP, descripcion = descripcionP, tipoProducto = tipoProductoP, 
        disponibilidad = disponibilidadP, precioProducto = precioProductoP WHERE idProducto = idProductoP;
        
        /* Seleccionar producto y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO producto FROM Productos WHERE idProducto = idProductoP;
        IF (producto.nombre <> nombreP AND producto.descripcion <> descripcionP AND producto.tipoProducto <> tipoProductoP 
        AND producto.disponibilidad <> disponibilidadP AND producto.precioProducto <> precioProductoP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminación */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idProductoP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroProducto INTEGER;
    BEGIN 
        /* Eliminar producto */
        DELETE FROM Productos WHERE idProducto = idProductoP;
        
        /* Verificar que producto no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroProducto FROM Productos WHERE idProducto = idProductoP;
        IF (numeroProducto <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_PRODUCTOS;

/* Prueba del paquete Productos */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
ALTER TRIGGER TR_producto_disponible DISABLE;
/* ATENCIÓN: DESACTIVAR TRIGGER PRODUCTO_DISPONIBLE PARA EJECUTAR LA PRUEBA */
DECLARE 
    idProducto SMALLINT;
BEGIN
    PRUEBAS_PRODUCTOS.inicializar;
    PRUEBAS_PRODUCTOS.insertar('PRUEBA 1 - Insercion','Jamon', 'Pata Negra', 'CARNE', 1, 10, TRUE);
    idProducto := sec_productos.CURRVAL;
    PRUEBAS_PRODUCTOS.actualizar('PRUEBA 2 - Actualizacion', idProducto, 'Jamon', 'Pata Blanca', 'CARNE', 1, 6, TRUE);
    PRUEBAS_PRODUCTOS.eliminar('PRUEBA 3 - Eliminacion', idProducto, TRUE);
END;

/* Paquete de la tabla Comandas */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_COMANDAS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, fechaP DATE, importeP FLOAT, usuarioP SMALLINT, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idComandaP SMALLINT, fechaP DATE, importeP FLOAT, usuarioP SMALLINT, salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idComandaP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_COMANDAS;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_COMANDAS AS

    /* Inicializacion */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Comandas;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, fechaP DATE, importeP FLOAT, usuarioP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        comanda Comandas%ROWTYPE;
        idComandaP SMALLINT;
    BEGIN
        /* Insertar comanda */
        INSERT INTO Comandas (fecha, importe, usuario)
        VALUES (fechaP, importeP, usuarioP);
        
        /* Seleccionar comanda y comprobar que los datos se insertaron correctamente */
        idComandaP := sec_comandas.CURRVAL;
        SELECT * INTO comanda FROM Comandas WHERE idComanda = idComandaP;
        IF (comanda.fecha <> fechaP AND comanda.importe <> importeP AND comanda.usuario <> usuarioP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2,idComandaP SMALLINT, fechaP DATE, importeP FLOAT, usuarioP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        comanda Comandas%ROWTYPE;
    BEGIN
        /* Actualizar comanda */
        UPDATE Comandas SET fecha = fechaP, importe = importeP, usuario = usuarioP WHERE idComanda = idComandaP;
        
        /* Seleccionar comanda y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO comanda FROM Comandas WHERE idComanda = idComandaP;
        IF (comanda.fecha <> fechaP AND comanda.importe <> importeP AND comanda.usuario <> usuarioP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminación */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idComandaP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroComanda INTEGER;
    BEGIN 
        /* Eliminar comanda */
        DELETE FROM Comandas WHERE idComanda = idComandaP;
        
        /* Verificar que comanda no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroComanda FROM Comandas WHERE idComanda = idComandaP;
        IF (numeroComanda <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_COMANDAS;

/* Prueba del paquete Comandas */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idComanda SMALLINT;
BEGIN
    PRUEBAS_COMANDAS.inicializar;
    PRUEBAS_COMANDAS.insertar('PRUEBA 1 - Insercion', TO_DATE('2020/05/13', 'yyyy/mm/dd'), 15, 2, TRUE);
    idComanda := sec_comandas.CURRVAL;
    PRUEBAS_COMANDAS.actualizar('PRUEBA 2 - Actualizacion', idComanda, TO_DATE('2020/05/13', 'yyyy/mm/dd'), 20, 2, TRUE);
    PRUEBAS_COMANDAS.eliminar('PRUEBA 3 - Eliminacion', idComanda, TRUE);
END;

/* Paquete de la tabla Menús */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_MENUS AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, precioP FLOAT, cartaP SMALLINT, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idMenuP SMALLINT, precioP FLOAT, cartaP SMALLINT,salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idMenuP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_MENUS;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_MENUS AS

    /* Inicializacion */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM Menus;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, precioP FLOAT, cartaP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        menu Menus%ROWTYPE;
        idMenuP SMALLINT;
    BEGIN
        /* Insertar menu */
        INSERT INTO Menus (precio, carta) VALUES (precioP, cartaP);
        
        /* Seleccionar menu y comprobar que los datos se insertaron correctamente */
        idMenuP := sec_menus.CURRVAL;
        SELECT * INTO menu FROM Menus WHERE idMenu = idMenuP;
        IF (menu.precio <> precioP AND menu.carta <> cartaP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2, idMenuP SMALLINT, precioP FLOAT, cartaP SMALLINT,salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        menu Menus%ROWTYPE;
    BEGIN
        /* Actualizar menu */
        UPDATE Menus SET precio = precioP, carta = cartaP WHERE idMenu = idMenuP;
        
        /* Seleccionar menu y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO menu FROM Menus WHERE idMenu = idMenuP;
        IF (menu.precio <> precioP AND menu.carta <> cartaP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminación */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idMenuP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroMenu INTEGER;
    BEGIN 
        /* Eliminar menu */
        DELETE FROM Menus WHERE idMenu = idMenuP;
        
        /* Verificar que menu no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroMenu FROM Menus WHERE idMenu = idMenuP;
        IF (numeroMenu <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_MENUS;

/* Prueba del paquete Menus */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idMenu SMALLINT;
BEGIN
    PRUEBAS_MENUS.inicializar;
    PRUEBAS_MENUS.insertar('PRUEBA 1 - Insercion', 20, null, TRUE);
    idMenu := sec_menus.CURRVAL;
    PRUEBAS_MENUS.actualizar('PRUEBA 2 - Actualizacion', idMenu, 15, null, TRUE);
    PRUEBAS_MENUS.eliminar('PRUEBA 3 - Eliminacion', idMenu, TRUE);
END;

/* Paquete de la tabla ProductoCarta */
/* Cabecera */
CREATE OR REPLACE 
PACKAGE PRUEBAS_PRODUCTO_CARTA AS

    PROCEDURE inicializar;
    PROCEDURE insertar
    (nombre_prueba VARCHAR2, idCartaP SMALLINT, idProductoP SMALLINT, salidaEsperada BOOLEAN);
    PROCEDURE actualizar
    (nombre_prueba VARCHAR2, idProductoCartaP SMALLINT, idCartaP SMALLINT, idProductoP SMALLINT,salidaEsperada BOOLEAN);
    PROCEDURE eliminar
    (nombre_prueba VARCHAR2, idProductoCartaP SMALLINT, salidaEsperada BOOLEAN);
    
END PRUEBAS_PRODUCTO_CARTA;
/

/* Body */
CREATE OR REPLACE 
PACKAGE BODY PRUEBAS_PRODUCTO_CARTA AS

    /* Inicializacion */
    PROCEDURE inicializar AS
    BEGIN
        DELETE FROM ProductoCarta;
    END inicializar;
    
    /* Insercion */
    PROCEDURE insertar (nombre_prueba VARCHAR2, idCartaP SMALLINT, idProductoP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        producto_carta ProductoCarta%ROWTYPE;
        idProductoCartaP SMALLINT;
    BEGIN
        /* Insertar productoCarta */
        INSERT INTO ProductoCarta (idCarta, idProducto) VALUES (idCartaP, idProductoP);
        
        /* Seleccionar productoCarta y comprobar que los datos se insertaron correctamente */
        idProductoCartaP := sec_producto_carta.CURRVAL;
        SELECT * INTO producto_carta FROM ProductoCarta WHERE idProductoCarta = idProductoCartaP;
        IF (producto_carta.idCarta <> idCartaP AND producto_carta.idProducto <> idProductoP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;

    END insertar;
        
    /* Actualizacion */
    PROCEDURE actualizar (nombre_prueba VARCHAR2, idProductoCartaP SMALLINT, idCartaP SMALLINT, idProductoP SMALLINT,salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        producto_carta ProductoCarta%ROWTYPE;
    BEGIN
        /* Actualizar productoCarta */
        UPDATE ProductoCarta SET idCarta = idCartaP, idProducto = idProductoP WHERE idProductoCarta = idProductoCartaP;
        
        /* Seleccionar productoCarta y comprobar que los datos se actualizaron correctamente */
        SELECT * INTO producto_carta FROM ProductoCarta WHERE idProductoCarta = idProductoCartaP;
        IF (producto_carta.idCarta <> idCartaP AND producto_carta.idProducto <> idProductoP) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END actualizar;

    /* Eliminación */
    PROCEDURE eliminar (nombre_prueba VARCHAR2, idProductoCartaP SMALLINT, salidaEsperada BOOLEAN) AS
        salida BOOLEAN := TRUE;
        numeroProductoCarta INTEGER;
    BEGIN 
        /* Eliminar productoCarta */
        DELETE FROM ProductoCarta WHERE idProductoCarta = idProductoCartaP;
        
        /* Verificar que productoCarta no se encuentra en la base de datos */
        SELECT COUNT(*) INTO numeroProductoCarta FROM ProductoCarta WHERE idProductoCarta = idProductoCartaP;
        IF (numeroProductoCarta <> 0) THEN
            salida := FALSE;
        END IF;
        COMMIT WORK;
        
        /* Mostrar resultados de la prueba */
        DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(salida, salidaEsperada));
        EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE(nombre_prueba || ':' || ASSERT_EQUALS(FALSE, salidaEsperada));
            ROLLBACK;
            
    END eliminar;
    
END PRUEBAS_PRODUCTO_CARTA;

/* Prueba del paquete ProductoCarta */
/* SET SERVEROUTPUT DEBE ESTAR EN ON */
DECLARE 
    idProductoCarta SMALLINT;
BEGIN
    PRUEBAS_PRODUCTO_CARTA.inicializar;
    PRUEBAS_PRODUCTO_CARTA.insertar('PRUEBA 1 - Insercion', null, null, TRUE);
    idProductoCarta := sec_producto_carta.CURRVAL;
    PRUEBAS_PRODUCTO_CARTA.actualizar('PRUEBA 2 - Actualizacion', idProductoCarta, null, null, TRUE);
    PRUEBAS_PRODUCTO_CARTA.eliminar('PRUEBA 3 - Eliminacion', idProductoCarta, TRUE);
END;
