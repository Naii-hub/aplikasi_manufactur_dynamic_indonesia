import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryBlack,
        surface: AppColors.surface,
      ),
      
      // --- Konfigurasi Font Global (Menggunakan Poppins agar terlihat modern) ---
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textPrimary
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20, 
          fontWeight: FontWeight.w600, 
          color: AppColors.textPrimary
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16, 
          color: AppColors.textPrimary
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14, 
          color: AppColors.textSecondary
        ),
      ),

      // --- Konfigurasi AppBar ---
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlack,
        foregroundColor: AppColors.primaryWhite,
        elevation: 0, // Hilangkan bayangan agar terlihat flat & modern
        centerTitle: true,
      ),

      // --- Konfigurasi Tombol (Elevated Button) ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut membulat modern
          ),
          elevation: 0,
        ),
      ),

      // --- Konfigurasi Input Field (TextField) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textSecondary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textSecondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 2), // Berubah merah saat diklik
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}