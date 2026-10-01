<<<<<<< HEAD
// Test file - kosongkan dulu
void main() {}
=======
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_manufactur_dynamic_indonesia/main.dart';
import 'package:aplikasi_manufactur_dynamic_indonesia/screens/keranjang_screen.dart';

void main() {
  testWidgets('PesananScreen smoke test and tab filter verification',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify header title "Pesanan" exists
    expect(find.text('Pesanan'), findsWidgets);

    // Verify filter tabs exist
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Menunggu Pembayaran'), findsWidgets);
    expect(find.text('Diproses'), findsWidgets);
    expect(find.text('Dikirim'), findsWidgets);
    expect(find.text('Selesai'), findsWidgets);
    expect(find.text('Dibatalkan'), findsWidgets);

    // Verify bottom navigation labels exist
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Verify "Lacak Pesanan" DOES NOT exist
    expect(find.text('Lacak Pesanan'), findsNothing);

    // Tap on a filter tab and verify interaction
    await tester.tap(find.widgetWithText(InkWell, 'Diproses').first);
    await tester.pumpAndSettle();

    expect(find.text('Lihat Detail'), findsWidgets);

    // Tap "Lihat Detail" to navigate to Detail Pesanan screen
    await tester.tap(find.text('Lihat Detail').first);
    await tester.pumpAndSettle();

    // Verify Detail Pesanan screen content
    expect(find.text('Detail Pesanan'), findsOneWidget);
    expect(find.text('PRODUK'), findsOneWidget);
    expect(find.text('RINCIAN PEMBAYARAN'), findsOneWidget);
    expect(find.text('Subtotal Produk'), findsOneWidget);
    expect(find.text('Ongkos Kirim'), findsOneWidget);
    expect(find.text('Biaya Layanan & Admin'), findsOneWidget);
    expect(find.text('Total Pembayaran'), findsOneWidget);
    expect(find.text('ALAMAT PENGIRIMAN'), findsOneWidget);
    expect(find.text('METODE PEMBAYARAN'), findsOneWidget);

    // Tap back button to return
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.text('Pesanan'), findsWidgets);
  });

  testWidgets('KeranjangScreen items, quantity, selection, and summary verification',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: KeranjangScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Header "Keranjang"
    expect(find.text('Keranjang'), findsWidgets);

    // "Pilih Semua" bar
    expect(find.textContaining('Pilih Semua'), findsOneWidget);

    // Verify cart items exist
    expect(find.text('Mesin CNC Milling 3-Axis Heavy Duty'), findsOneWidget);
    expect(find.text('Mesin Bubut Precision Lathe Metal 750W'), findsOneWidget);

    // Ringkasan Belanja exists
    expect(find.text('Ringkasan Belanja'), findsOneWidget);
    expect(find.text('Total Pembayaran'), findsWidgets);

    // Checkout button exists with selected count
    expect(find.textContaining('Checkout'), findsOneWidget);

    // Tap expand Ringkasan Belanja
    await tester.tap(find.text('Ringkasan Belanja'));
    await tester.pumpAndSettle();

    // Verify 3 fee components: Subtotal, Ongkos Kirim, Biaya Layanan & Admin
    expect(find.text('Subtotal Produk'), findsOneWidget);
    expect(find.text('Ongkos Kirim'), findsOneWidget);
    expect(find.text('Biaya Layanan & Admin'), findsOneWidget);
  });
}
>>>>>>> dd1028b (agnes ngepush)
