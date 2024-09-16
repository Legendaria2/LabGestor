-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 16, 2024 at 07:18 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_producto` (IN `producto` VARCHAR(30))   begin
delete from entradas_productos where numero_registro_producto=producto;
delete from cajas_bioburden where id_prueba_recuento in (select id_prueba_recuento from pruebas_recuento where numero_registro_producto=producto);
delete from pruebas_recuento where numero_registro_producto=producto;
delete from controles_negativos_medios where numero_registro_producto=producto;
delete from monitoreos_detecciones where id_deteccion_microorganismo in (select id_deteccion_microorganismo from deteccion_microorganismos where numero_registro_producto=producto);
delete from deteccion_microorganismos where numero_registro_producto=producto;
delete from analisis where numero_registro_producto=producto;
delete from peticiones_cambio where numero_registro_producto=producto;
delete from productos where numero_registro_producto=producto;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_log_accion` (`accion` VARCHAR(20))   select * from log_transaccional where accion = accion$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_log_modulo` (`modulo` INT)   begin
select * from log_transaccional where id_modulo=modulo;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_peticiones_cambio_estado` (IN `estado` VARCHAR(30))   select * from detalles_peticiones_cambio where nombre_estado=estado$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_productos_categoria` (`categoria` VARCHAR(30))   begin
select * from registro_entrada_productos where numero_registro_producto like concat(categoria, '%');
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `filtrar_usuarios_estado_ingreso` (IN `estado_usuario` VARCHAR(10))   begin
select id_usuario, nombre_completo, nombre_usuario, rol_usuario, firma_usuario, fecha_inscripcion, estado from usuarios where estado=estado_usuario;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `numero_productos_analizados_ano` (`ano` INT)   begin
select u.nombre_completo, u.nombre_usuario, u.id_usuario, count(*) from usuarios as u join entradas_productos as ep on u.id_usuario=ep.id_usuario where ep.numero_registro_producto in (select numero_registro_producto from productos where id_modulo=8 or id_modulo=9) and YEAR(ep.fecha_final_analisis)=ano  group by u.id_usuario;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `numero_productos_analizados_mes` (IN `mes_final_analisis` INT)   begin
select u.nombre_completo, u.nombre_usuario, u.id_usuario, count(*) from usuarios as u join entradas_productos as ep on u.id_usuario=ep.id_usuario where ep.numero_registro_producto in (select numero_registro_producto from productos where id_modulo=8 or id_modulo=9) and MONTH(ep.fecha_final_analisis)=mes_final_analisis  group by u.id_usuario;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `numero_productos_analizados_semana` (`semana` INT)   begin
select u.nombre_completo, u.nombre_usuario, u.id_usuario, count(*) from usuarios as u join entradas_productos as ep on u.id_usuario=ep.id_usuario where ep.numero_registro_producto in (select numero_registro_producto from productos where id_modulo=8 or id_modulo=9) and WEEK(ep.fecha_final_analisis)=semana  group by u.id_usuario;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `peticiones_cambio_usuario` (IN `usuario` VARCHAR(15))   begin
select id_usuario, nombre_usuario, nombre_estado, count(*) as n_peticiones from detalles_peticiones_cambio where id_usuario=usuario group by nombre_estado;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rechazar_solicitud_registro_usuario` (`id` VARCHAR(15))   delete from usuarios where id_usuario=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registro_producto` (IN `numero_registro_producto` VARCHAR(30), IN `nombre_producto` VARCHAR(30), IN `fecha_fabricacion` DATE, IN `fecha_vencimiento` DATE, IN `descripcion_producto` TEXT, IN `activo_producto` VARCHAR(50), IN `presentacion_producto` VARCHAR(30), IN `cantidad_producto` VARCHAR(15), IN `numero_lote_producto` VARCHAR(30), IN `tamano_lote_producto` VARCHAR(30), IN `id_cliente` INT, IN `id_fabricante` INT, IN `proposito_analisis` TEXT, IN `condiciones_ambientales` VARCHAR(30), IN `fecha_recepcion` DATE, IN `fecha_inicio_analisis` DATE, IN `id_usuario` VARCHAR(15))   begin
insert into productos(numero_registro_producto, nombre_producto, fecha_fabricacion, fecha_vencimiento, descripcion_producto, activo_producto, presentacion_producto, cantidad_producto, numero_lote_producto, tamano_lote_producto, id_cliente, id_fabricante)
values (numero_registro_producto, nombre_producto, fecha_fabricacion, fecha_vencimiento, descripcion_producto, activo_producto, presentacion_producto, cantidad_producto, numero_lote_producto, tamano_lote_producto, id_cliente, id_fabricante);
insert into entradas_productos(proposito_analisis, condiciones_ambientales, fecha_recepcion, fecha_inicio_analisis, numero_registro_producto, id_usuario)
values (proposito_analisis, condiciones_ambientales, fecha_recepcion, fecha_inicio_analisis, numero_registro_producto, id_usuario);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `analisis`
--

CREATE TABLE `analisis` (
  `id_analisis` int(11) NOT NULL,
  `numero_registro_producto` varchar(30) DEFAULT NULL,
  `id_modulo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `analisis`
--

INSERT INTO `analisis` (`id_analisis`, `numero_registro_producto`, `id_modulo`) VALUES
(52, 'PTM-2404-803', 2),
(53, 'PPM-2404-809', 5),
(54, 'PTM-2404-804', 6),
(55, 'MPM-2404-799', 7),
(56, 'PTM-2404-803', 3),
(57, 'MPM-2404-799', 2),
(58, 'PTM-2404-803', 6),
(59, 'PPM-2404-808', 5),
(60, 'MPM-2404-801', 2),
(61, 'MPM-2404-801', 9),
(62, 'PTM-2404-806', 3),
(63, 'MPM-2404-798', 7),
(65, 'MPM-2404-798', 4),
(66, 'MPM-2404-801', 9),
(68, 'MPM-2404-799', 7),
(69, 'PPM-2404-808', 1),
(71, 'PTM-2404-806', 8),
(72, 'PPM-2404-809', 6),
(73, 'PPM-2404-809', 6),
(74, 'MPM-2404-800', 4),
(75, 'PTM-2404-805', 9),
(76, 'MPM-2404-799', 8),
(77, 'PTM-2404-806', 2),
(78, 'PTM-2404-802', 5),
(79, 'PTM-2404-804', 9),
(80, 'PPM-2404-808', 5),
(81, 'PPM-2404-809', 6),
(83, 'PTM-2404-802', 1),
(84, 'PTM-2404-802', 7),
(85, 'MPM-2404-799', 7),
(86, 'PTM-2404-806', 7),
(87, 'PTM-2404-806', 8),
(88, 'PTM-2404-804', 7),
(89, 'MPM-2404-798', 4),
(90, 'PTM-2404-803', 2),
(91, 'PTM-2404-802', 9),
(92, 'PTM-2404-804', 9),
(93, 'PTM-2404-802', 8),
(94, 'PTM-2404-806', 6),
(95, 'MPM-2404-799', 8),
(97, 'MPM-2404-801', 6),
(98, 'PPM-2404-808', 2),
(99, 'MPM-2404-800', 8),
(100, 'PTM-2404-806', 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `analisis_por_producto`
-- (See below for the actual view)
--
CREATE TABLE `analisis_por_producto` (
`numero_registro_producto` varchar(30)
,`nombre_producto` varchar(50)
,`nombre_modulo` varchar(100)
,`nombre_microorganismo` text
,`nombre_recuento` text
);

-- --------------------------------------------------------

--
-- Table structure for table `cajas_bioburden`
--

CREATE TABLE `cajas_bioburden` (
  `id_caja_bioburden` int(11) NOT NULL,
  `codigo_caja_bioburden` varchar(10) DEFAULT 'CJB-',
  `tipo` varchar(15) NOT NULL,
  `resultado` varchar(15) DEFAULT NULL,
  `metodo_siembra` varchar(30) NOT NULL,
  `medida_aritmetica` varchar(15) NOT NULL,
  `fechayhora_incubacion` datetime NOT NULL,
  `fechayhora_lectura` datetime DEFAULT NULL,
  `factor_disolucion` varchar(5) DEFAULT NULL,
  `nombre_recuento` text NOT NULL,
  `id_prueba_recuento` int(11) NOT NULL,
  `id_usuario` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cajas_bioburden`
--

INSERT INTO `cajas_bioburden` (`id_caja_bioburden`, `codigo_caja_bioburden`, `tipo`, `resultado`, `metodo_siembra`, `medida_aritmetica`, `fechayhora_incubacion`, `fechayhora_lectura`, `factor_disolucion`, `nombre_recuento`, `id_prueba_recuento`, `id_usuario`) VALUES
(91, 'CJB-', 'agar TSA', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '2.1', 'recuento total de microorganismos aerobios', 13, '4787502077'),
(92, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 7, '4730702816'),
(93, 'CJB-', 'agar TSA', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 9, '4804064141'),
(94, 'CJB-', 'otro', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 16, '6690765121'),
(95, 'CJB-', 'agar TSA', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 3, '7514280510'),
(96, 'CJB-', 'agar TSA', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 16, '6573136446'),
(97, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 13, '6690765121'),
(98, 'CJB-', 'otro', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 14, '0872783316'),
(99, 'CJB-', 'agar TSA', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 20, '4787502077'),
(100, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 11, '7514280510'),
(101, 'CJB-', 'otro', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 2, '0872783316'),
(102, 'CJB-', 'otro', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 3, '4787502077'),
(103, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 13, '6573136446'),
(104, 'CJB-', 'otro', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 7, '7514280510'),
(105, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 1, '2595285254'),
(106, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 11, '6573136446'),
(107, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 15, '4787502077'),
(108, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 9, '2595285254'),
(109, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 4, '3769554418'),
(110, 'CJB-', 'otro', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 17, '3769554418'),
(111, 'CJB-', 'otro', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 14, '2595285254'),
(112, 'CJB-', 'otro', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 14, '3769554418'),
(113, 'CJB-', 'otro', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 18, '3769554418'),
(114, 'CJB-', 'agar TSA', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 4, '3769554418'),
(115, 'CJB-', 'otro', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 1, '4804064141'),
(116, 'CJB-', 'agar TSA', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 9, '0872783316'),
(117, 'CJB-', 'otro', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 18, '3769554418'),
(118, 'CJB-', 'otro', '<1UFC/g', 'filtracion por membrana', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 2, '3769554418'),
(119, 'CJB-', 'otro', '<1UFC/g', 'siembra en profundidad', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total combinado de hongos filamentos y levaduras', 5, '4787502077'),
(120, 'CJB-', 'agar Sabouraud', '<1UFC/g', 'siembra en superficie', '<10UFC/g', '2024-09-02 02:17:29', '2024-09-02 02:17:29', '1.1', 'recuento total de microorganismos aerobios', 9, '7514280510'),
(126, 'CJB-', 'agar', 'asd', 'asd', 'asd', '2024-09-09 21:11:57', '2024-09-09 21:11:57', 'asdas', 'recuento de manolo', 2, '7514280510'),
(128, 'CJB-', 'agar', 'hola', 'asd', 'asd', '2024-09-09 21:48:46', '2024-09-09 21:48:46', 'asdas', 'recuento de manolo', 2, '7514280510');

--
-- Triggers `cajas_bioburden`
--
DELIMITER $$
CREATE TRIGGER `delete_cajas_bioburden` BEFORE DELETE ON `cajas_bioburden` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT pr.numero_registro_producto from cajas_bioburden as cj join pruebas_recuento as pr on cj.id_prueba_recuento=pr.id_prueba_recuento where id_caja_bioburden=old.id_caja_bioburden), nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);



INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' elimino un resultado de  la prueba de recuento ', old.nombre_recuento ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),
 
JSON_object('tipo', old.tipo, 'resultado', old.resultado, 'metodo_siembra', old.metodo_siembra, 'medida_aritmetica', old.medida_aritmetica, 'fechayhora_incubacion', old.fechayhora_incubacion, 'fechayhora_lectura', old.fechayhora_lectura, 'factor_disolucion', old.factor_disolucion, 'nombre_recuento', old.nombre_recuento),
 
'eliminar', now(), 3, concat(old.codigo_caja_bioburden, old.id_caja_bioburden), numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_cajas_bioburden` AFTER INSERT ON `cajas_bioburden` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT pr.numero_registro_producto from cajas_bioburden as cj join pruebas_recuento as pr on cj.id_prueba_recuento=pr.id_prueba_recuento where id_caja_bioburden=new.id_caja_bioburden), nombre_completo:=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);




INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' registro un resultado de  la prueba de recuento ', new.nombre_recuento ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),
 
JSON_object('tipo', new.tipo, 'resultado', new.resultado, 'metodo_siembra', new.metodo_siembra, 'medida_aritmetica', new.medida_aritmetica, 'fechayhora_incubacion', new.fechayhora_incubacion, 'fechayhora_lectura', new.fechayhora_lectura, 'factor_disolucion', new.factor_disolucion, 'nombre_recuento', new.nombre_recuento),
 
'registrar', now(), 3, concat(new.codigo_caja_bioburden, new.id_caja_bioburden), numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_cajas_bioburden` BEFORE UPDATE ON `cajas_bioburden` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT pr.numero_registro_producto from cajas_bioburden as cj join pruebas_recuento as pr on cj.id_prueba_recuento=pr.id_prueba_recuento where id_caja_bioburden=new.id_caja_bioburden), nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' edito un resultado de  la prueba de recuento ', new.nombre_recuento ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),

JSON_OBJECT('registro_anterior', 
JSON_object('tipo', old.tipo, 'resultado', old.resultado, 'metodo_siembra', old.metodo_siembra, 'medida_aritmetica', old.medida_aritmetica, 'fechayhora_incubacion', old.fechayhora_incubacion, 'fechayhora_lectura', old.fechayhora_lectura, 'factor_disolucion', old.factor_disolucion, 'nombre_recuento', old.nombre_recuento), 
'registro_nuevo', 
JSON_object('tipo', new.tipo, 'resultado', new.resultado, 'metodo_siembra', new.metodo_siembra, 'medida_aritmetica', new.medida_aritmetica, 'fechayhora_incubacion', new.fechayhora_incubacion, 'fechayhora_lectura', new.fechayhora_lectura, 'factor_disolucion', new.factor_disolucion, 'nombre_recuento', new.nombre_recuento)),    


'editar', now(), 3, concat(new.codigo_caja_bioburden, new.id_caja_bioburden), numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre_cliente` varchar(50) NOT NULL,
  `direccion_cliente` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre_cliente`, `direccion_cliente`) VALUES
(1, 'BLISTECO S.A.S', 'Trans. 20A N° 4A-81, Bogota.'),
(2, 'NUTRICEL N.C', 'N.E'),
(3, 'PROCLIN PHARMA S.A.S', 'Cra. 68D N°98A - 73, Bogotá'),
(4, 'KNOVEL PHARAMA S.A.S', 'Calle 66 N° 73A-38, Bogotá.');

-- --------------------------------------------------------

--
-- Table structure for table `controles_negativos_medios`
--

CREATE TABLE `controles_negativos_medios` (
  `id_control_negativo` int(11) NOT NULL,
  `codigo_control_negativo` varchar(10) DEFAULT 'CNM-',
  `medio_cultivo` text DEFAULT NULL,
  `fechayhora_incubacion` datetime NOT NULL,
  `fechayhora_lectura` datetime DEFAULT NULL,
  `resultado` varchar(30) DEFAULT NULL,
  `id_usuario` varchar(15) NOT NULL,
  `numero_registro_producto` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `controles_negativos_medios`
--

INSERT INTO `controles_negativos_medios` (`id_control_negativo`, `codigo_control_negativo`, `medio_cultivo`, `fechayhora_incubacion`, `fechayhora_lectura`, `resultado`, `id_usuario`, `numero_registro_producto`) VALUES
(1, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '3769554418', 'MPM-2404-801'),
(2, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'MPM-2404-800'),
(3, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'PTM-2404-802'),
(6, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4730702816', 'PTM-2404-803'),
(7, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '0872783316', 'MPM-2404-801'),
(8, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '0872783316', 'MPM-2404-800'),
(9, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '0872783316', 'MPM-2404-801'),
(10, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '2595285254', 'MPM-2404-798'),
(12, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '7514280510', 'PTM-2404-805'),
(13, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'PPM-2404-808'),
(14, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '2595285254', 'PTM-2404-802'),
(15, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4787502077', 'MPM-2404-799'),
(16, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '7514280510', 'MPM-2404-799'),
(17, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '7514280510', 'MPM-2404-800'),
(18, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4804064141', 'MPM-2404-799'),
(19, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'PTM-2404-804'),
(20, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '3769554418', 'MPM-2404-799'),
(21, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '3769554418', 'PTM-2404-805'),
(22, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'PTM-2404-802'),
(23, 'CNM-', 'caldo digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6573136446', 'MPM-2404-801'),
(24, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '0872783316', 'PTM-2404-804'),
(25, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4787502077', 'PPM-2404-808'),
(26, 'CNM-', 'agar sabouraud dextrosa', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '6690765121', 'PPM-2404-808'),
(27, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '0872783316', 'PPM-2404-808'),
(28, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4804064141', 'MPM-2404-799'),
(29, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '4730702816', 'PTM-2404-803'),
(30, 'CNM-', 'agar digerido caseina y soya', '2024-09-02 02:30:11', '2024-09-02 02:30:11', '<1UFC/placa', '7514280510', 'PTM-2404-804');

--
-- Triggers `controles_negativos_medios`
--
DELIMITER $$
CREATE TRIGGER `delete_controles_negativos_medios` BEFORE DELETE ON `controles_negativos_medios` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' elimino un control negativo de medio del producto ', (select nombre_producto from productos WHERE numero_registro_producto = old.numero_registro_producto), ' con indentificacion: ', old.numero_registro_producto),
 
 JSON_object('medio_cultivo', old.medio_cultivo, 'fechayhora_incubacion', old.fechayhora_incubacion, 'fechayhora_lectura', old.fechayhora_lectura, 'resultado', old.resultado, 'id_usuario', old.id_usuario, 'numero_registro_producto', old.numero_registro_producto),
 
'eliminar', now(), 4, concat(old.codigo_control_negativo, old.id_control_negativo), old.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_controles_negativos_medios` AFTER INSERT ON `controles_negativos_medios` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' registro un control negativo de medio del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', new.numero_registro_producto),
 
 JSON_object('medio_cultivo', new.medio_cultivo, 'fechayhora_incubacion', new.fechayhora_incubacion, 'fechayhora_lectura', new.fechayhora_lectura, 'resultado', new.resultado, 'id_usuario', new.id_usuario, 'numero_registro_producto', new.numero_registro_producto),
 
