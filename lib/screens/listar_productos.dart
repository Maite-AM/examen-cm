import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ver_producto.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import 'editar_productos.dart';
import '/theme/theme.dart';

class ListarProductosScreen extends StatefulWidget {
  const ListarProductosScreen({super.key});

  @override
  State<ListarProductosScreen> createState() => _ListarProductosScreenState();
}

class _ListarProductosScreenState extends State<ListarProductosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productService = Provider.of<ProductService>(context, listen: false);
      productService.loadProducts();
    });
  }

  Future<void> _irAEditar([Map<String, dynamic>? producto]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarProductoScreen(producto: producto),
      ),
    );

    if (!mounted) return;

    Provider.of<ProductService>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final productos = productService.productos;

    if (productService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: AppColors.fondo,
        foregroundColor: AppColors.textoClaro,
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          final imageUrl = producto['product_image']?.toString() ?? '';

          return Card(
            color: AppColors.fondo2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: AppColors.textoOscuro),
                    )
                  : const Icon(Icons.image_not_supported, color: AppColors.textoOscuro),
              title: Text(
                producto['product_name'],
                style: const TextStyle(color: AppColors.textoOscuro),
              ),
              subtitle: Text(
                '\$${producto['product_price']}',
                style: const TextStyle(color: AppColors.textoOscuro),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerProductoScreen(
                      nombre: producto['product_name'],
                      precio: producto['product_price'].toString(),
                      imagenUrl: producto['product_image'] ?? '',
                    ),
                  ),
                );
              }
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabProductos',
        onPressed: () => _irAEditar(),
        child: const Icon(Icons.add),
      ),
    );
  }
}