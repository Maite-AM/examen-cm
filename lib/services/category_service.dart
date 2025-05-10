import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryService extends ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  List<Map<String, dynamic>> _categorias = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get categorias => _categorias;
  bool get isLoading => _isLoading;

  String get _authHeader =>
      'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

  CategoryService() {
    Future.delayed(Duration.zero, () => cargarCategorias());
  }

  Future<void> cargarCategorias() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('http://$_baseUrl/ejemplos/category_list_rest/');
      final resp = await http.get(url, headers: {
        'authorization': _authHeader,
      });

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        final listado = decoded['Listado Categorias'];

        if (listado != null && listado is List) {
          _categorias = List<Map<String, dynamic>>.from(listado);
        } else {
          debugPrint('Formato inesperado en "Listado": $listado');
          _categorias = [];
        }
      } else {
        debugPrint('Error HTTP ${resp.statusCode}: ${resp.body}');
        _categorias = [];
      }
    } catch (e) {
      debugPrint('Excepción en cargarCategorias: $e');
      _categorias = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> agregarCategoria(Map<String, dynamic> nueva) async {
    try {
      final url = Uri.parse('http://$_baseUrl/ejemplos/category_add_rest/');
      final resp = await http.post(
        url,
        headers: {
          'authorization': _authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(nueva),
      );

      if (resp.statusCode != 200) {
        debugPrint('Error al agregar categoría: ${resp.body}');
      }

    } catch (e) {
      debugPrint('Excepción en agregarCategoria: $e');
    }

    await cargarCategorias();
  }

  Future<void> editarCategoria(Map<String, dynamic> editada) async {
    try {
      final url = Uri.parse('http://$_baseUrl/ejemplos/category_edit_rest/');
      final resp = await http.post(
        url,
        headers: {
          'authorization': _authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(editada),
      );

      if (resp.statusCode != 200) {
        debugPrint('Error al editar categoría: ${resp.body}');
      }

    } catch (e) {
      debugPrint('Excepción en editarCategoria: $e');
    }

    await cargarCategorias();
  }

  Future<void> eliminarCategoria(int id) async {
    try {
      final url = Uri.parse('http://$_baseUrl/ejemplos/category_del_rest/');
      final resp = await http.post(
        url,
        headers: {
          'authorization': _authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'category_id': id}),
      );

      if (resp.statusCode != 200) {
        debugPrint('Error al eliminar categoría: ${resp.body}');
      }

    } catch (e) {
      debugPrint('Excepción en eliminarCategoria: $e');
    }

    await cargarCategorias();
  }
}