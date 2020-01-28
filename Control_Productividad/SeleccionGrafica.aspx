<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="SeleccionGrafica.aspx.vb" Inherits="Control_Productividad_SeleccionGrafica" %>

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
				<a href="" class="current_page">Selección Gráfica</a>
			 </div> <!-- #bread_crumbs -->
		</div> <!-- .content_pad -->
	</div> <!-- #masthead -->

	<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/>
		<h2>Seleccione la Gráfica que desea Visualizar</h2>
		<br><br><br>
		<div class="portlet x6">
			<div class="portlet-content">
			<h2>Grafica de Productividad</h2>
				<div align="center" style="position:relative; top:70px;">
					<button class="btn btn-large btn-orange" id="btnProductividad"><span class="Arriba">Gráfica Productividad</span>
					<img src="../img/icons/large/white/Graph.png"></button>
					<img src="../images/loading3.gif" id="picLoading" style="display: none;">
					<br/><br/><br/>
				</div>
			</div>
		</div>
		<div class="portlet x6">
			<div class="portlet-content">
			<h2>Grafica de Defectos</h2>
				<div align="center" style="position:relative; top:70px;">
					<button class="btn btn-large btn-green" id="btnDefectos"><span class="Arriba">Gráfica Defectos</span>
					<img src="../img/icons/large/white/Chart 8.png"></button>
					<img src="../images/loading3.gif" id="picLoading" style="display: none;">
					<br/><br/><br/>
				</div>
			</div>
		</div>

	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	</form>

<script type="text/javascript">

	$("#btnProductividad").click(function(){
		var pUsuarioNom = "<%= cUser.NomUsuario %>";
		var result = $.ajax(
			    {
			        type: "POST",
			        url: "SeleccionGrafica.aspx/LimpiarGrafProd",
			        data: '{ pUsuarioNom: "' + pUsuarioNom + '" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: LimpiarTablaGraficaProd,
			        failure: function (msg) {
			            alert(msg);
			        },
			        error: function (xhr, err) {
			            //alert(err);
			        }
			    });
	});

	function LimpiarTablaGraficaProd(msg)
	{
		if(msg.d >= 0)
		{
			window.location.replace("../Control_Productividad/Grafica_Productividad.aspx");
		}
		else
		{
			$.notification( 
			{
				title: "Ocurrio un Error",
				content: "Error inesperado, porfavor notifique a IT",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
		}
	}

</script>

<script type="text/javascript">

	$("#btnDefectos").click(function(){
		var pUsuarioNom = "<%= cUser.NomUsuario %>";
		var result = $.ajax(
			    {
			        type: "POST",
			        url: "SeleccionGrafica.aspx/LimpiarGrafDefectos",
			        data: '{ pUsuarioNom: "' + pUsuarioNom + '" }',
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: LimpiarTablaGraficaDef,
			        failure: function (msg) {
			            alert(msg);
			        },
			        error: function (xhr, err) {
			            //alert(err);
			        }
			    });
	});

	function LimpiarTablaGraficaDef(msg)
	{
		if(msg.d >= 0)
		{
			window.location.replace("../Control_Productividad/PreparacionGrafica.aspx");
		}
		else
		{
			$.notification( 
			{
				title: "Ocurrio un Error",
				content: "Error inesperado, porfavor notifique a IT",
				// img: "notification/demo/thumb.png",
				icon: 'X',
				timeout: 5000,
				error: true,
				border: false
			});
		}
	}

</script>

</asp:Content>

