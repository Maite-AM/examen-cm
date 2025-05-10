import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, String module) {
    switch (module) {
      case 'Proveedores':
        Navigator.pushNamed(context, '/proveedores');
        break;
      case 'Categorías':
        Navigator.pushNamed(context, '/categorias');
        break;
      case 'Productos':
        Navigator.pushNamed(context, '/productos');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Módulo "$module" aún no disponible')),
        );
    }
  }

  void _cerrarSesion(BuildContext context) {

  final navigator = Navigator.of(context);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar cierre de sesión'),
      content: const Text('¿Estás segura/o que deseas cerrar la sesión?'),
      actions: [
        TextButton(
          onPressed: () => navigator.pop(), // Usa el navigator guardado
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            navigator.pop(); // Cierra el diálogo
            await AuthService().signOut(); // Cierra sesión
            navigator.pushReplacementNamed('/login'); // Redirige
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.acento),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(color: AppColors.textoClaro)),
        backgroundColor: AppColors.fondo,
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _navigateTo(context, 'Proveedores'),
                                  child: const Text('Proveedores'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _navigateTo(context, 'Categorías'),
                                  child: const Text('Categorías'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _navigateTo(context, 'Productos'),
                                  child: const Text('Productos'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: SizedBox(
                          width: 150,
                          height: 40,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.fondo2,
                              foregroundColor: AppColors.textoOscuro,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _cerrarSesion(context),
                            child: const Text('Cerrar sesión'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}