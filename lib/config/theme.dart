
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
static ThemeData lightTheme = ThemeData(
useMaterial3: true,
brightness: Brightness.light,
primaryColor: AppColors.primary,
scaffoldBackgroundColor: AppColors.background,
fontFamily: 'Roboto',
appBarTheme: const AppBarTheme(
elevation: 0,
backgroundColor: AppColors.surfaceWhite,
),
inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: AppColors.surfaceWhite,
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: const BorderSide(color: AppColors.borderLight, width: 1),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: const BorderSide(color: AppColors.primary, width: 2),
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(8),
borderSide: const BorderSide(color: AppColors.error, width: 1),
),
hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
labelStyle: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500),
),
elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
disabledBackgroundColor: Colors.grey[300],
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
),
outlinedButtonTheme: OutlinedButtonThemeData(
style: OutlinedButton.styleFrom(
foregroundColor: AppColors.primary,
side: const BorderSide(color: AppColors.primary, width: 2),
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
),
),
);
}
