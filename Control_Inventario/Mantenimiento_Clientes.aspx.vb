Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Mantenimiento_Clientes
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

    <WebMethod(EnableSession:=True)>
    Public Shared Function BorrarCliente(pReferencia As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "delete from clientes where cliente_codigo = '" + pReferencia + "'"
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
    Public Shared Function ModificarCliente(pReferencia As String, pNombre As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "update clientes set cliente_nombre = '" + pNombre + "' where cliente_codigo = '" + pReferencia + "'"
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
    Public Shared Function AgregarCliente(pNombre As String) As String
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim SqlCorrelativo As String = "select max(cliente_codigo)+1 from clientes"
        'Seteo del  Correlativo
        Dim Correlativo As Integer = cnn.getValorQueryInventario(SqlCorrelativo)
        If IsNothing(Correlativo) Or Correlativo = 0 Then
            Correlativo = 1
        End If
        Dim Sql As String = "INSERT INTO clientes (`Cliente_Codigo`, `Cliente_Nombre`) VALUES ('" + Correlativo.ToString + "', '" + pNombre + "');"
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        If Retorno >= 1 Then
            Retorno = "<tr id='col" + Correlativo.ToString + "'><td>" + Correlativo.ToString + "</td><td>" + pNombre + "</td><td style='padding:5px;'><div align='center'><a onclick=""Modificar('" + Correlativo.ToString + "')""><span>Modificar <img src='../img/icons/icon_edit.png'></span></a></div></td><td style='padding:5px;'><div align='center'><a onclick=""Borrar('" + Correlativo.ToString + "')""><span>Eliminar <img src='../img/icons/icon_delete.png'></span></a></div></td></tr>"
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function CargaDatos(pReferencia As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "select * from clientes where cliente_codigo = '" + pReferencia + "'"
        Dim Retorno As String = "0"
        Try
            cnn.cnnInventario.Close()
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                Dim Codigo As String = ReaderInventario("cliente_codigo")
                Dim Nombre As String = ReaderInventario("cliente_nombre")
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