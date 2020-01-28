Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_MaterialDisponible
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario

    <WebMethod(EnableSession:=True)>
    Public Shared Function Generar(pCondiciones As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "select m.material_codigo, m.material_nombre, um.unidad_descripcion, p.proveedor_nombre, tm.tipomaterial_nombre, m.material_existencia from materiales as m join material_proveedor as mp join proveedores as p join unidad_medida as um join tipo_material as tm where m.material_codigo = mp.material_codigo and mp.proveedor_codigo = p.proveedor_codigo and um.unidad_codigo = m.material_unidadmedida and m.material_tipo = tm.tipomaterial_codigo" + pCondiciones
        Dim Cuenta As Integer = 0
        cnn.cnnInventario.Open()
        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
        While ReaderInventario.Read
            If Not IsDBNull(ReaderInventario("material_codigo")) Then
                Dim Codigo As String = ReaderInventario("material_codigo")
                Dim Nombre As String = ReaderInventario("material_nombre")
                Dim Unidad As String = ReaderInventario("unidad_descripcion")
                Dim Proveedor As String = ReaderInventario("proveedor_nombre")
                Dim TipoMaterial As String = ReaderInventario("tipomaterial_nombre")
                Dim Existencia As String = ReaderInventario("material_existencia")
                HTML += "$('#tblDisponible').dataTable().fnAddData(" + _
                           "['" + Codigo + "', " + _
                           "'" + Nombre + "', " + _
                           "'" + Unidad + "', " + _
                           "'" + Proveedor + "', " + _
                           "'" + TipoMaterial + "', " + _
                           " '" + Existencia + "' ]);"
            End If
        End While
        cnn.cnnInventario.Close()
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function


End Class
