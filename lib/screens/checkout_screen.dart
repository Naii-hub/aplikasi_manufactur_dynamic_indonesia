import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/cart_item_model.dart';
import '../screens/pesanan_screen.dart';
import '../utils/currency_formatter.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItemModel> selectedItems;
  final VoidCallback onCheckoutSuccess;

  const CheckoutScreen({
    super.key,
    required this.selectedItems,
    required this.onCheckoutSuccess,
  });

  int get subtotalProducts =>
      selectedItems.fold(0, (sum, item) => sum + item.subtotal);

  int get shippingFee => 150000;
  int get adminFee => 25000;
  int get totalPayment => subtotalProducts + shippingFee + adminFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 52,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. ALAMAT PENGIRIMAN
            // ==========================================
            _buildSectionCard(
              children: const [
                Text(
                  'ALAMAT PENGIRIMAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Agnes Riskiyah',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '0812-9876-5432',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.greyMuted,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kawasan Industri MM2100, Blok C-12, Cikarang Barat, Bekasi, Jawa Barat 17530',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.charcoal,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 2. PRODUK YANG DIPILIH
            // ==========================================
            _buildSectionCard(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PRODUK DIPILIH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '${selectedItems.length} Produk',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.greyMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(selectedItems.length, (index) {
                  final item = selectedItems[index];
                  final isLast = index == selectedItems.length - 1;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 56,
                              height: 56,
                              color: AppColors.cream,
                              child: item.imageUrl != null
                                  ? Image.network(
                                      item.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildFallbackImage(),
                                    )
                                  : _buildFallbackImage(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.charcoal,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${item.quantity} ${item.unit} x ${CurrencyFormatter.formatRupiah(item.unitPrice)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.greyMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormatter.formatRupiah(item.subtotal),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepRed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 10),
                        Divider(
                          height: 1,
                          color: AppColors.greyLight.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 3. METODE PEMBAYARAN: HANYA Transfer Bank
            // ==========================================
            _buildSectionCard(
              children: [
                const Text(
                  'METODE PEMBAYARAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        size: 20,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Transfer Bank',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.deepRed,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 4. RINCIAN PEMBAYARAN
            // HANYA Subtotal, Ongkir, Biaya Layanan & Admin, Total
            // ==========================================
            _buildSectionCard(
              children: [
                const Text(
                  'RINCIAN PEMBAYARAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeeRow(
                  label: 'Subtotal Produk',
                  value: CurrencyFormatter.formatRupiah(subtotalProducts),
                ),
                const SizedBox(height: 8),
                _buildFeeRow(
                  label: 'Ongkos Kirim',
                  value: CurrencyFormatter.formatRupiah(shippingFee),
                ),
                const SizedBox(height: 8),
                _buildFeeRow(
                  label: 'Biaya Layanan & Admin',
                  value: CurrencyFormatter.formatRupiah(adminFee),
                ),
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.greyLight.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatRupiah(totalPayment),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepRed,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol Konfirmasi Pembayaran
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRed,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _handlePayment(context),
                child: const Text(
                  'Bayar via Transfer Bank',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.deepRed, size: 28),
            SizedBox(width: 10),
            Text(
              'Pesanan Dibuat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan Anda berhasil dibuat dan diteruskan ke sistem manufaktur PT Manufactur Dynamic Indonesia.',
              style: TextStyle(fontSize: 13, color: AppColors.charcoal, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran:',
                    style: TextStyle(fontSize: 11, color: AppColors.greyMuted),
                  ),
                  const Text(
                    'Transfer Bank',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Total Pembayaran:',
                    style: TextStyle(fontSize: 11, color: AppColors.greyMuted),
                  ),
                  Text(
                    CurrencyFormatter.formatRupiah(totalPayment),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepRed,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx); // tutup dialog
              Navigator.pop(context); // kembali dari checkout
              onCheckoutSuccess(); // hapus item terpilih dari keranjang
              // Buka halaman Pesanan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PesananScreen(),
                ),
              );
            },
            child: const Text('Lihat Pesanan Saya'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyLight.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildFeeRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.greyMuted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage() {
    return const Center(
      child: Icon(
        Icons.precision_manufacturing_outlined,
        color: AppColors.darkBrown,
        size: 24,
      ),
    );
  }
}
