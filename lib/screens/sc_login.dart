import 'package:flutter/material.dart';
//import '/screens/sc_home.dart';
import '/services/auth_service.dart';
import 'package:flutter_application_1/screens/sc_register.dart';
import 'recuperar_pass.dart';
//import '/sc_register.dart';
import '/theme/theme.dart';
import '/widgets/data_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool validarEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (email.isEmpty || password.isEmpty) {
      if (email.isEmpty) _emailError = 'El correo es obligatorio';
      if (password.isEmpty) _passwordError = 'La contraseña es obligatoria';
      setState(() {});
      return;
  }

  if (!validarEmail(email)) {
      setState(() {
        _emailError = 'Formato de correo no válido';
      });
      return;
  }

  final authService = AuthService();
  final user = await authService.signInWithEmail(email, password);

  if (!mounted) return; 

  if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales inválidas o error de inicio de sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),


            CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hintText: 'correo@correo.cl',
              keyboardType: TextInputType.emailAddress,
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_emailError!, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _passwordController,
              label: 'Contraseña',
              hintText: 'contraseña',
              obscureText: true,
            ),
            if (_passwordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_passwordError!, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primario,
              ),
              child: const Text(
                'Ingresar',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textoClaro,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(color: AppColors.textoClaro),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RecuperarPasswordScreen()),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: AppColors.textoClaro),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




