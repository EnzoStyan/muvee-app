import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData muveeTheme = ThemeData(
  // Base Color
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.primaryDark,

  // Color Scheme
  colorScheme: const ColorScheme.dark(
      primary: AppColors.accentYellow,
      background: AppColors.primaryDark,
      surface: AppColors.bgGray,
  ),

  // Text Style
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textWhite,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textWhite,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textLight,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textLight,
    )
  ).apply(
    bodyColor: AppColors.textWhite,
    displayColor: AppColors.textWhite,
  ),

  // AppBar Style
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.textWhite,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Bottom Navbar Style
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.bgGray,
    selectedItemColor: AppColors.accentYellow,
    unselectedItemColor: AppColors.textLight,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  //Button Style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentYellow,
      foregroundColor: AppColors.primaryDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5.0)),
    ),
  ),
);