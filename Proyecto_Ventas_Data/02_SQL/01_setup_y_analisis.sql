CREATE DATABASE IF NOT EXISTS sales_project;
USE sales_project;

CREATE TABLE sales_data (
    row_id INT PRIMARY KEY,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(150),
    segment VARCHAR(50),
    city VARCHAR(150),
    state VARCHAR(150),
    country VARCHAR(150),
    postal_code VARCHAR(50) NULL,
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),
    sales DECIMAL(19, 6),
    quantity INT,
    discount DECIMAL(19, 6),
    profit DECIMAL(19, 6),
    shipping_cost DECIMAL(19, 6),
    order_priority VARCHAR(50)
);

-- Confirmar que no se perdió ni una sola fila
SELECT COUNT(*) FROM sales_data;

-- Ventas Totales y Ganancia Total
-- Para saber cuánto dinero movió la empresa en esos 4 años
SELECT 
    SUM(sales) AS ventas_totales, 
    SUM(profit) AS ganancia_total 
FROM sales_data;

-- Top 3 Categorías más vendidas
-- Para confirmar lo que viste en Excel:
SELECT category, SUM(sales) AS total_ventas
FROM sales_data
GROUP BY category
ORDER BY total_ventas DESC
LIMIT 3;

-- Los 5 Países que más compran
SELECT country, SUM(sales) AS total_ventas
FROM sales_data
GROUP BY country
ORDER BY total_ventas DESC
LIMIT 5;

-- ¿Cuántos códigos postales nos faltan? 
-- (Importante para saber si podemos hacer mapas por código postal después)
SELECT COUNT(*) AS filas_sin_codigo_postal 
FROM sales_data 
WHERE postal_code IS NULL OR postal_code = '';

-- ¿Hay fechas que no tengan el formato esperado?
-- Esta consulta identifica registros que no siguen estrictamente el patrón DD/MM/AAAA.
-- Es esperado que el resultado sea mayor a 0 porque algunas fechas contienen el siguiente formato: 1/01/2011
-- Estas inconsistencias se corregirán posteriormente durante el proceso de limpieza y transformación de datos en Python (pandas).
SELECT COUNT(*) AS fechas_formato_raro
FROM sales_data
WHERE order_date NOT LIKE '__/__/____'; -- Detecta fechas que no coinciden con el patrón estricto DD/MM/AAAA