Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Mantenimiento_MaterialProveedor
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

    <WebMethod(EnableSession:=True)>
    Public Shared Function Generar(pCondiciones As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "select m.material_codigo, m.material_nombre, mp.material_precio, mo.moneda_descripcion from materiales as m join material_proveedor as mp join moneda as mo where m.material_codigo = mp.material_codigo and mp.material_moneda = mo.moneda_codigo" + pCondiciones
        Dim Cuenta As Integer = 0
        cnn.cnnInventario.Open()
        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
        While ReaderInventario.Read
            If Not IsDBNull(ReaderInventario("material_codigo")) Then
                Dim Codigo As String = ReaderInventario("material_codigo")
                Dim Nombre As String = ReaderInventario("material_nombre")
                Dim Precio As String = ReaderInventario("material_precio")
                Dim Moneda As String = ReaderInventario("moneda_descripcion")
                HTML += "$('#tblMaterialesAgregados').dataTable().fnAddData(" + _
                           "['" + Codigo + "', " + _
                           "'" + Nombre + "', " + _
                           "'" + Precio + "', " + _
                           "'" + Moneda + "', " + _
                           " '<a onclick=""Borrar(" + Codigo + ")""><span>Eliminar <img src=""../img/icons/icon_delete.png""></span></a>' ]);"
                'HTML += "<tr id='col" + Codigo + "'><td>" + Codigo + "</td><td>" + Nombre + "</td><td>" + Precio + "</td><td>" + Moneda + "</td><td style='padding:5px;'><div align='center'><a onclick=""Borrar('" + Codigo + "')""><span>Eliminar <img src='../img/icons/icon_delete.png'></span></a></div></td></tr>"
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
    Public Shared Function Comprueba(pProveedor As String, pMaterial As String) As String
        Dim cnn As New conexion
        Dim Retorno As String = "0"
        Dim SqlComprueba As String = "select count(*) from material_proveedor where proveedor_codigo = '" + pProveedor + "' and material_codigo = '" + pMaterial + "'"
        If cnn.getValorQueryInventario(SqlComprueba) >= 1 Then
            Retorno = "1"
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function


    <WebMethod(EnableSession:=True)>
    Public Shared Function Agregar(pProveedor As String, pMaterial As String, pMoneda As String, pPrecio As String) As String
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim SqlComprueba As String = "select count(*) from material_proveedor where proveedor_codigo = '" + pProveedor + "' and material_codigo = '" + pMaterial + "'"
        If cnn.getValorQueryInventario(SqlComprueba) >= 1 Then
            'ya Existe
            Retorno = "2"
        Else
            Dim Sql As String = "INSERT INTO material_proveedor VALUES ('" + pMaterial + "', '" + pProveedor + "', '" + pPrecio + "', '" + pMoneda + "');"
            Try
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            Catch ex As Exception
                Retorno = ex.Message
            End Try
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Borrar(pProveedor As String, pMaterial As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "delete from material_proveedor where proveedor_codigo = '" + pProveedor + "' and material_codigo = '" + pMaterial + "'"
        Dim Retorno As String = ""
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

End Class