'registrar', now(), 4, concat(new.codigo_control_negativo, new.id_control_negativo), new.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_controles_negativos_medios` BEFORE UPDATE ON `controles_negativos_medios` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' edito un control negativo de medio del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', new.numero_registro_producto),

 JSON_OBJECT('registro_anterior',  JSON_object('medio_cultivo', old.medio_cultivo, 'fechayhora_incubacion', old.fechayhora_incubacion, 'fechayhora_lectura', old.fechayhora_lectura, 'resultado', old.resultado, 'id_usuario', old.id_usuario, 'numero_registro_producto', old.numero_registro_producto), 'registro_nuevo',  JSON_object('medio_cultivo', new.medio_cultivo, 'fechayhora_incubacion', new.fechayhora_incubacion, 'fechayhora_lectura', new.fechayhora_lectura, 'resultado', new.resultado, 'id_usuario', new.id_usuario, 'numero_registro_producto', new.numero_registro_producto)),
 
'editar', now(), 4, concat(new.codigo_control_negativo, new.id_control_negativo), new.numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `detalles_peticiones_cambio`
-- (See below for the actual view)
--
CREATE TABLE `detalles_peticiones_cambio` (
`id_peticion_cambio` int(11)
,`descripcion_peticion` longtext
,`fechayhora_creacion_peticion` datetime
,`id_usuario` varchar(15)
,`nombre_usuario` varchar(83)
,`nombre_estado` varchar(30)
,`nombre_modulo` varchar(100)
,`numero_registro_producto` varchar(30)
,`nombre_producto` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `deteccion_microorganismos`
--

CREATE TABLE `deteccion_microorganismos` (
  `id_deteccion_microorganismo` int(11) NOT NULL,
  `codigo_deteccion_microorganismo` varchar(10) DEFAULT 'DCM-',
  `nombre_microorganismo` text DEFAULT NULL,
  `especificacion` varchar(15) NOT NULL,
  `concepto` tinyint(1) DEFAULT 0,
  `tratamiento` text NOT NULL,
  `metodo_usado` varchar(30) NOT NULL,
  `cantidad_muestra` varchar(15) NOT NULL,
  `volumen_diluyente` varchar(15) NOT NULL,
  `resultado` varchar(15) DEFAULT NULL,
  `numero_registro_producto` varchar(30) NOT NULL,
  `id_usuario` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `deteccion_microorganismos`
--

INSERT INTO `deteccion_microorganismos` (`id_deteccion_microorganismo`, `codigo_deteccion_microorganismo`, `nombre_microorganismo`, `especificacion`, `concepto`, `tratamiento`, `metodo_usado`, `cantidad_muestra`, `volumen_diluyente`, `resultado`, `numero_registro_producto`, `id_usuario`) VALUES
(1, 'DCM-', 'Bacillus cereus', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '51.426742303849', 'becerra', 'aucencia/g', 'MPM-2404-801', '2595285254'),
(2, 'DCM-', 'Escherichia coli', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '13.370942115138', 'becerra', 'aucencia/g', 'MPM-2404-801', '4804064141'),
(3, 'DCM-', 'Escherichia coli', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-006', '94.885687880857', 'becerra', 'aucencia/g', 'PTM-2404-806', '7514280510'),
(4, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-006', '29.819911289094', 'becerra', 'aucencia/g', 'PTM-2404-803', '6690765121'),
(5, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '50.753064742718', 'becerra', 'aucencia/g', 'MPM-2404-799', '0872783316'),
(6, 'DCM-', 'Salmonella', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '58.591667490642', 'becerra', 'aucencia/g', 'MPM-2404-801', '2595285254'),
(7, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-006', '31.934920619419', 'becerra', 'aucencia/g', 'MPM-2404-801', '7514280510'),
(8, 'DCM-', 'Escherichia coli', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '22.023786740369', 'becerra', 'aucencia/g', 'MPM-2404-801', '7514280510'),
(9, 'DCM-', 'Salmonella', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '56.731390934385', 'becerra', 'aucencia/g', 'PTM-2404-803', '2595285254'),
(10, 'DCM-', 'Escherichia coli', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-009', '55.682381608852', 'becerra', 'aucencia/g', 'PTM-2404-802', '6573136446'),
(11, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-008', '13.896955618419', 'becerra', 'aucencia/g', 'MPM-2404-799', '4787502077'),
(12, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '41.838992970828', 'becerra', 'aucencia/g', 'PTM-2404-805', '2595285254'),
(13, 'DCM-', 'Bacillus cereus', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-008', '91.271166131039', 'becerra', 'aucencia/g', 'MPM-2404-798', '4787502077'),
(14, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '13.039211960680', 'becerra', 'aucencia/g', 'MPM-2404-800', '6690765121'),
(16, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-006', '22.120108011933', 'becerra', 'aucencia/g', 'PTM-2404-803', '4730702816'),
(18, 'DCM-', 'Escherichia coli', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '41.341175540411', 'becerra', 'aucencia/g', 'PTM-2404-804', '7514280510'),
(19, 'DCM-', 'Escherichia coli', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '59.012933634119', 'becerra', 'aucencia/g', 'PPM-2404-809', '7514280510'),
(20, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-008', '14.621619613512', 'becerra', 'aucencia/g', 'MPM-2404-798', '2595285254'),
(21, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-006', '22.517513087824', 'becerra', 'aucencia/g', 'PPM-2404-809', '6573136446'),
(22, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '23.722982773369', 'becerra', 'aucencia/g', 'PTM-2404-805', '4730702816'),
(23, 'DCM-', 'Bacillus cereus', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-009', '3.6581870791240', 'becerra', 'aucencia/g', 'PTM-2404-804', '3769554418'),
(24, 'DCM-', 'Escherichia coli', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-008', '46.710048154957', 'becerra', 'aucencia/g', 'MPM-2404-799', '6573136446'),
(25, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '93.097613262595', 'becerra', 'aucencia/g', 'PTM-2404-805', '6573136446'),
(26, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '51.784259539574', 'becerra', 'aucencia/g', 'PTM-2404-806', '0872783316'),
(27, 'DCM-', 'Escherichia coli', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '30.536541920866', 'becerra', 'aucencia/g', 'PTM-2404-805', '2595285254'),
(28, 'DCM-', 'Escherichia coli', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-010', '24.161996898571', 'becerra', 'aucencia/g', 'PPM-2404-808', '7514280510'),
(29, 'DCM-', 'Bacillus cereus', 'aucencia/g', 1, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-007', '39.001835725931', 'becerra', 'aucencia/g', 'MPM-2404-801', '6573136446'),
(30, 'DCM-', 'Salmonella', 'aucencia/g', 0, 'Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...', 'PON-MB-008', '41.181613030448', 'becerra', 'aucencia/g', 'MPM-2404-799', '7514280510'),
(31, 'DCM-', 'asdas', 'asdasd', 1, 'asdasdas', 'asdasdas', 'asdasdas', 'becerra', 'asdasdas', 'PTM-2404-805', '0872783316');

--
-- Triggers `deteccion_microorganismos`
--
DELIMITER $$
CREATE TRIGGER `delete_deteccion_microorganismos` BEFORE DELETE ON `deteccion_microorganismos` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' elimino la deteccion del microorganismo ', old.nombre_microorganismo, ' en el producto ', (select nombre_producto from productos WHERE numero_registro_producto = old.numero_registro_producto), ' con indentificacion: ', old.numero_registro_producto),
 
 JSON_object('nombre_microorganismo', old.nombre_microorganismo, 'especificacion', old.especificacion, 'concepto', old.concepto, 'tratamiento', old.tratamiento, 'metodo_usado', old.metodo_usado, 'cantidad_muestra', old.cantidad_muestra, 'volumen_diluyente', old.volumen_diluyente, 'resultado', old.resultado, 'numero_registro_producto', old.numero_registro_producto, 'id_usuario', old.id_usuario),
 
'eliminar', now(), 5, concat(old.codigo_deteccion_microorganismo, old.id_deteccion_microorganismo), old.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_deteccion_microorganismos` AFTER INSERT ON `deteccion_microorganismos` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' registro la deteccion del microorganismo ', new.nombre_microorganismo, ' en el producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', new.numero_registro_producto),
 
 JSON_object('nombre_microorganismo', new.nombre_microorganismo, 'especificacion', new.especificacion, 'concepto', new.concepto, 'tratamiento', new.tratamiento, 'metodo_usado', new.metodo_usado, 'cantidad_muestra', new.cantidad_muestra, 'volumen_diluyente', new.volumen_diluyente, 'resultado', new.resultado, 'numero_registro_producto', new.numero_registro_producto, 'id_usuario', new.id_usuario),
 
'registrar', now(), 5, concat(new.codigo_deteccion_microorganismo, new.id_deteccion_microorganismo), new.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_deteccion_microorganismos` BEFORE UPDATE ON `deteccion_microorganismos` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' edito la deteccion del microorganismo ', new.nombre_microorganismo, ' en el producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', new.numero_registro_producto),

 JSON_OBJECT('registro_anterior',  JSON_object('nombre_microorganismo', old.nombre_microorganismo, 'especificacion', old.especificacion, 'concepto', old.concepto, 'tratamiento', old.tratamiento, 'metodo_usado', old.metodo_usado, 'cantidad_muestra', old.cantidad_muestra, 'volumen_diluyente', old.volumen_diluyente, 'resultado', old.resultado, 'numero_registro_producto', old.numero_registro_producto, 'id_usuario', old.id_usuario), 'registro_nuevo',  JSON_object('nombre_microorganismo', new.nombre_microorganismo, 'especificacion', new.especificacion, 'concepto', new.concepto, 'tratamiento', new.tratamiento, 'metodo_usado', new.metodo_usado, 'cantidad_muestra', new.cantidad_muestra, 'volumen_diluyente', new.volumen_diluyente, 'resultado', new.resultado, 'numero_registro_producto', new.numero_registro_producto, 'id_usuario', new.id_usuario)),

 
'editar', now(), 5, concat(new.codigo_deteccion_microorganismo, new.id_deteccion_microorganismo), new.numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `entradas_productos`
--

CREATE TABLE `entradas_productos` (
  `id_entrada` int(11) NOT NULL,
  `codigo_entrada` varchar(30) DEFAULT 'ENT-',
  `proposito_analisis` text NOT NULL,
  `condiciones_ambientales` varchar(30) NOT NULL,
  `fecha_recepcion` date NOT NULL,
  `fecha_inicio_analisis` date NOT NULL,
  `fecha_final_analisis` date DEFAULT NULL,
  `numero_registro_producto` varchar(30) NOT NULL,
  `id_usuario` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `entradas_productos`
--

INSERT INTO `entradas_productos` (`id_entrada`, `codigo_entrada`, `proposito_analisis`, `condiciones_ambientales`, `fecha_recepcion`, `fecha_inicio_analisis`, `fecha_final_analisis`, `numero_registro_producto`, `id_usuario`) VALUES
(13, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de materia prima.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-04-27', 'PTM-2404-806', '4804064141'),
(14, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de materia prima.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-04-27', 'PTM-2404-805', '4787502077'),
(16, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de materia prima.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-04-27', 'PTM-2404-802', '0872783316'),
(17, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto temrinado.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-05-06', 'PTM-2404-802', '0872783316'),
(18, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto temrinado. Estabilidad acelerada tiempo 3.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-05-06', 'MPM-2404-798', '3769554418'),
(19, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto temrinado. Estabilidad acelerada tiempo 3.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-05-06', 'MPM-2404-799', '4730702816'),
(21, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto terminado. Estabilidad On Going tiempo 12', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-05-06', 'MPM-2404-801', '4730702816'),
(22, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de material y empaque.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-05-06', 'PTM-2404-806', '0872783316'),
(23, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto en proceso.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-04-22', 'MPM-2404-799', '4804064141'),
(24, 'ENT-', 'Anï¿½lisis para liberaciï¿½n de producto en proceso.', 'AMBIENTE', '2024-04-22', '2024-04-22', '2024-04-22', 'PTM-2404-805', '2595285254'),
(53, '', 'revisar si pega fuerte', 'ambientale', '2024-09-13', '2024-09-13', NULL, 'esteesuniddeprueba2', '321'),
(54, 'ENT-', 'revisar si pega fuerte', 'ambientale', '2024-09-13', '2024-09-13', NULL, 'esteesuniddeprueba3', '321');

--
-- Triggers `entradas_productos`
--
DELIMITER $$
CREATE TRIGGER `delete_entradas_productos` BEFORE DELETE ON `entradas_productos` FOR EACH ROW BEGIN
declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);

INSERT INTO log_transaccional(descripcion,detalles_registro,  accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values

(CONCAT('El usuario ', nombre_completo, ' eliminò  la entrada al area del producto ', (select nombre_producto from productos WHERE numero_registro_producto = old.numero_registro_producto), ' con indentificacion: ', (old.numero_registro_producto)),
 
  JSON_object('id_entrada', old.id_entrada, 'proposito_analisis', old.proposito_analisis, 'condiciones_ambientales', old.condiciones_ambientales, 'fecha_recepcion', old.fecha_recepcion, 'fecha_inicio_analisis', old.fecha_inicio_analisis, 'fecha_final_analisis', old.fecha_final_analisis, 'numero_registro_producto', old.numero_registro_producto, 'id_usuario', old.id_usuario),
 
 'eliminar', now(), 1, concat(old.codigo_entrada, old.id_entrada), old.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_entradas_productos` AFTER INSERT ON `entradas_productos` FOR EACH ROW BEGIN
declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' registro la entrada al area del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', (new.numero_registro_producto)),
 
 JSON_object('id_entrada', new.id_entrada, 'proposito_analisis', new.proposito_analisis, 'condiciones_ambientales', new.condiciones_ambientales, 'fecha_recepcion', new.fecha_recepcion, 'fecha_inicio_analisis', new.fecha_inicio_analisis, 'fecha_final_analisis', new.fecha_final_analisis, 'numero_registro_producto', new.numero_registro_producto, 'id_usuario', new.id_usuario),
 
'registrar', now(), 1, concat(new.codigo_entrada, new.id_entrada), new.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_entradas_productos` BEFORE UPDATE ON `entradas_productos` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values

(CONCAT('El usuario ', nombre_completo, 
' editò la entrada al area del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', new.numero_registro_producto),
 
JSON_OBJECT('registro_anterior', JSON_OBJECT('proposito_analisis', old.proposito_analisis, 'condiciones_ambientales', old.condiciones_ambientales, 'fecha_recepcion', old.fecha_recepcion, 'fecha_inicio_analisis', old.fecha_inicio_analisis, 'fecha_final_analisis', old.fecha_final_analisis, 'numero_registro_producto', old.numero_registro_producto, 'id_usuario', old.id_usuario), 'registro_nuevo', JSON_OBJECT('proposito_analisis', new.proposito_analisis, 'condiciones_ambientales', new.condiciones_ambientales, 'fecha_recepcion', new.fecha_recepcion, 'fecha_inicio_analisis', new.fecha_inicio_analisis, 'fecha_final_analisis', new.fecha_final_analisis, 'numero_registro_producto', new.numero_registro_producto, 'id_usuario', new.id_usuario)),
 
 
'editar', now(), 1, concat(old.codigo_entrada, old.id_entrada),  old.numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `estados`
--

CREATE TABLE `estados` (
  `id_estado` int(11) NOT NULL,
  `nombre_estado` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `estados`
--

INSERT INTO `estados` (`id_estado`, `nombre_estado`) VALUES
(1, 'pendiente'),
(2, 'en proceso'),
(3, 'realizado'),
(4, 'archivado');

-- --------------------------------------------------------

--
-- Table structure for table `etapas_deteccion`
--

CREATE TABLE `etapas_deteccion` (
  `id_etapa_deteccion` int(11) NOT NULL,
  `nombre_etapa` varchar(30) NOT NULL,
  `tiempo_etapa` varchar(30) NOT NULL,
  `temperatura_etapa` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `etapas_deteccion`
--

INSERT INTO `etapas_deteccion` (`id_etapa_deteccion`, `nombre_etapa`, `tiempo_etapa`, `temperatura_etapa`) VALUES
(1, 'incubacion previa', '18-24 horas', '30-35 c'),
(2, 'seleccion', '24-48 horas', '42-44 c'),
(3, 'subcultivo', '18-72 horas', '30-35 c');

-- --------------------------------------------------------

--
-- Table structure for table `fabricantes`
--

CREATE TABLE `fabricantes` (
  `id_fabricante` int(11) NOT NULL,
  `nombre_fabricante` varchar(50) NOT NULL,
  `direccion_fabricante` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fabricantes`
--

INSERT INTO `fabricantes` (`id_fabricante`, `nombre_fabricante`, `direccion_fabricante`) VALUES
(1, 'NORTHEAST PHARMACEUTICAL GROUP CO LTD', 'N.E'),
(2, 'MACCO ORGANIQUES', 'N.E'),
(3, 'VITECO S.A', 'Trans. 20A N 4A-81, Bogota.');

-- --------------------------------------------------------

--
-- Table structure for table `log_transaccional`
--

