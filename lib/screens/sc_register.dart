import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/theme/theme.dart';
import '../widgets/data_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  bool validarEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool validarPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }

  void _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirm = _confirmController.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
    });

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError('Completa todos los campos');
      return;
    }

    if (!validarEmail(email)) {
      setState(() {
        _emailError = 'Correo electrónico no válido';
      });
      return;
    }

    if (!validarPassword(password)) {
      setState(() {
        _passwordError =
            'La contraseña debe tener al menos 8 caracteres, una mayúscula y un número';
      });
      return;
    } 
    
    if (password != confirm) {
      setState(() {
        _confirmError = 'Las contraseñas no coinciden';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pop(context); // Vuelve al login
    } catch (e) {
      _showError('Error al registrar: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
        backgroundColor: AppColors.fondo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Correo electrónico',
              controller: _emailController,
              hintText: 'correo@correo.cl',
              keyboardType: TextInputType.emailAddress,
            ),

            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Contraseña',
              controller: _passwordController,
              hintText: '********',
              obscureText: true,
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _passwordError!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Confirmar contraseña',
              controller: _confirmController,
              hintText: '********',
              obscureText: true,
            ),
            if (_confirmError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _confirmError!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            Center(
              child: SizedBox(
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primario,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Registrarse',
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

    