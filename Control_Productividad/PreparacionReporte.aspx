<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="PreparacionReporte.aspx.vb" Inherits="Control_Productividad_PreparacionReporte" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
	<script src="../js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
	<link rel="stylesheet" href="../css/plugin/dataTables.css" type="text/css" media="screen" title="no title" />
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
					<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Reporte</a>
					<div class="nav_menu">			
						<ul>
							<li><a href="ControlProductividad.aspx">Nuevo Control</a></li>	
							<li><a href="SeleccionGrafica.aspx">Gráfica</a></li>
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
				<a href="" class="current_page">Reporte</a>
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
					<h3>Filtro por Usuario</h3>
					<input type="checkbox" id="chkUsuario">
					<br>
					<label for="cmbUsuario">Usuario </label>
					<select id="cmbUsuario" class="medium" disabled="disabled">
						<optgroup label="Seleccione el Usuario">
						<%
						    Try
						    	cnn.cnnSeguridad.Close()
						        cnn.cnnSeguridad.Open()
						        Dim Sql As String = "select usuario_codigo, usuario_usuario from usuarios where usuario_cadenaseguridad like '%1%'"
						        cnn.cmdSeguridad = New MySqlCommand(Sql, cnn.cnnSeguridad)
						        Dim Reader As MySqlDataReader = cnn.cmdSeguridad.ExecuteReader
						        While Reader.Read
						            Dim Codigo As String = Reader("usuario_codigo")
						            Dim Descripcion As String = Reader("usuario_usuario")
						            Response.Write("<option value='" + Codigo + "'>" + Descripcion + "</option>")
						        End While
						        cnn.cnnSeguridad.Close()
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
					<h3>Filtro por Turnos</h3>
					<input type="checkbox" id="chkTurno">
					<br>
					<label for="cmbTurno">Turno </label>
					<select id="cmbTurno" class="medium" disabled="disabled">
						<optgroup label="Seleccione el Turno">
						<%
						    Try
						    	cnn.cnn.Close()
						        cnn.cnn.Open()
						        Dim Sql As String = "select turno_codigo, turno_nombre from turnos"
						        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
						        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
						        While Reader.Read
						            Dim Codigo As String = Reader("turno_codigo")
						            Dim Descripcion As String = Reader("turno_nombre")
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
							<th>Serie</th>
							<th>Turno</th>
							<th>Proyecto</th>
							<th>Pieza</th>
							<th>Enchape</th>
							<th>Usuario</th>
							<th>Comentario</th>
							<th>Revisadas</th>
							<th>Malas</th>
							<th>Productividad</th>
							<th>Gráfica</th>
						</tr>
					</thead>
					<tbody id="cols">
					<%
						    Try
						    	Dim Suma as Decimal = 0
						        cnn.cnn.Close()
						        cnn.cnn.Open()
						        Dim Sql As String = "select c.control_codigo, c.control_fecha, c.control_serie, t.turno_nombre, pr.proyecto_nombre, pi.pieza_nombre, e.enchape_descripcion, c.control_usuario, c.control_comentario, c.control_piezasrevisadas, c.control_piezasmalas, c.control_productividad from control as c join proyectos as pr join piezas as pi join turnos as t join enchapes as e where c.control_turno = t.turno_codigo and c.control_proyecto = pr.proyecto_codigo and c.control_pieza = pi.pieza_codigo and c.control_enchape = e.enchape_codigo order by c.control_fecha asc"
						        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
						        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
						        While Reader.Read
						            Dim Codigo As String = Reader("control_codigo")
					                Dim Fecha As String = Reader("control_fecha")
					                Dim Serie As String = Reader("control_serie")
					                Dim Turno As String = Reader("turno_nombre")
					                Dim Proyecto As String = Reader("proyecto_nombre")
					                Dim Pieza As String = Reader("pieza_nombre")
					                Dim Enchape As String = Reader("enchape_descripcion")
					                Dim CodUsuario As String = Reader("control_usuario")
					                Dim Comentario As String = Reader("control_comentario")
					                Dim TotalP As String = Reader("control_piezasrevisadas")
					                Dim TotalM As String = Reader("control_piezasmalas")
					                Dim Productividad As Decimal = Reader("control_productividad")
					                Suma += Productividad
					                Dim Usuario As String = CargarNombre(CodUsuario)
			            %>
	                        	<tr>
	                        		<td><%= Replace(Fecha.ToString, ".", "/") %></td>
									<td><%= Serie %></td>
									<td><%= Turno %></td>
									<td><%= Proyecto %></td>
									<td><%= Pieza %></td>
									<td><%= Enchape %></td>
									<td><%= Usuario %></td>
									<td><%= Comentario %></td>
									<td><%= TotalP %></td>
									<td><%= TotalM %></td>
									<td><%= Replace(Productividad.ToString, ",", ".")+" %" %></td>
									<td><a onclick="VerGrafica(<%= Codigo %>)"><span>Ver <img src="../img/icons/ver.jpg"></span></a></td>
								</tr>
								<script type="text/javascript">
									$("#lblProductividadTotal").text("<%= Suma %>");
								</script>
                        <% 
						        End While
	                            Catch ex As Exception
						        	Response.Write("<tr>" + ex.Message + "</tr>")
	                            End Try
				        %>
					</tbody>
				</table>
				
				</div>
			</div>
		</div>
		<a id="EnlaceGrafica" href="../Grafica/Grafica.aspx?lightbox[width]=1000&lightbox[height]=600" class="lightbox" style="display:none;"></a>
	</form>
	<br/><br/>
	<label for="lblProductividadTotal" style="position:relative; left:1120px; top:-50px; font-size:20px; font-weight: bold;">Productividad Total </label>
	<span id="lblProductividadTotal" class="orange" style="position:relative; left:1140px; top:-50px; font-size:30px; font-weight: bold;"></span>
	<br/><br/>
	<script type="text/javascript">

		$("#chkUsuario").change(function()
		{
			if(frmDatos.chkUsuario.checked == false)
			{
				$("#cmbUsuario").attr('disabled','disabled');
			}
			else
			{
				$("#cmbUsuario").removeAttr('disabled');
			}
		});

		$("#chkTurno").change(function()
		{
			if(frmDatos.chkTurno.checked == false)
			{
				$("#cmbTurno").attr('disabled','disabled');
			}
			else
			{
				$("#cmbTurno").removeAttr('disabled');
			}
		});

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
		if (pCondiciones.length == 0)
		{
			$.notification( 
			{
			    title: "Error al generar Reporte",
				content: "Es necesario establecer al menos un Filtro.",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
			return false;
		}

		$("#picLoading").show();
		$("#btnGenerar").hide();
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "PreparacionReporte.aspx/Generar",
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
 	var Usuario = $("#cmbUsuario").val();
 	var Turno = $("#cmbTurno").val();
 	var Proyecto = $("#cmbProyecto").val();
 	var Pieza = $("#cmbPieza").val();
 	var FechaInicio = $("#txtFechaInicio").val();
 	var FechaFin = $("#txtFechaFin").val();

 	if(frmDatos.chkUsuario.checked == true)
		{
			pCondiciones += " and c.control_usuario = '"+ Usuario +"'";
		}
		if(frmDatos.chkTurno.checked == true)
		{
			pCondiciones += " and c.control_turno = '"+ Turno +"'";
		}
		if(frmDatos.chkProyecto.checked == true)
		{
			pCondiciones += " and c.control_proyecto = '"+ Proyecto +"'";
		}
		if(frmDatos.chkPieza.checked == true)
		{
			pCondiciones += " and c.control_pieza = '"+ Pieza +"'";
		}
		if(frmDatos.chkFechas.checked == true)
		{
			if(FechaFin.length == 0)
			{
				pCondiciones += " and c.control_fecha = '"+ FechaInicio +"'";
			}
			else
			{
				pCondiciones += " and c.control_fecha between '"+ FechaInicio +"' and '"+ FechaFin +"'";
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
	        url: "PreparacionReporte.aspx/CargarGrafica",
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
				content: "Este Número de Serie no posee defectos",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
		}
	}

</script>
</asp:Content>

