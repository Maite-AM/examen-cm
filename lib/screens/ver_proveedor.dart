import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/provider_service.dart';
import 'editar_proveedor.dart';
import 'package:flutter_application_1/widgets/button_accion.dart';
import '/theme/theme.dart';

class VerProveedorScreen extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String correo;
  final int id;

  const VerProveedorScreen({
    super.key,
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  void _eliminarProveedor(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar a "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor:AppColors.acento),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!context.mounted || confirm != true) return;

      final providerService = Provider.of<ProviderService>(context, listen: false);

      try {
        await providerService.eliminarProveedor(id);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proveedor "$nombre" eliminado.')),
        );

        Navigator.pop(context); // vuelve al listado
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar: $e')),
            );
          }
        }

  void _editarProveedor(BuildContext context) async{
    final providerService = Provider.of<ProviderService>(context, listen: false);
    final proveedores = providerService.proveedores;

    final proveedor = proveedores.firstWhere(
      (p) => p['providerid'] == id,
      orElse: () => {},
    );

    if (proveedor.isNotEmpty) {
      final actualizado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditarProveedorScreen(proveedor: proveedor),
        ),
      );
      if (actualizado == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Proveedor actualizado correctamente!')),
          );

          await providerService.cargarProveedores(); // refresca la lista
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo encontrar el proveedor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final anchoBoton = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      backgroundColor: const Color(0xFF40788C),
      appBar: AppBar(
        title: const Text('Detalle del Proveedor'),
        centerTitle: true,
        backgroundColor: const Color(0xFF40788C),
        foregroundColor: AppColors.textoClaro,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: $nombre', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 12),
            Text('Apellido: $apellido', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 24),
            Text('Correo: $correo', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const SizedBox(height: 12),

            // Editar
            BotonAccion(
              onPressed:() => _editarProveedor(context), 
              icono: Icons.edit, 
              texto: 'Editar', 
              color: AppColors.primario,
              ancho: anchoBoton
              ),
            const SizedBox(height: 12),

            // Eliminar
            BotonAccion(
              onPressed:() => _eliminarProveedor(context),
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