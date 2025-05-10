import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import 'editar_categoria.dart';
import 'package:flutter_application_1/widgets/button_accion.dart';
import '/theme/theme.dart';

class VerCategoriaScreen extends StatelessWidget {
  final String nombre;

  const VerCategoriaScreen({
    super.key,
    required this.nombre,
  });

  void _eliminarCategoria(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar la categoría "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (confirm == true) {
      final categoryService = Provider.of<CategoryService>(context, listen: false);
      final categorias = categoryService.categorias;

      final categoria = categorias.firstWhere(
        (c) => c['category_name'] == nombre,
        orElse: () => {},
      );

      if (!context.mounted) return;

      if (categoria.isEmpty || !categoria.containsKey('category_id')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo encontrar la categoría.')),
        );
        return;
      }

      final id = categoria['category_id'];
      await categoryService.eliminarCategoria(id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría "$nombre" eliminada.')),
      );

      Navigator.pop(context);

    }
  }

  void _editarCategoria(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context, listen: false);
    final categorias = categoryService.categorias;

    final categoria = categorias.firstWhere(
      (c) => c['category_name'] == nombre,
      orElse: () => {},
    );

    if (categoria.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditarCategoriaScreen(categoria: categoria),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar la categoría.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anchoBoton = MediaQuery.of(context).size.width * 0.5;
    
    return Scaffold(
      backgroundColor: const Color(0xFF40788C),
      appBar: AppBar(
        title: const Text('Detalle de Categoría',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor:AppColors.fondo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: $nombre', style: const TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 24),

            // Editar
            BotonAccion(
              onPressed:() => _editarCategoria(context),
              icono: Icons.edit, 
              texto: 'Editar', 
              color: AppColors.primario,
              ancho: anchoBoton
              ),
            const SizedBox(height: 12),

            // Eliminar
            BotonAccion(
              onPressed:() => _eliminarCategoria(context),
              icono: Icons.delete, 
              texto: 'Eliminar', 
              color: AppColors.acento,
              ancho: anchoBoton
              ),
            const SizedBox(height: 12),

            // Volver
            BotonAccion(
              onPressed:() =>  Navigator.pop(context),
              icono: Icons.undo, 
              texto: 'Volver', 
              color: AppColors.fondo2,
              ancho: anchoBoton
            ),
          ],
        ),
      ),
    );
  }
}