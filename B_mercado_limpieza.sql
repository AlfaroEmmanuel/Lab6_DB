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

DELIMITER ;