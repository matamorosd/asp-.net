<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Entrada_Inventario.aspx.vb" Inherits="Control_Inventario_Entrada_Inventario" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Nuevo Control",
				content: "A continuación ingrese los datos.",
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
		</ul>
	</div> <!-- .content_pad -->
</div> <!-- #header -->	

<div id="masthead">
	<div class="content_pad">
		<h1 class="">Entrada de Materiales</h1>
		<div id="bread_crumbs">
			<a href="../pages/Dashboard.aspx">Menu</a> / 
			<a href="" class="current_page">Nueva Entrada</a>
		 </div> <!-- #bread_crumbs -->
	</div> <!-- .content_pad -->
</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Nueva Entrada. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>

				<h2>Datos de Entrada</h2>
				<div class="portlet x6">
					<div class="portlet-content">
						<div class="field">
							<label for="txtFactura">Factura</label>
							<input id="txtFactura" name="txtFactura" value="" size="10" type="text" class="small" onkeyup="return ValNumero(this);" placeholder="Número de Factura"/>
						</div>
						<div class="field">
							<label for="cmbProveedor">Proveedor </label>
							<select id="cmbProveedor" class="medium">
								<optgroup label="Seleccione el Proveedor">
								<%
								    Try
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
							<input id="hdn" type="text" style="display:none;" />
						</div>
					</div>
				</div>
				<div class="portlet x6">
					<div class="portlet-content">
						<div>
							<button class="btn btn-large btn-green" id="btnAgregar" style="position:relative; left:200px; top:73px;"><span class="Arriba">Agregar</span>
							<img src="../img/icons/large/white/Fountain Pen.png"></button>
							<a id="EnlaceMaterial" href="#" class="lightbox"></a>
						</div>
					</div>
				</div>
				

		<div class="portlet x12">
			<div class="portlet-content">
				<h3>Materiales Agregados a Factura</h3>
				<table class="data display" id="tblMaterialesAgregados">
						<thead>
							<tr>
								<th style="width:150px;">Código</th>
								<th>Descripcion Material</th>
								<th style="width:150px;">Cantidad</th>
								<th style="width:80px;">Eliminar</th>
							</tr>
						</thead>
						<tbody>
							<%
						    Try
							        Dim c As Integer = 0
							        cnn.cnnInventario.Close()
							        cnn.cnnInventario.Open()
							        Dim Sql As String = "select edt.entrada_material_temporal, m.material_nombre, edt.entrada_cantidad_temporal from entrada_detalle_temporal as edt join materiales as m where edt.entrada_material_temporal = m.material_codigo and edt.entrada_codigo_temporal = '" + cUser.NomUsuario + "'"
							        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
							        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
							        While ReaderInventario.Read
							            Dim Codigo As String = ReaderInventario("entrada_material_temporal")
							            Dim Descripcion As String = ReaderInventario("material_nombre")
							            Dim Cantidad As String = ReaderInventario("entrada_cantidad_temporal")
							            dim Sum as Integer = ReaderInventario("entrada_cantidad_temporal")
							            c += Sum
						            %>
	                                	<tr>
	                                		<td><%=Codigo %></td>
											<td><%=Descripcion %></td>
											<td><%=Cantidad %></td>
											<td style='padding:5px;'>
												<div align='center'>
													<a class="btn-mini btn-black btn-cross" onclick="Borrar('<%=Codigo %>')"><span></span>Eliminar</a>
												</div>
											</td>
										</tr>
	                                <%
						        End While
						        %>
						        	<script type="text/javascript">
												var Contador = "<%=c%>";
										    	if(Contador >= 1)
										    	{
										    		$('#txtFactura').attr( "disabled", "disabled" );
													$('#cmbProveedor').attr( "disabled", "disabled" );
													$('#hdn').val("1");
										    	}
										    	else
										    	{
										    		$('#txtFactura').RemoveAttr( "disabled" );
													$('#cmbProveedor').RemoveAttr( "disabled" );
													$('#hdn').val("0");
										    	}
										</script>
						        <%
    						cnn.cnn.Close()
						    Catch ex As Exception
						    		Response.Write("<tr>" + ex.message + "</tr>")
						    End Try
						%>
						</tbody>
					</table>
			</div>
		</div>
		<div class="portlet x12">
			<div class="portlet-content">
				<div class="field">
					<label for="txtComentario">Comentario</label>
					<textarea id="txtComentario" name="txtComentario" value="" size="10" style="width:670px; height:10em; resize:none;" type="text" placeholder="Comentarios"></textarea>
				</div>
			</div>
		</div>
	</div>
</form>

