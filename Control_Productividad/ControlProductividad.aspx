<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="ControlProductividad.aspx.vb" Inherits="pages_ControlProductividad" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" type="ContentType" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script type="text/javascript">
		$(document).ready(function() {
		    $('#txtFecha').Zebra_DatePicker({
			  //format: 'd-m-Y'
			});
			$('#txtFechaPolyester').Zebra_DatePicker({
			});
			// $('#txtFechaPolyester').Zebra_DatePicker({
			//   //format: 'd-m-Y',
			//   pair: $('#txtFecha')
			// });

			// $('#txtFecha').Zebra_DatePicker({
			//   //format: 'd-m-Y',
			//   direction: 1
			// });
			$.notification( 
			{
			    title: "Nuevo Control",
				content: "A continuación ingrese los datos.",
				// img: "notification/demo/thumb.png",
				icon: '&',
				timeout: 5000,
				border: false
			});
			var enchape = localStorage["enchape"];
            if (enchape){
                $('#cmbEnchape').val(enchape);
            }
			var pieza = localStorage["pieza"];
            if (pieza){
                $('#cmbPieza').val(pieza);
            }
            $('#cmbProyecto').change();
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
			<h1 class="">Nuevo Control de Productividad</h1>
			<div id="bread_crumbs">
				<a href="../pages/Dashboard.aspx">Menu</a> / 
				<a href="" class="current_page">Nuevo Control</a>
			 </div> <!-- #bread_crumbs -->
		</div> <!-- .content_pad -->
	</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
<!-- Cuadros -->
<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Nuevo Control. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>
		<div class="portlet x6">
			<div class="portlet-content">
				<h2>Datos del Encargado</h2>

				<div class="field">
					<label for="txtSerie">Serie</label>
					<input id="txtSerie" name="txtSerie" value="" size="10" type="text" class="small" onkeyup="return ValNumero(this);" placeholder="Número de Serie"/>
				</div>

				<div class="field">
					<label for="txtFechaPolyester">Fecha Apl. Polyester </label>
					<input id="txtFechaPolyester" type="text" readonly="readonly" placeholder="Fecha Polyester">
				</div>

				<div class="field">
					<label for="cmbTurnoPolyester">Turno Apl. Polyester </label>
					<select id="cmbTurnoPolyester" class="medium">
						<optgroup label="Seleccione el Turno">
						<%
						    Try
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
				<div class="field">
					<label for="cmbMaquina">Maquina Apl. </label>
					<select id="cmbMaquina" class="medium">
						<optgroup label="Seleccione la Maquina de Apl.">
							<option value='1'>Maquina 1</option>
							<option value='2'>Maquina 2</option>
							<option value='3'>Maquina 3</option>
							<option value='4'>Maquina 4</option>
						</optgroup>
					</select>
				</div>
				<br>
				<div class="field">
					<label for="txtTotal">Total de Piezas </label>
					<input id="txtTotal" name="txtTotal" value="" size="10" type="text" class="small" placeholder="Total Piezas" onkeyup="return ValNumero(this);"/>
					<br><br>
					<label for="lblPiezasBuenas">Piezas Buenas</label>
					<span id="lblPiezasBuenas" class="blue" style="position:relative; left:10px; font-size:20px; font-weight: bold;">0</span>
					<br><br>
					<label for="lblPiezasMalas">Piezas Malas</label>
					<span id="lblPiezasMalas" class="orange" style="position:relative; left:10px; font-size:20px; font-weight: bold;">0</span>
					<br><br>
					<a href="#">
						<button class="btn btn-large btn-red" id="btnMala" style="position:relative; left:150px;"><span class="Arriba"></span>
						<img src="../img/icons/large/white/Trashcan.png"></button>
					</a>
					<a id="EnlaceDefecto" href="AgregarDefecto.aspx?lightbox[width]=1000&lightbox[height]=76p" class="lightbox" ></a>
					<br><br>
				</div>
			</div>
		</div>



		<div class="portlet x6">
			<div class="portlet-content">
				<h2>Datos de las piezas a revisar.</h2>
				<div class="field">
					<label for="cmbProyecto">Proyecto </label> 
					<select id="cmbProyecto" class="medium">
						<optgroup label="Seleccione el Proyecto">
						<%
						    Try
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
				<div class="field">
					<label for="cmbPieza">Pieza </label> 
					<select id="cmbPieza" class="medium">
						<optgroup label="Seleccione el Pieza">
						
						</optgroup>
					</select>
					<img src="../images/loading2.gif" id="picLoadingPieza" style="display: none;" style="position: relative; left:800px;"/>
				</div>
				
				<div class="field">
					<label for="cmbEnchape">Enchape </label>
					<select id="cmbEnchape" class="medium">
						<optgroup label="Seleccione el Enchape">
						
						</optgroup>
					</select>
					<img src="../images/loading2.gif" id="picLoadingEnchape" style="display: none;" style="position: relative; left:800px"/>
				</div>
				<div class="field">
					<br><br><br><br>
					<label for="txtFecha">Fecha de Revisión</label>
					<input id="txtFecha" type="text" readonly="readonly" placeholder="Fecha Revisión"></input>
				</div>
				<div class="field">
					<label for="cmbTurno">Turno Revisión</label>
					<select id="cmbTurno" class="medium">
						<optgroup label="Seleccione el Turno">
						<%
						    Try
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
		</div>		
		<div class="portlet x12">
			<div class="portlet-content">
				<h3>Defectos Encontrados</h3>
				<table class="data display" id="tblDetalleDefectos">
						<thead>
							<tr>
								<th style="width:150px;">Código</th>
								<th>Descripcion Defecto</th>
								<th style="width:150px;">Cantidad</th>
								<th style="width:80px;">Eliminar</th>
							</tr>
						</thead>
						<tbody>
							<%
						    Try
							        Dim c As Integer = 0
							        cnn.cnn.Close()
							        cnn.cnn.Open()
							        Dim Sql As String = "select cdt.defecto_codigo_temp, d.defecto_descripcion, cdt.defecto_cantidad_temp from control_defectos_temporal as cdt join defectos as d where cdt.defecto_codigo_temp = d.defecto_codigo and cdt.control_codigo_temp = '" + cUser.NomUsuario + "'"
							        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
							        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
							        While Reader.Read
							            Dim Cantidad As String = Reader("defecto_cantidad_temp")
							            Dim Codigo As String = Reader("defecto_codigo_temp")
							            Dim Descripcion As String = Reader("defecto_descripcion")
							            dim Sum as Integer = Reader("defecto_cantidad_temp")
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
												var Total = $("#txtTotal").val();
												if(Total == "")
												{
													Total = localStorage["total"];
												}
												$("#lblPiezasBuenas").text(Total - Contador);
												$("#lblPiezasMalas").text(Contador);
										    	if(Contador >= 1)
										    	{
										    		$('#txtSerie').attr( "disabled", "disabled" );
													$('#txtTotal').attr( "disabled", "disabled" );
													// $('#cmbTurno').attr( "disabled", "disabled" );
													$('#cmbEnchape').attr( "disabled", "disabled" );
													$('#cmbProyecto').attr( "disabled", "disabled" );
													$('#cmbPieza').attr( "disabled", "disabled" );
													$('#cmbTurnoPolyester').attr( "disabled", "disabled" );
													$('#txtFechaPolyester').attr( "disabled", "disabled" );
										    	}
										    	else
										    	{
										    		$('#txtSerie').RemoveAttr( "disabled" );
													$('#txtTotal').RemoveAttr( "disabled" );
													// $('#cmbTurno').RemoveAttr( "disabled" );
													$('#cmbEnchape').RemoveAttr( "disabled" );
													$('#cmbProyecto').RemoveAttr( "disabled" );
													$('#cmbPieza').RemoveAttr( "disabled" );
													$('#cmbTurnoPolyester').RemoveAttr( "disabled" );
													$('#txtFechaPolyester').RemoveAttr( "disabled" );
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
		<button class="btn btn-large btn-blue" id="btnPostear"><span class="Arriba">Postear Información</span>
		<img src="../img/icons/large/white/Travel Suitcase.png"></button>
		<img src="../images/loading3.gif" id="loading" style="display: none;">
		<br/><br/><br/><br/><br/><br/>
	</div>

<!-- CARGAR COMBOBOX DE PIEZAS Y ENCHAPE -->
<script type="text/javascript">

	$("#txtTotal").change(function(){
		var BuenasTemp = $("#txtTotal").val();
		$("#lblPiezasBuenas").text(BuenasTemp);
	});
	
	$('#cmbProyecto').change(function() 
	{
		$("#picLoadingPieza").show();
		$("#picLoadingEnchape").show();
		var Proyecto = $("#cmbProyecto").val();
		$("#cmbPieza option").remove();
		$("#cmbEnchape option").remove();
		BuscarPiezas(Proyecto)
		BuscarEnchapes(Proyecto)
	});


	function BuscarPiezas (pProyecto)
	{
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "ControlProductividad.aspx/BuscarPieza",
	        data: '{ Proyecto: "' + pProyecto + '" }',
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

	function BuscarEnchapes (pProyecto)
	{
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "ControlProductividad.aspx/BuscarEnchape",
	        data: '{ Proyecto: "' + pProyecto + '" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: CargarEnchapes,
	        failure: function (msg) {
	            alert(msg);
	        },
	        error: function (xhr, err) {
	            alert(err);
	        }
	    });
	}

	// Funcion de retorno de la instruccion AJAX, Funcion de BuscarPieza y BuscarEnchape en el CodeFile
	function CargarPiezas(msg) 
	{
		var Pieza = $('#cmbPieza'); 
		$("#picLoadingPieza").hide();
		Pieza.append($(msg.d)); 
	}
	function CargarEnchapes(msg) 
	{
		var Enchape = $('#cmbEnchape'); 
		$("#picLoadingEnchape").hide();
		Enchape.append($(msg.d));
	}
</script>

<!-- GRABAR INFORMACIÓN -->
<script type="text/javascript">
	$("#btnPostear").click(function(){
		var pSerie		             =  $.trim($("#txtSerie").val().toUpperCase());
		var pFechaPoly		         =  $("#txtFechaPolyester").val();
		var pTurnoPoly		         =  $("#cmbTurnoPolyester").val();
		var pComentario              =  $.trim($("#txtComentario").val().toUpperCase());
		var pTurno					 =  $("#cmbTurno").val();
		var pProyecto				 =  $("#cmbProyecto").val();
		var pPieza					 =  $("#cmbPieza").val();
		var pEnchape				 =  $("#cmbEnchape").val();
		var pTotal					 =  $("#txtTotal").val();
		var pMalas 					 =  $("#lblPiezasMalas").text();
		var pBuenas 				 =  $("#lblPiezasBuenas").text();
		var pUsuario 				 =  "<%= cUser.UsuarioCodigo %>";
		var pUsuarioNom				 =  "<%= cUser.NomUsuario %>";
		var pFecha					 =  $("#txtFecha").val();
		var pMaquina                 =  $("#cmbMaquina").val();
		var Error = false;
		var Mensaje = "";

		if(pSerie.length == 0)
		{
			Error = true;
			Mensaje = "La Serie es Obligatoria";
		}else if(pTotal.length == 0)
		{
			Error = true;
			Mensaje = "Total de la Serie es Obligatorio";
		}else if(pFecha.length == 0)
		{
			Error = true;
			Mensaje = "La Fecha de Revision es Obligatorio";
		}else if(pFechaPoly.length == 0)
		{
			Error = true;
			Mensaje = "La Fecha de Aplicación de Polyester es Obligatoria";
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
			        url: "ControlProductividad.aspx/Grabando",
			        data: '{ pSerie: "' + pSerie + '", pFecha: "'+ pFecha +'", pComentario: "' + pComentario + '",pTurno: "' + pTurno + '", pProyecto: "' + pProyecto + '",pPieza: "' + pPieza + '", pEnchape: "' + pEnchape + '", pUsuario: "'+ pUsuario +'", pUsuarioNom: "'+ pUsuarioNom +'", pTotal: "'+ pTotal +'", pMalas: "'+ pMalas +'", pFechaPoly: "'+ pFechaPoly +'", pTurnoPoly: "'+ pTurnoPoly+'", pMaquina: "'+pMaquina+'" }',
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

<!-- BORRAR DEFECTOS -->
<script type="text/javascript">

 function Borrar(id)
	{
		var pUsuarioNom =  "<%= cUser.NomUsuario %>";
		var result = $.ajax(
	    {
	        type: "POST",
	        url: "ControlProductividad.aspx/BorrarDefecto",
	        data: '{ pReferencia: "' + id + '", pUsuarioNom: "'+ pUsuarioNom +'" }',
	        contentType: "application/json; charset=utf-8",
	        dataType: "json",
	        success: BorrarDef,
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

	function BorrarDef(msg)
	{		
		if (msg.d >= 1)
		{
			window.location.reload("ControlProductividad.aspx");
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
	    localStorage["serie"] = $('#txtSerie').val();
	    localStorage["fechapoly"] = $('#txtFechaPolyester').val();
	    localStorage["turnopoly"] = $('#cmbTurnoPolyester').val();
	    localStorage["total"] = $('#txtTotal').val();
	    localStorage["turno"] = $('#cmbTurno').val();
	    localStorage["enchape"] = $('#cmbEnchape').val();
	    localStorage["proyecto"] = $('#cmbProyecto').val();
	    localStorage["pieza"] = $('#cmbPieza').val();
	    localStorage["comentario"] = $('#txtComentario').val();
	    localStorage["Fecha"] = $('#txtFecha').val();
	    localStorage["Maquina"] = $('#cmbMaquina').val();
	}


	window.onload = function() {
            var serie = localStorage["serie"];
            if (serie) {
                $('#txtSerie').val(serie);
            }
            var total = localStorage["total"];
            if (total){
                $('#txtTotal').val(total);
            }
            var turno = localStorage["turno"];
            if (turno){
                $('#cmbTurno').val(turno);
            }
            var proyecto = localStorage["proyecto"];
            if (proyecto){
                $('#cmbProyecto').val(proyecto);
            }
            var comentario = localStorage["comentario"];
            if (comentario){
                $('#txtComentario').val(comentario);
            }
            var Fecha = localStorage["Fecha"];
            if (Fecha){
                $('#txtFecha').val(Fecha);
            }
            var fechapoly = localStorage["fechapoly"];
            if (fechapoly){
                $('#txtFechaPolyester').val(fechapoly);
            }
            var turnopoly = localStorage["turnopoly"];
            if (turnopoly){
                $('#cmbTurnoPolyester').val(turnopoly);
            }
            var pProyecto = $("#cmbProyecto").val();
            //$("#cmbPieza option").remove();
			//$("#cmbEnchape option").remove();
            //BuscarPiezas(pProyecto)
			//BuscarEnchapes(pProyecto)

		    var pieza = localStorage["pieza"];
            if (pieza){
                $('#cmbPieza').val(pieza);
            }
            var enchape = localStorage["enchape"];
            if (enchape){
                $('#cmbEnchape').val(enchape);
            }
            var Maquina = localStorage["Maquina"];
            if (Maquina){
                $('#cmbMaquina').val(Maquina);
            }
    }
</script>

<script type="text/javascript">
	$("#btnMala").click(function(){

		var pSerie		             =  $.trim($("#txtSerie").val().toUpperCase());
		var pTotal					 =  $("#txtTotal").val();
		localStorage["total"]		 = $('#txtTotal').val();
		localStorage["PiezasMalas"]  = $('#lblPiezasMalas').text();
		var pFechapoly = $("#txtFechaPolyester").val();
		var Error = false;
		var Mensaje = "";

		if(pSerie.length == 0)
		{
			Error = true;
			Mensaje = "La Serie es Obligatoria";
		}else if(pTotal.length == 0)
		{
			Error = true;
			Mensaje = "Total de la Serie es Obligatorio";
		}else if(pFechapoly.length == 0)
		{
			Error = true;
			Mensaje = "La Fecha de Apl. Polyester es Obligatoria";
		}
		
		if(Error)
		{
			$.notification( 
			{
			    title: "Falta información por llenar",
				content: Mensaje,
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 6000,
				border: false,
				error: true
			});
			return false;
		}
		$("#EnlaceDefecto").click();
	});

</script>

<!-- BLOQUEO Y DESBLOQUEO DE CAMPOS. 
ACTUALMENTE NO ESTAN SIENDO UTILIZADAS POR PROBLEMAS DE EJECUCION -->
<script type="text/javascript">
	function BloquearCampos()
	{
		alert("Bloqueo");
		$('#txtSerie').attr( "disabled", "disabled" );
		$('#txtTotal').attr( "disabled", "disabled" );
		$('#cmbTurno').attr( "disabled", "disabled" );
		$('#cmbEnchape').attr( "disabled", "disabled" );
		$('#cmbProyecto').attr( "disabled", "disabled" );
		$('#cmbPieza').attr( "disabled", "disabled" );
	}

	function DesbloquearCampos()
	{
		alert("Desbloqueo");
		$('#txtSerie').RemoveAttr( "disabled" );
		$('#txtTotal').RemoveAttr( "disabled" );
		$('#cmbTurno').RemoveAttr( "disabled" );
		$('#cmbEnchape').RemoveAttr( "disabled" );
		$('#cmbProyecto').RemoveAttr( "disabled" );
		$('#cmbPieza').RemoveAttr( "disabled" );
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

</asp:Content>