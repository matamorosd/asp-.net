<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="SeleccionReporte.aspx.vb" Inherits="Control_Inventario_SeleccionReporte" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Reportes",
				content: "Que desea hacer hoy?.",
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
				<a href="javascript:;"><span class="ui-icon ui-icon-gripsmall-diagonal-se"></span>Reportes</a>
				<div class="nav_menu">			
					<ul>
						<li><a href="#" id="aDisponible">Mat. Disponible</a></li>
						<li><a href="#" id="aEntrada">Entrada Mat.</a></li>
						<li><a href="#" id="aSalida">Salida Mat.</a></li>
					</ul>
				</div>
			</li>
		</ul>
	</div> <!-- .content_pad -->
</div> <!-- #header -->	

<div id="masthead">
	<div class="content_pad">
		<h1 class="">Reportes</h1>
		<div id="bread_crumbs">
			<a href="../pages/Dashboard.aspx">Menu</a> / 
			<a href="" class="current_page">Reportes</a>
		 </div> <!-- #bread_crumbs -->
	</div> <!-- .content_pad -->
</div> <!-- #masthead -->
<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Reportes. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>
			<h2>Reportes Generales</h2>
			<br><br><br>
			<div class="portlet x12">
				<div class="portlet-content">
					<div>
						<button class="btn btn-large btn-green" id="btnDisponible" style="width:300px; left:350px;"><span class="Arriba">Material Disponible</span>
						<img src="../img/icons/large/white/Books 2.png"></button>
						<a href="MaterialDisponible.aspx"></a>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-blue" id="btnEntrada" style="width:300px; left:350px;"><span class="Arriba">Entrada de Inventario</span>
						<img src="../img/icons/large/white/Text Document.png"></button>
						<a href="ReporteEntrada.aspx"></a>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-red" id="btnSalida" style="width:300px; left:350px;"><span class="Arriba">Salida de Inventario</span>
						<img src="../img/icons/large/white/Text Document.png"></button>
						<a href="ReporteSalida.aspx"></a>
					</div>
				</div>
			</div>
	</div>
	<br><br><br><br>
</form>

<script type="text/javascript">

	$("#aDisponible").click(function(){
		$("#btnDisponible").click();
	});

	$("#aEntrada").click(function(){
		$("#btnEntrada").click();
	});

	$("#aSalida").click(function(){
		$("#btnSalida").click();
	});

	$("#btnDisponible").click(function()
	{
		window.location.replace("MaterialDisponible.aspx");
	});
	$("#btnEntrada").click(function()
	{
		VerificaAcceso("ReporteEntrada.aspx");
	});
	$("#btnSalida").click(function()
	{
		VerificaAcceso("ReporteSalida.aspx");
	});

</script>

<script type="text/javascript">
	function VerificaAcceso(url)
	{
		var pUsuarioSeguridad = "<%= cUser.CadenaSeguridad %>";
		if (pUsuarioSeguridad.indexOf(9) == -1)
		{
			$.notification( 
			{
				title: "Problemas de Acceso",
				content: "El usuario Logueado no tiene permisos de Acceso",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
		}
		else
		{
			window.location.replace(url);
		}
	}
</script>

</asp:Content>

