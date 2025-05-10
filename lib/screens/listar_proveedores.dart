import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import 'ver_proveedor.dart';
import 'editar_proveedor.dart';
import '/theme/theme.dart';

class ListarProveedoresScreen extends StatefulWidget {
  const ListarProveedoresScreen({super.key});

  @override
  State<ListarProveedoresScreen> createState() => _ListarProveedoresScreenState();
}

class _ListarProveedoresScreenState extends State<ListarProveedoresScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      Provider.of<ProviderService>(context, listen: false).cargarProveedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context);

    if (providerService.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final proveedores = providerService.proveedores;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Proveedores'),
        backgroundColor: AppColors.fondo,
        foregroundColor: AppColors.textoClaro,
      ),
       body: ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) {
          final p = proveedores[index];
          final nombre = p['provider_name'] ?? 'Sin nombre';
          final apellido = p['provider_last_name'] ?? '';
          final correo = p['provider_mail'] ?? 'Sin correo';

          return Card(
            color: AppColors.fondo2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person, color: AppColors.textoOscuro),
              title: Text(
                '$nombre $apellido',
                style: const TextStyle(color: AppColors.textoOscuro),
              ),
              subtitle: Text(
                correo,
                style: const TextStyle(color: AppColors.textoOscuro),
              ),
              onTap: () {
                final id = p['providerid'];
  
                // Validación para evitar errores de tipo 'Null' is not a subtype of 'int'
                if (id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proveedor sin ID válido')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerProveedorScreen(
                      id: id,
                      nombre: nombre,
                      apellido: apellido,
                      correo: correo,
                    ),
                  ),
                );
              }
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabProveedores',
        backgroundColor: AppColors.primario,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditarProveedorScreen(),
            ),
          );

          if (!context.mounted) return;

          await Provider.of<ProviderService>(context, listen: false).cargarProveedores();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}