<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="ReporteSalida.aspx.vb" Inherits="Control_Inventario_ReporteSalida" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
	
		$(document).ready(function() {

			$.notification( 
				{
				    title: "Bienvenido al generador de Reportes",
					content: "Que deseas hacer hoy?.",
					// img: "notification/demo/thumb.png",
					icon: 'P',
					timeout: 5000,
					border: false
				});
		    $('#txtFechaInicio').Zebra_DatePicker({
			  //format: 'd-m-Y',
			  pair: $('#txtFechaFin')
			});

			$('#txtFechaFin').Zebra_DatePicker({
			  //format: 'd-m-Y',
			  direction: 1
				});
			$("#txtFechaInicio").attr('disabled','disabled');
			$("#txtFechaFin").attr('disabled','disabled');
			$("#tblReporte").dataTable();
		 });

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="header">
		
		<div class="content_pad">
			<h1><a href="../pages/dashboard.aspx">Menu Principal</a></h1>
			
			<ul id="nav">
				<li class="nav_dropdown nav_icon"><a href="../pages/Dashboard.aspx">
					<span class="nav_dropdown nav_current nav_icon"></span>Menu Principal</a>
				</li>
				<li class="nav_dropdown nav_icon nav_current">
					<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Reporte Salidas</a>
					<div class="nav_menu">			
						<ul>
							<li><a href="SeleccionReporte.aspx">Reportes</a></li>
							<li><a href="MaterialDisponible.aspx">Mat. Disponible</a></li>
							<li><a href="ReporteEntrada.aspx">Entrada Mat.</a></li>
						</ul>	
					</div>
				</li>
			</ul>
		</div> <!-- .content_pad -->
</div> <!-- #header -->	


    <div id="masthead">
		
		<div class="content_pad">
			
			<h1 class="">Generador de Reportes</h1>
			
			<div id="bread_crumbs">
				<a href="../pages/Dashboard.aspx">Menu</a> / 
				<a href="SeleccionReporte.aspx" > Seleccion de Reportes</a> /
				<a href="" class="current_page">Reporte de Salida</a>
			 </div> <!-- #bread_crumbs -->
			
			<div id="search">
				<form action="/search" method="get">
					<input type="text" value="" placeholder="Buscar..." name="search" id="search_input" title="Search" />					
					<input type="submit" value="" name="submit" class="submit" />					
				</form>
			</div> <!-- #search -->
			
		</div> <!-- .content_pad -->
		
	</div> <!-- #masthead -->


	<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
		<div id="content" class="xgrid">
			<br/><br/><br/>
			<h2>Preparacion de Reporte</h2>
			<br><br><br>
			<div class="portlet x6">
				<div class="portlet-content">
					<h3>Filtro por Cliente</h3>
					<input type="checkbox" id="chkCliente">
					<br>
					<label for="cmbCliente">Cliente </label>
					<select id="cmbCliente" class="medium" disabled="disabled">
						<optgroup label="Seleccione el Cliente">
						<%
						    Try
						    	cnn.cnnInventario.Close()
						        cnn.cnnInventario.Open()
						        Dim Sql As String = "select cliente_codigo, cliente_nombre from clientes"
						        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
						        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
						        While ReaderInventario.Read
						            Dim Codigo As String = ReaderInventario("cliente_codigo")
						            Dim Descripcion As String = ReaderInventario("cliente_nombre")
						            Response.Write("<option value='" + Codigo + "'>" + Descripcion + "</option>")
						        End While
						        cnn.cnnInventario.Close()
						    Catch ex As Exception
						    		Response.Write("<option value='XX'>"+ ex.message +"</option>")
						    End Try
						%>
						</optgroup>
					</select>
				</div>
			</div>
			<div class="portlet x6">
				<div class="portlet-content">
					<h3>Filtro por Material</h3>
					<input type="checkbox" id="chkMaterial">
					<br>
					<label for="cmbMaterial">Material </label>
					<select id="cmbMaterial" class="medium" disabled="disabled">
						<optgroup label="Seleccione el Material">
						<%
						    Try
						    	cnn.cnnInventario.Close()
						        cnn.cnnInventario.Open()
						        Dim Sql As String = "select material_codigo, material_nombre from materiales"
						        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
						        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
						        While ReaderInventario.Read
						            Dim Codigo As String = ReaderInventario("material_codigo")
						            Dim Descripcion As String = ReaderInventario("material_nombre")
						            Response.Write("<option value='" + Codigo + "'>" + Descripcion + "</option>")
						        End While
						        cnn.cnnInventario.Close()
						    Catch ex As Exception
						    		Response.Write("<option value='XX'>"+ ex.message +"</option>")
						    End Try
						%>
						</optgroup>
					</select>
					<img src="../images/loading2.gif" id="picLoading" style="display: none;" style="position: relative; left:800px;"/>
				</div>
			</div>
			<div class="portlet x6">
				<div class="portlet-content">
					<h3>Filtro por Fechas</h3><input type="checkbox" id="chkFechas">
					<br>
					<label for="txtFechaInicio">Inicio </label>
					<input id ="txtFechaInicio" type="text" readonly="readonly" style="display: inline-block; position: relative; top: auto; right: auto; bottom: auto; left: auto;"/>
					<br><br>
					<label for="txtFechaFin">Fin </label>
			   		<input id ="txtFechaFin" type="text" readonly="readonly" style="display: inline-block; position: relative; top: auto; right: auto; bottom: auto; left: auto;"/>
				</div>
			</div>  
			<br><br><br><br><br><br>
			<div class="portlet x6">
				<div class="portlet-content">
					<div align="center" style="position:relative; top:70px;">
						<button class="btn btn-large btn-blue" id="btnGenerar"><span class="Arriba">Generar Reporte</span>
						<img src="../img/icons/large/white/Clipboard.png"></button>
						<img src="../images/loading3.gif" id="picLoading" style="display: none;">
						<br/>
					</div>
				</div>
			</div>
			<div class="portlet x12"><div class="portlet-content">
				<table class="data display dataTable" id="tblReporte">
					<thead>
						<tr>
							<!-- <th style="display: none;">Ordenado</th> -->
							<th>Fecha</th>
							<th>Factura</th>
							<th>Cliente</th>
							<th>Comentario</th>
							<th>Usuario</th>
							<th>Detalle</th>
						</tr>
					</thead>
					<tbody id="cols">
					
					</tbody>
				</table>
				
				</div>
			</div>
		</div>
		<a id="EnlaceGrafica" href="../Grafica/GraficaInventario.aspx?lightbox[width]=1000&lightbox[height]=600" class="lightbox" style="display:none;"></a>
	</form>
	<br/><br/>
	<script type="text/javascript">


		$("#chkCliente").change(function()
		{
			if(frmDatos.chkCliente.checked == false)
			{
				$("#cmbCliente").attr('disabled','disabled');
			}
			else
			{
				$("#cmbCliente").removeAttr('disabled');
			}
		});

		$("#chkMaterial").change(function()
		{
			if(frmDatos.chkMaterial.checked == false)
			{
				$("#cmbMaterial").attr('disabled','disabled');
			}
			else
			{
				$("#cmbMaterial").removeAttr('disabled');
			}
		});

		$("#chkFechas").change(function()
		{
			if(frmDatos.chkFechas.checked == false)
			{
				$("#txtFechaInicio").attr('disabled','disabled');
				$("#txtFechaFin").attr('disabled','disabled');
			}
			else
			{
				$("#txtFechaInicio").removeAttr('disabled');
				$("#txtFechaFin").removeAttr('disabled');
			}
		});

	</script>

