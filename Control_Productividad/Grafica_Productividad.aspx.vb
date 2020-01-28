Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Productividad_Grafica_Productividad
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public Shared TotalDef As String = "0"
    Public Cuenta As Integer

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Function BuscarPieza(Proyecto As String, Accion As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = ""
        If Accion = 1 Then
            Sql = "select p.pieza_codigo, p.pieza_nombre from piezas as p join piezas_proyectos as pp join proyectos as pr where p.pieza_codigo = pp.pieza_codigo and pp.proyecto_codigo = pr.proyecto_codigo and pp.proyecto_codigo = " + Proyecto
        ElseIf Accion = 0 Then
            Sql = "select pieza_codigo, pieza_nombre from piezas"
        End If
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
    Public Shared Function Generar(pCondiciones As String, pUsuarioNom As String) As String
        Dim cnn As New conexion
        Dim HTML As String = "1"
        Dim Sql As String = ""
        If pCondiciones = "" Then
            Sql = "select control_usuario from control group by control_usuario order by control_usuario asc"
        Else
            Sql = "select control_usuario from control where 1=1" + pCondiciones + " group by control_usuario order by control_usuario asc"
        End If
        Dim SqlLimpia As String = "delete from control_graficaproductividad where grafica_codigo = '" + pUsuarioNom + "'"
        Try
            Dim valor As String = ""
            Dim SqlSum As String
            cnn.EjecutarInsertUpdate(SqlLimpia)
            Dim Encontrados As Boolean = False
            cnn.cnn.Close()
            cnn.cnn.Open()
            cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
            Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
            While Reader.Read
                Encontrados = True
                Dim Codigo As String = Reader("control_usuario")
                Dim Descripcion As String = RetornaDesc(Codigo)
                SqlSum = "select sum(control_productividad) from control where control_usuario = '" + Codigo.ToString + "'" + pCondiciones
                Dim Productividad As String = SumaProd(SqlSum)
                InsertaDatos(pUsuarioNom, Descripcion, Productividad)
            End While
            cnn.cnn.Close()
            If Encontrados = False Then
                HTML = "0"
            End If
        Catch ex As Exception
            Return ex.Message
        End Try
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    Public Shared Function RetornaDesc(pCodigo As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "select usuario_usuario from usuarios where usuario_codigo = '" + pCodigo + "'"
        Return cnn.getValorQuerySeguridad(Sql)
    End Function

    Public Shared Function SumaProd(SqlSum As String) As String
        Dim Valor As String
        Dim cnn As New conexion
        Valor = cnn.getValorQuery(SqlSum)
        Return Valor
    End Function

    Public Shared Function InsertaDatos(Usuario As String, Descripcion As String, Productividad As String) As String
        Dim Valor As String = ""
        Dim Sql As String = "insert into control_graficaproductividad set grafica_codigo = '" + Usuario + "', grafica_usuario = '" + Descripcion + "', grafica_productividad = '" + Productividad + "'"
        Dim cnn As New conexion
        Try
            cnn.cnn.Close()
            cnn.cnn.Open()
            Valor = cnn.EjecutarInsertUpdate(Sql)
            cnn.cnn.Close()
        Catch ex As Exception
            Valor = ex.Message
        End Try
        Return Valor
    End Function

End Class
