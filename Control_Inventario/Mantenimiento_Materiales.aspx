<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Mantenimiento_Materiales.aspx.vb" Inherits="Control_Inventario_Mantenimiento_Materiales" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Mantenimiento de Materiales",
				content: "Agregue, Modifique o Elimine Materiales.",
				// img: "notification/demo/thumb.png",
				icon: '&',
				timeout: 5000,
				border: false
			});
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
				<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Mant. Materiales</a>
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
			<a href="" class="current_page">Mantenimiento de Materiales</a>
		 </div> <!-- #bread_crumbs -->
	</div> <!-- .content_pad -->
</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Mantenimiento. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>
			<div class="portlet x12" id="Tabla">
				<div class="portlet-content">
				<h3>Mantenimiento de Materiales</h3>
					<table class="data display datatable" id="tblMaterialesAgregados">
						<thead>
							<tr>
								<th style="width:50px;">C&oacute;digo</th>
								<th>Nombre del Material</th>
								<th>Proveedor</th>
								<th style="width:50px;">Unidad</th>
								<th>Tipo Mat.</th>
								<th style="width:50px;">Existencia</th>
								<th>Moneda</th>
								<th>Precio</th>
								<th style="width:80px;">Modificar</th>
								<th style="width:80px;">Eliminar</th>
							</tr>
						</thead>
						<tbody id="cols">
							<%
						    Try
							        cnn.cnnInventario.Close()
							        cnn.cnnInventario.Open()
							        Dim Sql As String = "select m.material_codigo, m.material_nombre, p.proveedor_codigo, p.proveedor_nombre, um.unidad_descripcion, tm.tipomaterial_nombre, m.material_existencia, mm.moneda_simbolo, mp.material_precio from materiales as m join material_proveedor as mp join proveedores as p join unidad_medida as um join tipo_material as tm join moneda as mm where m.material_codigo = mp.material_codigo and mp.proveedor_codigo = p.proveedor_codigo and um.unidad_codigo = m.material_unidadmedida and m.material_tipo = tm.tipomaterial_codigo and mm.moneda_codigo = mp.material_moneda"
							        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
							        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
							        While ReaderInventario.Read
							            Dim Codigo As String = ReaderInventario("material_codigo")
						                Dim Nombre As String = ReaderInventario("material_nombre")
						                dim CodigoP as string = ReaderInventario("proveedor_codigo")
						                Dim Proveedor As String = ReaderInventario("proveedor_nombre")
						                Dim Unidad As String = ReaderInventario("unidad_descripcion")
						                Dim TipoMaterial As String = ReaderInventario("tipomaterial_nombre")
						                Dim Existencia As String = ReaderInventario("material_existencia")
						                Dim Moneda As String = ReaderInventario("moneda_simbolo")
						                Dim Precio As String = ReaderInventario("material_precio")
						            %>
	                                	<tr id="col<%=Codigo %>">
	                                		<td><%=Codigo %></td>
											<td><%=Nombre %></td>
											<td><%=Proveedor %></td>
											<td><%=Unidad %></td>
											<td><%=TipoMaterial %></td>
											<td><%=Existencia %></td>
											<td><%=Moneda %></td>
											<td><%=Precio %></td>
											<td style='padding:5px;'>
												<div align='center'>
													<a onclick="Modificar('<%=Codigo %>','<%=CodigoP %>')"><span>Modificar <img src="../img/icons/icon_edit.png"></span></a>
												</div>
											</td>
											<td style='padding:5px;'>
												<div align='center'>
													<a onclick="Borrar('<%=Codigo %>','<%=CodigoP %>')"><span>Eliminar <img src="../img/icons/icon_delete.png"></span></a>
												</div>
											</td>
										</tr>
	                                <%
						        End While
								cnn.cnnInventario.Close()
						    Catch ex As Exception
					    		Response.Write("<tr>" + ex.message + "</tr>")
						    End Try
						%>
						</tbody>
					</table>
				</div>
			</div>
			<div>
				<button class="btn btn-large btn-green" id="btnAgregar" style="position:relative; left:800px;"><span class="Arriba">Agregar</span>
				<img src="../img/icons/large/white/Fountain Pen.png"></button>
			</div>
			<br><br><br><br>
			<div id="divMaterial" style="display:none;">
				<h3><span class="orange" id="divAccion"></span></h3>
				<div class="portlet x6">
					<div class="portlet-content">
						<div class="field">
							<label for="txtCodigo">C&oacute;digo</label>
							<input id="txtCodigo" name="txtCodigo" value="" size="10" type="text" class="small" placeholder="C&oacute;digo del Material" disabled="disabled" />
						</div>
						<div class="field">
							<label for="txtNombre">Nombre</label>
							<input id="txtNombre" type="text" class="large" placeholder="Nombre del Material">
						</div>
						<div class="field">
							<label for="cmbTipo">Tipo Material</label>
							<select id="cmbTipo" class="medium">
								<optgroup label="Seleccione el Tipo de Material">
								<%
								    Try
								    	cnn.cnnInventario.Close()
								        cnn.cnnInventario.Open()
								        Dim Sql As String = "select tipomaterial_codigo, tipomaterial_nombre from tipo_material"
								        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
								        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
								        While ReaderInventario.Read
								            Dim Codigo As String = ReaderInventario("tipomaterial_codigo")
								            Dim Descripcion As String = ReaderInventario("tipomaterial_nombre")
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
							<label for="cmbUnidad">Und. Medida </label>
							<select id="cmbUnidad" class="medium">
								<optgroup label="Seleccione el Und. de Medida">
								<%
								    Try
								    	cnn.cnnInventario.Close()
								        cnn.cnnInventario.Open()
								        Dim Sql As String = "select unidad_codigo, unidad_descripcion from unidad_medida"
								        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
								        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
								        While ReaderInventario.Read
								            Dim Codigo As String = ReaderInventario("unidad_codigo")
								            Dim Descripcion As String = ReaderInventario("unidad_descripcion")
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
							<label for="txtExistencia">Existencia</label>
							<input id="txtExistencia" type="text" class="medium" onkeyup="return ValNumero(this);" placeholder="Existencia del Material">
						</div>
						
					</div>
				</div>
				<div class="portlet x6">
					<div class="portlet-content">
						<div class="field">
							<label for="cmbProveedor">Proveedor </label>
							<select id="cmbProveedor" class="medium">
								<optgroup label="Seleccione el Proveedor">
								<%
								    Try
								    	cnn.cnnInventario.Close()
								        cnn.cnnInventario.Open()
								        Dim Sql As String = "select proveedor_codigo, proveedor_nombre from proveedores"
								        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
								        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
								        While ReaderInventario.Read
								            Dim Codigo As String = ReaderInventario("proveedor_codigo")
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
						<div class="field">
							<label for="cmbMoneda">Moneda</label>
							<select id="cmbMoneda" class="medium">
								<optgroup label="Seleccione la Moneda">
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
							<input id="txtPrecio" type="text" class="medium" placeholder="Precio del Material">
						</div>
					</div>
				</div>
				<div>
					<button class="btn btn-large btn-navy" id="btnAceptar" style="position:relative; top:30px; left:240px;"><span class="Arriba">Aceptar</span>
					<img src="../img/icons/large/white/Fountain Pen.png"></button>
				</div>
			</div>
			<br><br><br>
	</div>
