import 'package:flutter/material.dart';

class Responsive {
  // Cek apakah ini mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  // Cek apakah ini tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 && 
           MediaQuery.of(context).size.width < 1024;
  }

  // Cek apakah ini desktop/web besar
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  // Dapatkan jumlah kolom grid berdasarkan ukuran layar
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4; // Desktop
  }

  // Max width untuk container di web (agar tidak terlalu lebar)
  static double getMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity; // Mobile: full width
  }
}