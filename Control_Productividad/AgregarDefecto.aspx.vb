Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Productividad_AgregarDefecto
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario

    <WebMethod(EnableSession:=True)>
    Public Shared Function busqueda(aBuscar As String) As String

        Dim HTML As String = ""
        Dim Corte As String

        Dim cnn As New Conexion
        'aBuscar = aBuscar.Trim.ToUpper.Replace(".", "")

        Corte = aBuscar.Substring(1)

        Dim SQL As String = "select * from defectos"

        If IsNumeric(Corte) Or aBuscar.Length = 1 Then
            SQL += " where defecto_codigo like '" + aBuscar + "%'"
        Else
            SQL += " where " + Condiciones(aBuscar)
        End If

        'SQL += " order by NombreAfiliado asc"

        Try
            Dim valor As String = ""

            cnn.cnn.Close()
            Dim Encontrados As Boolean = False

            cnn.cnn.Open()

            cnn.cmd = New MySqlCommand(SQL, cnn.cnn)

            Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
            While Reader.Read

                Encontrados = True
                Dim Codigo As String = Reader("defecto_codigo")
                Dim Descripcion As String = Reader("defecto_descripcion")
                HTML += "$('#tblDefectos').dataTable().fnAddData(" + _
                            "['" + Codigo + "', " + _
                             " '" + Descripcion + "' ]);"
            End While

            cnn.cnn.Close()

            If Encontrados = False Then
                HTML = "<tr><td align='center' style='width:300px; color:red;'>No se encontro a nadie con ese parametro</td></tr>"
            End If

        Catch ex As Exception

            Return ex.Message

        End Try
        ' ================================
        ' Retorno de un string 
        ' ================================

        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    Public Shared Function Condiciones(ByRef NombresJuntos As String) As String
        Dim Condicion As String = ""
        Dim Variable As String = ""
        Dim Nombre As String = NombresJuntos

        Dim i As Integer
        Dim Contador As Integer = 0

        NombresJuntos = NombresJuntos + " "

        For i = 0 To NombresJuntos.Length - 1
            If (NombresJuntos(i) = " ") Then

                If (Contador = 0) Then
                    Condicion = " defecto_descripcion like '%" + Variable + "%' "
                    Contador = Contador + 1
                    Variable = ""
                Else
                    Condicion = Condicion + " and defecto_descripcion like '%" + Variable + "%' "
                    Variable = ""
                    Contador = Contador + 1
                End If

            Else
                Variable = Variable + NombresJuntos(i)

            End If


        Next

        Return Condicion
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Agregar(Codigo As String, pUsuarioNom As String, pCantidad As String, pOperario As String) As String
        Dim cUser As New Usuario
        Dim Retorno As String = ""
        Dim cnn As New conexion
        Codigo = Codigo.Substring(0, Codigo.IndexOf(","))

        Dim SqlComprueba As String = "select count(*) from control_defectos_temporal where control_codigo_temp = '" + pUsuarioNom + "' and defecto_codigo_temp = '" + Codigo.ToString + "'"
        If cnn.getValorQuery(SqlComprueba) >= 1 Then
            'Si ya existe el registro de ese defecto
            Retorno = "2"
        Else
            'GRABAR TABLA TEMPORAL DE DEFECTOS
            Dim Sql As String = "insert into control_defectos_temporal set control_codigo_temp = '" + pUsuarioNom.ToString + "', defecto_codigo_temp = '" + Codigo.ToString + "', defecto_cantidad_temp = '" + pCantidad.ToString + "', defecto_operario_temp = '" + pOperario + "'"
            Try
                Retorno = cnn.EjecutarInsertUpdate(Sql)
            Catch ex As Exception
                Retorno = ex.Message
            End Try
        End If
        HttpContext.Current.Session("test") = Retorno
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(enablesession:=True)>
    Public Shared Function BuscarOperarios(pBusqueda As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = ""
        If pBusqueda = "" Then
            Sql = "select operario_codigo, operario_nombre, operario_apellido from operarios WHERE operario_codigo NOT LIKE '0' order by operario_codigo asc"
        Else
            Sql = "select operario_codigo, operario_nombre, operario_apellido from operarios WHERE operario_codigo NOT LIKE '0' and operario_codigo like '%" + pBusqueda + "%' order by operario_codigo asc"
        End If
        Dim Cuenta As Integer = 0
        cnn.cnn.Open()
        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
        While Reader.Read
            If Not IsDBNull(Reader("operario_codigo")) Then
                Dim Codigo As String = Reader("operario_codigo")
                Dim Nombre As String = Reader("operario_nombre")
                Dim Apellido As String = Reader("operario_apellido")
                HTML = HTML + "<option value='" + Codigo + "'>" + Codigo + " - " + Nombre + " " + Apellido + " </option>"
            End If
        End While
        cnn.cnn.Close()
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

End Class
