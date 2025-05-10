import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_service.dart';
import '../theme/theme.dart';
import '../widgets/data_fields.dart';

class EditarCategoriaScreen extends StatefulWidget {
  final Map<String, dynamic>? categoria;

  const EditarCategoriaScreen({super.key, this.categoria});

  @override
  State<EditarCategoriaScreen> createState() => _EditarCategoriaScreenState();
}

class _EditarCategoriaScreenState extends State<EditarCategoriaScreen> {
  late TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.categoria?['category_name'] ?? '',
    );
  }

  void _guardar() async {
    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }

    final categoryService = Provider.of<CategoryService>(context, listen: false);

    if (widget.categoria == null || widget.categoria!['category_id'] == null) {
      // Agregar
      await categoryService.agregarCategoria({
        'category_name': nombre,
        'category_state': 'Activa',
      });
    } else {
      // Editar
      final id = widget.categoria!['category_id'];
      await categoryService.editarCategoria({
        'category_id': id,
        'category_name': nombre,
        'category_state': 'Activa',
      });
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoria != null;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Categoría' : 'Agregar Categoría'),
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
              label: 'Nombre de la categoría',
              controller: _nombreController,
              hintText: 'Ej. Electrónica',
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