CREATE TABLE `log_transaccional` (
  `id_log` int(11) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `detalles_registro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`detalles_registro`)),
  `accion` enum('registrar','editar','eliminar') NOT NULL,
  `fechayhora_log` datetime NOT NULL,
  `id_modulo` int(11) NOT NULL,
  `codigo_registro` varchar(30) NOT NULL,
  `numero_registro_producto` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_transaccional`
--

INSERT INTO `log_transaccional` (`id_log`, `descripcion`, `detalles_registro`, `accion`, `fechayhora_log`, `id_modulo`, `codigo_registro`, `numero_registro_producto`) VALUES
(1, NULL, '{\"id_entrada\": 15, \"proposito_analisis\": \"Anï¿½lisis para liberaciï¿½n de materia prima.\", \"condiciones_ambientales\": \"AMBIENTE\", \"fecha_recepcion\": \"2024-04-22\", \"fecha_inicio_analisis\": \"2024-04-22\", \"fecha_final_analisis\": \"2024-04-27\", \"numero_registro_producto\": \"MEEM-2404-807\", \"id_usuario\": \"6690765121\"}', 'eliminar', '2024-09-13 03:15:41', 1, 'ENT-15', 'MEEM-2404-807'),
(2, 'El usuario     eliminò  la entrada al area del producto LIDOCAINA JALEA HCL 2% con indentificacion: MEEM-2404-807', '{\"id_entrada\": 20, \"proposito_analisis\": \"Anï¿½lisis para liberaciï¿½n de producto terminado. Estabilidad On going tiempo 24\", \"condiciones_ambientales\": \"AMBIENTE\", \"fecha_recepcion\": \"2024-04-22\", \"fecha_inicio_analisis\": \"2024-04-22\", \"fecha_final_analisis\": \"2024-05-06\", \"numero_registro_producto\": \"MEEM-2404-807\", \"id_usuario\": \"2595285254\"}', 'eliminar', '2024-09-13 03:15:41', 1, 'ENT-20', 'MEEM-2404-807'),
(3, 'El usuario     elimino un control negativo de medio del producto LIDOCAINA JALEA HCL 2% con indentificacion: MEEM-2404-807', '{\"medio_cultivo\": \"agar sabouraud dextrosa\", \"fechayhora_incubacion\": \"2024-09-02 02:30:11\", \"fechayhora_lectura\": \"2024-09-02 02:30:11\", \"resultado\": \"<1UFC/placa\", \"id_usuario\": \"3769554418\", \"numero_registro_producto\": \"MEEM-2404-807\"}', 'eliminar', '2024-09-13 03:15:41', 4, 'CNM-4', 'MEEM-2404-807'),
(4, 'El usuario     elimino un control negativo de medio del producto LIDOCAINA JALEA HCL 2% con indentificacion: MEEM-2404-807', '{\"medio_cultivo\": \"agar sabouraud dextrosa\", \"fechayhora_incubacion\": \"2024-09-02 02:30:11\", \"fechayhora_lectura\": \"2024-09-02 02:30:11\", \"resultado\": \"<1UFC/placa\", \"id_usuario\": \"0872783316\", \"numero_registro_producto\": \"MEEM-2404-807\"}', 'eliminar', '2024-09-13 03:15:41', 4, 'CNM-5', 'MEEM-2404-807'),
(5, NULL, '{\"medio_cultivo\": \"agar sabouraud dextrosa\", \"fechayhora_incubacion\": \"2024-09-02 02:30:11\", \"fechayhora_lectura\": \"2024-09-02 02:30:11\", \"resultado\": \"<1UFC/placa\", \"id_usuario\": \"6690765121\", \"numero_registro_producto\": \"MEEM-2404-807\"}', 'eliminar', '2024-09-13 03:15:41', 4, 'CNM-11', 'MEEM-2404-807'),
(6, 'El usuario     elimino un monitoreo de la deteccion del microrganismo Escherichia coli del producto LIDOCAINA JALEA HCL 2% con identificacion: MEEM-2404-807', '{\"volumen_muestra\": \"62.052489419589\", \"nombre_diluyente\": \"caldo macconkey\", \"fechayhora_inicio\": \"2024-09-02 03:21:40\", \"fechayhora_final\": \"2024-09-02 03:21:40\", \"id_etapa_deteccion\": 1, \"id_deteccion_microorganismo\": 15, \"id_usuario\": \"4804064141\"}', 'eliminar', '2024-09-13 03:15:41', 6, 'MTD-3', 'MEEM-2404-807'),
(7, NULL, '{\"volumen_muestra\": \"75.647999650844\", \"nombre_diluyente\": \"caldo macconkey\", \"fechayhora_inicio\": \"2024-09-02 03:21:40\", \"fechayhora_final\": \"2024-09-02 03:21:40\", \"id_etapa_deteccion\": 1, \"id_deteccion_microorganismo\": 17, \"id_usuario\": \"6690765121\"}', 'eliminar', '2024-09-13 03:15:41', 6, 'MTD-17', 'MEEM-2404-807'),
(8, 'El usuario     elimino un monitoreo de la deteccion del microrganismo Salmonella del producto LIDOCAINA JALEA HCL 2% con identificacion: MEEM-2404-807', '{\"volumen_muestra\": \"92.859988399595\", \"nombre_diluyente\": \"agar macconkey\", \"fechayhora_inicio\": \"2024-09-02 03:21:40\", \"fechayhora_final\": \"2024-09-02 03:21:40\", \"id_etapa_deteccion\": 3, \"id_deteccion_microorganismo\": 17, \"id_usuario\": \"3769554418\"}', 'eliminar', '2024-09-13 03:15:41', 6, 'MTD-20', 'MEEM-2404-807'),
(9, 'El usuario     elimino la deteccion del microorganismo Escherichia coli en el producto LIDOCAINA JALEA HCL 2% con indentificacion: MEEM-2404-807', '{\"nombre_microorganismo\": \"Escherichia coli\", \"especificacion\": \"aucencia/g\", \"concepto\": 1, \"tratamiento\": \"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...\", \"metodo_usado\": \"PON-MB-006\", \"cantidad_muestra\": \"84.750869263267\", \"volumen_diluyente\": \"becerra\", \"resultado\": \"aucencia/g\", \"numero_registro_producto\": \"MEEM-2404-807\", \"id_usuario\": \"2595285254\"}', 'eliminar', '2024-09-13 03:15:41', 5, 'DCM-15', 'MEEM-2404-807'),
(10, 'El usuario     elimino la deteccion del microorganismo Salmonella en el producto LIDOCAINA JALEA HCL 2% con indentificacion: MEEM-2404-807', '{\"nombre_microorganismo\": \"Salmonella\", \"especificacion\": \"aucencia/g\", \"concepto\": 0, \"tratamiento\": \"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit...\", \"metodo_usado\": \"PON-MB-010\", \"cantidad_muestra\": \"7.9134895146518\", \"volumen_diluyente\": \"becerra\", \"resultado\": \"aucencia/g\", \"numero_registro_producto\": \"MEEM-2404-807\", \"id_usuario\": \"6573136446\"}', 'eliminar', '2024-09-13 03:15:41', 5, 'DCM-17', 'MEEM-2404-807');

-- --------------------------------------------------------

--
-- Table structure for table `modulos`
--

CREATE TABLE `modulos` (
  `id_modulo` int(11) NOT NULL,
  `nombre_modulo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `modulos`
--

INSERT INTO `modulos` (`id_modulo`, `nombre_modulo`) VALUES
(1, 'pendiente por analizar'),
(2, 'registro pruebas de recuento'),
(3, 'registro resultados pruebas de recuento'),
(4, 'registro de controles negativos de medios'),
(5, 'registro deteccion de microorganismos especificos'),
(6, 'registro monitoreos de detecciones de microorganismos especificos'),
(7, 'revision de documentacion'),
(8, 'finalizacion de analisis'),
(9, 'analisis archivado');

-- --------------------------------------------------------

--
-- Table structure for table `monitoreos_detecciones`
--

CREATE TABLE `monitoreos_detecciones` (
  `id_monitoreo_deteccion` int(11) NOT NULL,
  `codigo_monitoreo_deteccion` varchar(10) DEFAULT 'MTD-',
  `volumen_muestra` varchar(15) NOT NULL,
  `nombre_diluyente` varchar(30) NOT NULL,
  `fechayhora_inicio` datetime NOT NULL,
  `fechayhora_final` datetime DEFAULT NULL,
  `id_etapa_deteccion` int(11) NOT NULL,
  `id_deteccion_microorganismo` int(11) NOT NULL,
  `id_usuario` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `monitoreos_detecciones`
--

INSERT INTO `monitoreos_detecciones` (`id_monitoreo_deteccion`, `codigo_monitoreo_deteccion`, `volumen_muestra`, `nombre_diluyente`, `fechayhora_inicio`, `fechayhora_final`, `id_etapa_deteccion`, `id_deteccion_microorganismo`, `id_usuario`) VALUES
(1, 'MTD-', '48.505487150308', 'TSB', '2024-09-02 03:21:39', '2024-09-02 03:21:39', 1, 25, '4730702816'),
(2, 'MTD-', '21.166621405001', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 19, '6573136446'),
(4, 'MTD-', '90.597791369537', 'caldo macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 14, '7514280510'),
(5, 'MTD-', '13.804179555045', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 11, '4730702816'),
(6, 'MTD-', '62.361406813471', 'caldo macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 19, '0872783316'),
(7, 'MTD-', '67.711404357851', 'caldo macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 22, '3769554418'),
(8, 'MTD-', '89.788515566201', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 11, '0872783316'),
(9, 'MTD-', '16.792772146048', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 13, '6690765121'),
(10, 'MTD-', '54.997168561278', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 27, '2595285254'),
(11, 'MTD-', '34.466191950699', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 29, '3769554418'),
(12, 'MTD-', '43.031634004623', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 8, '0872783316'),
(13, 'MTD-', '78.857142620931', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 27, '6690765121'),
(14, 'MTD-', '58.229173343361', 'caldo macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 28, '4730702816'),
(15, 'MTD-', '37.412261356419', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 8, '2595285254'),
(16, 'MTD-', '26.398115473520', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 9, '0872783316'),
(18, 'MTD-', '69.907244177526', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 14, '4804064141'),
(19, 'MTD-', '67.638898791469', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 5, '7514280510'),
(21, 'MTD-', '18.934226069490', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 2, '4787502077'),
(22, 'MTD-', '32.134206385165', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 1, '6690765121'),
(23, 'MTD-', '38.110347015869', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 16, '4730702816'),
(24, 'MTD-', '72.135193685341', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 24, '6690765121'),
(25, 'MTD-', '63.022206787862', 'caldo macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 28, '3769554418'),
(26, 'MTD-', '1.2213240717019', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 7, '3769554418'),
(27, 'MTD-', '80.147887267308', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 16, '7514280510'),
(28, 'MTD-', '97.038340978922', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 1, 27, '7514280510'),
(29, 'MTD-', '91.108330221785', 'agar macconkey', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 2, 24, '4804064141'),
(30, 'MTD-', '90.721444162621', 'TSB', '2024-09-02 03:21:40', '2024-09-02 03:21:40', 3, 29, '7514280510'),
(46, 'MTD-', 'nicolas', 'becerra', '2024-09-10 01:14:34', '2024-09-10 01:14:34', 1, 25, '4730702816');

--
-- Triggers `monitoreos_detecciones`
--
DELIMITER $$
CREATE TRIGGER `delete_monitoreos_detecciones` BEFORE DELETE ON `monitoreos_detecciones` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT DISTINCT dm.numero_registro_producto from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where md.id_monitoreo_deteccion=old.id_monitoreo_deteccion),
nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);


INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' elimino un monitoreo de la deteccion del microrganismo ', (select dm.nombre_microorganismo from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where id_monitoreo_deteccion=old.id_monitoreo_deteccion) ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),
 
JSON_object('volumen_muestra', old.volumen_muestra, 'nombre_diluyente', old.nombre_diluyente, 'fechayhora_inicio', old.fechayhora_inicio, 'fechayhora_final', old.fechayhora_final, 'id_etapa_deteccion', old.id_etapa_deteccion, 'id_deteccion_microorganismo', old.id_deteccion_microorganismo, 'id_usuario', old.id_usuario),
 
'eliminar', now(), 6, concat(old.codigo_monitoreo_deteccion, old.id_monitoreo_deteccion), numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_monitoreos_detecciones` AFTER INSERT ON `monitoreos_detecciones` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT DISTINCT dm.numero_registro_producto from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where md.id_monitoreo_deteccion=new.id_monitoreo_deteccion),
nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' registro un monitoreo de la deteccion del microrganismo ', (select dm.nombre_microorganismo from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where id_monitoreo_deteccion=new.id_monitoreo_deteccion) ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),
 
JSON_object('volumen_muestra', new.volumen_muestra, 'nombre_diluyente', new.nombre_diluyente, 'fechayhora_inicio', new.fechayhora_inicio, 'fechayhora_final', new.fechayhora_final, 'id_etapa_deteccion', new.id_etapa_deteccion, 'id_deteccion_microorganismo', new.id_deteccion_microorganismo, 'id_usuario', new.id_usuario),
 
'registrar', now(), 6, concat(new.codigo_monitoreo_deteccion, new.id_monitoreo_deteccion), numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_monitoreos_detecciones` BEFORE UPDATE ON `monitoreos_detecciones` FOR EACH ROW BEGIN
declare numero_registro_producto, nombre_completo varchar(50);
set numero_registro_producto := (SELECT DISTINCT dm.numero_registro_producto from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where md.id_monitoreo_deteccion=new.id_monitoreo_deteccion),
nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);


INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values
(
CONCAT('El usuario ', nombre_completo, ' edito un monitoreo de la deteccion del microrganismo ', (select dm.nombre_microorganismo from monitoreos_detecciones as md join deteccion_microorganismos as dm on md.id_deteccion_microorganismo=dm.id_deteccion_microorganismo where id_monitoreo_deteccion=new.id_monitoreo_deteccion) ,' del producto ', (select nombre_producto from productos as pro WHERE pro.numero_registro_producto=numero_registro_producto),' con identificacion: ', numero_registro_producto),
 
JSON_OBJECT('registro_anterior', JSON_object('volumen_muestra', old.volumen_muestra, 'nombre_diluyente', old.nombre_diluyente, 'fechayhora_inicio', old.fechayhora_inicio, 'fechayhora_final', old.fechayhora_final, 'id_etapa_deteccion', old.id_etapa_deteccion, 'id_deteccion_microorganismo', old.id_deteccion_microorganismo, 'id_usuario', old.id_usuario), 'registro_nuevo', JSON_object('volumen_muestra', new.volumen_muestra, 'nombre_diluyente', new.nombre_diluyente, 'fechayhora_inicio', new.fechayhora_inicio, 'fechayhora_final', new.fechayhora_final, 'id_etapa_deteccion', new.id_etapa_deteccion, 'id_deteccion_microorganismo', new.id_deteccion_microorganismo, 'id_usuario', new.id_usuario)),
 
'editar', now(), 6, concat(new.codigo_monitoreo_deteccion, new.id_monitoreo_deteccion), numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `peticiones_cambio`
--

CREATE TABLE `peticiones_cambio` (
  `id_peticion_cambio` int(11) NOT NULL,
  `descripcion_peticion` longtext NOT NULL,
  `fechayhora_creacion_peticion` datetime NOT NULL,
  `id_usuario` varchar(15) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL,
  `numero_registro_producto` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `peticiones_cambio`
--

INSERT INTO `peticiones_cambio` (`id_peticion_cambio`, `descripcion_peticion`, `fechayhora_creacion_peticion`, `id_usuario`, `id_estado`, `id_modulo`, `numero_registro_producto`) VALUES
(1, 'Drug-induced chronic gout, multiple sites, with tophus (tophi)', '2024-09-01 23:28:22', '2595285254', 4, 4, 'PTM-2404-806'),
(2, 'External constriction of left index finger, initial encounter', '2024-09-01 23:28:22', '4787502077', 1, 2, 'MPM-2404-798'),
(3, 'Displaced comminuted fracture of shaft of right tibia, subsequent encounter for closed fracture with routine healing', '2024-09-01 23:28:22', '0872783316', 3, 7, 'PPM-2404-808'),
(4, 'Partial traumatic amputation of left hip and thigh, level unspecified, initial encounter', '2024-09-01 23:28:22', '3769554418', 3, 8, 'MPM-2404-801'),
(5, 'Fracture of condylar process of left mandible, sequela', '2024-09-01 23:28:22', '4787502077', 1, 4, 'PTM-2404-804'),
(6, 'Burns involving 30-39% of body surface with 0% to 9% third degree burns', '2024-09-01 23:28:22', '4787502077', 1, 3, 'MPM-2404-799'),
(7, 'Posterior dislocation of right hip, subsequent encounter', '2024-09-01 23:28:22', '7514280510', 2, 1, 'MPM-2404-800'),
(8, 'Infection and inflammatory reaction due to internal fixation device of right tibia, initial encounter', '2024-09-01 23:28:22', '3769554418', 3, 5, 'PTM-2404-804'),
(9, 'Traumatic arthropathy, left hand', '2024-09-01 23:28:22', '4787502077', 4, 5, 'PTM-2404-806'),
(10, 'Toxic effect of unspecified noxious substance eaten as food', '2024-09-01 23:28:22', '3769554418', 3, 6, 'PTM-2404-802'),
(11, 'Fall from, out of or through building, not otherwise specified, sequela', '2024-09-01 23:28:22', '0872783316', 4, 1, 'MPM-2404-800'),
(12, 'Burn of second degree of unspecified ankle, subsequent encounter', '2024-09-01 23:28:22', '4787502077', 3, 8, 'PTM-2404-806'),
(13, 'Poisoning by histamine H2-receptor blockers, undetermined, subsequent encounter', '2024-09-01 23:28:22', '0872783316', 3, 8, 'PTM-2404-804'),
(14, 'Subluxation of distal radioulnar joint of unspecified wrist, sequela', '2024-09-01 23:28:22', '7514280510', 1, 6, 'PTM-2404-804'),
(15, 'Monteggia\'s fracture of unspecified ulna, initial encounter for open fracture type I or II', '2024-09-01 23:28:22', '6573136446', 1, 9, 'PTM-2404-805'),
(17, 'Stable burst fracture of T11-T12 vertebra, sequela', '2024-09-01 23:28:22', '3769554418', 1, 7, 'MPM-2404-798'),
(18, 'Poisoning by, adverse effect of and underdosing of unspecified agents primarily affecting the cardiovascular system', '2024-09-01 23:28:22', '4730702816', 4, 8, 'MPM-2404-800'),
(19, 'Spontaneous rupture of flexor tendons, other site', '2024-09-01 23:28:22', '6573136446', 3, 3, 'PTM-2404-805'),
(20, 'Legal intervention, means unspecified, bystander injured', '2024-09-01 23:28:22', '0872783316', 2, 5, 'PPM-2404-809');

-- --------------------------------------------------------

--
-- Table structure for table `productos`
--

CREATE TABLE `productos` (
  `numero_registro_producto` varchar(30) NOT NULL,
  `nombre_producto` varchar(50) NOT NULL,
  `fecha_fabricacion` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `descripcion_producto` text NOT NULL,
  `activo_producto` varchar(50) NOT NULL,
  `presentacion_producto` varchar(30) NOT NULL,
  `cantidad_producto` varchar(15) NOT NULL,
  `numero_lote_producto` varchar(30) NOT NULL,
  `tamano_lote_producto` varchar(30) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_fabricante` int(11) NOT NULL,
  `id_modulo` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `productos`
