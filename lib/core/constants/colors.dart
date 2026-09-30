import 'package:flutter/material.dart';

class AppColors {
  // --- Primary Palette (Hitam, Merah, Putih) ---
  static const Color primaryRed = Color(0xFFD32F2F);      // Merah elegan (tidak terlalu mencolok)
  static const Color primaryBlack = Color(0xFF121212);    // Hitam pekat modern
  static const Color primaryWhite = Color(0xFFFFFFFF);    // Putih bersih

  // --- Secondary / Background ---
  static const Color background = Color(0xFFF8F9FA);      // Putih keabuan sangat muda (lebih nyaman di mata)
  static const Color surface = Color(0xFFFFFFFF);         // Putih untuk card/kotak
  static const Color surfaceDark = Color(0xFF1E1E1E);     // Hitam untuk card gelap

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF121212);     // Teks utama (hitam)
  static const Color textSecondary = Color(0xFF757575);   // Teks deskripsi (abu-abu)
  static const Color textOnPrimary = Color(0xFFFFFFFF);   // Teks di atas background merah/hitam

  // --- Status Colors ---
  static const Color success = Color(0xFF2E7D32);         // Hijau (untuk sukses/pembayaran berhasil)
  static const Color error = Color(0xFFC62828);           // Merah tua (untuk error)
}