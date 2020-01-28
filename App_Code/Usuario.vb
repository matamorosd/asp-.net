Imports Microsoft.VisualBasic
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Public Class Usuario

    Public UsuarioCodigo As String = ""
    Public NomUsuario As String = ""
    Public Nombre As String = ""
    Public CadenaSeguridad As String = ""

    Public UsuarioLogueado As Boolean = False

    Private Cnn As New conexion

    Sub DesloguearUsuario()
        NomUsuario = "NoUs"
        Nombre = "No user"
        UsuarioLogueado = False
    End Sub

    Sub CargarDatosDeUsuario(ByVal Usuario As String)

        Dim Sql As String = "SELECT * FROM usuarios WHERE Usuario_Usuario ='" + Usuario + "'"

        Try
            Dim valor As String = ""
            Cnn.cnnSeguridad.Close()
            Cnn.cnnSeguridad.Open()
            Cnn.cmdSeguridad = New MySqlCommand(Sql, Cnn.cnnSeguridad)
            Dim ReaderSeguridad As MySqlDataReader = Cnn.cmdSeguridad.ExecuteReader
            While ReaderSeguridad.Read
                UsuarioCodigo = ReaderSeguridad("Usuario_Codigo")
                NomUsuario = Usuario
                Nombre = ReaderSeguridad("Usuario_Nombre")
                CadenaSeguridad = ReaderSeguridad("Usuario_CadenaSeguridad")
            End While
            Cnn.cnnSeguridad.Close()
        Catch ex As Exception
        End Try


    End Sub

    'Function NombreCompleto() As String

    '    Dim NombreTempo As String = Nombre.ToLower

    '    NombreTempo = NombreTempo.Substring(0, 1).ToUpper + NombreTempo.Substring(1)
    '    ApellidoTempo = ApellidoTempo.Substring(0, 1).ToUpper + ApellidoTempo.Substring(1)

    '    Return NombreTempo + " " + ApellidoTempo

    'End Function

End Class
