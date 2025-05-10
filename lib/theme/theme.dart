import 'package:flutter/material.dart';

class AppColors {
  static const Color fondo = Color(0xFF40788C);       // Pantone 7699 XGC
  static const Color fondo2 = Color.fromARGB(255, 176, 178, 179);  
  static const Color primario = Color(0xFF642F80);    // Pantone 2623 C
  static const Color acento = Color(0xFF9E2A63);      // Pantone 8842 C
  static const Color textoClaro = Colors.white;
  static const Color textoOscuro = Colors.black;
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.fondo,
  fontFamily: 'Quicksand', // Si la estás usando
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primario,
    surface: AppColors.fondo,
    primary: AppColors.primario,
    secondary: AppColors.acento,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: AppColors.primario,
    selectionColor: AppColors.primario,
    selectionHandleColor: AppColors.primario,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.fondo2,
    labelStyle: const TextStyle(color: AppColors.textoOscuro),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primario, width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primario,
      foregroundColor: AppColors.textoClaro,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);