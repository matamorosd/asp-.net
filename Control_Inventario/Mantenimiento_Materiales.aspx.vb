Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Inventario_Mantenimiento_Materiales
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public FechaActual As String = Now.Date

    <WebMethod(EnableSession:=True)>
    Public Shared Function BorrarMaterial(pCodigo As String, pCodigoP As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "delete from material_proveedor where material_codigo = '" + pCodigo + "' and proveedor_codigo = '" + pCodigoP + "'"
        Dim Retorno As String = ""
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            If Retorno >= 1 Then
                Sql = "delete from materiales where material_codigo = '" + pCodigo + "'"
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            End If
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        If Retorno >= 1 Then
            Retorno = pCodigo
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function ModificarMaterial(pCodigo As String, pNombre As String, pTipo As String, pUnidad As String, pExistencia As String, pProveedor As String, pMoneda As String, pPrecio As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "update materiales set material_nombre = '" + pNombre + "', material_unidadmedida = '" + pUnidad + "', material_tipo = '" + pTipo + "', material_existencia = '" + pExistencia + "' where material_codigo = '" + pCodigo + "'"
        Dim Retorno As String = ""
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            If Retorno >= 1 Then
                Sql = "update material_proveedor set material_precio = '" + pPrecio + "', material_moneda = '" + pMoneda + "' where material_codigo = '" + pCodigo + "' and proveedor_codigo = '" + pProveedor + "'"
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            End If
        Catch ex As Exception
            Retorno = ex.Message
        End Try

        If Retorno >= 1 Then
            Retorno = pCodigo
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function


    <WebMethod(EnableSession:=True)>
    Public Shared Function AgregarMaterial(pNombre As String, pTipo As String, pUnidad As String, pExistencia As String, pProveedor As String, pMoneda As String, pPrecio As String) As String
        Dim cnn As New conexion
        Dim Retorno As String = ""
        Dim SqlCorrelativo As String = "select max(material_codigo)+1 from materiales"
        'Seteo del  Correlativo
        Dim Correlativo As Integer = cnn.getValorQueryInventario(SqlCorrelativo)
        If IsNothing(Correlativo) Or Correlativo = 0 Then
            Correlativo = 1
        End If
        Dim Sql As String = "INSERT INTO materiales (`material_Codigo`, `material_Nombre`, `material_unidadmedida`, `material_tipo`, `material_existencia`) VALUES ('" + Correlativo.ToString + "', '" + pNombre + "', '" + pUnidad + "', '" + pTipo + "', '" + pExistencia + "');"
        Try
            Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            If Retorno >= 1 Then
                Sql = "INSERT INTO material_proveedor (`material_Codigo`, `proveedor_codigo`, `material_precio`, `material_moneda`) VALUES ('" + Correlativo.ToString + "', '" + pProveedor + "', '" + pPrecio + "', '" + pMoneda + "');"
                Retorno = cnn.EjecutarInsertUpdateInventario(Sql)
            End If
        Catch ex As Exception
            Retorno = ex.Message
        End Try
        If Retorno >= 1 Then
            Dim nProveedor As String = cnn.getValorQueryInventario("select proveedor_nombre from proveedores where proveedor_codigo = '" + pProveedor + "'")
            Dim nUnidad As String = cnn.getValorQueryInventario("select unidad_descripcion from unidad_medida where unidad_codigo = '" + pUnidad + "'")
            Dim nTipo As String = cnn.getValorQueryInventario("select tipomaterial_nombre from tipo_material where tipomaterial_codigo = '" + pTipo + "'")
            Dim nMoneda As String = cnn.getValorQueryInventario("select moneda_simbolo from moneda where moneda_codigo = '" + pMoneda + "'")
            Retorno = "<tr id='col" + Correlativo.ToString + "'><td>" + Correlativo.ToString + "</td><td>" + pNombre + "</td><td>" + nProveedor + "</td><td>" + nUnidad + "</td><td>" + nTipo + "</td><td>" + pExistencia + "</td><td>" + nMoneda + "</td><td>" + pPrecio + "</td><td style='padding:5px;'><div align='center'><a onclick=""Modificar('" + Correlativo.ToString + "', '" + pProveedor + "')""><span>Modificar <img src='../img/icons/icon_edit.png'></span></a></div></td><td style='padding:5px;'><div align='center'><a onclick=""Borrar('" + Correlativo.ToString + "', '" + pProveedor + "')""><span>Eliminar <img src='../img/icons/icon_delete.png'></span></a></div></td></tr>"
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function CargaDatos(pCodigo As String, pCodigoP As String) As String
        Dim cnn As New conexion
        Dim Sql As String = "select m.material_codigo, m.material_nombre, m.material_unidadmedida, m.material_tipo, m.material_existencia, mp.proveedor_codigo, mp.material_precio, mp.material_moneda from materiales as m join material_proveedor as mp where m.material_codigo = mp.material_codigo and mp.material_codigo = '" + pCodigo + "' and mp.proveedor_codigo = '" + pCodigoP + "'"
        Dim Retorno As String = "0"
        Try
            cnn.cnnInventario.Close()
            cnn.cnnInventario.Open()
            cnn.cmdInventario = New MySqlCommand(Sql, cnn.cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cnn.cmdInventario.ExecuteReader
            While ReaderInventario.Read
                Dim Codigo As String = ReaderInventario("material_codigo")
                Dim Nombre As String = ReaderInventario("material_nombre")
                Dim Proveedor As String = ReaderInventario("proveedor_codigo")
                Dim Tipo As String = ReaderInventario("material_tipo")
                Dim Unidad As String = ReaderInventario("material_unidadmedida")
                Dim Existencia As String = ReaderInventario("material_existencia")
                Dim Moneda As String = ReaderInventario("material_moneda")
                Dim Precio As String = ReaderInventario("material_precio")
                Retorno = "$('#txtCodigo').val('" + Codigo + "');$('#txtNombre').val('" + Nombre + "');$('#cmbProveedor').val('" + Proveedor + "');$('#cmbTipo').val('" + Tipo + "');$('#cmbUnidad').val('" + Unidad + "');$('#txtExistencia').val('" + Existencia + "');$('#cmbMoneda').val('" + Moneda + "');$('#txtPrecio').val('" + Precio + "');"
            End While
        Catch ex As Exception
            Retorno = -1
        End Try
        cnn.cnnInventario.Close()
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

End Class
