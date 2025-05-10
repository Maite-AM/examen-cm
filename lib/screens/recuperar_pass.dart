import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/theme/theme.dart';
import '../widgets/data_fields.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _recuperar() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido')),
      );
      return;
    }

    try {
      await AuthService().sendPasswordResetEmail(email);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo de recuperación enviado si existe una cuenta asociada.'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/recuperar-confirmacion');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar correo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        centerTitle: true,
        backgroundColor: AppColors.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingresa tu correo electrónico para recuperar tu contraseña',
              style: TextStyle(color: AppColors.textoClaro, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            CustomTextField(
              label: 'Correo',
              controller: _emailController,
              hintText: 'correo@correo.cl',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),


            Center(
              child: SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: _recuperar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
                    padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Recuperar',
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