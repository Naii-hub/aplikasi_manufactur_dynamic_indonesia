import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../utils/currency_formatter.dart';
import '../widgets/order_status_badge.dart';

class DetailPesananScreen extends StatelessWidget {
  final OrderModel order;

  const DetailPesananScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      // HEADER: "Detail Pesanan", Dark Brown #3A2118
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 52,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
        title: const Text(
          'Detail Pesanan',
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
            // 1. INFORMASI PESANAN
            // ==========================================
            _buildSectionCard(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      order.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.greyMuted,
                      ),
                    ),
                  ],
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
                      'Status Pesanan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.charcoal,
                      ),
                    ),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 2. PRODUK
            // ==========================================
            _buildSectionCard(
              children: [
                const Text(
                  'PRODUK',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 14),
                ...List.generate(order.items.length, (index) {
                  final item = order.items[index];
                  final isLast = index == order.items.length - 1;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Foto Produk
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 64,
                              height: 64,
                              color: AppColors.cream,
                              child: item.imageUrl != null
                                  ? Image.network(
                                      item.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildFallbackImage(),
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.deepRed,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : _buildFallbackImage(),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Rincian Produk
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.productCategory != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      item.productCategory!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.terracotta,
                                      ),
                                    ),
                                  ),
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.charcoal,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item.quantity} ${item.unit}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.greyMuted,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      CurrencyFormatter.formatRupiah(
                                          item.unitPrice),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.charcoal,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.quantity > 1) ...[
                                  const SizedBox(height: 2),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Subtotal: ${CurrencyFormatter.formatRupiah(item.subtotal)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!isLast) ...[
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          color: AppColors.greyLight.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 3. RINCIAN PEMBAYARAN
            // Hanya: Subtotal Produk, Ongkos Kirim, Biaya Layanan & Admin, Total Pembayaran
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
                const SizedBox(height: 14),
                _buildFeeRow(
                  label: 'Subtotal Produk',
                  value: CurrencyFormatter.formatRupiah(order.subtotalProducts),
                ),
                const SizedBox(height: 8),
                _buildFeeRow(
                  label: 'Ongkos Kirim',
                  value: CurrencyFormatter.formatRupiah(order.shippingFee),
                ),
                const SizedBox(height: 8),
                _buildFeeRow(
                  label: 'Biaya Layanan & Admin',
                  value: CurrencyFormatter.formatRupiah(order.adminFee),
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
                      CurrencyFormatter.formatRupiah(order.totalPayment),
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
            const SizedBox(height: 14),

            // ==========================================
            // 4. INFORMASI PENGIRIMAN
            // ==========================================
            _buildSectionCard(
              children: [
                const Text(
                  'ALAMAT PENGIRIMAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  order.recipientName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  order.recipientPhone,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  order.recipientAddress,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.charcoal,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ==========================================
            // 5. METODE PEMBAYARAN
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
                      padding: const EdgeInsets.all(6),
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
                    const SizedBox(width: 10),
                    Text(
                      order.paymentMethod,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Aksi Sesuai Status di Bagian Bawah
            _buildBottomActionButton(context),
            const SizedBox(height: 16),
          ],
        ),
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
        size: 26,
      ),
    );
  }

  Widget _buildBottomActionButton(BuildContext context) {
    if (order.status == OrderStatus.menungguPembayaran) {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepRed,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Mengarahkan ke instruksi pembayaran...',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: AppColors.charcoal,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text(
            'Bayar Sekarang',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else if (order.status == OrderStatus.selesai) {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deepRed,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Produk telah ditambahkan ke keranjang belanja.',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: AppColors.charcoal,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text(
            'Beli Lagi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