<script type="text/javascript">

	$("#btnGenerar").click(function()
	{
		var FechaInicio = $("#txtFechaInicio").val();
		if(frmDatos.chkFechas.checked == true && FechaInicio.length == 0)
		{
			$.notification( 
			{
			    title: "Faltó información por llenar",
				content: "Es necesario especificar una Fecha",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
			return false;
		}

		var pCondiciones = Condiciones();
		// ===========================================
		// Buscar a la persona deseada
		// ===========================================
		// if (pCondiciones.length == 0)
		// {
		// 	$.notification( 
		// 	{
		// 	    title: "Error al generar Reporte",
		// 		content: "Es necesario establecer al menos un Filtro.",
		// 		icon: 'X',
		// 		timeout: 6000,
		// 		border: false,
		// 		error: true
		// 	});
		// 	return false;
		// }

		$("#btnGenerar").hide();
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "ReporteSalida.aspx/Generar",
	        data: '{ pCondiciones: "' + pCondiciones + '" }',
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
	$("#btnGenerar").show();
	var oTable = $('#tblReporte').dataTable();
    // Immediately 'nuke' the current rows (perhaps waiting for an Ajax callback...)
    oTable.fnClearTable();
	// ========================================
	// Proceso que ejecuta el llenado de la tabla dinamicamente
	// ========================================
	eval(msg.d);
 }

 function Condiciones(pCondiciones)
 {
 	var pCondiciones = "";
 	var Cliente = $("#cmbCliente").val();
 	var Material = $("#cmbMaterial").val();
 	var FechaInicio = $("#txtFechaInicio").val();
 	var FechaFin = $("#txtFechaFin").val();


		if(frmDatos.chkCliente.checked == true)
		{
			pCondiciones += " and s.salida_Cliente = '"+ Cliente +"'";
		}
		if(frmDatos.chkMaterial.checked == true)
		{
			pCondiciones += " and sd.salida_material = '"+ Material +"'";
		}
		if(frmDatos.chkFechas.checked == true)
		{
			if(FechaFin.length == 0)
			{
				pCondiciones += " and s.salida_fecha = '"+ FechaInicio +"'";
			}
			else
			{
				pCondiciones += " and s.salida_fecha between '"+ FechaInicio +"' and '"+ FechaFin +"'";
			}
		}
		return pCondiciones;
 }

</script>
<script type="text/javascript">
	function VerGrafica(Codigo)
	{
		var pUsuarioNom	 =  "<%= cUser.NomUsuario %>";
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "ReporteSalida.aspx/CargarGrafica",
	        data: '{ pCodigo: "' + Codigo + '", pUsuarioNom: "'+pUsuarioNom+'" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: Grafica,
	        failure: function (msg) {
	            alert(msg);
	        },
	        error: function (xhr, err) {
	            alert(err);
	        }
	    });
	}
	function Grafica(msg)
	{
		if(msg.d == "1")
		{
			$("#EnlaceGrafica").click();
		}
		else if(msg.d == "0")
		{
			$.notification( 
			{
			    title: "No se pudo generar Grafica",
				content: "Este Número de Facrtura no posee Materiales",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
		}
	}

</script>
</asp:Content>

