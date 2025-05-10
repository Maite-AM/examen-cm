import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import '../theme/theme.dart';
import '../widgets/data_fields.dart';

class EditarProveedorScreen extends StatefulWidget {
  final Map<String, dynamic>? proveedor;

  const EditarProveedorScreen({super.key, this.proveedor});

  @override
  State<EditarProveedorScreen> createState() => _EditarProveedorScreenState();
}

class _EditarProveedorScreenState extends State<EditarProveedorScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _correoController;

  @override
  void initState() {
    super.initState();
    final p = widget.proveedor;
    _nombreController = TextEditingController(text: p?['provider_name'] ?? '');
    _apellidoController = TextEditingController(text: p?['provider_last_name'] ?? '');
    _correoController = TextEditingController(text: p?['provider_mail'] ?? '');
  }

  bool _esCorreoValido(String correo) {
    final correoRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return correoRegExp.hasMatch(correo);
  }


  void _guardar() async {
  try {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final correo = _correoController.text.trim();

    if (nombre.isEmpty || apellido.isEmpty || correo.isEmpty || !_esCorreoValido(correo)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos válidamente.')),
      );
      return;
    }

    final providerService = Provider.of<ProviderService>(context, listen: false);
    final data = {
      'provider_name': nombre,
      'provider_last_name': apellido,
      'provider_mail': correo,
      'provider_state': 'Activo',
    };

    if (widget.proveedor == null || widget.proveedor!['providerid'] == null) {
      await providerService.agregarProveedor(data);
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      data['provider_id'] = widget.proveedor!['providerid'].toString();
      await providerService.editarProveedor(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Proveedor actualizado exitosamente!')),
      );
      Navigator.pop(context, true);
    }
  } catch (e, stackTrace) {
    if (!mounted) return;
    debugPrint('ERROR al guardar proveedor: $e\n$stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el proveedor: $e')),
    );
  }
}

  

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.proveedor != null;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Proveedor' : 'Agregar Proveedor'),
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
              hintText: 'Ej. Juan',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Apellido',
              controller: _apellidoController,
              hintText: 'Ej. Pérez',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Correo',
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'correo@correo.cl',
            ),
            const SizedBox(height: 24),

            Center(
              child: SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
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
              