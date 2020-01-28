Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_SeleccionReporte
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub
End Class
