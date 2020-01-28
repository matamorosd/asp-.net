<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Salida_Agregar.aspx.vb" Inherits="Control_Inventario_Salida_Agregar" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%
	    Dim UrlCliente As String = Request.QueryString("urlc")
	%>
    <script src="../js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../css/buttons.css" type="text/css" media="screen" title="no title" />
    <link rel="stylesheet" href="../css/plugin/dataTables.css" type="text/css" media="screen" title="no title" />
</head>
<body>

<div id="content" class="xgrid" style="width:100%">
	<br/><br/><br/>	
		<h3>Listado de Materiales</h3>
		<form id="frmBuscar" class="form label-inline uniform" onsubmit="return false;">
				<img src="../images/loading2.gif" id="picLoading" style="display: none;"/>
		</form>
		<span>
			<table class="data display datatable" id="tblMateriales">
				<thead>
					<tr>
						<th style="width:150px;">Código</th>
						<th>Descripcion Material</th>
						<th style="width:150px;">Unidad Medida</th>
						<th style="width:150px;">Existencia</th>
					</tr>
				</thead>
				<tbody>
				<%
				    Try
				        cnn.cnnInventario.Open()
				        Dim Sql As String = "select m.material_codigo, m.material_nombre, um.unidad_descripcion, m.material_existencia from Materiales as m join unidad_medida as um where m.material_unidadmedida = um.unidad_codigo"
				        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
				        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
				        While ReaderInventario.Read
				            Dim Codigo As String = ReaderInventario("material_codigo")
				            Dim Descripcion As String = ReaderInventario("material_nombre")
				            Dim Unidad As String = ReaderInventario("unidad_descripcion")
				            Dim Existencia As String = ReaderInventario("material_existencia")
				            Response.Write("<tr><td>" + Codigo + "</td><td>" + Descripcion + "</td><td>" + Unidad + "</td><td>" + Existencia + "</td></tr>")
				        End While
				        cnn.cnnInventario.Close()
				    Catch ex As Exception
				        Response.Write("<tr>" + ex.Message + "</tr>")
				    End Try
				%>
				</tbody>
			</table>
		</span>
		<form id="frmMaterialSalida" class="form label-inline uniform" onsubmit="return false;">
			<div class="portlet x6">
				<div class="portlet-content">
					<div class="field">
						<label for="txtMaterial" style="position:relative; left:0px;">Material </label>
						<input id="txtMaterial" name="txtMaterial" style="text-transform:uppercase; position:relative;" placeholder="Material"
						type="text" class="large" readonly="readonly"/>
					</div>
					<div class="field">
						<label for="txtCantidad"  style="position:relative;">Cantidad </label>
						<input id="txtCantidad" name="txtCantidad" placeholder="Cantidad"
						type="text" class="xsmall" style="position:relative;" onkeyup="return ValNumero(this);"/>
						<button id="btnAceptar" class="btn-icon btn-navy" style="position:relative; left:150px;">Aceptar</button>
					</div>
				</div>
			</div>
		</form>
	</div>


<script type="text/javascript">

	oTable = $('#tblMateriales').dataTable();

	 $('#tblMateriales tbody tr').live('click', function (event) {
	    var aData = oTable.fnGetData(this); // get datarow
	    if (null != aData)  // null if we clicked on title row
	    {
	        //now aData[0] - 1st column(count_id), aData[1] -2nd, etc.
	    }
	    $("#txtMaterial").val(aData);
		$("#txtCantidad").focus();
	});

 	$("#btnAceptar").click(function(){
		GrabarMaterial();
	});

 function GrabarMaterial()
 {
 	var pMaterial = $("#txtMaterial").val();
    var pCantidad = $("#txtCantidad").val();
    var Error = false;
	var Mensaje = "";
	if(pMaterial.length == 0)
	{
		Error = true;
		Mensaje = "Debe de Seleccionar un Material";
	}else if(pCantidad.length == 0)
	{
		Error = true;
		Mensaje = "La cantidad es Obligatoria";
	}

	if(Error)
	{
		$.notification( 
			{
				title: "Falta informacion por llenar",
				content: Mensaje,
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
		return false;
	}
    var pUsuarioNom =  "<%= cUser.NomUsuario %>";
    var result = $.ajax(
    {
        type: "POST",
        url: "Salida_Agregar.aspx/Agregar",
        data: '{ Codigo: "' + pMaterial + '", pUsuarioNom: "'+ pUsuarioNom +'", pCantidad: "'+ pCantidad +'" }',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: MaterialAgregado,
        failure: function (msg) {
            alert(msg);
        },
        error: function (xhr, err) {
            alert(err);
        }
    });
 }

function MaterialAgregado(msg)
{
	//Cierra el lightbox
	$(".jquery-lightbox-button-close").click();
	if(msg.d == 1)
	{
		window.location.reload("Salida_Inventario.aspx");
		
		$.notification(
			{
				title: "Material Agregado",
				content: "Se agrego el Material exitosamente.",
				// img: "notification/demo/thumb.png",
				icon: 'M',
				timeout: 5000,
				border: false
			});
	}
	else if (msg.d == 2)
	{
		$.notification( 
			{
				title: "Error al grabar Material",
				content: "Este Material ya esta agregado a la Salida",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
	}
	else if(msg.d == 3)
	{
		$.notification( 
			{
				title: "Error al grabar Material",
				content: "La Cantidad especificada sobrepasa la Existencia",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
	}
	else 
	{
		$.notification( 
			{
				title: "Error al grabar Material",
				content: "Error: Comunicar a IT, Cod: "+ msg.d,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
	}
}

</script>

<script language="javascript" type="text/javascript">

    //*** Este Codigo permite Validar que sea un campo Numerico
    function Solo_Numerico(variable)
    {
        Numer=parseInt(variable);
        if (isNaN(Numer))
        {
            return "";
        }
        return Numer;
    }
    function ValNumero(Control)
    {
        Control.value=Solo_Numerico(Control.value);
    }
    //*** Fin del Codigo para Validar que sea un campo Numerico

</script>

</body>
</html>
