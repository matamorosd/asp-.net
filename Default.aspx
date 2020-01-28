<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <meta charset="utf-8"/>
    <script src="js/jquery/jquery-1.5.2.min.js" type="text/javascript"></script>

    <link rel="icon" type="image/png" href="images/Logo.ico" />
	<link rel="stylesheet" href="./css/reset.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="./css/text.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="./css/form.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="./css/buttons.css" type="text/css" media="screen" title="no title" />
	<link rel="stylesheet" href="./css/login.css" type="text/css" media="screen" title="no title" />
	
	<!-- Notificaciones y Animaciones -->
	<link href="./notification/main.css" rel="stylesheet" type="text/css" media="screen" />
	<script src="./notification/js/library.js" type="text/javascript"></script>
	<script src="./notification/js/notification.js" type="text/javascript"></script>
    <script type="text/javascript">
    $(document).ready(function() {			
		$("#txtUsuario").focus();


			$.notification( 
				{
					title: "Bienvenidos",
					content: "Ingrese su Usuario y Password",
					// img: "notification/demo/thumb.png",
					icon: '4',
					border: false
				}
			);

		});
	</script>
</head>
<body>
   <div id="login" class="animated fadeInDown">
	<br/><br/><br/>
	<h1>LOGIN</h1>
	<br/>
	<div id="login_panel">
		<form action="default.aspx" method="post" accept-charset="utf-8" >
			<div class="animated login_fields" id="frmLogin" >
				<div class="field">
					<label for="email">Usuario</label>
					<input type="text" class="nueva" name="txtUsuario" value="" id="txtUsuario" tabindex="1" placeholder="Código de Usuario" style="text-transform:uppercase; text-align:center;" />		
				</div>
				
				<div class="field">
					<label for="password">Contraseña</label>
					<input type="password" class="nueva" name="txtPassword" value="" id="txtPassword" tabindex="2" placeholder="CONTRASEÑA" style="text-align:center;"/>			
				</div>
			</div> <!-- .login_fields -->
			


			<div class="animated login_fields" id="frmCambioPass" style="display: none;">
				<div class="field">
					<label for="txtPass1">Contraseña</label>
					<input type="password" class="cambio" name="txtPass1" value="" id="txtPass1" tabindex="5" placeholder="Contraseña nueva" style="text-align:center;" />		
				</div>
				
				<div class="field">
					<label for="txtPass2">Repita la Contraseña</label>
					<input type="password" class="cambio" name="txtPass2" value="" id="txtPass2" tabindex="6" placeholder="Repita la Contraseña" style="text-align:center;"/>
				</div>
			</div> <!-- .Cambio de Password -->

			<div id="picActualizada" style="display: none;">
					<br/>
					<img src="images/actualizada.png"/>
					<br/>
					<div align="center"><a href="pages/Dashboard.aspx">Click aquí para continuar</a></div>
					<br/>
			</div>



			<div class="login_actions" align="center">
				<button type="button" class="animated btn btn-navy" id="botEnviar" tabindex="3" style="width:100%;">Ingreso</button>
				<!-- <button type="button" class="animated btn btn-navy" id="botCambiar" tabindex="3" style="width:100%; display: none;">Cambiar Contraseña</button> -->
				<img src="images/loading3.gif" id="picLoading" style="display: none;"/>
			</div>
		</form><!-- #login_panel -->



		

	</div> 
</div> <!-- #login -->





</body>
<script type="text/javascript">

    $("#txtUsuario").keypress(function (e) {
        if (e.which == 13) {
            $("#botEnviar").click();
        }
    });

    $("#txtPassword").keypress(function (e) {
        if (e.which == 13) {
            $("#botEnviar").click();
        }
    }); 

	$("#botEnviar").click(function () 
	{
		var user = $("#txtUsuario").val().toUpperCase();
		var pass = $("#txtPassword").val();

		if (user.length == 0 || pass.length == 0) {
		    $("#txtPassword").focus();
		    $.notification(
						{
						    title: "Ingrese el usuario y password por favor",
						    content: "Llene todos los datos por favor.",
						    // img: "notification/demo/thumb.png",
						    icon: 'X',
						    timeout: 5000,
						    error: true,
						    border: false
						}
					);
		    return false;
		}

		// Ocultar boton para evitar doble post
		$("#botEnviar").hide();
		$("#picLoading").show();

		loading('Ingresando', 1);

			var result = $.ajax(
		    {
		        type: "POST",
		        url: "Default.aspx/Login",
		        data: '{ user: "' + user + '",  pass: "' + pass + '"}',
		        contentType: "application/json; charset=utf-8",
		        dataType: "json",
		        success: Login,
		        failure: function (msg) {
		            alert(msg);
		        },
		        error: function (xhr, err) {
		        	alert(msg);
		        }
		    });
    });

		function Login(msg)
		{
            unloading();
		    $("#botEnviar").show();
		    $("#picLoading").hide();
		    if (msg.d != 0) {
		        // msg.d = 1: Usuario logueado y correcto
		        // msg.d = 2: Usuario necesita cambio de password
		        if (msg.d == 1) {
		            window.location.replace("pages/Dashboard.aspx");
		        }
		        else {
		            $("#frmLogin").addClass("fadeOutRight fast");
		            $("#botEnviar").addClass("fadeOutRight fast").delay(300).queue(function () {
		                $(this).hide();
		                $("#frmLogin").hide();
		                $("#frmCambioPass").addClass("fadeInRight fast");
		                $("#botCambiar").addClass("fadeInRight fast");
		                $("#frmCambioPass").show();
		                $("#botCambiar").show();
		                $("#txtPass1").focus();
		                // Cambio de Password
		                $.notification(
							{
							    title: "<font color=\"red\">Cambie la Contraseña</font>",
							    content: "Por favor ingrese su nueva contraseña para entrar al Sistema.",
							    icon: 'U',
							    border: false
							});
		            });
		            // $("#frmLogin").hide()
		        } //fin else
		    }
		    else {
		        $("#txtPassword").val("").focus();
		        $.notification(
						{
						    title: "Usuario o Password Incorrectos",
						    content: "Por favor vuelva a intentarlo.",
						    // img: "notification/demo/thumb.png",
						    icon: 'X',
						    timeout: 5000,
						    error: true,
						    border: false
						});

		        $("#login_panel").removeClass("animated shake").delay(1).queue(function () {
		            $("#login_panel").clearQueue();
		            $("#login_panel").addClass("animated shake");
		        });
		    }
            
		}

        
    </script> 
</html>
