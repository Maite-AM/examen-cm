import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import 'editar_productos.dart';
import 'package:flutter_application_1/widgets/button_accion.dart';
import '/theme/theme.dart';

class VerProductoScreen extends StatelessWidget {
  final String nombre;
  final String precio;
  final String imagenUrl;

  const VerProductoScreen({
    super.key,
    required this.nombre,
    required this.precio,
    required this.imagenUrl,
  });

  void _eliminarProducto(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar el producto "$nombre"?'),
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
      final productService = Provider.of<ProductService>(context, listen: false);

      final productos = productService.productos;
      final producto = productos.firstWhere(
        (p) =>
            p['product_name'] == nombre &&
            p['product_price'].toString() == precio,
        orElse: () => {},
      );


      if (!context.mounted) return;

      if (producto.isEmpty || !producto.containsKey('product_id')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo encontrar el producto.')),
        );
        return;
      }

      final id = producto['product_id'];
      await productService.deleteProduct(id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto "$nombre" eliminado.')),
      );

      Navigator.pop(context);
    }
  }

  void _editarProducto(BuildContext context) {
    final productService = Provider.of<ProductService>(context, listen: false);
    final productos = productService.productos;

    final producto = productos.firstWhere(
      (p) =>
          p['product_name'] == nombre &&
          p['product_price'].toString() == precio,
      orElse: () => {},
    );

    if (producto.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditarProductoScreen(producto: producto),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar el producto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anchoBoton = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text(
          'Detalle del Producto',
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
            if (imagenUrl.isNotEmpty)
              Center(
                child: Image.network(
                  imagenUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100, color: Colors.white70),
                ),
              ),
            const SizedBox(height: 20),
            Text('Nombre: $nombre',
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 12),
            Text('Precio: \$$precio',
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 24),

            // Editar
            BotonAccion(
              onPressed:() => _editarProducto(context), 
              icono: Icons.edit, 
              texto: 'Editar', 
              color: AppColors.primario,
              ancho: anchoBoton
              ),
            const SizedBox(height: 12),

            // Eliminar
            BotonAccion(
              onPressed:() => _eliminarProducto(context),
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