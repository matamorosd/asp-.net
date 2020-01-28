Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class pages_ControlProductividad
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date
    Public CCodigo As String = ""
    Public c As Integer

    <WebMethod(EnableSession:=True)>
    Public Shared Function BuscarPieza(Proyecto As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "select p.pieza_codigo, p.pieza_nombre from piezas as p join piezas_proyectos as pp join proyectos as pr where p.pieza_codigo = pp.pieza_codigo and pp.proyecto_codigo = pr.proyecto_codigo and pp.proyecto_codigo = " + Proyecto
        Dim Cuenta As Integer = 0
        cnn.cnn.Open()
        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
        While Reader.Read
            If Not IsDBNull(Reader("pieza_nombre")) Then
                Dim Codigo As String = Reader("pieza_codigo")
                Dim Descripcion As String = Reader("pieza_nombre")
                If Cuenta = 0 Then
                    HTML = HTML + "<option selected='selected' value='" + Codigo + "'>" + Descripcion + "</option>"
                Else
                    HTML = HTML + "<option value='" + Codigo + "'>" + Descripcion + "</option>"
                End If
                Cuenta += 1
            End If
        End While
        cnn.cnn.Close()
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function BuscarEnchape(Proyecto As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "select e.enchape_codigo, e.enchape_descripcion from enchapes as e join enchapes_proyectos as ep join proyectos as pr where e.enchape_codigo = ep.enchape_codigo and ep.proyecto_codigo = pr.proyecto_codigo and ep.proyecto_codigo = " + Proyecto
        'Dim Cuenta As Integer = 0
        cnn.cnn.Open()
        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
        While Reader.Read
            If Not IsDBNull(Reader("enchape_descripcion")) Then
                Dim Codigo As String = Reader("enchape_codigo")
                Dim Descripcion As String = Reader("enchape_descripcion")
                'If Cuenta = 0 Then
                '    HTML = HTML + "<option selected='selected' value='" + Codigo + "'>" + Descripcion + "</option>"
                'Else
                HTML = HTML + "<option value='" + Codigo + "'>" + Descripcion + "</option>"
                'End If
                'Cuenta += 1
            End If

        End While
        cnn.cnn.Close()
        ' ================================
        ' Retorno de un string
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Grabando(pSerie As String, pFecha As String, pComentario As String, pTurno As String, pProyecto As String, pPieza As String, pEnchape As String, pUsuario As String, pUsuarioNom As String, pTotal As String, pMalas As String, pFechaPoly As String, pTurnoPoly As String, pMaquina As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = "0"
        Dim cnn As New conexion
        Dim MinProd As Decimal = 0
        Dim MinTrab As Decimal = 0
        Dim Productividad As Decimal = 0
        Dim SqlCorrelativo As String = "select max(control_codigo)+1 from control"
        'Seteo del  Correlativo
        Dim Correlativo As Integer = cnn.getValorQuery(SqlCorrelativo)
        If IsNothing(Correlativo) Or Correlativo = 0 Then
            Correlativo = 1
        End If
        Dim SqlMinProd As String = "select " + pTotal + " * meta_minutosporpiezas from piezas_proyectos where pieza_codigo = '" + pPieza + "' and proyecto_codigo = '" + pProyecto + "'"
        Dim SqlMinTrab As String = "select turno_minutos from turnos where turno_codigo = '" + pTurno + "'"
        Try
            MinProd = cnn.getValorQuery(SqlMinProd)
            MinTrab = cnn.getValorQuery(SqlMinTrab)
            Productividad = (MinProd / MinTrab) * 100
            Productividad = Format(Productividad, "###0.00")
        Catch ex As Exception
            Productividad = 0
        End Try
        Dim Sql As String = "insert into control set control_codigo = '" + Correlativo.ToString + "', control_fecha = '" + pFecha + "', control_fechasistema = now(), control_serie = '" + pSerie + "', control_fechapolyester = '" + pFechaPoly + "', control_turnopolyester = '" + pTurnoPoly + "', control_turno = '" + pTurno + "', control_comentario = '" + pComentario + "', control_pieza = '" + pPieza + "', control_proyecto = '" + pProyecto + "', control_enchape = '" + pEnchape + "', control_usuario = '" + pUsuario + "', control_piezasrevisadas = '" + pTotal + "', control_piezasmalas = '" + pMalas + "', control_productividad = '" + Replace(Productividad.ToString, ",", ".") + "', control_maquina = '" + pMaquina + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            'Retorno = ex.Message
        End Try
        'GRABANDO EL DETALLE DE LOS DEFECTOS DEL CONTROL
        If Retorno = 1 Then
            Dim SqlCuenta As String = "select count(*) from control_defectos_temporal where control_codigo_temp = '" + pUsuarioNom + "'"
            If cnn.getValorQuery(SqlCuenta) = 0 Then
            Else
                Dim SqlDetalle As String = "INSERT INTO control_defectos (Control_Codigo, Defecto_Codigo, Defecto_Cantidad, Defecto_Operario) SELECT " + Correlativo.ToString + ", Defecto_Codigo_Temp, Defecto_Cantidad_Temp, Defecto_Operario_Temp FROM control_defectos_temporal where Control_Codigo_Temp = '" + pUsuarioNom.ToString + "'"
                Try
                    Retorno = cnn.EjecutarInsertUpdate(SqlDetalle)
                Catch ex As Exception
                    'Retorno = ex.Message
                End Try
            End If
        End If
        ' ================================
        ' Retorno de un string
        ' ================================
        System.Threading.Thread.Sleep(1500)
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function BorrarDefecto(pReferencia As String, pUsuarioNom As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "delete from control_defectos_temporal where control_codigo_temp = '" + pUsuarioNom + "' and defecto_codigo_temp = '" + pReferencia + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString
    End Function

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

End Class
