import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/product_service.dart';
import '../theme/theme.dart';
import '../widgets/data_fields.dart';

class EditarProductoScreen extends StatefulWidget {
  final Map<String, dynamic>? producto;

  const EditarProductoScreen({super.key, this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _imagenController;

  @override
  void initState() {
    super.initState();
    final producto = widget.producto;
    _nombreController = TextEditingController(text: producto?['product_name'] ?? '');
    _precioController = TextEditingController(text: producto?['product_price']?.toString() ?? '');
    _imagenController = TextEditingController(text: producto?['product_image'] ?? '');
  }

  bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath && (uri.isScheme("http") || uri.isScheme("https"));
  }

  void _guardar() async {
    try {
      final nombre = _nombreController.text.trim();
      final precio = double.tryParse(_precioController.text.trim());
      final imagen = _imagenController.text.trim();

      if (nombre.isEmpty || precio == null || precio <= 0 || !isValidUrl(imagen)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos válidamente.')),
        );
        return;
      }

      final producto = {
        'product_name': nombre,
        'product_price': precio,
        'product_image': imagen,
        'product_state': 'Activo',
      };

      final productService = Provider.of<ProductService>(context, listen: false);

      if (widget.producto == null || widget.producto!['product_id'] == null || widget.producto!['product_id'] == 0) {
        await productService.addProduct(producto);
      } else {
        producto['product_id'] = widget.producto!['product_id'];
        await productService.editProduct(producto);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e, stackTrace) {
      if (!mounted) return;
      debugPrint('ERROR al guardar producto: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.producto != null;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Producto' : 'Agregar Producto'),
        centerTitle: true,
        backgroundColor:AppColors.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nombre',
              controller: _nombreController,
              hintText: 'Ej. Computador',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Precio',
              controller: _precioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: 'Ej. 10000',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'URL de Imagen',
              controller: _imagenController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: 'https://www.imagen.cl',
            ),
            const SizedBox(height: 24),

            Center(
              child: SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF642F80),
                    padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontWeight: FontWeight.bold),
                 ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}