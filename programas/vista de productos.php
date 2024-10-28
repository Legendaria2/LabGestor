<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vista productos</title>
</head>
<body>
<?php
include '../conexionDB.php';

$tabla = 'productos'; 

$query1 = "SHOW COLUMNS FROM $tabla";
$result1 = mysqli_query($conexion, $query1);

$query = "SELECT * FROM $tabla";
$result = mysqli_query($conexion, $query);

if (mysqli_num_rows($result1) > 0 && mysqli_num_rows($result) > 0) {
    echo "<h2>Lista de Productos:</h2>";

    
    echo "<h2>Campos de la tabla $tabla:</h2>";
    echo "<ul>";
    while ($campo = mysqli_fetch_assoc($result1)) {
        echo "<li>" . $campo["Field"] . "</li>";
    }
    echo "</ul>";
    echo "<table border='1'>";
    echo "<tr>
        <th>Número de Registro</th>
        <th>Nombre del Producto</th>
        <th>Fecha de Fabricación</th>
        <th>Fecha de Vencimiento</th>
        <th>Descripción</th>
        <th>Activo</th>
        <th>Presentación</th>
        <th>Cantidad</th>
        <th>Número de Lote</th>
        <th>Tamaño de Lote</th>
        <th>ID Cliente</th>
        <th>ID Fabricante</th>
        <th>ID Módulo</th>
    </tr>";

   
    while ($fila = mysqli_fetch_assoc($result)) {
        echo "<tr>";
        echo "<td>" . $fila["numero_registro_producto"] . "</td>";
        echo "<td>" . $fila["nombre_producto"] . "</td>";
        echo "<td>" . $fila["fecha_fabricacion"] . "</td>";
        echo "<td>" . $fila["fecha_vencimiento"] . "</td>";
        echo "<td>" . $fila["descripcion_producto"] . "</td>";
        echo "<td>" . $fila["activo_producto"] . "</td>";
        echo "<td>" . $fila["presentacion_producto"] . "</td>";
        echo "<td>" . $fila["cantidad_producto"] . "</td>";
        echo "<td>" . $fila["numero_lote_producto"] . "</td>";
        echo "<td>" . $fila["tamano_lote_producto"] . "</td>";
        echo "<td>" . $fila["id_cliente"] . "</td>";
        echo "<td>" . $fila["id_fabricante"] . "</td>";
        echo "<td>" . $fila["id_modulo"] . "</td>";
        echo "</tr>";
    }
    echo "</table>";
} else {
    echo "No se encontraron productos en la tabla.";
}

mysqli_close($conexion);
?>
</body>
</html>

