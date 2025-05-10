import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // IMPORTANTE

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'theme/theme.dart';

// Servicios
import 'services/product_service.dart';
import 'services/category_service.dart';
import 'services/provider_service.dart';

// Pantallas
import 'screens/sc_login.dart';
import 'screens/sc_home.dart';
import 'screens/listar_proveedores.dart';
//import 'screens/ver_proveedor.dart';
//import 'screens/editar_proveedor.dart';
import 'screens/listar_categorias.dart';
//import 'screens/ver_categoria.dart';
import 'screens/listar_productos.dart';
//import 'screens/ver_producto.dart';
import 'screens/recuperar_pass_confirmacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => ProviderService()),
      ],
      child: MaterialApp(
        title: 'Examen Flutter',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const HomeScreen(); // Usuario logueado
            } else {
              return const LoginScreen(); // Usuario no logueado
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/proveedores': (context) => const ListarProveedoresScreen(),
          '/categorias': (context) => const ListarCategoriasScreen(),
          '/productos': (context) => const ListarProductosScreen(),
          '/recuperar-confirmacion': (context) => const RecuperarConfirmacionScreen(),
        },
      ),
    );
  }
}