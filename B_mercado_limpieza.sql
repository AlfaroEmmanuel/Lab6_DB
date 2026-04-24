DELIMITER //
/*Se tuvo que cambiar a comentarios de //, ya que el delimitador se cambió ya q la ejecucuion en powershell no era posible */
CREATE FUNCTION fn_espia_tortugo(id_producto INT) RETURNS DECIMAL(3,1)
READS SQL DATA /*Se usa para indicar que la función solo lee datos, no los modifica*/
BEGIN
    /* Declaramos las variables a usar */
    DECLARE v_categoria VARCHAR(100);
    DECLARE v_precio_finca DECIMAL(10,2);
    DECLARE v_precio_referencia DECIMAL(10,2);
    
    /* Obtener categoría y precio_finca del producto */
    SELECT categoria, precio_finca INTO v_categoria, v_precio_finca
    FROM inventario_pirata
    WHERE id = id_producto;
    
    /* Obtener precio_referencia del mercado */
    SELECT precio_referencia INTO v_precio_referencia
    FROM mercado_negro
    WHERE categoria = v_categoria;
    
    /* Comparar y devolver factor, si el producto es mas caro, se devuelve 1.2, si es mas barato, se devuelve 0.8 */
    IF v_precio_finca > v_precio_referencia THEN
        RETURN 1.2;
    ELSE
        RETURN 0.8;
    END IF;
END //

-- El delimiter se usa para indicar el final de la función
DELIMITER ;

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