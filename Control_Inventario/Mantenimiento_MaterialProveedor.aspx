<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Mantenimiento_MaterialProveedor.aspx.vb" Inherits="Control_Inventario_Mantenimiento_MaterialProveedor" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Mantenimiento Materiales-Proveedores",
				content: "Agregue, Modifique o Elimine Materiales-Proveedores.",
				// img: "notification/demo/thumb.png",
				icon: '&',
				timeout: 5000,
				border: false
			});
			$("#cmbProveedor").change();
		 });
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="header">
	<div class="content_pad">
		<h1><a href="../pages/Dashboard.aspx">Menu Principal</a></h1>
		<ul id="nav">
			<li class="nav_dropdown  nav_icon"><a href="../pages/Dashboard.aspx">
				<span class="nav_dropdown  nav_icon"></span>Menu Principal</a>
			</li>
			<li class="nav_dropdown nav_icon nav_current">
				<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Mant. Materiales-Proveedores</a>
				<div class="nav_menu">			
					<ul>
						<li><a href="Mantenimiento.aspx">Mantenimientos</a></li>
					</ul>
				</div>
			</li>
		</ul>
	</div> <!-- .content_pad -->
</div> <!-- #header -->	

<div id="masthead">
	<div class="content_pad">
		<h1 class="">Mantenimientos</h1>
		<div id="bread_crumbs">
			<a href="../pages/Dashboard.aspx">Menu</a> / 
			<a href="Mantenimiento.aspx">Mantenimientos</a> / 
			<a href="" class="current_page">Mant. Materiales-Proveedores</a>
		 </div> <!-- #bread_crumbs -->
	</div> <!-- .content_pad -->
</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Mantenimiento. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>
			<div class="portlet x12">
				<div class="portlet-content">
				<h3>Mantenimiento de Materiales por Proveedores</h3>
				<div class="field">
				<br><br>
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
				<br><br><br><br><br><br><br>
				<h3>Materiales del Proveedor</h3>
					<table class="data display datatable" id="tblMaterialesAgregados">
						<thead>
							<tr>
								<th style="width:150px;">C&oacute;digo</th>
								<th>Nombre del Material</th>
								<th style="width:100px;">Precio</th>
								<th style="width:100px;">Moneda</th>
								<th style="width:100px;">Eliminar</th>
							</tr>
						</thead>
						<tbody id="cols">

						</tbody>
					</table>
				</div>
			</div>
			<div class="portlet x12" id="divAgregar" style="display:none;">
				<div class="portlet-content">
				<h3><span class="orange" id="lblAccion"></span></h3>
				<div class="field">
						<label for="txtCodigo">Codigo </label>
						<input id="txtCodigo" name="txtCodigo" value="" size="10" type="text" class="small" disabled="disabled" />
					</div>
					<div class="field">
						<label for="txtMaterial">Material </label>
						<input id="txtMaterial" name="txtMaterial" value="" size="10" type="text" class="x-large" disabled="disabled" />
					</div>
					<div class="field">
						<label for="cmbMoneda">Moneda </label>
						<select id="cmbMoneda" class="medium">
							<optgroup label="Seleccione el Proveedor">
							<%
							    Try
							    	cnn.cnnInventario.Close()
							        cnn.cnnInventario.Open()
							        Dim Sql As String = "select moneda_codigo, moneda_descripcion from moneda"
							        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
							        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
							        While ReaderInventario.Read
							            Dim Codigo As String = ReaderInventario("moneda_codigo")
							            Dim Descripcion As String = ReaderInventario("moneda_descripcion")
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
					<div class="field">
						<label for="txtPrecio">Precio</label>
						<input id="txtPrecio" name="txtPrecio" value="" size="10" type="text" class="small" placeholder="Precio del Material"/>
					</div>
					<div>
						<button class="btn btn-large btn-navy" id="btnAceptar" style="position:relative; top:-60px; left:790px;"><span class="Arriba">Aceptar</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
					</div>
				</div>
			</div>
			<div class="portlet x12">
				<div class="portlet-content">
				<h3>Materiales por Agregar</h3>
					<table class="data display datatable" id="tblMateriales">
						<thead>
							<tr>
								<th style="width:150px;">C&oacute;digo</th>
								<th>Nombre del Material</th>
								<th style="width:100px;">Unidad</th>
								<th style="width:100px;">Tipo</th>
								<th style="width:100px;">Agregar</th>
							</tr>
						</thead>
						<tbody>
							<%
						    Try
						        cnn.cnnInventario.Open()
						        Dim Sql As String = "select * from materiales as m join unidad_medida as um join tipo_material as tm where m.material_unidadmedida = um.unidad_codigo and m.material_tipo = tm.tipomaterial_codigo"
						        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
						        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
						        While ReaderInventario.Read
						            If Not IsDBNull(ReaderInventario("material_codigo")) Then
						                Dim Codigo As String = ReaderInventario("material_codigo")
						                Dim Nombre As String = ReaderInventario("material_nombre")
						                Dim Unidad As String = ReaderInventario("unidad_descripcion")
						                Dim TipoMaterial As String = ReaderInventario("tipomaterial_nombre")
						                %>
		                                	<tr>
		                                		<td><%=Codigo %></td>
												<td><%=Nombre %></td>
												<td><%=Unidad %></td>
												<td><%=TipoMaterial %></td>
												<td style='padding:5px;'>
													<div align='center'>
														<a onclick="Agregar('<%=Codigo %>', '<%=Nombre%>')"><span>Agregar <img src="../img/icons/agregar.jpg"></span></a>
													</div>
												</td>
											</tr>
		                                <%
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
			<br><br><br><br>
			<br><br><br><br><br><br><br><br><br>
	</div>
