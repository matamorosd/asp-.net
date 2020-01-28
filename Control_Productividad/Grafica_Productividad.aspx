<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Grafica_Productividad.aspx.vb" Inherits="Control_Productividad_Grafica_Productividad" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script type="text/javascript">
    	$(document).ready(function() {			
			$.notification( 
				{
				    title: "Bienvenido al generador de Gráfica",
					content: "Que deseas hacer hoy?.",
					// img: "notification/demo/thumb.png",
					icon: 'F',
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

		});
	</script>

	<div id="header">
		<div class="content_pad">
			<h1><a href="../pages/Dashboard.aspx">Menu Principal</a></h1>
			<ul id="nav">
				<li class="nav_dropdown nav_icon"><a href="../pages/Dashboard.aspx">
					<span class="nav_dropdown  nav_icon"></span>Menu Principal</a>
				</li>
				<li class="nav_dropdown nav_icon nav_current">
					<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Control Prod.</a>
					<div class="nav_menu">			
						<ul>
							<li><a href="ControlProductividad.aspx">Nuevo Control</a></li>	
							<li><a href="PreparacionReporte.aspx">Reporte</a></li>
							<li><a href="SeleccionGrafica.aspx">Gráfica</a></li>	
						</ul>	
					</div>
				</li>
			</ul>
		</div> <!-- .content_pad -->
	</div> <!-- #header -->	

	 <div id="masthead">
		<div class="content_pad">
			<h1 class="">Generador de Gráfica</h1>
			<div id="bread_crumbs">
				<a href="../pages/Dashboard.aspx">Menu</a> / 
				<a href="SeleccionGrafica.aspx">Selección Gráfica</a> /
				<a href="" class="current_page">Gráfica Productividad</a>
			 </div> <!-- #bread_crumbs -->
		</div> <!-- .content_pad -->
	</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/>
		<h2>Preparacion de Gráfica</h2>
		<br><br><br>
		<div class="portlet x6">
			<div class="portlet-content">
				<h3>Filtro por Proyecto</h3>
				<input type="checkbox" id="chkProyecto">
				<br>
				<label for="cmbProyecto">Proyecto </label>
				<select id="cmbProyecto" class="medium" disabled="disabled">
					<optgroup label="Seleccione el Proyecto">
					<%
					    Try
					    	cnn.cnn.Close()
					        cnn.cnn.Open()
					        Dim Sql As String = "select proyecto_codigo, proyecto_nombre from proyectos"
					        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
					        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
					        While Reader.Read
					            Dim Codigo As String = Reader("proyecto_codigo")
					            Dim Descripcion As String = Reader("proyecto_nombre")
					            Response.Write("<option value='" + Codigo + "'>" + Descripcion + "</option>")
					        End While
					        cnn.cnn.Close()
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
				<h3>Filtro por Pieza</h3>
				<input type="checkbox" id="chkPieza">
				<br>
				<label for="cmbPieza">Pieza </label>
				<select id="cmbPieza" class="medium" disabled="disabled">
					<optgroup label="Seleccione el Pieza">
					<%
					    Try
					    	cnn.cnn.Close()
					        cnn.cnn.Open()
					        Dim Sql As String = "select pieza_codigo, pieza_nombre from piezas"
					        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
					        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
					        While Reader.Read
					            Dim Codigo As String = Reader("pieza_codigo")
					            Dim Descripcion As String = Reader("pieza_nombre")
					            Response.Write("<option value='" + Codigo + "'>" + Descripcion + "</option>")
					        End While
					        cnn.cnn.Close()
					    Catch ex As Exception
					    		Response.Write("<option value='XX'>"+ ex.message +"</option>")
					    End Try
					%>
					</optgroup>
				</select>
				<img src="../images/loading2.gif" id="picLoadingPieza" style="display: none;" style="position: relative; left:800px;"/>
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
		<div class="portlet x12">
			<div class="portlet-content">
				<div align="center" style="position:relative; top:70px;">
					<button class="btn btn-large btn-blue" id="btnGenerar"><span class="Arriba">Generar Gráfica</span>
					<img src="../img/icons/large/white/Graph.png"></button>
					<img src="../images/loading3.gif" id="picLoading" style="display: none;">
					<br/><br/><br/>
				</div>
			</div>
		</div>
		<div class="portlet x12">
			<div class="portlet-content" id="divGrafica">

					<table id="tblGrafica" class="stats" data-chart="line">
						<caption>Productividad por Usuarios</caption>
						<thead>
							<tr>
								<td>&nbsp;</td>
								<%
							    Try
							    	Dim Cuenta as Integer = 0
							        cnn.cnn.Close()
							        cnn.cnn.Open()
							        Dim Sql As String = "select * from control_graficaproductividad where Grafica_Codigo = '" + cUser.NomUsuario + "' order by grafica_usuario asc"
							        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
							        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
							        While Reader.Read
							            Dim Descripcion As String = Reader("grafica_usuario")
					            %>
			                        	<th><%=Descripcion %></th>
		                        <% 
		                        	Cuenta += 1
								    End While
								%>
						        	<script type="text/javascript">
						        	var i = "<%= Cuenta %>";
						        	if(i > 0)
									{
										$("#divGrafica").show();
									}
						        	else
									{
								 		$("#divGrafica").hide();
									}
						        	</script>
						     
							</tr>
							<%
	                            Catch ex As Exception
						        	Response.Write("<tr>" + ex.Message + "</tr>")
	                            End Try
			        		%>
						</thead>
						<tbody>
						<tr>
						<th>Productividad</th>
						<%
						    Try
						        cnn.cnn.Close()
						        cnn.cnn.Open()
						        Dim Sql As String = "select * from control_graficaproductividad where Grafica_Codigo = '" + cUser.NomUsuario + "' order by grafica_usuario asc"
						        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
						        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
						        While Reader.Read
						            dim Productividad as Decimal = Reader("grafica_Productividad")
			            %>
									<td><%=Productividad %></td>
                        <% 
						        End While
	                            Catch ex As Exception
						        	Response.Write("<tr>" + ex.Message + "</tr>")
	                            End Try
				        %>
				        </tr>
						</tbody>
					</table>
			</div>
		</div>
	</div>

</form>
	
	<script type="text/javascript">

		$("#chkProyecto").change(function()
		{
			if(frmDatos.chkProyecto.checked == false)
			{
				$("#cmbProyecto").attr('disabled','disabled');
				CargarCMB(0);
			}
			else
			{
				$("#cmbProyecto").removeAttr('disabled');
			}
		});

		$("#chkPieza").change(function()
		{
			if(frmDatos.chkPieza.checked == false)
			{
				$("#cmbPieza").attr('disabled','disabled');
			}
			else
			{
				$("#cmbPieza").removeAttr('disabled');
				if(frmDatos.chkProyecto.checked == true)
				{
					CargarCMB(1);
				}
			}
		});

		$("#cmbProyecto").change(function(){
			if(frmDatos.chkPieza.checked == true)
			{
				CargarCMB(1);
			}
		});

		function CargarCMB(Accion)
		{
			$("#picLoadingPieza").show();
			$("#cmbPieza option").remove();
			var pProyecto = $("#cmbProyecto").val();
			var result = $.ajax(
		    {
		        type: "POST",
		        url: "PreparacionReporte.aspx/BuscarPieza",
		        data: '{ Proyecto: "' + pProyecto + '", Accion: "'+ Accion +'" }',
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        success: CargarPiezas,
		        failure: function (msg) {
		            alert(msg);
		        },
		        error: function (xhr, err) {
		            alert(err);
		        }
		    });
		}
		function CargarPiezas(msg)
		{
			var Pieza = $('#cmbPieza'); 
			$("#picLoadingPieza").hide();
			Pieza.append($(msg.d)); 
		}

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
	$("#cmbProyecto").change(function()
	{

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
		$("#picLoading").show();
		$("#btnGenerar").hide();
		// ===========================================
		// Buscar a la persona deseada
		// ===========================================
		var pUsuarioNom = "<%= cUser.NomUsuario %>";
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "Grafica_Productividad.aspx/Generar",
	        data: '{ pCondiciones: "' + pCondiciones + '", pUsuarioNom: "'+pUsuarioNom+'" }',
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
 	if(msg.d == 0)
 	{
 		$.notification( 
			{
			    title: "No se encontraron Datos",
				content: "Intente con otros parametros",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
 		$("#divGrafica").hide();
 	}
 	else
 	{
 		window.location.reload("Grafica_Productividad.aspx");
		$("#divGrafica").show();
 	}
 	$("#picLoading").hide();
	$("#btnGenerar").show();
 }

 function Condiciones(pCondiciones)
 {
 	var pCondiciones = "";
 	var Proyecto = $("#cmbProyecto").val();
 	var Pieza = $("#cmbPieza").val();
 	var FechaInicio = $("#txtFechaInicio").val();
 	var FechaFin = $("#txtFechaFin").val();

		if(frmDatos.chkProyecto.checked == true)
		{
			pCondiciones += " and control_proyecto = '"+ Proyecto +"'";
		}
		if(frmDatos.chkPieza.checked == true)
		{
			pCondiciones += " and control_pieza = '"+ Pieza +"'";
		}
		if(frmDatos.chkFechas.checked == true)
		{
			if(FechaFin.length == 0)
			{
				pCondiciones += " and control_fecha = '"+ FechaInicio +"'";
			}
			else
			{
				pCondiciones += " and control_fecha between '"+ FechaInicio +"' and '"+ FechaFin +"'";
			}
		}
		return pCondiciones;
 }

</script>

</asp:Content>

