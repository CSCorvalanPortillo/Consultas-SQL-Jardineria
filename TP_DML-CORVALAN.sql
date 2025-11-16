/*Devuelve un listado con el código de oficina y la ciudad donde hay
oficinas.*/

SELECT codigo_oficina,ciudad
FROM jardineria.oficina;

/*Devuelve un listado con la ciudad y el teléfono de las oficinas de España*/

SELECT ciudad,telefono
FROM oficina
WHERE pais='España';

/*Devuelve un listado con el nombre, apellido y correo electrónico de los
empleados cuyo jefe tiene un código igual a 7.*/

SELECT nombre,apellido1,apellido2,email
FROM empleado
WHERE codigo_jefe = '7';

/*Devuelve el nombre del puesto, nombre, apellido y correo electrónico del
jefe de la empresa.*/

SELECT puesto,nombre,apellido1,apellido2,email 
FROM empleado 
WHERE codigo_jefe IS NULL;

/* Devuelve un listado con el nombre, apellido y puesto de aquellos
empleados que no sean representantes de ventas*/

SELECT nombre,apellido1,apellido2,puesto
FROM empleado
WHERE puesto != 'Representante Ventas';

/*Devuelve un listado con el nombre de los todos los clientes españoles*/
SELECT nombre_cliente
FROM cliente
WHERE pais = 'Spain';

/*Devuelve un listado con los distintos estados por los que puede pasar un
pedido*/

SELECT estado
FROM pedido;

/*Devuelve un listado con el código de cliente de aquellos clientes que
realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
aquellos códigos de cliente que aparezcan repetidos. Resuelva la
consulta:
• Utilizando la función YEARde MySQL. */

SELECT DISTINCT cliente.codigo_cliente
FROM cliente
INNER JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE YEAR(pago.fecha_pago) = 2008; /* YEAR devuelve un numero entero*/

/*Devuelve un listado con el código de cliente de aquellos clientes que
realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
aquellos códigos de cliente que aparezcan repetidos. Resuelva la
consulta
Utilizando la función DATE_FORMATde MySQL.*/

SELECT DISTINCT cliente.codigo_cliente
FROM cliente
INNER JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE DATE_FORMAT (pago.fecha_pago, '%Y') = '2008'; /* DATE_FORMAT devuelve una cadena*/


/*Devuelve un listado con el código de cliente de aquellos clientes que
realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar
aquellos códigos de cliente que aparezcan repetidos. Resuelva la
consulta:
Sin utilizar ninguna de las funciones anteriores*/

SELECT DISTINCT cliente.codigo_cliente
FROM cliente
INNER JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE pago.fecha_pago LIKE '2008%'; 

/*Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos que no han sido entregados
a tiempo.*/

SELECT pedido.codigo_pedido, pedido.codigo_cliente, pedido.fecha_esperada, pedido.fecha_entrega, pedido.comentarios
FROM pedido
WHERE pedido.fecha_entrega > pedido.fecha_esperada;

/*Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos cuya fecha de entrega ha
sido al menos dos días antes de la fecha esperada.
Utilizando la función ADDDATEde MySQL.*/

SELECT pedido.codigo_pedido, pedido.codigo_cliente, pedido.fecha_esperada, pedido.fecha_entrega
FROM pedido
WHERE pedido.fecha_entrega <= ADDDATE(pedido.fecha_esperada,-2);

/*Devuelve un listado con el código de pedido, código de cliente, fecha
esperada y fecha de entrega de los pedidos cuya fecha de entrega ha
sido al menos dos días antes de la fecha esperada.
Utilizando la función DATEDIFF de MySQL.*/

SELECT pedido.codigo_pedido, pedido.codigo_cliente, pedido.fecha_esperada, pedido.fecha_entrega
FROM pedido
WHERE DATEDIFF (pedido.fecha_esperada,pedido.fecha_entrega) >= 2; /*HACE FECHA1 - FECHA2*/ 

/*Devuelve un listado de todos los pedidos que fueron rechazados en
2009.*/

SELECT *
FROM pedido
WHERE pedido.estado ='Rechazado' AND pedido.fecha_entrega LIKE '2009%';

/*Devuelve un listado de todos los pedidos que han sido entregados en el
mes de enero de cualquier año.*/

SELECT *
FROM pedido
WHERE pedido.estado = 'Entregado' AND MONTH (pedido.fecha_entrega) = 1;


/*Devuelve un listado con todos los pagos que se realizaron en el año 2008
mediante Paypal. Ordene el resultado de mayor a menor.*/

SELECT *
FROM pago
WHERE pago.forma_pago = 'Paypal' AND pago.fecha_pago LIKE '2008%'
ORDER BY pago.total DESC;

/*Devuelve un listado con todas las formas de pago que aparecen en la
tabla pago. Tenga en cuenta que no deben aparecer formas de pago
repetidas.*/

