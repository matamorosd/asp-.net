Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Entrada_Agregar
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Function Agregar(Codigo As String, pUsuarioNom As String, pCantidad As String, pProveedor As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = ""
        Dim cnn As New conexion
        Dim pSubtotal As Decimal = 0
        Dim pMoneda As String = ""
        Codigo = Codigo.Substring(0, Codigo.IndexOf(","))

        Dim SqlComprueba As String = "select count(*) from entrada_detalle_temporal where entrada_codigo_temporal = '" + pUsuarioNom + "' and entrada_material_temporal = '" + Codigo.ToString + "'"
        If cnn.getValorQueryInventario(SqlComprueba) >= 1 Then
            'Si ya existe el registro de ese material
            Retorno = "2"
        Else
            Try
                Dim SqlDatos As String = "select material_precio, material_moneda from material_proveedor where material_codigo = '" + Codigo.ToString + "' and proveedor_codigo = '" + pProveedor + "'"
                cnn.cmdInventario = New MySqlCommand(SqlDatos, cnn.cnnInventario)
                cnn.cnnInventario.Open()
                Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
                While ReaderInventario.Read
                    pSubtotal = ReaderInventario("material_precio") * pCantidad
                    pMoneda = ReaderInventario("material_moneda")
                    pSubtotal = Format(pSubtotal, "###0.00")
                End While
                cnn.cnnInventario.Close()
            Catch ex As Exception
                Retorno = ex.Message
            End Try
            'GRABAR TABLA TEMPORAL DE DEFECTOS
            Dim Sql As String = "insert into entrada_detalle_temporal set entrada_codigo_temporal = '" + pUsuarioNom.ToString + "', entrada_material_temporal = '" + Codigo.ToString + "', entrada_cantidad_temporal = '" + pCantidad.ToString + "', entrada_subtotal_temporal = '" + Replace(pSubtotal.ToString, ",", ".") + "', entrada_moneda_temporal = '" + pMoneda.ToString + "'"
            Try
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            Catch ex As Exception
                Retorno = ex.Message
            End Try
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function
End Class
