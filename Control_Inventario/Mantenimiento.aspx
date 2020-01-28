<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Site.master" AutoEventWireup="false" CodeFile="Mantenimiento.aspx.vb" Inherits="Control_Inventario_Mantenimiento" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
<script type="text/javascript">
		$(document).ready(function() {
			$.notification( 
			{
			    title: "Mantenimientos",
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
		</ul>
	</div> <!-- .content_pad -->
</div> <!-- #header -->	

<div id="masthead">
	<div class="content_pad">
		<h1 class="">Mantenimientos</h1>
		<div id="bread_crumbs">
			<a href="../pages/Dashboard.aspx">Menu</a> / 
			<a href="" class="current_page">Mantenimientos</a>
		 </div> <!-- #bread_crumbs -->
	</div> <!-- .content_pad -->
</div> <!-- #masthead -->

<form id="frmDatos" class="form label-inline uniform" onsubmit="return false;">
	<div id="content" class="xgrid">
		<br/><br/><br/><br/><br/>
		<h2>Mantenimiento. Hoy es <span class="orange"> <%=FechaActual%></span></h2>
		<br/>
			<h2>Mantenimiento General</h2>
			<br><br><br>
			<div class="portlet x6">
				<div class="portlet-content">
					<div>
						<button class="btn btn-large btn-green" id="btnMateriales" style="width:200px; left:250px;"><span class="Arriba">Materiales</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
						<a href="Mantenimiento_Materiales.aspx"></a>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-blue" id="btnClientes" style="width:200px; left:250px;"><span class="Arriba">Clientes</span>
						<img src="../img/icons/large/white/User 2.png"></button>
						<a href="Mantenimiento_Clientes.aspx"></a>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-red" id="btnUnidad" style="width:200px; left:250px;"><span class="Arriba">Unidad Medida</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
						<a href="Mantenimiento_Clientes.aspx"></a>
					</div>
				</div>
			</div>
			<div class="portlet x6">
				<div class="portlet-content">
					<div>
						<button class="btn btn-large btn-yellow" id="btnProveedores" style="width:200px;"><span class="Arriba">Proveedores</span>
						<img src="../img/icons/large/white/Companies.png"></button>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-purple" id="btnMaterialProveedor" style="width:200px;"><span class="Arriba">Mat. por Prov.</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
					</div>
					<br>
					<div>
						<button class="btn btn-large btn-navy" id="btnTipo" style="width:200px;"><span class="Arriba">Tipo Material</span>
						<img src="../img/icons/large/white/Fountain Pen.png"></button>
					</div>
				</div>
			</div>
	</div>
	<br><br><br><br>
</form>

<script type="text/javascript">
	$("#btnMateriales").click(function()
	{
		window.location.replace("Mantenimiento_Materiales.aspx");
	});
	$("#btnClientes").click(function()
	{
		window.location.replace("Mantenimiento_Clientes.aspx");
	});
	$("#btnProveedores").click(function()
	{
		window.location.replace("Mantenimiento_Proveedor.aspx");
	});
	$("#btnMaterialProveedor").click(function()
	{
		window.location.replace("Mantenimiento_MaterialProveedor.aspx");
	});
	$("#btnUnidad").click(function()
	{
		window.location.replace("Mantenimiento_Unidad.aspx");
	});
	$("#btnTipo").click(function()
	{
		window.location.replace("Mantenimiento_Tipo.aspx");
	});

</script>
</asp:Content>

