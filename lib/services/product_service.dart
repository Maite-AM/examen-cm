import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final String _baseUrl = '143.198.118.203:8100';
  final String _user = 'test';
  final String _pass = 'test2023';

  List<Map<String, dynamic>> _productos = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get productos => _productos;
  bool get isLoading => _isLoading;

  String get _authHeader =>
      'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

  ProductService() {
    Future.delayed(Duration.zero, () => loadProducts());
  }

Future<void> loadProducts() async {
  _isLoading = true;
  notifyListeners();

  try {
    final url = Uri.parse('http://$_baseUrl/ejemplos/product_list_rest/');
    final resp = await http.get(url, headers: {
      'authorization': _authHeader,
    });

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      final listado = decoded['Listado'];

      if (listado != null && listado is List) {
        _productos = List<Map<String, dynamic>>.from(listado);
      } else {
        debugPrint('Formato inesperado en "Listado": $listado');
        _productos = [];
      }
    } else {
      debugPrint('Error HTTP ${resp.statusCode}: ${resp.body}');
      _productos = [];
    }
  } catch (e) {
    debugPrint('Excepción en loadProducts: $e');
    _productos = [];
  }

  _isLoading = false;
  notifyListeners();
}


  Future<void> addProduct(Map<String, dynamic> nuevoProducto) async {
  final url = Uri.parse('http://$_baseUrl/ejemplos/product_add_rest/');
  final response = await http.post(
    url,
    headers: {
      'authorization': _authHeader,
      'Content-Type': 'application/json',
    },
    body: jsonEncode(nuevoProducto),
  );

  if (response.statusCode == 200) {
    await loadProducts();
  } else {
    debugPrint('Error en addProduct: ${response.statusCode} - ${response.body}');
    throw Exception('Error al agregar producto');
  }
}


Future<void> editProduct(Map<String, dynamic> productoEditado) async {
  final url = Uri.parse('http://$_baseUrl/ejemplos/product_edit_rest/');
  final response = await http.post(
    url,
    headers: {
      'authorization': _authHeader,
      'Content-Type': 'application/json',
    },
    body: jsonEncode(productoEditado),
  );

  if (response.statusCode == 200) {
    await loadProducts();
  } else {
    debugPrint('Error en editProduct: ${response.statusCode} - ${response.body}');
    throw Exception('Error al editar producto');
  }
}

  Future<void> deleteProduct(int idProducto) async {
    final url = Uri.parse('http://$_baseUrl/ejemplos/product_del_rest/');
    final response = await http.post(
      url,
      headers: {
        'authorization': _authHeader,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'product_id': idProducto}),
    );

    debugPrint('Respuesta DELETE producto: ${response.statusCode}');
    debugPrint('Cuerpo: ${response.body}');

    await loadProducts();
  }
}