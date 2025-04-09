import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textWhite,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textWhite),
    bodyMedium: TextStyle(color: AppColors.textGray300),
    labelLarge: TextStyle(color: AppColors.textGray400),
    titleLarge: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold),
    displaySmall: TextStyle( color: AppColors.textGray900),    
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  cardColor: AppColors.contrastBackground,
  dividerColor: Color.fromRGBO(156, 163, 175, 0.2), // RGB del #9CA3AF con opacidad del 20%
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.background, // ✅ Reemplaza background por surface
    onPrimary: AppColors.textWhite,
    onSurface: AppColors.textGray300,
  ),
);
