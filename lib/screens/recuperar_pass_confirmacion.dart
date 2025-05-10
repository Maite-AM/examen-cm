import 'package:flutter/material.dart';
import '/theme/theme.dart';

class RecuperarConfirmacionScreen extends StatelessWidget {
  const RecuperarConfirmacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text(
          'Recuperación enviada',
          style: TextStyle(color: AppColors.textoClaro),
        ),
        centerTitle: true,
        backgroundColor: AppColors.fondo,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.greenAccent),
              const SizedBox(height: 24),
              const Text(
                'Revisa tu correo electrónico',
                style: TextStyle(color: AppColors.textoClaro, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Si el correo ingresado existe, te enviaremos instrucciones para restablecer tu contraseña.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/login'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primario,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Volver al login',
                  style: TextStyle(
                    color: AppColors.textoClaro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}