SELECT DISTINCT pago.forma_pago
FROM pago;

/*Devuelve un listado con todos los productos que pertenecen a la
gama Ornamentales y que tienen más de 100 unidades en stock. El listado
deberá estar ordenado por su precio de venta, mostrando en primer
lugar los de mayor precio.*/

SELECT *
FROM producto
WHERE producto.gama = 'Ornamentales' AND producto.cantidad_en_stock > 100
ORDER BY producto.precio_venta DESC;

/*Devuelve un listado con todos los clientes que sean de la ciudad de
Madrid y cuyo representante de ventas tenga el código de empleado 11 o
30.*/

SELECT nombre_cliente, codigo_empleado_rep_ventas
FROM cliente
WHERE cliente.ciudad = 'Madrid' AND cliente.codigo_empleado_rep_ventas = 11 OR cliente.codigo_empleado_rep_ventas = 30;

/**********************************************CONSULTAS DE RESUMEN*******************************************************/

/*¿Cuántos empleados hay en la compañía?*/

SELECT COUNT(*) empleado
FROM empleado;

SELECT COUNT(apellido2) /*Consulta de prueba*/
FROM empleado
WHERE apellido2 = ''; /*Que no tenga campo "lleno" no significa que sea NULL*/

/*¿Cuántos clientes tiene cada país?*/

SELECT pais, COUNT(*) AS cliente
FROM cliente
GROUP BY pais;

/*¿Cuál fue el pago medio en 2009?*/

SELECT AVG(total)
FROM pago
WHERE fecha_pago LIKE '2009%';

SELECT AVG(total)
FROM pago
WHERE YEAR(fecha_pago) = 2009;

/*¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma
descendente por el número de pedidos.*/

SELECT estado, COUNT(*)
FROM pedido
GROUP BY estado
ORDER BY estado DESC;

/*Calcula el precio de venta de los productos más caro y más barato en
una misma consulta.*/

SELECT MIN(precio_venta), MAX(precio_venta)
FROM producto;

/***************************************CONSULTAS MULTITABLA INTERNA ****************************************************************/

/*Obtén un listado con el nombre de cada cliente y el nombre y apellido de
su representante de ventas.*/


SELECT nombre_cliente, nombre, apellido1 /* Pedimos todos los campos que queremos que nos muestre la consulta*/
FROM cliente /*desde la tabla cliente*/
FULL JOIN empleado ON codigo_empleado_rep_ventas = codigo_empleado; /*donde machea con la tabla empleado la FK(cliente) con la PK(empleado)*/

/*Muestra el nombre de los clientes que hayan realizado pagos junto con
el nombre de sus representantes de ventas.*/

SELECT DISTINCT nombre_cliente, nombre
FROM cliente
INNER JOIN pago ON pago.codigo_cliente = cliente.codigo_cliente
LEFT JOIN empleado ON codigo_empleado_rep_ventas = codigo_empleado; /*por que no podemos usar full join*/

/*Devuelve un listado que muestre los clientes que no han realizado 
ningún pago y los que no han realizado ningún pedido. */

SELECT 
    c.nombre_cliente,
    e.nombre AS nombre_representante,
    e.apellido1 AS apellido_representante
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e 
        ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE p.codigo_cliente IS NULL;


/*Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus 
representantes junto con la ciudad de la oficina a la que pertenece el 
representante.*/

SELECT DISTINCT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, oficina.ciudad
FROM cliente
INNER JOIN pago ON pago.codigo_cliente = cliente.codigo_cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina;

/*Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de 
sus representantes junto con la ciudad de la oficina a la que pertenece el 
representante.*/

SELECT DISTINCT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, oficina.ciudad
FROM cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE pago.codigo_cliente IS NULL;

/*Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.*/

SELECT DISTINCT oficina.linea_direccion1, oficina.linea_direccion2, oficina.ciudad
FROM cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE cliente.ciudad = 'Fuenlabrada';

/*Devuelve el nombre de los clientes y el nombre de sus representantes junto con 
la ciudad de la oficina a la que pertenece el representante.*/

SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, oficina.ciudad
FROM cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina;

/*Devuelve un listado con el nombre de los empleados junto con el nombre de 
sus jefes.*/

SELECT e1.nombre AS nombre_empleado, e1.apellido1 AS apellido_empleado,
       e2.nombre AS nombre_jefe, e2.apellido1 AS apellido_jefe
FROM empleado e1
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado;

/*Devuelve un listado que muestre el nombre de cada empleado, el nombre de su 
jefe y el nombre del jefe de su jefe.*/

SELECT e1.nombre AS empleado, e1.apellido1 AS apellido_empleado,
       e2.nombre AS jefe, e2.apellido1 AS apellido_jefe,
       e3.nombre AS jefe_del_jefe, e3.apellido1 AS apellido_jefe_del_jefe
