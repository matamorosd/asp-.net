Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Salida_Agregar
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Function Agregar(Codigo As String, pUsuarioNom As String, pCantidad As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = ""
        Dim cnn As New conexion
        Codigo = Codigo.Substring(0, Codigo.IndexOf(","))
        Dim Existencia As Integer = cnn.getValorQueryInventario("select material_existencia from materiales where material_codigo = '" + Codigo + "'")
        If Existencia < pCantidad Then
            'En caso de que la Cantidad que se desea ingresar sobrepase la existencia actual
            Retorno = "3"
        Else
            Dim SqlComprueba As String = "select count(*) from salida_detalle_temporal where salida_codigo_temporal = '" + pUsuarioNom + "' and salida_material_temporal = '" + Codigo.ToString + "'"
            If cnn.getValorQueryInventario(SqlComprueba) >= 1 Then
                'Si ya existe el registro de ese material
                Retorno = "2"
            Else
                'GRABAR TABLA TEMPORAL DE DEFECTOS
                Dim Sql As String = "insert into salida_detalle_temporal set salida_codigo_temporal = '" + pUsuarioNom.ToString + "', salida_material_temporal = '" + Codigo.ToString + "', salida_cantidad_temporal = '" + pCantidad.ToString + "'"
                Try
                    Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
                Catch ex As Exception
                    Retorno = ex.Message
                End Try
            End If
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function
End Class