<div align="center" style="position:relative; top:-20px;">
	<button class="btn btn-large btn-blue" id="btnPostear"><span class="Arriba">Postear Entrada</span>
	<img src="../img/icons/large/white/Travel Suitcase.png"></button>
	<img src="../images/loading3.gif" id="loading" style="display: none;">
	<br/><br/><br/><br/><br/><br/>
</div>

<script type="text/javascript">
	$("#btnAgregar").click(function()
	{
		var pFactura = $("#txtFactura").val();
		var Error = false;
		var Mensaje = "";
		if(pFactura.length == 0)
		{
			Error = true;
			Mensaje = "Debe de Setear un número de Factura";
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
		var pProveedor = $("#cmbProveedor").val();
		$("#EnlaceMaterial").attr('href', "Entrada_Agregar.aspx?lightbox[width]=1000&lightbox[height]=76p&urlp="+pProveedor);
		$("#EnlaceMaterial").click();
	});

</script>

<!-- BORRAR Materiales -->
<script type="text/javascript">

 function Borrar(id)
	{
		var pUsuarioNom =  "<%= cUser.NomUsuario %>";
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "Entrada_Inventario.aspx/BorrarMaterial",
	        data: '{ pReferencia: "' + id + '", pUsuarioNom: "'+ pUsuarioNom +'" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: BorrarMat,
	        failure: function (msg) {
	            alert(msg);
	        },
	        error: function (xhr, err) {
	            alert(err);
	        }
	    });
	}
</script>

<script type="text/javascript">

	function BorrarMat(msg)
	{
		if (msg.d >= 1)
		{
			window.location.reload("Entrada_Inventario.aspx");
		}
		else
		{
			$.notification( 
				{
				    title: "Eliminar Registro",
					content: "Hubo un error al eliminar, Error: ("+msg.d+")" ,
					// img: "notification/demo/thumb.png",
					icon: 'X',
					timeout: 6000,
					border: false,
					error: true
				});
		}
	}
</script>

<!-- SETEAR VARIABLES LOCALES (AL RECARGAR PÁGINA) -->
<script type="text/javascript">

	window.onbeforeunload = function() {
	    localStorage["Factura"] = $('#txtFactura').val();
	    localStorage["Proveedor"] = $('#cmbProveedor').val();
	}

	window.onload = function() {
            var Factura = localStorage["Factura"];
            if (Factura) {
                $('#txtFactura').val(Factura);
            }
            var Proveedor = localStorage["Proveedor"];
            if (Proveedor){
                $('#cmbProveedor').val(Proveedor);
            }
    }
</script>

<!-- GRABAR INFORMACIÓN -->
<script type="text/javascript">
	$("#btnPostear").click(function(){
		var pFactura 				 =  $("#txtFactura").val();
		var pProveedor 				 =  $("#cmbProveedor").val();
		var pComentario				 =  $("#txtComentario").val();
		var pUsuario 				 =  "<%= cUser.UsuarioCodigo %>";
		var pUsuarioNom				 =  "<%= cUser.NomUsuario %>";
		var ExisteDetalle 			 =  $("#hdn").val();
		var Error = false;
		var Mensaje = "";

		if(pFactura.length == 0)
		{
			Error = true;
			Mensaje = "La Factura es Obligatoria";
		}else if(ExisteDetalle != "1")
		{
			Error = true;
			Mensaje = "Es necesario que se agregue al menos un Material";
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

		$(this).hide();
		loading('Grabando',1);

		$.msgbox("Desea grabar los registros ingresados?.<br/><br/> Desea continuar?", {
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
			        url: "Entrada_Inventario.aspx/Grabando",
			        data: '{ pFactura: "' + pFactura + '", pProveedor: "'+ pProveedor +'", pComentario: "'+ pComentario +'", pUsuario: "'+ pUsuario +'", pUsuarioNom: "'+ pUsuarioNom +'" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: Grabar,
			        failure: function (msg) {
			        	unloading();
			        	$("#btnPostear").show();
			            alert(msg);
			        },
			        error: function (xhr, err) {
			        	unloading();
			        	$("#btnPostear").show();
			            alert(err);
			        }
			    });
	  	  	}
	  	  else
	  	  {
	  	  		$("#btnPostear").show();
				unloading();
	  	  }
	  	});
		
	});
	
	function Grabar(msg)
	{
		unloading();
		if( msg.d != 0)
		{
			window.location.replace("../pages/Dashboard.aspx"); 
		}
		else
		{
			$.notification(
			{
			    title: "ERROR 001: Error al grabar la solicitud...",
				content: msg.d,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				border: false,
				error: true
			});
		}

	}
</script>

</asp:Content>