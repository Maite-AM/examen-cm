import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ButtonCerrarSesion extends StatelessWidget {
  final VoidCallback onLogout;

  const ButtonCerrarSesion({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 40,
      child: ElevatedButton(
        onPressed: onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fondo2,
          foregroundColor: AppColors.textoOscuro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        child: const Text('Cerrar sesión'),
      ),
    );
  }
}