FROM empleado e1
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado
INNER JOIN empleado e3 ON e2.codigo_jefe = e3.codigo_empleado;

/*Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.*/

SELECT DISTINCT cliente.nombre_cliente
FROM pedido
INNER JOIN cliente ON pedido.codigo_cliente = cliente.codigo_cliente
WHERE pedido.fecha_entrega > pedido.fecha_esperada;

/*Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.*/

SELECT DISTINCT cliente.nombre_cliente, producto.gama
FROM cliente
INNER JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
INNER JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
INNER JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto;


/***************************************CONSULTAS MULTITABLA EXTERNA****************************************************************/

/*Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/

SELECT cliente.nombre_cliente, cliente.codigo_cliente
FROM cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE pago.codigo_cliente IS NULL;

/*Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.*/

SELECT cliente.nombre_cliente, cliente.codigo_cliente
FROM cliente
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE pedido.codigo_cliente IS NULL;

/*Devuelve un listado que muestre los clientes que no han realizado ningún pago 
y los que no han realizado ningún pedido.*/

(
    SELECT cliente.nombre_cliente, cliente.codigo_cliente
    FROM cliente
    LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
    WHERE pago.codigo_cliente IS NULL
)
UNION
(
    SELECT cliente.nombre_cliente, cliente.codigo_cliente
    FROM cliente
    LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
    WHERE pedido.codigo_cliente IS NULL
);

/*Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.*/

SELECT empleado.nombre, empleado.apellido1, empleado.codigo_empleado
FROM empleado
LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE oficina.codigo_oficina IS NULL;

/*Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.*/

SELECT empleado.nombre, empleado.apellido1, empleado.codigo_empleado
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
WHERE cliente.codigo_empleado_rep_ventas IS NULL;

/*Devuelve un listado que muestre solamente los empleados que no tienen un 
cliente asociado junto con los datos de la oficina donde trabajan.*/

SELECT empleado.nombre, empleado.apellido1, empleado.codigo_empleado,
       oficina.ciudad, oficina.linea_direccion1, oficina.linea_direccion2
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
WHERE cliente.codigo_empleado_rep_ventas IS NULL;

/*Devuelve un listado que muestre los empleados que no tienen una oficina 
asociada y los que no tienen un cliente asociado.*/

(
    SELECT empleado.nombre, empleado.apellido1, empleado.codigo_empleado
    FROM empleado
    LEFT JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina
    WHERE oficina.codigo_oficina IS NULL
)
UNION
(
    SELECT empleado.nombre, empleado.apellido1, empleado.codigo_empleado
    FROM empleado
    LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
    WHERE cliente.codigo_empleado_rep_ventas IS NULL
);

/*Devuelve un listado de los productos que nunca han aparecido en un pedido.*/

SELECT producto.codigo_producto, producto.nombre, producto.gama
FROM producto
LEFT JOIN detalle_pedido ON producto.codigo_producto = detalle_pedido.codigo_producto
WHERE detalle_pedido.codigo_producto IS NULL;

/*Devuelve un listado de los productos que nunca han aparecido en un pedido.
El resultado debe mostrar el nombre, la descripción y la imagen del producto.*/

SELECT producto.nombre, producto.descripcion, NULL AS imagen
FROM producto
LEFT JOIN detalle_pedido ON producto.codigo_producto = detalle_pedido.codigo_producto
WHERE detalle_pedido.codigo_producto IS NULL;

/*Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido
los representantes de ventas de algún cliente que haya realizado la compra de 
algún producto de la gama Frutales.*/

SELECT DISTINCT oficina.codigo_oficina, oficina.ciudad, oficina.linea_direccion1
FROM oficina
LEFT JOIN empleado ON oficina.codigo_oficina = empleado.codigo_oficina
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
LEFT JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
LEFT JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
    AND producto.gama = 'Frutales'
WHERE producto.gama IS NULL;

/*Devuelve un listado con los clientes que han realizado algún pedido pero no 
han realizado ningún pago.*/

SELECT DISTINCT cliente.nombre_cliente, cliente.codigo_cliente
FROM cliente
LEFT JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
LEFT JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
WHERE pedido.codigo_cliente IS NOT NULL
  AND pago.codigo_cliente IS NULL;
  
/*Devuelve un listado con los datos de los empleados que no tienen clientes 
asociados y el nombre de su jefe asociado.*/

SELECT empleado.nombre, empleado.apellido1, empleado.apellido2,
       empleado.codigo_empleado, jefe.nombre AS nombre_jefe, jefe.apellido1 AS apellido_jefe
FROM empleado
LEFT JOIN cliente ON empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
INNER JOIN empleado AS jefe ON empleado.codigo_jefe = jefe.codigo_empleado
WHERE cliente.codigo_empleado_rep_ventas IS NULL;








