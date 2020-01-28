Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class _Default
    Inherits System.Web.UI.Page

    Dim cUser As New Usuario

    Public Shared cnn As New conexion

    <WebMethod(EnableSession:=True)>
    Public Shared Function Login(ByVal user As String, ByVal pass As String) As String
        Dim Existe As String = ""
        Dim Cnn As New conexion
        Try
            Cnn.cnnSeguridad.Close()
            Cnn.cnnSeguridad.Open()
            Dim Sql As String = "SELECT * FROM usuarios where usuario_usuario = '" + user + "' and usuario_clave = '" + pass + "' and usuario_estado = '1'"
            Existe = Cnn.getValorQuerySeguridad(Sql)
            If Existe <> "" Then
                'si encontro algun registro en tabla usuarios que este ACTIVO
                Dim FuncionesFotma As New _Default
                FuncionesFotma.UsuarioValido(user)
                Existe = "1"
            Else
                Existe = "0"
            End If
        Catch ex As Exception
            Existe = ex.ToString
        End Try
        Cnn.cnnSeguridad.Close()
        System.Threading.Thread.Sleep(1500)
        HttpContext.Current.Session("Retorno") = Existe
        Return HttpContext.Current.Session("Retorno").ToString()
    End Function

    Sub UsuarioValido(ByVal usuario As String)
        cUser.CargarDatosDeUsuario(usuario)
        Session("glbUser") = cUser
    End Sub

End Class
