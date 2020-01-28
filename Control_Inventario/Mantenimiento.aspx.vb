Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Mantenimiento
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

End Class
