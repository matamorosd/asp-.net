Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Productividad_SeleccionGrafica
    Inherits System.Web.UI.Page

    Public cUser As New Usuario
    Public cnn As New conexion

    '=========================================
    'Funcion que Limpia la tabla Temporal de la Grafica
    '=========================================
    <WebMethod(EnableSession:=True)>
    Public Shared Function LimpiarGrafDefectos(pUsuarioNom As String) As String
        Dim cUser As New Usuario
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim Sql As String = "delete from control_grafica where grafica_codigo = '" + pUsuarioNom + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    '=========================================
    'Funcion que Limpia la tabla Temporal de la Grafica
    '=========================================
    <WebMethod(EnableSession:=True)>
    Public Shared Function LimpiarGrafProd(pUsuarioNom As String) As String
        Dim cUser As New Usuario
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim Sql As String = "delete from control_graficaproductividad where grafica_codigo = '" + pUsuarioNom + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub
End Class
