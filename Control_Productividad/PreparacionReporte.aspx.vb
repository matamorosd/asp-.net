Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Partial Class Control_Productividad_PreparacionReporte
    Inherits System.Web.UI.Page

    Public cnn As New conexion
    Public cUser As New Usuario
    Public Shared Suma As Decimal

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        cUser = Session("glbUser")
    End Sub

    <WebMethod(EnableSession:=True)>
    Public Shared Function BuscarPieza(Proyecto As String, Accion As String) As String
        Dim HTML As String = ""
        Dim cnn As New conexion
        Dim Sql As String = ""
        If Accion = 1 Then
            Sql = "select p.pieza_codigo, p.pieza_nombre from piezas as p join piezas_proyectos as pp join proyectos as pr where p.pieza_codigo = pp.pieza_codigo and pp.proyecto_codigo = pr.proyecto_codigo and pp.proyecto_codigo = " + Proyecto
        ElseIf Accion = 0 Then
            Sql = "select pieza_codigo, pieza_nombre from piezas"
        End If
        Dim Cuenta As Integer = 0
        cnn.cnn.Open()
        cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
        Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
        While Reader.Read
            If Not IsDBNull(Reader("pieza_nombre")) Then
                Dim Codigo As String = Reader("pieza_codigo")
                Dim Descripcion As String = Reader("pieza_nombre")
                If Cuenta = 0 Then
                    HTML = HTML + "<option selected='selected' value='" + Codigo + "'>" + Descripcion + "</option>"
                Else
                    HTML = HTML + "<option value='" + Codigo + "'>" + Descripcion + "</option>"
                End If
                Cuenta += 1
            End If
        End While
        cnn.cnn.Close()
        ' ================================
        ' Retorno de un string 
        ' ================================
        HttpContext.Current.Session("test") = HTML
        Return HttpContext.Current.Session("test").ToString()
    End Function

    <WebMethod(EnableSession:=True)>
    Public Shared Function Generar(pCondiciones As String) As String
        Dim cnn As New conexion
        Dim HTML As String = ""
        Dim Suma As Decimal = 0
        Dim Sql As String = "select c.control_codigo, c.control_fecha, c.control_serie, t.turno_nombre, pr.proyecto_nombre, pi.pieza_nombre, e.enchape_descripcion, c.control_usuario, c.control_comentario, c.control_piezasrevisadas, c.control_piezasmalas, c.control_productividad from control as c join proyectos as pr join piezas as pi join turnos as t join enchapes as e where c.control_turno = t.turno_codigo and c.control_proyecto = pr.proyecto_codigo and c.control_pieza = pi.pieza_codigo and c.control_enchape = e.enchape_codigo" + pCondiciones + " order by c.control_fecha asc"
        Try
            Dim valor As String = ""
            cnn.cnn.Close()
            Dim Encontrados As Boolean = False
            cnn.cnn.Open()
            cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
            Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
            While Reader.Read
                Encontrados = True
                Dim Codigo As String = Reader("control_codigo")
                Dim Fecha As String = Reader("control_fecha")
                Dim Serie As String = Reader("control_serie")
                Dim Turno As String = Reader("turno_nombre")
                Dim Proyecto As String = Reader("proyecto_nombre")
                Dim Pieza As String = Reader("pieza_nombre")
                Dim Enchape As String = Reader("enchape_descripcion")
                Dim CodUsuario As String = Reader("control_usuario")
                Dim Comentario As String = Reader("control_comentario")
                Dim TotalP As String = Reader("control_piezasrevisadas")
                Dim TotalM As String = Reader("control_piezasmalas")
                Dim Productividad As String = Reader("control_productividad")
                Suma += System.Convert.ToDecimal(Productividad)
                'Dim Ordenado As String = Orden(Fecha)
                Dim Usuario As String = CargarNombre(CodUsuario)

                HTML += "$('#tblReporte').dataTable().fnAddData(" + _
                            "['" + Replace(Fecha.ToString, ".", "/") + "', " + _
                            "'" + Serie + "', " + _
                            "'" + Turno + "', " + _
                            "'" + Proyecto + "', " + _
                            "'" + Pieza + "', " + _
                            "'" + Enchape + "', " + _
                            "'" + Usuario + "', " + _
                            "'" + Comentario + "', " + _
                            "'" + TotalP + "', " + _
                            "'" + TotalM + "', " + _
                            "'" + Replace(Productividad.ToString, ",", ".") + " %', " + _
                            " '<a onclick=""VerGrafica(" + Codigo + ")""><span>Ver <img src=""../img/icons/ver.jpg""></span></a>' ]);"
            End While
            'MsgBox(Suma)
            'Dim SqlSum As String = "select sum(control_productividad) as total from control as c join proyectos as pr join piezas as pi join turnos as t join usuarios as u join enchapes as e where c.control_turno = t.turno_codigo and c.control_proyecto = pr.proyecto_codigo and c.control_pieza = pi.pieza_codigo and c.control_enchape = e.enchape_codigo and c.control_usuario = u.usuario_codigo" + pCondiciones
            'Dim ProductividadTotal As Decimal = cnn.getValorQuery(SqlSum)
            cnn.cnn.Close()
            'HTML += " $('#lblProductividadTotal').text('" + Replace(ProductividadTotal.ToString, ",", ".") + " %');"
            HTML += " $('#lblProductividadTotal').text('" + Replace(Suma.ToString, ",", ".") + " %');"
            If Encontrados = False Then
                HTML = "<tr align='center' style='width:300px; color:red;'>No se encontro ningun registro con estos parametros</tr>"
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

    Public Shared Function Orden(Fecha As String) As String
        Dim Año As String = Fecha.Substring(6, 4)
        Dim Mes As String = Fecha.Substring(3, 2)
        Dim Dia As String = Fecha.Substring(0, 2)
        Return Año + Mes + Dia
    End Function

    Public Shared Function CargarNombre(Codigo As String) As String
        Dim cnn As New conexion
        Dim valor As String = cnn.getValorQuerySeguridad("select usuario_usuario from usuarios where usuario_codigo = '" + Codigo + "'")
        Return valor
    End Function


    <WebMethod(EnableSession:=True)>
    Public Shared Function CargarGrafica(pCodigo As String, pUsuarioNom As String) As String
        Dim cnn As New conexion
        Dim HTML As String = "1"
        'Dim SqlComprueba = "SELECT count(*) FROM CONTROL_defectos as cd join control as c where cd.control_codigo = c.control_codigo and c.control_serie = '" + pSerie + "' group by cd.defecto_codigo"
        Dim SqlLimpia As String = "delete from control_grafica where grafica_codigo = '" + pUsuarioNom + "'"
        Dim Sql As String = "SELECT cd.defecto_codigo, d.defecto_descripcion, cd.defecto_cantidad FROM CONTROL_defectos as cd join defectos as d join control as c where cd.defecto_codigo = d.defecto_codigo and cd.control_codigo = c.control_codigo and c.control_codigo = '" + pCodigo + "' group by cd.defecto_codigo"
        Try
            Dim valor As String = ""
            cnn.EjecutarInsertUpdate(SqlLimpia)
            Dim Encontrados As Boolean = False
            cnn.cnn.Close()
            cnn.cnn.Open()
            cnn.cmd = New MySqlCommand(Sql, cnn.cnn)
            Dim Reader As MySqlDataReader = cnn.cmd.ExecuteReader
            While Reader.Read
                Encontrados = True
                Dim Codigo As String = Reader("defecto_codigo")
                Dim Descripcion As String = Reader("defecto_descripcion")
                Dim Cantidad As String = Reader("defecto_cantidad")
                InsertaDatos(pUsuarioNom, Descripcion, Cantidad)
            End While
            cnn.cnn.Close()
            If Encontrados = False Then
                HTML = "0"
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

    Public Shared Function InsertaDatos(Usuario As String, Descripcion As String, Cantidad As String) As String
        Dim Valor As String = ""
        Dim Sql As String = "insert into control_grafica set grafica_codigo = '" + Usuario + "', grafica_defecto_descripcion = '" + Descripcion + "', grafica_defecto_cantidad = '" + Cantidad + "'"
        Dim cnn As New conexion
        Try
            Valor = cnn.EjecutarInsertUpdate(Sql)
        Catch ex As Exception
            Valor = ex.Message
        End Try
        Return Valor
    End Function


End Class