--

INSERT INTO `productos` (`numero_registro_producto`, `nombre_producto`, `fecha_fabricacion`, `fecha_vencimiento`, `descripcion_producto`, `activo_producto`, `presentacion_producto`, `cantidad_producto`, `numero_lote_producto`, `tamano_lote_producto`, `id_cliente`, `id_fabricante`, `id_modulo`) VALUES
('esteesuniddeprueba', 'codeina', '2024-09-13', '2024-09-13', 'este es un producto de prueba', 'codeina', 'pastilla', '10g', '123456', '6666', 1, 1, 1),
('esteesuniddeprueba2', 'codeina', '2024-09-13', '2024-09-13', 'este es un producto de prueba', 'codeina', 'pastilla', '10g', '123456', '6666', 1, 1, 1),
('esteesuniddeprueba3', 'codeina', '2024-09-13', '2024-09-13', 'este es un producto de prueba', 'codeina', 'pastilla', '10g', '123456', '6666', 1, 1, 1),
('MPM-2404-798', 'ALCOHOL ETILICO', '2024-01-23', '2028-01-23', 'Liquido translucido e incoloro en bolsa esteril. Libre de partï¿½culas extraï¿½as.', 'ALCOHOL ETILICO', 'Bolsa por 20 gramos', '20 gramos', '1B00570255', '375,0 L', 1, 3, 7),
('MPM-2404-799', 'ALCOHOL ETILICO', '2023-08-21', '2027-08-21', 'Liquido translucido e incoloro en bolsa esteril. Libre de partï¿½culas extraï¿½as.', 'ALCOHOL ETILICO', 'Bolsa por 20 gramos', '20 gramos', '1B000536307', '300 kg', 4, 1, 3),
('MPM-2404-800', 'BICARBONATO DE SODIO', '2023-05-09', '2025-05-09', 'Polvo blanco en bolsa estï¿½ril. Libre de partï¿½culas extraï¿½as.', 'BICARBONATO DE SODIO', 'Bolsa por 20 gramos', '20 gramos', '4123050912', '25 kg', 4, 2, 2),
('MPM-2404-801', 'ï¿½CIDO ASCORBICO', '2023-06-07', '2026-06-06', 'Polvo blanco en bolsa estï¿½ril. Libre de partï¿½culas extraï¿½as.', 'ï¿½CIDO ASCORBICO', 'Bolsa por 20 gramos', '20 gramos', 'DY02612300424', '22.00 kg', 1, 3, 2),
('PPM-2404-808', 'TUBO CONDESADO', '2024-04-22', '2025-05-20', 'Tubo apirogeno por 30 mL con liquido translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'N.A', 'Tubo apirogeno por 30 mL', '30 mL', '2124033', '6666', 2, 1, 1),
('PPM-2404-809', 'TUBO CONDESADO LINEA TRASIEGO', '2024-04-22', '2025-05-21', 'Tubo apirogeno por 30 mL con liquido translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'N.A', 'Tubo apirogeno por 30 mL', '30 mL', '2124033', '6666', 4, 1, 9),
('PTM-2404-802', 'LIDOCAINA JALEA HCL 2%', '2024-04-18', '2026-06-07', 'Tubos colapsible por 30 gramos con gel translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'LIDOCAINA JALEA', 'Tubos colapsibles por 30 gramo', '45 tubos colaps', '2124031', '6666', 2, 1, 6),
('PTM-2404-803', 'ADENOSINA 6 mg/2 mL', '2023-10-01', '2026-06-08', 'Ampollas por 2 mL con liquido translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'ADENOSINA', 'Ampolla por 6 mg/2 mL', '40 ampollas', 'K18AD22', '20.000 ampollas', 4, 2, 8),
('PTM-2404-804', 'ADENOSINA 6 mg/2 mL', '2023-10-01', '2026-06-09', 'Ampollas por 2 mL con liquido translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'ADENOSINA', 'Ampolla por 6 mg/2 mL', '40 ampollas', 'K19AD22', '20.000 ampollas', 3, 2, 7),
('PTM-2404-805', 'ZOCILED 500  mg/5 mL', '2023-10-01', '2026-06-10', 'Ampolla por 5 mL con liquido translï¿½cido. Libre de partï¿½culas extraï¿½as. ', 'ï¿½CIDO TRANEXï¿½MICO', 'Ampolla 500  mg/5 mL', '20 ampollas', 'ATX21K09', '100', 2, 1, 7),
('PTM-2404-806', 'ETILEFRINA CLORHIDRATO 10 mg/mL', '2023-10-01', '2026-06-11', 'Ampolla por 1 mL con liquido translï¿½cido e incoloro. Libre de partï¿½culas extraï¿½as.', 'ETILEFRINA CLORHIDRATO', 'Ampolla por 10mg/mL', '80 ampollas', 'K39ETC22', '100', 4, 2, 8);

-- --------------------------------------------------------

--
-- Table structure for table `pruebas_recuento`
--

CREATE TABLE `pruebas_recuento` (
  `id_prueba_recuento` int(11) NOT NULL,
  `codigo_prueba_recuento` varchar(10) DEFAULT 'PRC-',
  `metodo_usado` varchar(30) NOT NULL,
  `concepto` tinyint(1) NOT NULL DEFAULT 0,
  `especificacion` varchar(15) NOT NULL,
  `volumen_diluyente` varchar(15) NOT NULL,
  `tiempo_disolucion` varchar(5) DEFAULT NULL,
  `cantidad_muestra` varchar(15) NOT NULL,
  `tratamiento` text NOT NULL,
  `id_usuario` varchar(15) NOT NULL,
  `numero_registro_producto` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pruebas_recuento`
--

INSERT INTO `pruebas_recuento` (`id_prueba_recuento`, `codigo_prueba_recuento`, `metodo_usado`, `concepto`, `especificacion`, `volumen_diluyente`, `tiempo_disolucion`, `cantidad_muestra`, `tratamiento`, `id_usuario`, `numero_registro_producto`) VALUES
(1, 'PRC-', 'PON-MB-006', 1, '<1 EU/mg', '80', '0.99', '10', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4804064141', 'PTM-2404-805'),
(2, 'PRC-', 'PON-MB-010', 1, '<1 EU/mg', '59', '0.99', '9', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4787502077', 'MPM-2404-798'),
(3, 'PRC-', 'PON-MB-009', 0, '<1 EU/mg', '24', '0.99', '2', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4730702816', 'MPM-2404-798'),
(4, 'PRC-', 'PON-MB-006', 1, '<1 EU/mg', '63', '0.99', '1', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '0872783316', 'PTM-2404-803'),
(5, 'PRC-', 'PON-MB-008', 1, '<1 EU/mg', '27', '0.99', '8', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '7514280510', 'MPM-2404-799'),
(6, 'PRC-', 'PON-MB-008', 1, '<1 EU/mg', '10', '0.99', '3', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4804064141', 'PTM-2404-802'),
(7, 'PRC-', 'PON-MB-007', 0, '<1 EU/mg', '98', '0.99', '7', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4787502077', 'MPM-2404-801'),
(8, 'PRC-', 'PON-MB-009', 1, '<1 EU/mg', '70', '0.99', '6', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '6573136446', 'PTM-2404-805'),
(9, 'PRC-', 'PON-MB-010', 1, '<1 EU/mg', '67', '0.99', '10', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '7514280510', 'PPM-2404-808'),
(10, 'PRC-', 'PON-MB-009', 0, '<1 EU/mg', '90', '0.99', '10', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '0872783316', 'PTM-2404-805'),
(11, 'PRC-', 'PON-MB-007', 0, '<1 EU/mg', '78', '0.99', '4', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '6573136446', 'PTM-2404-806'),
(12, 'PRC-', 'PON-MB-008', 1, '<1 EU/mg', '45', '0.99', '10', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '4787502077', 'MPM-2404-800'),
(13, 'PRC-', 'PON-MB-009', 0, '<1 EU/mg', '47', '0.99', '9', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '0872783316', 'PTM-2404-802'),
(14, 'PRC-', 'PON-MB-007', 1, '<1 EU/mg', '64', '0.99', '5', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '6690765121', 'PTM-2404-806'),
(15, 'PRC-', 'PON-MB-008', 1, '<1 EU/mg', '88', '0.99', '5', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '6690765121', 'PTM-2404-806'),
(16, 'PRC-', 'PON-MB-009', 1, '<1 EU/mg', '70', '0.99', '9', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '6690765121', 'PTM-2404-804'),
(17, 'PRC-', 'PON-MB-006', 1, '<1 EU/mg', '37', '0.99', '10', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '7514280510', 'PTM-2404-802'),
(18, 'PRC-', 'PON-MB-010', 0, '<1 EU/mg', '79', '0.99', '8', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '0872783316', 'PPM-2404-809'),
(19, 'PRC-', 'PON-MB-009', 1, '<1 EU/mg', '52', '0.99', '2', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '3769554418', 'PTM-2404-806'),
(20, 'PRC-', 'PON-MB-006', 1, '<1 EU/mg', '6', '0.99', '5', 'Lorem ipsum dolor sit amet consectetur adipiscing elit, aenean vestibulum curae luctus natoque nullam, montes nulla blandit fringilla facilisi vel.', '7514280510', 'MPM-2404-800'),
(22, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(26, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(27, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(28, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(29, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(30, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(31, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(32, 'PRC-', 'asdasd', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805'),
(33, 'PRC-', 'hola', 1, 'asdasdasd', 'adasdasd', 'asdas', 'asdasd', 'asdasdasdas', '0872783316', 'PTM-2404-805');

--
-- Triggers `pruebas_recuento`
--
DELIMITER $$
CREATE TRIGGER `delete_pruebas_recuento` BEFORE DELETE ON `pruebas_recuento` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = old.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ', nombre_completo, ' elimino el registro de una prueba de recuento del producto ', (select nombre_producto from productos WHERE numero_registro_producto = old.numero_registro_producto), ' con indentificacion: ', (old.numero_registro_producto)),
 
 JSON_object('metodo_usado', old.metodo_usado, 'concepto', old.metodo_usado, 'concepto', old.concepto, 'especificacion', old.especificacion, 'volumen_diluyente', old.volumen_diluyente, 'tiempo_disolucion', old.tiempo_disolucion, 'cantidad_muestra', old.cantidad_muestra, 'tratamiento', old.tratamiento, 'id_usaurio', old.id_usuario, 'numero_registro_producto', old.numero_registro_producto),
 
'eliminar', now(), 2, concat(old.codigo_prueba_recuento, old.id_prueba_recuento) , old.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_pruebas_recuento` AFTER INSERT ON `pruebas_recuento` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values


(CONCAT('El usuario ',nombre_completo, ' registro una prueba de recuento del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', (new.numero_registro_producto)),
 
 JSON_object('metodo_usado', new.metodo_usado, 'concepto', new.metodo_usado, 'concepto', new.concepto, 'especificacion', new.especificacion, 'volumen_diluyente', new.volumen_diluyente, 'tiempo_disolucion', new.tiempo_disolucion, 'cantidad_muestra', new.cantidad_muestra, 'tratamiento', new.tratamiento, 'id_usaurio', new.id_usuario, 'numero_registro_producto', new.numero_registro_producto),
 
'registrar', now(), 2, concat(new.codigo_prueba_recuento, new.id_prueba_recuento) , new.numero_registro_producto);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_pruebas_recuento` BEFORE UPDATE ON `pruebas_recuento` FOR EACH ROW BEGIN

declare nombre_completo varchar(50);
set nombre_completo :=(select concat(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido) from usuarios where id_usuario = new.id_usuario);

INSERT INTO log_transaccional(descripcion, detalles_registro, accion, fechayhora_log, id_modulo, codigo_registro, numero_registro_producto) values

(CONCAT('El usuario ', nombre_completo, ' edito el registro de una prueba de recuento del producto ', (select nombre_producto from productos WHERE numero_registro_producto = new.numero_registro_producto), ' con indentificacion: ', (new.numero_registro_producto)),
 
JSON_OBJECT('registro_anterior', 
JSON_object('metodo_usado', old.metodo_usado, 'concepto', old.metodo_usado, 'concepto', old.concepto, 'especificacion', old.especificacion, 'volumen_diluyente', old.volumen_diluyente, 'tiempo_disolucion', old.tiempo_disolucion, 'cantidad_muestra', old.cantidad_muestra, 'tratamiento', old.tratamiento, 'id_usaurio', old.id_usuario, 'numero_registro_producto', old.numero_registro_producto), 
'registro_nuevo', 
JSON_object('metodo_usado', new.metodo_usado, 'concepto', new.metodo_usado, 'concepto', new.concepto, 'especificacion', new.especificacion, 'volumen_diluyente', new.volumen_diluyente, 'tiempo_disolucion', new.tiempo_disolucion, 'cantidad_muestra', new.cantidad_muestra, 'tratamiento', new.tratamiento, 'id_usaurio', new.id_usuario, 'numero_registro_producto', new.numero_registro_producto)),
 
'editar', now(), 2, concat(new.codigo_prueba_recuento, new.id_prueba_recuento) , new.numero_registro_producto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `registro_entrada_productos`
-- (See below for the actual view)
--
CREATE TABLE `registro_entrada_productos` (
`numero_registro_producto` varchar(30)
,`nombre_producto` varchar(50)
,`proposito_analisis` text
,`condiciones_ambientales` varchar(30)
,`fecha_recepcion` date
,`fecha_inicio_analisis` date
,`fecha_final_analisis` date
,`id_usuario` varchar(15)
,`nombre_usuario` varchar(83)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `solicitudes_registro`
-- (See below for the actual view)
--
CREATE TABLE `solicitudes_registro` (
`nombre_completo` varchar(83)
,`id_usuario` varchar(15)
,`nombre_usuario` varchar(50)
,`fecha_inscripcion` date
);

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` varchar(15) NOT NULL,
  `primer_nombre` varchar(20) NOT NULL,
  `segundo_nombre` varchar(20) NOT NULL,
  `primer_apellido` varchar(20) NOT NULL,
  `segundo_apellido` varchar(20) NOT NULL,
  `foto_usuario` mediumblob DEFAULT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contraseña_usuario` longtext NOT NULL,
  `rol_usuario` enum('analista','coordinador') NOT NULL DEFAULT 'analista',
  `firma_usuario` varchar(20) DEFAULT NULL,
  `fecha_inscripcion` date DEFAULT current_timestamp(),
  `estado` enum('activo','inactivo') DEFAULT 'inactivo',
  `solicitud_registro` enum('aceptada','en revision') DEFAULT 'en revision'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `foto_usuario`, `nombre_usuario`, `contraseña_usuario`, `rol_usuario`, `firma_usuario`, `fecha_inscripcion`, `estado`, `solicitud_registro`) VALUES
('0872783316', '', '', '', '', NULL, 'ginchbald7@lycos.com', '$2a$04$AXy4LOpB4jsqhO6dzsv/c.qQ0Jgx.mN4boL6I2KIZAWoryr2KAmFa', 'analista', 'Georgeta', '2024-07-30', 'activo', 'en revision'),
('2595285254', '', '', '', '', NULL, 'kdmitrovic3@engadget.com', '$2a$04$fijrResNeypnBePp79CxJutWkmfamPogm6l264CSVLBX6/VU0Of0y', 'analista', 'Kelly', '2024-07-23', 'inactivo', 'en revision'),
('321', 'David', '', 'Gonzalez', '', NULL, 'David123', '', 'analista', 'D. Gonzalez', '2024-09-11', 'inactivo', 'en revision'),
('3769554418', '', '', '', '', NULL, 'nwhapple4@geocities.com', '$2a$04$5NtEHlRo/9KCtAujcRQRR.Xg9CqfbtwcmbvDjBJsL3zzqwfjMUDAS', 'analista', 'Normie', '2024-01-11', 'inactivo', 'en revision'),
('4730702816', '', '', '', '', NULL, 'grichmont8@infoseek.co.jp', '$2a$04$GHEKibIVbMqFPZgk/9/5tORoxgEz3gWSx/bOWUtJIaA1LlWd3Tf8a', 'analista', 'Glory', '2023-12-22', 'activo', 'en revision'),
('4787502077', '', '', '', '', NULL, 'jmcgahey9@bloomberg.com', '$2a$04$dQROvHpLyi1cawPJyTT73u7bUcwOeih8lD.mFhwmJnZVmcnNV3H9C', 'analista', 'Jessica', '2024-06-12', 'inactivo', 'en revision'),
('4804064141', '', '', '', '', NULL, 'cmalcher1@tamu.edu', '$2a$04$ZW4Ry3wzleKl1KINrRva3.YUXbNAPfXzBjQz7kE6q7dVZd5gVolg.', 'analista', 'Calvin', '2024-07-08', 'inactivo', 'en revision'),
('6573136446', '', '', '', '', NULL, 'rbroadhurst5@squarespace.com', '$2a$04$CCXeEPWde11Ozb75QeDPuej6UfOaQQIT2gIwDUAywxbPWX95XzuqG', 'analista', 'Rois', '2024-05-19', 'inactivo', 'en revision'),
('7514280510', '', '', '', '', NULL, 'mcrotty6@wiley.com', '$2a$04$sDe8WZM3KkxmKBHSqhmDm.4nrIp02C8J0Tf.RBEWPcPt4Lfktmv7O', 'analista', 'Marietta', '2023-12-09', 'inactivo', 'en revision');

--
-- Triggers `usuarios`
--
DELIMITER $$
CREATE TRIGGER `generar_firma_usuario` BEFORE INSERT ON `usuarios` FOR EACH ROW BEGIN
set new.firma_usuario = CONCAT(LEFT(new.primer_nombre, 1), '. ', new. primer_apellido);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `analisis_por_producto`
--
DROP TABLE IF EXISTS `analisis_por_producto`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `analisis_por_producto`  AS SELECT `a`.`numero_registro_producto` AS `numero_registro_producto`, `p`.`nombre_producto` AS `nombre_producto`, `m`.`nombre_modulo` AS `nombre_modulo`, `d`.`nombre_microorganismo` AS `nombre_microorganismo`, `cb`.`nombre_recuento` AS `nombre_recuento` FROM (((((`analisis` `a` left join `productos` `p` on(`a`.`numero_registro_producto` = `p`.`numero_registro_producto`)) left join `deteccion_microorganismos` `d` on(`p`.`numero_registro_producto` = `d`.`numero_registro_producto`)) left join `modulos` `m` on(`a`.`id_modulo` = `m`.`id_modulo`)) left join `pruebas_recuento` `pr` on(`pr`.`numero_registro_producto` = `a`.`numero_registro_producto`)) left join `cajas_bioburden` `cb` on(`pr`.`id_prueba_recuento` = `cb`.`id_prueba_recuento`)) ;

-- --------------------------------------------------------

--
-- Structure for view `detalles_peticiones_cambio`
--
DROP TABLE IF EXISTS `detalles_peticiones_cambio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detalles_peticiones_cambio`  AS SELECT `p`.`id_peticion_cambio` AS `id_peticion_cambio`, `p`.`descripcion_peticion` AS `descripcion_peticion`, `p`.`fechayhora_creacion_peticion` AS `fechayhora_creacion_peticion`, `u`.`id_usuario` AS `id_usuario`, concat(`u`.`primer_nombre`,' ',`u`.`segundo_nombre`,' ',`u`.`primer_apellido`,' ',`u`.`segundo_apellido`) AS `nombre_usuario`, `e`.`nombre_estado` AS `nombre_estado`, `m`.`nombre_modulo` AS `nombre_modulo`, `pr`.`numero_registro_producto` AS `numero_registro_producto`, `pr`.`nombre_producto` AS `nombre_producto` FROM ((((`peticiones_cambio` `p` join `usuarios` `u` on(`p`.`id_usuario` = `u`.`id_usuario`)) join `estados` `e` on(`p`.`id_estado` = `e`.`id_estado`)) join `modulos` `m` on(`p`.`id_modulo` = `m`.`id_modulo`)) join `productos` `pr` on(`p`.`numero_registro_producto` = `pr`.`numero_registro_producto`)) ;

-- --------------------------------------------------------

--
-- Structure for view `registro_entrada_productos`
--
DROP TABLE IF EXISTS `registro_entrada_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `registro_entrada_productos`  AS SELECT `p`.`numero_registro_producto` AS `numero_registro_producto`, `p`.`nombre_producto` AS `nombre_producto`, `e`.`proposito_analisis` AS `proposito_analisis`, `e`.`condiciones_ambientales` AS `condiciones_ambientales`, `e`.`fecha_recepcion` AS `fecha_recepcion`, `e`.`fecha_inicio_analisis` AS `fecha_inicio_analisis`, `e`.`fecha_final_analisis` AS `fecha_final_analisis`, `u`.`id_usuario` AS `id_usuario`, concat(`u`.`primer_nombre`,' ',`u`.`segundo_nombre`,' ',`u`.`primer_apellido`,' ',`u`.`segundo_apellido`) AS `nombre_usuario` FROM ((`entradas_productos` `e` join `productos` `p` on(`e`.`numero_registro_producto` = `p`.`numero_registro_producto`)) join `usuarios` `u` on(`e`.`id_usuario` = `u`.`id_usuario`)) ;

-- --------------------------------------------------------

--
-- Structure for view `solicitudes_registro`
--
DROP TABLE IF EXISTS `solicitudes_registro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `solicitudes_registro`  AS SELECT concat(`usuarios`.`primer_nombre`,' ',`usuarios`.`segundo_nombre`,' ',`usuarios`.`primer_apellido`,' ',`usuarios`.`segundo_apellido`) AS `nombre_completo`, `usuarios`.`id_usuario` AS `id_usuario`, `usuarios`.`nombre_usuario` AS `nombre_usuario`, `usuarios`.`fecha_inscripcion` AS `fecha_inscripcion` FROM `usuarios` WHERE `usuarios`.`solicitud_registro` = 'en revision' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `analisis`
--
ALTER TABLE `analisis`
  ADD PRIMARY KEY (`id_analisis`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`),
  ADD KEY `id_modulo` (`id_modulo`);

--
-- Indexes for table `cajas_bioburden`
--
ALTER TABLE `cajas_bioburden`
  ADD PRIMARY KEY (`id_caja_bioburden`),
  ADD KEY `id_prueba_recuento` (`id_prueba_recuento`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indexes for table `controles_negativos_medios`
--
ALTER TABLE `controles_negativos_medios`
  ADD PRIMARY KEY (`id_control_negativo`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`);

--
-- Indexes for table `deteccion_microorganismos`
--
ALTER TABLE `deteccion_microorganismos`
  ADD PRIMARY KEY (`id_deteccion_microorganismo`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `entradas_productos`
--
ALTER TABLE `entradas_productos`
  ADD PRIMARY KEY (`id_entrada`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`id_estado`);

--
-- Indexes for table `etapas_deteccion`
--
ALTER TABLE `etapas_deteccion`
  ADD PRIMARY KEY (`id_etapa_deteccion`);

--
-- Indexes for table `fabricantes`
--
ALTER TABLE `fabricantes`
  ADD PRIMARY KEY (`id_fabricante`);

--
-- Indexes for table `log_transaccional`
--
ALTER TABLE `log_transaccional`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_modulo` (`id_modulo`);

--
-- Indexes for table `modulos`
--
ALTER TABLE `modulos`
  ADD PRIMARY KEY (`id_modulo`);

--
-- Indexes for table `monitoreos_detecciones`
--
ALTER TABLE `monitoreos_detecciones`
  ADD PRIMARY KEY (`id_monitoreo_deteccion`),
  ADD KEY `id_etapa_deteccion` (`id_etapa_deteccion`),
  ADD KEY `id_deteccion_microorganismo` (`id_deteccion_microorganismo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indexes for table `peticiones_cambio`
--
ALTER TABLE `peticiones_cambio`
  ADD PRIMARY KEY (`id_peticion_cambio`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_estado` (`id_estado`),
  ADD KEY `id_modulo` (`id_modulo`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`);

--
-- Indexes for table `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`numero_registro_producto`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_fabricante` (`id_fabricante`),
  ADD KEY `id_modulo` (`id_modulo`);

--
-- Indexes for table `pruebas_recuento`
--
ALTER TABLE `pruebas_recuento`
  ADD PRIMARY KEY (`id_prueba_recuento`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `numero_registro_producto` (`numero_registro_producto`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `analisis`
--
ALTER TABLE `analisis`
  MODIFY `id_analisis` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `cajas_bioburden`
--
ALTER TABLE `cajas_bioburden`
  MODIFY `id_caja_bioburden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT for table `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `controles_negativos_medios`
--
ALTER TABLE `controles_negativos_medios`
  MODIFY `id_control_negativo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `deteccion_microorganismos`
--
ALTER TABLE `deteccion_microorganismos`
  MODIFY `id_deteccion_microorganismo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `entradas_productos`
--
ALTER TABLE `entradas_productos`
  MODIFY `id_entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `estados`
--
ALTER TABLE `estados`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `etapas_deteccion`
--
ALTER TABLE `etapas_deteccion`
  MODIFY `id_etapa_deteccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `fabricantes`
--
ALTER TABLE `fabricantes`
  MODIFY `id_fabricante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `log_transaccional`
--
ALTER TABLE `log_transaccional`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `modulos`
--
ALTER TABLE `modulos`
  MODIFY `id_modulo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `monitoreos_detecciones`
--
ALTER TABLE `monitoreos_detecciones`
  MODIFY `id_monitoreo_deteccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `peticiones_cambio`
--
ALTER TABLE `peticiones_cambio`
  MODIFY `id_peticion_cambio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `pruebas_recuento`
--
ALTER TABLE `pruebas_recuento`
  MODIFY `id_prueba_recuento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `analisis`
--
ALTER TABLE `analisis`
  ADD CONSTRAINT `analisis_ibfk_1` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`),
  ADD CONSTRAINT `analisis_ibfk_2` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`);

--
-- Constraints for table `cajas_bioburden`
--
ALTER TABLE `cajas_bioburden`
  ADD CONSTRAINT `cajas_bioburden_ibfk_1` FOREIGN KEY (`id_prueba_recuento`) REFERENCES `pruebas_recuento` (`id_prueba_recuento`),
  ADD CONSTRAINT `cajas_bioburden_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Constraints for table `controles_negativos_medios`
--
ALTER TABLE `controles_negativos_medios`
  ADD CONSTRAINT `controles_negativos_medios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `controles_negativos_medios_ibfk_2` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`);

--
-- Constraints for table `deteccion_microorganismos`
--
ALTER TABLE `deteccion_microorganismos`
  ADD CONSTRAINT `deteccion_microorganismos_ibfk_1` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`),
  ADD CONSTRAINT `deteccion_microorganismos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Constraints for table `entradas_productos`
--
ALTER TABLE `entradas_productos`
  ADD CONSTRAINT `entradas_productos_ibfk_1` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`),
  ADD CONSTRAINT `entradas_productos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Constraints for table `log_transaccional`
--
ALTER TABLE `log_transaccional`
  ADD CONSTRAINT `log_transaccional_ibfk_1` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`);

--
-- Constraints for table `monitoreos_detecciones`
--
ALTER TABLE `monitoreos_detecciones`
  ADD CONSTRAINT `monitoreos_detecciones_ibfk_1` FOREIGN KEY (`id_etapa_deteccion`) REFERENCES `etapas_deteccion` (`id_etapa_deteccion`),
  ADD CONSTRAINT `monitoreos_detecciones_ibfk_2` FOREIGN KEY (`id_deteccion_microorganismo`) REFERENCES `deteccion_microorganismos` (`id_deteccion_microorganismo`),
  ADD CONSTRAINT `monitoreos_detecciones_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Constraints for table `peticiones_cambio`
--
ALTER TABLE `peticiones_cambio`
  ADD CONSTRAINT `peticiones_cambio_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `peticiones_cambio_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`),
  ADD CONSTRAINT `peticiones_cambio_ibfk_3` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`),
  ADD CONSTRAINT `peticiones_cambio_ibfk_4` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`);

--
-- Constraints for table `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`id_fabricante`) REFERENCES `fabricantes` (`id_fabricante`),
  ADD CONSTRAINT `productos_ibfk_3` FOREIGN KEY (`id_modulo`) REFERENCES `modulos` (`id_modulo`);

--
-- Constraints for table `pruebas_recuento`
--
ALTER TABLE `pruebas_recuento`
  ADD CONSTRAINT `pruebas_recuento_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`),
  ADD CONSTRAINT `pruebas_recuento_ibfk_2` FOREIGN KEY (`numero_registro_producto`) REFERENCES `productos` (`numero_registro_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
