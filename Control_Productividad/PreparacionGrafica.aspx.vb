Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Productividad_PreparacionGrafica
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public Shared TotalDef As String = "0"
    Public Cuenta As Integer

    Dim Sql As String = "SELECT d.defecto_descripcion, sum(cd.defecto_cantidad) FROM CONTROL_defectos as cd join defectos as d join control as c where cd.defecto_codigo = d.defecto_codigo and cd.control_codigo = c.control_codigo and c.control_turno = 2 group by cd.defecto_codigo"

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
        Dim SqlLimpia As String = "delete from control_grafica where grafica_codigo = '" + pUsuarioNom + "'"
        Dim Sql As String = "SELECT cd.defecto_codigo, d.defecto_descripcion FROM CONTROL_defectos as cd join defectos as d join control as c where cd.defecto_codigo = d.defecto_codigo and cd.control_codigo = c.control_codigo" + pCondiciones + " group by cd.defecto_codigo"
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
                Dim Codigo As String = Reader("defecto_codigo")
                Dim Descripcion As String = Reader("defecto_descripcion")
                SqlSum = "SELECT sum(cd.defecto_cantidad) FROM CONTROL_defectos as cd join defectos as d join control as c where cd.defecto_codigo = d.defecto_codigo and cd.control_codigo = c.control_codigo and cd.defecto_codigo = " + Codigo + pCondiciones + " group by cd.defecto_codigo"
                Dim Cantidad As String = SumaDefectos(SqlSum)
                InsertaDatos(pUsuarioNom, Descripcion, Cantidad)
            End While
            Dim SqlTotal As String = "SELECT sum(cd.defecto_cantidad) FROM CONTROL_defectos as cd join control as c where cd.control_codigo = c.control_codigo" + pCondiciones
            Dim DefectosTotal As Integer = cnn.getValorQuery(SqlTotal)
            cnn.cnn.Close()
            HTML = DefectosTotal.ToString
            TotalDef = HTML
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

    Public Shared Function SumaDefectos(SqlSum As String) As String
        Dim Valor As String
        Dim cnn As New conexion
        Valor = cnn.getValorQuery(SqlSum)
        Return Valor
    End Function

    Public Shared Function InsertaDatos(Usuario As String, Descripcion As String, Cantidad As String) As String
        Dim Valor As String = ""
        Dim Sql As String = "insert into control_grafica set grafica_codigo = '" + Usuario + "', grafica_defecto_descripcion = '" + Descripcion + "', grafica_defecto_cantidad = '" + Cantidad + "'"
        Dim cnn As New conexion
        Try
            Valor = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            Valor = ex.Message
        End Try
        Return Valor
    End Function

End Class
