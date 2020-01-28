Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Mantenimiento_Proveedor
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

    <WebMethod(EnableSession:=True)>
    Public Shared Function BorrarProveedor(pReferencia As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "delete from proveedores where proveedor_codigo = '" + pReferencia + "'"
        Dim Retorno As String = ""
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        If Retorno >= 1 Then
            Retorno = pReferencia
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function ModificarProveedor(pReferencia As String, pNombre As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "update proveedores set proveedor_nombre = '" + pNombre + "' where proveedor_codigo = '" + pReferencia + "'"
        Dim Retorno As String = ""
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        If Retorno >= 1 Then
            Retorno = pReferencia
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function


    <WebMethod(EnableSession:=True)>
    Public Shared Function AgregarProveedor(pReferencia As String, pNombre As String) As String
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim SqlComprueba As String = "select count(*) from proveedores where proveedor_codigo = '" + pReferencia + "'"
        If cnn.getValorQueryInventario(SqlComprueba) >= 1 Then
            'ya Existe
            Retorno = "2"
        Else
            Dim Sql As String = "INSERT INTO proveedores (`proveedor_Codigo`, `proveedor_Nombre`) VALUES ('" + pReferencia + "', '" + pNombre + "');"
            Try
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            Catch ex As Exception
                Retorno = ex.Message
            End Try
            If Retorno >= 1 Then
                Retorno = "<tr id='col" + pReferencia + "'><td>" + pReferencia + "</td><td>" + pNombre + "</td><td style='padding:5px;'><div align='center'><a onclick=""Modificar('" + pReferencia + "')""><span>Modificar <img src='../img/icons/icon_edit.png'></span></a></div></td><td style='padding:5px;'><div align='center'><a onclick=""Borrar('" + pReferencia + "')""><span>Eliminar <img src='../img/icons/icon_delete.png'></span></a></div></td></tr>"
            End If
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function CargaDatos(pReferencia As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "select * from proveedores where proveedor_codigo = '" + pReferencia + "'"
        Dim Retorno As String = "0"
        Try
            cnn.cnnInventario.Close()
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                Dim Codigo As String = ReaderInventario("proveedor_codigo")
                Dim Nombre As String = ReaderInventario("proveedor_nombre")
                Retorno = "$('#txtCodigo').val('" + Codigo + "');$('#txtNombre').val('" + Nombre + "');"
            End While
        Catch ex As Exception
            Retorno = -1
        End Try
        cnn.cnnInventario.Close()
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function
End Class
