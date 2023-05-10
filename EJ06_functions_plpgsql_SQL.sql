--función sin parametro de entrada para devolver el precio máximo
CREATE OR REPLACE FUNCTION precio_max()
RETURNS numeric AS $$
DECLARE max_unit_price numeric;
BEGIN
	SELECT MAX(unit_price) INTO max_unit_price FROM products;
	RETURN max_unit_price;
END;
$$ LANGUAGE 'plpgsql';
SELECT precio_max();
	

--parametro de entrada
--Obtener el numero de ordenes por empleado
CREATE OR REPLACE FUNCTION order_per_employee(employee int)
RETURNS int AS $$
DECLARE cont int;
BEGIN
	SELECT COUNT(order_id) INTO cont from orders WHERE employee_id = employee;
	RETURN cont;
END;
$$ LANGUAGE 'plpgsql';
SELECT order_per_employee(1);

--Obtener la venta de un empleado con un determinado producto
CREATE OR REPLACE FUNCTION product_per_employee(product int,employee int)
RETURNS int AS $$
DECLARE cantidad int;
BEGIN
	SELECT sum(quantity) INTO cantidad FROM order_details AS od INNER JOIN orders AS os 
	ON os.order_id = od.order_id 
	AND os.employee_id = employee 
	AND od.product_id = product;
	RETURN cantidad;
	
END;
$$ LANGUAGE 'plpgsql';
SELECT product_per_employee(1,4);

--Crear una funcion para devolver una tabla con producto_id, nombre, precio y unidades en strock, 
--debe obtener los productos terminados en n
CREATE OR REPLACE FUNCTION products_finish_n()
RETURNS TABLE(Producto_id smallint,Nombre_producto varchar,precio_unidad real,Unidades_en_stock smallint)
AS $$
BEGIN
	RETURN QUERY
	SELECT product_id,product_name,unit_price,units_in_stock FROM products WHERE product_name LIKE '%n';
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM products_finish_n();

-- Creamos la función contador_ordenes_anio()
--QUE CUENTE LAS ORDENES POR AÑO devuelve una tabla con año y contador
CREATE OR REPLACE FUNCTION contador_ordenes_anio()
RETURNS TABLE(fecha_orden numeric, contador bigint)
AS $$
BEGIN
	RETURN QUERY
	SELECT EXTRACT (YEAR FROM order_date),COUNT(order_id) FROM orders GROUP BY EXTRACT (YEAR FROM order_date);
END;
$$ LANGUAGE 'plpgsql';
SELECT * FROM contador_ordenes_anio();

--Lo mismo que el ejemplo anterior pero con un parametro de entrada que sea el año
CREATE OR REPLACE FUNCTION contador_ordenes_anio(anio int)
RETURNS TABLE(fecha_orden numeric, contador bigint)
AS $$
BEGIN
	RETURN QUERY
	SELECT EXTRACT (YEAR FROM order_date),COUNT(order_id) FROM orders WHERE EXTRACT (YEAR FROM order_date) = anio GROUP BY EXTRACT (YEAR FROM order_date);
END;
$$ LANGUAGE 'plpgsql';
SELECT * FROM contador_ordenes_anio(1997);

--PROCEDIMIENTO ALMACENADO PARA OBTENER PRECIO PROMEDIO Y SUMA DE 
--UNIDADES EN STOCK POR CATEGORIA
CREATE OR REPLACE FUNCTION almacen(categoria integer)
RETURNS TABLE(Precio_promedio double precision, Suma_unidades bigint)
AS $$
BEGIN
	RETURN QUERY
	SELECT AVG(unit_price),SUM(units_in_stock) FROM products WHERE category_id = categoria;
END;
$$ LANGUAGE 'plpgsql';
SELECT * FROM almacen(2);