</form>

<!-- BORRAR Material -->
<script type="text/javascript">

 function Borrar(Codigo, CodigoP)
	{
		$.msgbox("Esta seguro de desea eliminar el Material?.<br/><br/> Desea continuar?", {
		  type: "confirm",
		  buttons : [
		    {type: "submit", value: "Si"},
		    {type: "submit", value: "No"},
		    {type: "cancel", value: "Cancelar"}
		  ]
		}, function(result) {
			  if(result == "Si")
			  {
	  	  		var result = $.ajax(
			    {
			        type: "POST",
			        url: "Mantenimiento_Materiales.aspx/BorrarMaterial",
			        data: '{ pCodigo: "' + Codigo + '", pCodigoP: "' + CodigoP + '" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: BorrarC,
			        failure: function (msg) {
			            alert(msg);
			        },
			        error: function (xhr, err) {
			            alert(err);
			        }
			    });
  	  	   		}
	  	});
	}

	function BorrarC(msg)
	{		
		if (msg.d >= 1)
		{
			$("#col" + msg.d).delay(100);
		    $("#col" + msg.d).fadeOut(100, function () {
		    $("#col" + msg.d).remove().fadeOut(300);
		    });
		    $("#divMaterial").hide();
		 
		    $.notification(
			{
			    title: "Eliminar Registro",
				content: "Registro Eliminado exitosamente" ,
				// img: "notification/demo/thumb.png",
				icon: 'M',
				timeout: 6000,
				border: false
			});
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

$("#btnAceptar").click(function()
		{
			var pCodigo = $("#txtCodigo").val();
			var pNombre = $("#txtNombre").val();
			var pTipo 	= $("#cmbTipo").val();
			var pUnidad = $("#cmbUnidad").val();
			var pExistencia = $("#txtExistencia").val();
			var pProveedor = $("#cmbProveedor").val();
			var pMoneda = $("#cmbMoneda").val();
			var pPrecio = $("#txtPrecio").val();
			var opcion = $("#divAccion").text();
			var Error = false;
			var Mensaje = "";
			if(pNombre.length == 0)
			{
				Error = true;
				Mensaje = "El Nombre es Obligatoria";
			}else if(pExistencia.length == 0)
			{
				Error = true;
				Mensaje = "La Existencia es Obligatoria";
			}else if(pPrecio.length == 0)
			{
				Error = true;
				Mensaje = "El Precio es Obligatoria";
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
			if(opcion == "Agrega Material")
			{
				alert("entro!");
				var result = $.ajax(
			    {
			        type: "POST",
			        url: "Mantenimiento_Materiales.aspx/AgregarMaterial",
			        data: '{ pNombre: "'+ pNombre +'", pTipo: "'+ pTipo +'", pUnidad: "'+ pUnidad +'", pExistencia: "'+ pExistencia +'", pProveedor: "'+ pProveedor +'", pMoneda: "'+ pMoneda +'", pPrecio: "'+ pPrecio +'" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: AgregarC,
			        failure: function (msg) {
			            alert(msg);
			        },
			        error: function (xhr, err) {
			            alert(err);
			        }
			    });
			}
			else if(opcion == "Modifica Material")
			{	
				var result = $.ajax(
			    {
			        type: "POST",
			        url: "Mantenimiento_Materiales.aspx/ModificarMaterial",
			        data: '{ pCodigo: "' + pCodigo + '", pNombre: "'+ pNombre +'", pTipo: "'+ pTipo +'", pUnidad: "'+ pUnidad +'", pExistencia: "'+ pExistencia +'", pProveedor: "'+ pProveedor +'", pMoneda: "'+ pMoneda +'", pPrecio: "'+ pPrecio +'" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: ModificarC,
			        failure: function (msg) {
			            alert(msg);
			        },
			        error: function (xhr, err) {
			            alert(err);
			        }
			    });
			}
			
		});

 function Modificar(Codigo, CodigoP)
	{
		$("#divMaterial").show();
		$("#divAccion").text("Modifica Material");
		$("#cmbProveedor").attr( "disabled", "disabled" );
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "Mantenimiento_Materiales.aspx/CargaDatos",
	        data: '{ pCodigo: "' + Codigo + '", pCodigoP: "' + CodigoP + '" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: CargaD,
	        failure: function (msg) {
	            alert(msg);
	        },
	        error: function (xhr, err) {
	            alert(err);
	        }
	    });
	}

	function CargaD(msg)
	{
		eval(msg.d);
		$("#txtNombre").focus();
	}
	function ModificarC(msg)
	{	
		$("#divMaterial").hide();
		if (msg.d >= 1)
		{
			$.notification( 
				{
				    title: "Modificar Registro",
					content: "Registro Modificado exitosamente" ,
					// img: "notification/demo/thumb.png",
					icon: 'M',
					timeout: 6000,
					border: false
				});
			window.location.reload("Mantenimiento_Materiales.aspx");
		}
		else
		{
			$.notification( 
				{
				    title: "Modificar Registro",
					content: "Hubo un error al Modificar, Error: ("+msg.d+")" ,
					// img: "notification/demo/thumb.png",
					icon: 'X',
					timeout: 6000,
					border: false,
					error: true
				});
		}
	}

	function AgregarC(msg)
	{
		$("#divMaterial").hide();
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
		else
		{
			document.getElementById("cols").innerHTML += msg.d;
			$.notification( 
				{
				    title: "Agregar Registro",
					content: "Registro Agregado exitosamente" ,
					// img: "notification/demo/thumb.png",
					icon: 'M',
					timeout: 6000,
					border: false
				});
		}
	}
</script>

<script type="text/javascript">
	$("#btnAgregar").click(function()
		{
			$("#txtCodigo").val("");	
			$("#txtNombre").val("");
			$("#txtPrecio").val("");
			$("#txtExistencia").val("");
			$("#divMaterial").show();
			$("#divAccion").text("Agrega Material");
			$("#cmbProveedor").removeAttr('disabled');
			$("#txtNombre").focus();
		});
</script>
<script type="text/javascript">
	$("#txtNombre").keypress(function (e) {
        if (e.which == 13) {
            $("#btnAceptar").click();
        }
    });
    $("#txtPrecio").keypress(function (e) {
        if (e.which == 13) {
            $("#btnAceptar").click();
        }
    });
    $("#txtExistencia").keypress(function (e) {
        if (e.which == 13) {
            $("#btnAceptar").click();
        }
    });
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
</asp:Content>

