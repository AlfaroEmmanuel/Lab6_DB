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
    
    --se hace la insercion en la tabla 
    INSERT INTO logs_hashy (nombre_funcion, mensaje_accion)
    VALUES ('fn_notario', v_mensaje);

    -- se hace return para que la cadena de dulces no se rompa
    RETURN p_texto;
END //

DELIMITER ;
--fin llave 6


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

