<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="MaterialDisponible.aspx.vb" Inherits="Control_Inventario_MaterialDisponible" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script type="text/javascript">
	
	$(document).ready(function() {
		$.notification( 
			{
			    title: "Bienvenido a Materiales Disponibles",
				content: "Que deseas hacer hoy?.",
				// img: "notification/demo/thumb.png",
				icon: 'P',
				timeout: 5000,
				border: false
			});
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
					<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Mat. Disponible</a>
					<div class="nav_menu">
						<ul>
							<li><a href="SeleccionReporte.aspx">Reportes</a></li>
						</ul>
					</div>
				</li>
			</ul>
		</div> <!-- .content_pad -->
</div> <!-- #header -->	


    <div id="masthead">
		
		<div class="content_pad">
			
			<h1 class="">Visualiza los Materiales Disonibles</h1>
			
			<div id="bread_crumbs">
				<a href="../pages/Dashboard.aspx">Menu</a> / 
				<a href="" class="current_page">Material Disponible</a>
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
			<h2>Materiales Disponibles</h2>
			<br><br><br>
			<div class="portlet x6">
				<div class="portlet-content">
					<h3>Filtro por Proveedor</h3>
					<br>
					<label for="cmbProveedor">Proveedor </label>
					<select id="cmbProveedor" class="medium">
						<optgroup label="Seleccione el Proveedor">
						<%
						    Try
						    	cnn.cnnInventario.Close()
						        cnn.cnnInventario.Open()
						        Dim Sql As String = "select Proveedor_codigo, proveedor_nombre from proveedores"
						        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
						        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
						        While ReaderInventario.Read
						            Dim Codigo As String = ReaderInventario("Proveedor_codigo")
						            Dim Descripcion As String = ReaderInventario("proveedor_nombre")
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
			<br><br><br><br><br><br>
			<div class="portlet x6">
				<div class="portlet-content">
					<div align="center" style="position:relative;">
						<button class="btn btn-large btn-orange" id="btnVerTodo"><span class="Arriba">Ver Todos</span>
						<img src="../img/icons/large/white/List w_ Images.png"></button>
						<img src="../images/loading3.gif" id="picLoading" style="display: none;">
						<br/><br/><br/>
					</div>
				</div>
			</div>
			<div class="portlet x12"><div class="portlet-content">
				<table class="data display dataTable" id="tblDisponible">
					<thead>
						<tr>
							<!-- <th style="display: none;">Ordenado</th> -->
							<th>Código</th>
							<th>Nombre</th>
							<th>Und. Medida</th>
							<th>Proveedor</th>
							<th>Tipo Mat.</th>
							<th>Existencia</th>
						</tr>
					</thead>
					<tbody>
					<%
					    Try
					        cnn.cnnInventario.Open()
					        Dim Sql As String = "select m.material_codigo, m.material_nombre, um.unidad_descripcion, p.proveedor_nombre, tm.tipomaterial_nombre, m.material_existencia from materiales as m join material_proveedor as mp join proveedores as p join unidad_medida as um join tipo_material as tm where m.material_codigo = mp.material_codigo and mp.proveedor_codigo = p.proveedor_codigo and um.unidad_codigo = m.material_unidadmedida and m.material_tipo = tm.tipomaterial_codigo"
					        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
					        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
					        While ReaderInventario.Read
					            If Not IsDBNull(ReaderInventario("material_codigo")) Then
					                Dim Codigo As String = ReaderInventario("material_codigo")
					                Dim Nombre As String = ReaderInventario("material_nombre")
					                Dim Unidad As String = ReaderInventario("unidad_descripcion")
					                Dim Proveedor As String = ReaderInventario("proveedor_nombre")
					                Dim TipoMaterial As String = ReaderInventario("tipomaterial_nombre")
					                Dim Existencia As String = ReaderInventario("material_existencia")
					                Response.Write("<tr><td>" + Codigo + "</td><td>" + Nombre + "</td><td>" + Unidad + "</td><td>" + Proveedor + "</td><td>" + TipoMaterial + "</td><td>" + Existencia + "</td></tr>")
					            End If
					        End While
					        cnn.cnnInventario.Close()
					    Catch ex As Exception
					        Response.Write("<tr>" + ex.Message + "</tr>")
					    End Try
					%>
					</tbody>
				</table>
				</div>
			</div>
		</div>
	</form>
	<br/><br/>
	<br/><br/>

<script type="text/javascript">

	$("#cmbProveedor").change(function()
		{
			var pCondiciones = Condiciones();
			$("#picLoading").show();
			$("#btnVerTodo").hide();
			// ===========================================
			// Buscar a la persona deseada
			// ===========================================
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "MaterialDisponible.aspx/Generar",
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

	$("#btnVerTodo").click(function()
	{
		var pCondiciones = "";
		$("#picLoading").show();
		$("#btnVerTodo").hide();
			// ===========================================
			// Buscar a la persona deseada
			// ===========================================
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "MaterialDisponible.aspx/Generar",
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

 	$("#picLoading").hide();
	$("#btnVerTodo").show();
	var oTable = $('#tblDisponible').dataTable();
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
 	var pProveedor = $("#cmbProveedor").val();

 	// if(frmDatos.chkProveedor.checked == true)
		// {
		pCondiciones += " and p.proveedor_codigo = '"+ pProveedor +"'";
		// }
		// if(frmDatos.chkFechas.checked == true)
		// {
		// 	if(FechaFin.length == 0)
		// 	{
		// 		pCondiciones += " and c.control_fecha = '"+ FechaInicio +"'";
		// 	}
		// 	else
		// 	{
		// 		pCondiciones += " and c.control_fecha between '"+ FechaInicio +"' and '"+ FechaFin +"'";
		// 	}
		// }
		return pCondiciones;
 }

</script>
</asp:Content>

