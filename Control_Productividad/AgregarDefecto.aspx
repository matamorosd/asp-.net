<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AgregarDefecto.aspx.vb" Inherits="Control_Productividad_AgregarDefecto" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="../css/buttons.css" type="text/css" media="screen" title="no title" />
    <link rel="stylesheet" href="../css/plugin/dataTables.css" type="text/css" media="screen" title="no title" />
</head>
<body>
	<div id="content" class="xgrid" style="width:100%">
	<br/><br/><br/>
			<!-- <div class="portlet x12">
				
				<div class="portlet-content"> -->
					<h2>Agregar Defecto</h2>

					<form id="frmBuscar" class="form label-inline uniform" onsubmit="return false;">
							<img src="../images/loading2.gif" id="picLoading" style="display: none;"/>
					</form>

					<table class="data display datatable" id="tblDefectos">
						<thead>
							<tr>
								<th style="width:150px;">Código</th>
								<th>Descripcion Defecto</th>
							</tr>
						</thead>
						<tbody>
							<%
						    Try
						        cnn.cnn.Open()
						        Dim Sql As String = "select defecto_codigo, defecto_descripcion from DEFECTOS"
						        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
						        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
						        While Reader.Read
						            Dim Codigo As String = Reader("defecto_codigo")
						            Dim Descripcion As String = Reader("defecto_descripcion")
						            Response.Write("<tr><td>" + Codigo + "</td><td>" + Descripcion + "</td></tr>")
						        End While
						        cnn.cnn.Close()
							    Catch ex As Exception
							    		Response.Write("<tr>" + ex.message + "</tr>")
							    End Try
						%>
						</tbody>
					</table>
					<br><br><br>
			<form id="frmDefecto" class="form label-inline uniform" onsubmit="return false;">
					<div class="portlet x6">
						<div class="portlet-content">
							<div class="field">
								<label for="txtDefecto" style="position:relative; left:0px;">Defecto </label>
								<input id="txtDefecto" name="txtDefecto" style="text-transform:uppercase; position:relative;" placeholder="Defecto"
								type="text" class="large" readonly="readonly"/>
							</div>
							<div class="field">
								<label for="txtCantidad"  style="position:relative;">Cantidad </label>
								<input id="txtCantidad" name="txtCantidad" placeholder="Cantidad"
								type="text" class="xsmall" style="position:relative;" onkeyup="return ValNumero(this);"/>
							</div>
							<div class="field">
								<label for="cmbOperario"  style="position:relative;">Operario </label>
								<select id="cmbOperario" class="large" disabled="disabled">
									<optgroup label="Seleccione el Operario Responsable">
									<%
									    Try
									        cnn.cnn.Open()
									        Dim Sql As String = "select operario_codigo, operario_nombre, operario_apellido from operarios WHERE operario_codigo NOT LIKE '0' order by operario_codigo asc"
									        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
									        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
									        While Reader.Read
									            Dim Codigo As String = Reader("operario_codigo")
									            Dim Nombre As String = Reader("operario_nombre")
									            dim Apellido as string = Reader("operario_apellido")
					                            Response.Write("<option value='" + Codigo + "'>"+ Codigo +" - "+Nombre+" "+Apellido + "</option>")
									        End While
									        cnn.cnn.Close()
									    Catch ex As Exception
									    		Response.Write("<option value='XX'>"+ ex.message +"</option>")
									    End Try
									%>
									</optgroup>
								</select>
								<img src="../images/loading2.gif" id="picLoading" style="display: none;" style="position: relative;"/>
								<input type="text" id="txtBuscarOp" placeholder="Buscar" class="xsmall" style="position: relative; left:470px; top:-31px;"  disabled="disabled">
								<br/>
								<!-- <input type="checkbox" id="chkSinOperario"> -->
								<!-- <label for="chkSinOperario">Sin Operario</label> -->
								<button id="btnAceptar" class="btn-icon btn-navy" style="position:relative; left:150px;">Aceptar</button>
							</div>
						</div>
					</div>
			</form>
	</div>

<script type="text/javascript">
	$("#txtBuscarOp").keyup(function(){
		var pBusqueda = $("#txtBuscarOp").val();
		if (pBusqueda.length < 4 && pBusqueda.length > 0)
		{

		}
		else
		{
			$("#picLoading").show();
			$("#cmbOperario option").remove();
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "AgregarDefecto.aspx/BuscarOperarios",
		        data: '{ pBusqueda: "' + pBusqueda + '" }',
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        success: CargarOperarios,
		        failure: function (msg) {
		            alert(msg);
		        },
		        error: function (xhr, err) {
		            alert(err);
		        }
		    });
		}
	});

	function CargarOperarios (msg)
	{
		var Operarios = $('#cmbOperario'); 
		$("#picLoading").hide();
		Operarios.append($(msg.d)); 
	}