</form>

<!-- BORRAR -->
<script type="text/javascript">

 function Borrar(id)
	{
		$("#divAgregar").hide();
		var pProveedor = $("#cmbProveedor").val();
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "Mantenimiento_MaterialProveedor.aspx/Borrar",
	        data: '{ pProveedor: "' + pProveedor + '", pMaterial: "' + id + '" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: BorrarMP,
	        failure: function (msg) {
	            alert(msg);
	        },
	        error: function (xhr, err) {
	            alert(err);
	        }
	    });
	}

	function BorrarMP(msg)
	{		
		if (msg.d >= 1)
		{
			window.location.reload("Mantenimiento_MaterialProveedor.aspx");
		}
		else
		{
			$.notification( 
			{
			    title: "Eliminar Registro",
				content: "Hubo un error al Eliminar, Error: ("+msg.d+")" ,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
		}
	}
</script>

<script type="text/javascript">
	$("#txtPrecio").keypress(function (e) {
        if (e.which == 13) {
            // $("#btnAceptar").click();
        }
    });
</script>

<script type="text/javascript">
	function Agregar(codigo, nombre)
	{
		var pProveedor = $("#cmbProveedor").val();
		var result = $.ajax(
		    {
		        type: "POST",
		        url: "Mantenimiento_MaterialProveedor.aspx/Comprueba",
		        data: '{ pProveedor: "' + pProveedor + '", pMaterial: "' + codigo + '" }',
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        success: CompruebaMP,
		        failure: function (msg) {
		            alert(msg);
		        },
		        error: function (xhr, err) {
		            alert(err);
		        }
		    });
		$("#lblAccion").text("Agregar Material "+ nombre);
		$("#txtMaterial").val(nombre);
		$("#txtCodigo").val(codigo);
	}

	function CompruebaMP(msg)
	{
		if(msg.d == 1)
		{
			$.notification( 
			{
			    title: "Error al Agregar Registro",
				content: "El Codigo del Material ya existe" ,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
		}
		else if(msg.d == 0)
		{
			$("#divAgregar").show();
			$("#txtPrecio").val("");
			$("#txtPrecio").focus();
		}
	}

	$("#btnAceptar").click(function()
		{
			var pProveedor = $("#cmbProveedor").val();
			var pMaterial =$("#txtCodigo").val();
			var pMoneda = $("#cmbMoneda").val();
			var pPrecio = $("#txtPrecio").val();
			var Error = false;
			var mensaje = "";
			if (pPrecio.length == 0)
			{
				Error = true;
				mensaje = "Es necesario especificar el Precio";
			} else if(pMaterial.length == 0)
			{
				Error = true;
				mensaje = "Es necesario especificar el Material";
			}
			if(Error)
			{
				$.notification( 
				{
				    title: "Falta información por llenar",
					content: Mensaje,
					icon: 'X',
					timeout: 6000,
					border: false,
					error: true
				});
				return false;
			}
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "Mantenimiento_MaterialProveedor.aspx/Agregar",
		        data: '{ pProveedor: "' + pProveedor + '", pMaterial: "' + pMaterial + '", pMoneda: "' + pMoneda + '", pPrecio: "' + pPrecio + '" }',
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        success: AgregarMP,
		        failure: function (msg) {
		            alert(msg);
		        },
		        error: function (xhr, err) {
		            alert(err);
		        }
		    });
		});

	function AgregarMP(msg)
	{
		$("#divAgregar").hide();
		if (msg.d == -1 || msg.d == 0)
		{
			$.notification( 
			{
			    title: "Agregar Registro",
				content: "Hubo un error al Agregar, Error: ("+msg.d+")" ,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
			
		}
		else if(msg.d == 2)
		{
			$.notification( 
			{
			    title: "Error al Agregar Registro",
				content: "El Codigo del Material ya existe" ,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
		}
		else
		{
			window.location.reload("Mantenimiento_MaterialProveedor.aspx");
		}
		
	}



</script>

<script type="text/javascript">
	$("#cmbProveedor").change(function()
		{
			var pCondiciones = Condiciones();
			// ===========================================
			// Buscar a la persona deseada
			// ===========================================
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "Mantenimiento_MaterialProveedor.aspx/Generar",
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
	var oTable = $('#tblMaterialesAgregados').dataTable();
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
		pCondiciones += " and mp.proveedor_codigo = '"+ pProveedor +"'";
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

