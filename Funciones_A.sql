-- ========= FUNCIONES INTEGRANTE A =========
DELIMITER //

-- LLAVE 1: El Cernidor (Verifica si el ID es número primo)
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

-- LLAVE 2: El Reloj de Arena (Verifica si el producto caducó)
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

DELIMITER ;