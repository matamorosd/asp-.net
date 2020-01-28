Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_ReporteEntrada
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Function BuscarMaterial(pProveedor As String, Accion As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = ""
        If Accion = 1 Then
            Sql = "select m.material_codigo, m.material_nombre from materiales as m join material_proveedor as mp where m.material_codigo = mp.material_codigo and mp.proveedor_codigo = '" + pProveedor + "'"
        ElseIf Accion = 0 Then
            Sql = "select material_codigo, material_nombre from materiales"
        End If
        Dim Cuenta As Integer = 0
        cnn.cnnInventario.Open()
        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
        While ReaderInventario.Read
            If Not IsDBNull(ReaderInventario("material_nombre")) Then
                Dim Codigo As String = ReaderInventario("material_codigo")
                Dim Descripcion As String = ReaderInventario("material_nombre")
                If Cuenta = 0 Then
                    HTML = HTML + "<option selected='selected' value='" + Codigo + "'>" + Descripcion + "</option>"
                Else
                    HTML = HTML + "<option value='" + Codigo + "'>" + Descripcion + "</option>"
                End If
                Cuenta += 1
            End If
        End While
        cnn.cnnInventario.Close()
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Generar(pCondiciones As String) As String
        Dim cnn As New conexion
        Dim HTML As String = ""
        Dim Sql As String = "select e.entrada_codigo, e.entrada_fecha, e.entrada_factura, p.proveedor_nombre, e.entrada_comentario, e.entrada_usuario from entrada_inventario as e join proveedores as p join entrada_detalle as ed where e.entrada_proveedor = p.proveedor_codigo and e.entrada_codigo = ed.entrada_codigo" + pCondiciones + " group by e.entrada_codigo order by e.entrada_fecha asc"
        Try
            Dim valor As String = ""
            cnn.cnnInventario.Close()
            Dim Encontrados As Boolean = False
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                Encontrados = True
                Dim Codigo As String = ReaderInventario("entrada_codigo")
                Dim Fecha As String = ReaderInventario("entrada_fecha")
                Dim Factura As String = ReaderInventario("entrada_factura")
                Dim Proveedor As String = ReaderInventario("proveedor_nombre")
                Dim CodUsuario As String = ReaderInventario("entrada_usuario")
                Dim Comentario As String = ReaderInventario("entrada_comentario")
                Dim Usuario As String = CargarNombre(CodUsuario)

                HTML += "$('#tblReporte').dataTable().fnAddData(" + _
                            "['" + Replace(Fecha.ToString, ".", "/") + "', " + _
                            "'" + Factura + "', " + _
                            "'" + Proveedor + "', " + _
                            "'" + Comentario + "', " + _
                            "'" + Usuario + "', " + _
                            " '<a onclick=""VerGrafica(" + Codigo + ")""><span>Ver <img src=""../img/icons/ver.jpg""></span></a>' ]);"
            End While
            cnn.cnn.Close()
            If Encontrados = False Then
                HTML = "<tr align='center' style='width:300px; color:red;'>No se encontro ningun registro con estos parametros</tr>"
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

    Public Shared Function Orden(Fecha As String) As String
        Dim Año As String = Fecha.Substring(6, 4)
        Dim Mes As String = Fecha.Substring(3, 2)
        Dim Dia As String = Fecha.Substring(0, 2)
        Return Año + Mes + Dia
    End Function

    Public Shared Function CargarNombre(Codigo As String) As String
        Dim cnn As New conexion
        Dim valor As String = cnn.getValorQuerySeguridad("select usuario_usuario from usuarios where usuario_codigo = '" + Codigo + "'")
        Return valor
    End Function


    <WebMethod(EnableSession:=True)>
    Public Shared Function CargarGrafica(pCodigo As String, pUsuarioNom As String) As String
        Dim cnn As New conexion
        Dim HTML As String = "1"
        Dim SqlLimpia As String = "delete from grafica where grafica_codigo = '" + pUsuarioNom + "'"
        Dim Sql As String = "select m.material_nombre, ed.entrada_cantidad from materiales as m join entrada_detalle as ed where m.material_codigo = ed.entrada_material and ed.entrada_codigo = '" + pCodigo + "'"
        Try
            Dim valor As String = ""
            cnn.EjecutarInsertUpdateInventario(SqlLimpia)
            Dim Encontrados As Boolean = False
            cnn.cnnInventario.Close()
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                Encontrados = True
                Dim Descripcion As String = ReaderInventario("material_nombre")
                Dim Cantidad As String = ReaderInventario("entrada_cantidad")
                InsertaDatos(pUsuarioNom, Descripcion, Cantidad)
            End While
            cnn.cnnInventario.Close()
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

    Public Shared Function InsertaDatos(Usuario As String, Descripcion As String, Cantidad As String) As String
        Dim Valor As String = ""
        Dim Sql As String = "insert into grafica set grafica_codigo = '" + Usuario + "', grafica_descripcion = '" + Descripcion + "', grafica_cantidad = '" + Cantidad + "'"
        Dim cnn As New conexion
        Try
            Valor = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Valor = ex.Message
        End Try
        Return Valor
    End Function

End Class
