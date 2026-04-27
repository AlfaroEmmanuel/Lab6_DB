DELIMITER //

CREATE FUNCTION fn_cernidor(p_id_producto INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_es_primo BOOLEAN DEFAULT TRUE;
    DECLARE v_contador INT DEFAULT 2;

    IF p_id_producto < 2 THEN
        SET v_es_primo = FALSE;
    ELSE
        -- Ciclo para ver si alguien divide al número
        WHILE v_contador <= p_id_producto / 2 DO
            IF p_id_producto % v_contador = 0 THEN
                SET v_es_primo = FALSE;
            END IF;
            SET v_contador = v_contador + 1;
        END WHILE;
    END IF;

    RETURN v_es_primo;
END //


CREATE FUNCTION fn_reloj_arena(p_fecha_ingreso DATE, p_meses_validez INT) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_resultado VARCHAR(10);

    -- Sumamos los meses a la fecha de ingreso
    SET v_fecha_vencimiento = DATE_ADD(p_fecha_ingreso, INTERVAL p_meses_validez MONTH);

    -- Comparamos con la fecha de hoy
    IF v_fecha_vencimiento >= CURDATE() THEN
        SET v_resultado = 'Fresco';
    ELSE
        SET v_resultado = 'Expirado';
    END IF;

    RETURN v_resultado;
END //

DELIMITER //
CREATE FUNCTION fn_espia_tortuga(p_categoria VARCHAR(100), p_precio_finca DECIMAL(10,2)) 
RETURNS DECIMAL(3,1)
READS SQL DATA -- Usamos esto porque la función necesita LEER datos de la tabla de mercado
BEGIN
    -- PASO 1 y REGLAS ESTRICTAS: Declarar variables locales (Prohibido retornos directos)
    DECLARE v_precio_mercado DECIMAL(10,2);
    DECLARE v_relacion_porc DECIMAL(10,2);
    DECLARE v_factor_final DECIMAL(3,1);

    -- PASO 2: Consulta anidada hacia la tabla de mercado
    -- Buscamos el precio de referencia para esa categoría específica
    SELECT precio_referencia INTO v_precio_mercado
    FROM mercado_negro
    WHERE categoria = p_categoria
    LIMIT 1;

    -- NORMA ESTRICTA: Manejo de Nulidad (Por si la categoría no existe en el mercado negro)
    IF v_precio_mercado IS NULL THEN
        SET v_precio_mercado = p_precio_finca; -- Si no hay referencia, asumimos empate
    END IF;

    -- PASO 3: Calcular la relación porcentual usando variables/alias para el cálculo intermedio
    SET v_relacion_porc = (p_precio_finca / v_precio_mercado) * 100;

    -- PASO 4: Selección condicional
    IF p_precio_finca > v_precio_mercado THEN
        -- Si nuestro precio es superior al del mercado
        SET v_factor_final = 1.2;
    ELSE
        -- Si nuestro precio es igual o inferior al del mercado
        SET v_factor_final = 0.8;
    END IF;

    -- Retorno final limpio usando la variable
    RETURN v_factor_final;
END //

DELIMITER //

CREATE FUNCTION fn_purificador(nombre_sucio VARCHAR(255)) RETURNS VARCHAR(255)
READS SQL DATA /*Se usa para indicar que la función solo lee datos, no los modifica*/
BEGIN
    DECLARE v_limpio VARCHAR(255);
    
    /* Eliminar caracteres especiales, dejar solo letras, números y espacios */
    /* Ejemplo: "Producto@#1!!" se convierte en "Producto 1" */
    SET v_limpio = REGEXP_REPLACE(nombre_sucio, '[^A-Za-z0-9 ]', '');
    
    /* Eliminar espacios múltiples */
    /* Ejemplo: "Producto   1" se convierte en "Producto 1" */
    SET v_limpio = REGEXP_REPLACE(v_limpio, ' +', ' ');
    
    /* Eliminar espacios al inicio y final */
    /* Ejemplo: "  Producto 1  " se convierte en "Producto 1" */
    SET v_limpio = TRIM(v_limpio);
    
    RETURN v_limpio;
END //

--llave 5
DELIMITER //

CREATE FUNCTION fn_escultor(p_texto_limpio VARCHAR(255), p_factor DECIMAL(10,2))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    -- variables que guarda el resultado final
    DECLARE v_texto_transformado VARCHAR(255);
    DECLARE v_etiqueta VARCHAR(50);
    DECLARE v_resultado_final VARCHAR(255);
    
    -- evaluacion de factor
    -- si el factor es mayor a 1, es de alta prioridad
    IF p_factor > 1.0 THEN
            -- se pasa a mayusculas y agregamos el sufijo
        SET v_texto_transformado = UPPER(p_texto_limpio);
        SET v_etiqueta = ' - PRIORIDAD ALTA';
    ELSE
            -- si el factor es 1 o menos, se pasa a minúsculas
        SET v_texto_transformado = LOWER(p_texto_limpio);
        SET v_etiqueta = ' - prioridad baja';
    END IF;
    
        -- se return el texto corregido
    SET v_resultado_final = CONCAT(v_texto_transformado, v_etiqueta);
    RETURN v_resultado_final;
END //

DELIMITER ;
-- fin llave 5


-- llave 6
DELIMITER //

CREATE FUNCTION fn_notario(p_texto VARCHAR(255))
RETURNS VARCHAR(255)
MODIFIES SQL DATA -- permiso para que la función pueda hacer un insert
BEGIN
    -- se declara variable
    DECLARE v_mensaje TEXT;
    
    -- uso concat para unir el texto
    SET v_mensaje = CONCAT('El texto ha pasado por la Llave 6. Estado actual: [', p_texto, ']');
    
    -- se hace la insercion en la tabla 
    INSERT INTO logs_hashy (nombre_funcion, mensaje_accion)
    VALUES ('fn_notario', v_mensaje);

    -- se hace return para que la cadena de dulces no se rompa
    RETURN p_texto;
END //

DELIMITER ;
-- fin llave 6


-- llave 7
DELIMITER //
CREATE FUNCTION fn_gran_sello(p_texto VARCHAR(255))
RETURNS VARCHAR(64)
DETERMINISTIC
BEGIN
    -- se usa variables intermedias
    DECLARE v_algoritmo VARCHAR(10) DEFAULT 'SHA2-256';
    DECLARE v_hash_final VARCHAR(64);
    
    -- se toma el texto y se aplica el algoritmo SHA2 de 256 bitts
    SET v_hash_final = SHA2(p_texto, 256);
    
    RETURN v_hash_final;
END //
DELIMITER ;
-- fin llave 7