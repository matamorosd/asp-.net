<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Mantenimiento_Unidad.aspx.vb" Inherits="Control_Inventario_Mantenimiento_Unidad" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Mantenimiento de Unidad de Medida",
				content: "Agregue, Modifique o Elimine Unidad de Medida.",
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
				<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Mant. Unds. de Med.</a>
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
			<a href="" class="current_page">Mantenimiento de Unidades de Medida</a>
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
				<h3>Mantenimiento de Unidades de Medida</h3>
					<table class="data display datatable" id="tblMaterialesAgregados">
						<thead>
							<tr>
								<th style="width:150px;">C&oacute;digo</th>
								<th>Nombre de Unidad de Medida</th>
								<th style="width:100px;">Modificar</th>
								<th style="width:100px;">Eliminar</th>
							</tr>
						</thead>
						<tbody id="cols">
							<%
						    Try
							        cnn.cnnInventario.Close()
							        cnn.cnnInventario.Open()
							        Dim Sql As String = "select * from unidad_medida"
							        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
							        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
							        While ReaderInventario.Read
							            Dim Codigo As String = ReaderInventario("unidad_codigo")
							            Dim Nombre As String = ReaderInventario("unidad_descripcion")
						            %>
	                                	<tr id="col<%=Codigo %>">
	                                		<td><%=Codigo %></td>
											<td><%=Nombre %></td>
											<td style='padding:5px;'>
												<div align='center'>
													<a onclick="Modificar('<%=Codigo %>')"><span>Modificar <img src="../img/icons/icon_edit.png"></span></a>
												</div>
											</td>
											<td style='padding:5px;'>
												<div align='center'>
													<a onclick="Borrar('<%=Codigo %>')"><span>Eliminar <img src="../img/icons/icon_delete.png"></span></a>
												</div>
											</td>
										</tr>
	                                <%
						        End While
								cnn.cnn.Close()
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
			<div class="portlet x12" id="divUnidad" style="display:none;">
				<div class="portlet-content">
				<h3><span class="orange" id="divAccion"></span></h3>
					<div class="field">
						<label for="txtCodigo">C&oacute;digo</label>
						<input id="txtCodigo" name="txtCodigo" value="" size="10" type="text" class="small" placeholder="C&oacute;digo de Unidad de Medida" disabled="disabled" />
					</div>
					<div class="field">
						<label for="txtNombre">Nombre</label>
						<input id="txtNombre" type="text" class="large" placeholder="Nombre de Unidad de Medida">
					</div>
					<div>
						<button class="btn btn-large btn-navy" id="btnAceptar" style="position:relative; top:-60px; left:790px;"><span class="Arriba">Aceptar</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
					</div>
				</div>
			</div>
			<br><br><br><br><br><br><br><br><br>
	</div>
</form>

<!-- BORRAR Unidad de Medida -->
<script type="text/javascript">

 function Borrar(id)
	{

		$.msgbox("Esta seguro de desea eliminar el Unidad de Medida?.<br/><br/> Desea continuar?", {
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
			        url: "Mantenimiento_Unidad.aspx/BorrarUnidad",
			        data: '{ pReferencia: "' + id + '" }',
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
		    $("#divUnidad").hide();
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
			var opcion = $("#divAccion").text();
			var Error = false;
			var Mensaje = "";
			if(pNombre.length == 0)
			{
				Error = true;
				Mensaje = "El Nombre es Obligatoria";
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
			if(opcion == "Agrega Unidad de Medida")
			{
				var result = $.ajax(
			    {
			        type: "POST",
			        url: "Mantenimiento_Unidad.aspx/AgregarUnidad",
			        data: '{ pNombre: "'+ pNombre +'" }',
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
			else if(opcion == "Modifica Unidad de Medida")
			{
				var result = $.ajax(
			    {
			        type: "POST",
			        url: "Mantenimiento_Unidad.aspx/ModificarUnidad",
			        data: '{ pReferencia: "' + pCodigo + '", pNombre: "'+ pNombre +'" }',
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

 function Modificar(id)
	{
		$("#divUnidad").show();
		$("#divAccion").text("Modifica Unidad de Medida");
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "Mantenimiento_Unidad.aspx/CargaDatos",
	        data: '{ pReferencia: "' + id + '" }',
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
		$("#divUnidad").hide();
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
			window.location.reload("Mantenimiento_Unidad.aspx");
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
		$("#divUnidad").hide();
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
			$("#divUnidad").show();	
			$("#divAccion").text("Agrega Unidad de Medida");
			$("#txtNombre").focus();
		});
</script>
<script type="text/javascript">
	$("#txtNombre").keypress(function (e) {
        if (e.which == 13) {
            $("#btnAceptar").click();
        }
    });
</script>
</asp:Content>

