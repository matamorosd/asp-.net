Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Salida_Inventario
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date
    Public c As Integer

    '<WebMethod(EnableSession:=True)>
    'Public Shared Function BuscarMateriales(pCliente As String) As String
    '    Dim cnn As New conexion
    '    Dim HTML As String = ""
    '    Dim Suma As Decimal = 0
    '    Dim Sql As String = "select m.material_codigo, m.material_nombre, um.unidad_descripcion from materiales as m join unidad_medida as um where m.material_unidadmedida = um.unidad_codigo and m.material_proveedor = '" + pProveedor + "'"
    '    Try
    '        Dim valor As String = ""
    '        cnn.cnnInventario.Close()
    '        Dim Encontrados As Boolean = False
    '        cnn.cnnInventario.Open()
    '        cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
    '        Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
    '        While ReaderInventario.Read
    '            Encontrados = True
    '            Dim Codigo As String = ReaderInventario("material_codigo")
    '            Dim Nombre As String = ReaderInventario("material_nombre")
    '            Dim Unidad As String = ReaderInventario("unidad_descripcion")

    '            HTML += "$('#tblMateriales').dataTable().fnAddData(" + _
    '                        "['" + Codigo + "', " + _
    '                        "'" + Nombre + "', " + _
    '                        " '" + Unidad + "' ]);"
    '        End While
    '        cnn.cnnInventario.Close()
    '        If Encontrados = False Then
    '            HTML = "<tr><td align='center' style='width:300px; color:red;'>No se encontro ningun registro con estos parametros</td></tr>"
    '        End If
    '    Catch ex As Exception
    '        Return ex.Message
    '    End Try
    '    ' ================================
    '    ' Retorno de un string 
    '    ' ================================
    '    HttpContext.Current.Session("test") = HTML
    '    Return HttpContext.Current.Session("test").ToString()
    'End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function BorrarMaterial(pReferencia As String, pUsuarioNom As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = ""
        Dim cnn As New conexion
        Dim Sql As String = "delete from salida_detalle_temporal where salida_codigo_temporal = '" + pUsuarioNom + "' and salida_material_temporal = '" + pReferencia + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Grabando(pCliente As String, pComentario As String, pUsuario As String, pUsuarioNom As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = "0"
        Dim cnn As New conexion
        Dim SqlCorrelativo As String = "select max(salida_codigo)+1 from salida_inventario"
        'Seteo del  Correlativo
        Dim Correlativo As Integer = cnn.getValorQueryInventario(SqlCorrelativo)
        If IsNothing(Correlativo) Or Correlativo = 0 Then
            Correlativo = 1
        End If
        Dim Sql As String = "insert into salida_inventario set salida_codigo = '" + Correlativo.ToString + "', salida_fecha = now(), salida_cliente = '" + pCliente + "', salida_usuario = '" + pUsuario + "', salida_comentario = '" + pComentario + "'"
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
        Catch ex As Exception
            'Retorno = ex.Message
        End Try
        'GRABANDO EL DETALLE DE LOS DEFECTOS DEL CONTROL
        If Retorno = 1 Then
            'Dim SqlCuenta As String = "select count(*) from  where control_codigo_temp = '" + pUsuarioNom + "'"
            'If cnn.getValorQuery(SqlCuenta) = 0 Then
            'Else
            Dim SqlDetalle As String = "INSERT INTO salida_detalle (salida_Codigo, salida_material, salida_cantidad) SELECT " + Correlativo.ToString + ", salida_material_temporal, salida_cantidad_temporal FROM salida_detalle_temporal where salida_codigo_temporal = '" + pUsuarioNom.ToString + "'"
            Try
                Retorno = cnn.EjecutarInsertUpdateInventario(SqlDetalle)
            Catch ex As Exception
                'Retorno = ex.Message
            End Try
            'End If
        End If
        If Retorno >= 1 Then
            Dim SqlExistencia As String = "select * from salida_detalle where salida_codigo = '" + Correlativo.ToString + "'"
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(SqlExistencia, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                If Not IsDBNull(ReaderInventario("salida_cantidad")) Then
                    Dim Material As String = ReaderInventario("salida_material")
                    Dim Existencia As String = ReaderInventario("salida_cantidad")
                    Retorno = ModificaExistencia(Material, Existencia)
                End If
            End While
            cnn.cnn.Close()
        End If
        ' ================================
        ' Retorno de un string
        ' ================================
        System.Threading.Thread.Sleep(1500)
        HttpContext.Current.Session("test") = Retorno 'si retorna 0 muestra error, si no se grabo, OJO verificar que retorno Ejecutarinsertupdateinventario
        Return HttpContext.Current.Session("test").ToString()
    End Function

    Public Shared Function ModificaExistencia(pMaterial As String, pExistencia As String) As Integer
        Dim cnn As New conexion
        Dim valor As String = cnn.EjecutarInsertUpdateInventario("UPDATE materiales SET Material_existencia= Material_existencia - " + pExistencia + " WHERE Material_Codigo='" + pMaterial + "'")
        Return valor
    End Function

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub
End Class
