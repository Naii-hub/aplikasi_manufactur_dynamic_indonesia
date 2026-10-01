class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format angka integer ke format mata uang Rupiah standar
  /// Contoh: 25000000 -> "Rp25.000.000"
  static String formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join('')}';
  }
}
