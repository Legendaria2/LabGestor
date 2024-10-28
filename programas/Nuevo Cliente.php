<?php include '../conexionDB.php'; ?>

<!DOCTYPE html>
<html>
<head>
    <title>Añadir Cliente</title>
</head>
<body>
    <h2>Añadir Cliente</h2>
    <form method="POST">
        <label>Nombre:</label>
        <input type="text" name="nombre_cliente" required><br>
        <label>Dirección:</label>
        <input type="text" name="direccion_cliente" required><br>
        <button type="submit" name="submit">Guardar</button>
    </form>

    <?php
    if (isset($_POST['submit'])) {
        $Nombre = $_POST['nombre_cliente'];
        $Direccion = $_POST['direccion_cliente'];

        $sql = "INSERT INTO clientes ( nombre_cliente, direccion_cliente ) VALUES ('$Nombre', '$Direccion')";
        if ($conexion->query($sql) === TRUE) {
            echo "Cliente añadido exitosamente";
        } else {
            echo "Error: " . $conexion->error;
        }
    }
    ?>
</body>
</html>
