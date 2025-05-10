import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import 'ver_categoria.dart';
import 'editar_categoria.dart';
import '/theme/theme.dart';

class ListarCategoriasScreen extends StatelessWidget {
  const ListarCategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);

    if (categoryService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categorias = categoryService.categorias;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: AppColors.fondo,
        foregroundColor: AppColors.textoClaro,
      ),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final nombre = categoria['category_name'] ?? 'Sin nombre';

          return Card(
            color: AppColors.fondo2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.category, color: AppColors.textoOscuro),
              title: Text(
                nombre,
                style: const TextStyle(color: AppColors.textoOscuro),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerCategoriaScreen(nombre: nombre),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabCategorias',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditarCategoriaScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}