Imports Microsoft.VisualBasic
Imports System.Configuration
Imports System.Data
Imports System
Imports MySql.Data.MySqlClient

Public Class conexion

    ' CADENA DE CONEXION
    ' Productividad
    Public StringDBMYSQL As String = "Server=localhost;Database=controlproductividad;Uid=root;Pwd=;"
    Public cnn As New MySqlConnection(StringDBMYSQL)

    ' INICIACION DE VARIABLES DE CONEXION
    Public cmd As MySqlCommand
    Public daMySql As MySqlDataAdapter
    Public dtMySql As DataTable
    Public Reader As MySqlDataReader

    ' CAPTURA EL VALOR ESPECIFICO DE UNA CONSULTA EN LA BD DE MYSQL
    Public Function getValorQuery(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnn.Close()
            cnn.Open()
            cmd = New MySqlCommand(Query, cnn)
            Dim Reader As MySqlDataReader = cmd.ExecuteReader
            If Reader.Read Then
                valor = Reader(0)
            End If
            cnn.Close()
            Return valor
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    ' EJECUTA LAS CONSULTAS DE INSERCION Y MODIFICACION EN LA BD DE MYSQL
    Public Function EjecutarInsertUpdate(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnn.Close()
            cnn.Open()
            cmd = New MySqlCommand(Query, cnn)
            Dim Hecho As Integer = cmd.ExecuteNonQuery()
            cnn.Close()
            Return Hecho
        Catch ex As Exception
            Return 0
        End Try
    End Function

    ' Inventario
    Public StringInventario As String = "Server=localhost;Database=controlinventario;Uid=root;Pwd=;"
    Public cnnInventario As New MySqlConnection(StringInventario)

    ' INICIACION DE VARIABLES DE CONEXION
    Public cmdInventario As MySqlCommand
    Public daMySqlInventario As MySqlDataAdapter
    Public dtMySqlInventario As DataTable
    Public ReaderInventario As MySqlDataReader

    ' CAPTURA EL VALOR ESPECIFICO DE UNA CONSULTA EN LA BD DE MYSQL
    Public Function getValorQueryInventario(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnInventario.Close()
            cnnInventario.Open()
            cmdInventario = New MySqlCommand(Query, cnnInventario)
            Dim ReaderInventario As MySqlDataReader = cmdInventario.ExecuteReader
            If ReaderInventario.Read Then
                valor = ReaderInventario(0)
            End If
            cnnInventario.Close()
            Return valor
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    ' EJECUTA LAS CONSULTAS DE INSERCION Y MODIFICACION EN LA BD DE MYSQL
    Public Function EjecutarInsertUpdateInventario(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnInventario.Close()
            cnnInventario.Open()
            cmdInventario = New MySqlCommand(Query, cnnInventario)
            Dim Hecho As Integer = cmdInventario.ExecuteNonQuery()
            cnnInventario.Close()
            Return Hecho
        Catch ex As Exception
            Return -1
        End Try
    End Function

    ' Seguridad
    Public StringSeguridad As String = "Server=localhost;Database=seguridad;Uid=root;Pwd=;"
    Public cnnSeguridad As New MySqlConnection(StringSeguridad)

    ' INICIACION DE VARIABLES DE CONEXION
    Public cmdSeguridad As MySqlCommand
    Public daMySqlSeguridad As MySqlDataAdapter
    Public dtMySqlSeguridad As DataTable
    Public ReaderSeguridad As MySqlDataReader

    ' CAPTURA EL VALOR ESPECIFICO DE UNA CONSULTA EN LA BD DE MYSQL
    Public Function getValorQuerySeguridad(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnSeguridad.Close()
            cnnSeguridad.Open()
            cmdSeguridad = New MySqlCommand(Query, cnnSeguridad)
            Dim ReaderSeguridad As MySqlDataReader = cmdSeguridad.ExecuteReader
            If ReaderSeguridad.Read Then
                valor = ReaderSeguridad(0)
            End If
            cnnSeguridad.Close()
            Return valor
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    ' EJECUTA LAS CONSULTAS DE INSERCION Y MODIFICACION EN LA BD DE MYSQL
    Public Function EjecutarInsertUpdateSeguridad(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnSeguridad.Close()
            cnnSeguridad.Open()
            cmdSeguridad = New MySqlCommand(Query, cnnSeguridad)
            Dim Hecho As Integer = cmdSeguridad.ExecuteNonQuery()
            cnnSeguridad.Close()
            Return Hecho
        Catch ex As Exception
            Return 0
        End Try
    End Function

    ' Jaula
    Public StringJaula As String = "Server=localhost;Database=controljaula;Uid=root;Pwd=;"
    Public cnnJaula As New MySqlConnection(StringJaula)

    ' INICIACION DE VARIABLES DE CONEXION
    Public cmdJaula As MySqlCommand
    Public daMySqlJaula As MySqlDataAdapter
    Public dtMySqlJaula As DataTable
    Public ReaderJaula As MySqlDataReader

    ' CAPTURA EL VALOR ESPECIFICO DE UNA CONSULTA EN LA BD DE MYSQL
    Public Function getValorQueryJaula(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnJaula.Close()
            cnnJaula.Open()
            cmdJaula = New MySqlCommand(Query, cnnJaula)
            Dim ReaderJaula As MySqlDataReader = cmdJaula.ExecuteReader
            If ReaderJaula.Read Then
                valor = ReaderJaula(0)
            End If
            cnnJaula.Close()
            Return valor
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    ' EJECUTA LAS CONSULTAS DE INSERCION Y MODIFICACION EN LA BD DE MYSQL
    Public Function EjecutarInsertUpdateJaula(ByVal Query As String) As String
        Try
            Dim valor As String = ""
            cnnJaula.Close()
            cnnJaula.Open()
            cmdJaula = New MySqlCommand(Query, cnnJaula)
            Dim Hecho As Integer = cmdJaula.ExecuteNonQuery()
            cnnJaula.Close()
            Return Hecho
        Catch ex As Exception
            Return 0
        End Try
    End Function

    ' LIMPIA LOS COMANDOS, DATA ADAPTER Y DATA TABLE DE LA BD DE MYSQL
    Public Sub desechar()
        cmd.Dispose()
        daMySql.Dispose()
        dtMySql.Dispose()
    End Sub

End Class
