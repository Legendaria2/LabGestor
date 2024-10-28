<?php include("../conexionDB.php");

	$accion=$_POST["Accion"];
 //   $Codigop=$_GET['codigo'];
	if(isset($accion))
	{
		if($accion=="Update")
		{
			//echo"Enviado desde actualizaci�n";
			$query="UPDATE clientes
					SET nombre = '".$_POST['nombre_cliente']."',
						direccion = '".$_POST['direccion_cliente']."',
						WHERE clientes.id_cliente = '".$_POST['id_cliente']."'";
			$result=mysqli_query($link,$query) or die ("Error en la actualizacion de los datos. Error: ".mysqli_error());
			echo "<script>
					alert('Los datos fueron actualizados correctamente');
					location.href='../index.html';
					</script>";
		}
		else
		{
			
			$query="DELETE 
					FROM clientes
					WHERE id_cliente = '".$_POST['id_cliente']."'";
			$result=mysqli_query($link,$query) or die ("Error en el borrado de los datos. Error: ".mysqli_error());
			echo "<script>
					alert('Los datos fueron borrados correctamente');
					location.href='../index.html';
					</script>";
		}
	}
?>