</script>
	

<script type="text/javascript">

	oTable = $('#tblDefectos').dataTable();

	 $('#tblDefectos tbody tr').live('click', function (event) {
	    var aData = oTable.fnGetData(this); // get datarow
	    if (null != aData)  // null if we clicked on title row
	    {
	        //now aData[0] - 1st column(count_id), aData[1] -2nd, etc. 
	    }
	    $("#txtDefecto").val(aData);
	    $("#txtCantidad").focus();
	});

 	$("#btnAceptar").click(function(){
		GrabarDefecto();
	});

 function GrabarDefecto()
 {
 	var pDefecto = $("#txtDefecto").val();
    var pCantidad = $("#txtCantidad").val();
    var pOperario = $("#cmbOperario").val();
    if (pCantidad < 3)
   	{
   		pOperario = "0";
   	}
   	// else if(frmDatos.chkSinOperario.checked == true)
   	// {
   	// 	pOperario = "0";
   	// }
    var Mala = localStorage["PiezasMalas"];
    var total = localStorage["total"];
    if (total){
        $('#txtTotal').val(total);
    }
    var Error = false;
	var Mensaje = "";
	if(pDefecto.length == 0)
	{
		Error = true;
		Mensaje = "Debe de Seleccionar un Defecto";
	}else if(pCantidad.length == 0)
	{
		Error = true;
		Mensaje = "La cantidad es Obligatoria";
	}else if(pOperario == null)
	{
		Error = true;
		Mensaje = "Es necesario especificar un Operario";
	}else if (Number(Mala) + Number(pCantidad) > total )
	{
		//Cierra el lightbox
		$(".jquery-lightbox-button-close").click();
		$.notification( 
			{
				title: "Informacion no Valida",
				content: "La cantidad asignada sobrepasa el numero de piezas en revision",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
		return false;
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
        url: "AgregarDefecto.aspx/Agregar",
        data: '{ Codigo: "' + pDefecto + '", pUsuarioNom: "'+ pUsuarioNom +'", pCantidad: "'+ pCantidad +'", pOperario: "'+ pOperario +'" }',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: DefectoAgregado,
        failure: function (msg) {
            alert(msg);
        },
        error: function (xhr, err) {
            alert(err);
        }
    });
 }

function DefectoAgregado(msg)
{
	//Cierra el lightbox
	$(".jquery-lightbox-button-close").click();
	if(msg.d == 1)
	{
	
		window.location.reload("ControlProductividad.aspx");
		
		$.notification(
			{
				title: "Defecto de pieza Agregado",
				content: "Se agrego el defecto exitosamente.",
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
				title: "Error al grabar Pieza con Defecto",
				content: "Este Defecto ya esta agregado al control",
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
				title: "Error al grabar Pieza con Defecto",
				content: "Error: "+ msg.d,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
	}
}

$('#btnBuscar').click(function() 
{
	var aBuscar = $("#txtBuscar").val();
	if(aBuscar.length == 0)
	{
		$.notification( 
			{
				title: "Favor especifique un valor",
				content: "Se requiere al menos un parametro de busqueda.",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			}
		);

		$("#txtBuscar").focus();
		return false;
	}


	$("#picLoading").show();
	$("#btnBuscar").hide();

	// ===========================================
	// Buscar a la persona deseada
	// ===========================================
	var result = $.ajax(
    {
        type: "POST",
        url: "AgregarDefecto.aspx/Busqueda",
        data: '{ aBuscar: "' + aBuscar + '" }',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: imprimirTable,
        failure: function (msg) {
            alert(msg);
        },
        error: function (xhr, err) {
            alert(err);
        }
    });
});


 function imprimirTable(msg) {

 	$("#picLoading").hide();
	$("#btnBuscar").show();
	var oTable = $('#tblDefectos').dataTable();
    // Immediately 'nuke' the current rows (perhaps waiting for an Ajax callback...)
     oTable.fnClearTable();
	// ========================================
	// Proceso que ejecuta el llenado de la tabla dinamicamente
	// ========================================
	eval(msg.d);
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

<script type="text/javascript">
	$("#txtCantidad").keyup(function(){
		var Cantidad = $("#txtCantidad").val();
		if (Cantidad >= 3)
		{
			$("#cmbOperario").removeAttr('disabled');
			$("#txtBuscarOp").removeAttr('disabled');
			// $("#chkSinOperario").removeAttr('disabled');
		}
		else
		{
			$("#cmbOperario").attr('disabled','disabled');
			$("#txtBuscarOp").attr('disabled','disabled');
			// $("#chkSinOperario").attr('disabled', 'disabled');
		}
	});


</script>

</body>
</html>
