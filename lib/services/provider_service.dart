import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Map<String, dynamic>> _proveedores = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get proveedores => _proveedores;
  bool get isLoading => _isLoading;

  String get _authHeader =>
      'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

  ProviderService() {
    Future.delayed(Duration.zero, () => cargarProveedores());
  }

  Future<void> cargarProveedores() async {
  _isLoading = true;
  notifyListeners();

  try {
    final url = Uri.parse('http://$_baseUrl/ejemplos/provider_list_rest/');
    final resp = await http.get(url, headers: {
      'authorization': _authHeader,
    });

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      final listado = decoded['Proveedores Listado'];

      if (listado != null && listado is List) {
        _proveedores = List<Map<String, dynamic>>.from(listado);
      } else {
        debugPrint('Formato inesperado en "Listado": $listado');
        _proveedores = [];
      }
    } else {
      debugPrint('Error HTTP ${resp.statusCode}: ${resp.body}');
      _proveedores = [];
    }
  } catch (e) {
    debugPrint('Excepción en cargarProveedores: $e');
    _proveedores = [];
  }

  _isLoading = false;
  notifyListeners();
}

  Future<void> agregarProveedor(Map<String, dynamic> nuevo) async {
    final url = Uri.parse('http://$_baseUrl/ejemplos/provider_add_rest/');
    await http.post(
      url,
      headers: {
        'authorization': _authHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(nuevo),
    );
    await cargarProveedores();
  }

  Future<void> editarProveedor(Map<String, dynamic> editado) async {
    final url = Uri.parse('http://$_baseUrl/ejemplos/provider_edit_rest/');
    final resp = await http.post(
      url,
      headers: {
        'authorization': _authHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(editado),
    );

    debugPrint('RESPUESTA EDITAR: ${resp.statusCode} - ${resp.body}');

    if (resp.statusCode != 200) {
      throw Exception('Error al editar proveedor: ${resp.body}');
    }

    await cargarProveedores();
  }

  Future<void> eliminarProveedor(int id) async {
    final url = Uri.parse('http://$_baseUrl/ejemplos/provider_del_rest/');
    final response = await http.post(
      url,
      headers: {
        'authorization': _authHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'provider_id': id.toString()}),
    );

    if (response.statusCode == 200) {
    await cargarProveedores();
  } else {
    debugPrint('Error al eliminar proveedor: ${response.statusCode} - ${response.body}');
    throw Exception('Error al eliminar proveedor');
  }
}}