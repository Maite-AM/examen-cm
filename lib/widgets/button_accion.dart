import 'package:flutter/material.dart';

class BotonAccion extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icono;
  final String texto;
  final Color color;
  final double ancho;

  const BotonAccion({
    super.key,
    required this.onPressed,
    required this.icono,
    required this.texto,
    required this.color,
    this.ancho = 200, 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ancho,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icono),
          label: Text(texto),
          style: ElevatedButton.styleFrom(backgroundColor: color),
        ),
      ),
    );
  }
}