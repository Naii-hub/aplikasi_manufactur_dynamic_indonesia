import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../screens/detail_pesanan_screen.dart';
import '../utils/currency_formatter.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    this.onActionPressed,
    this.onTap,
  });

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPesananScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyLight.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ?? () => _navigateToDetail(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Nomor Pesanan, Tanggal, dan Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.greyMuted,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OrderStatusBadge(status: order.status),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.greyLight.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 12),

                // 2. Konten Produk: Foto, Nama, Jumlah, dan Harga Satuan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail Foto Produk
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 68,
                        height: 68,
                        color: AppColors.cream,
                        child: order.imageUrl != null
                            ? Image.network(
                                order.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildFallbackImage(),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
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

                    // Detail Nama & Jumlah
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.productCategory != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                order.productCategory!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.terracotta,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          Text(
                            order.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.charcoal,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.quantity} ${order.unit}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.greyMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.formatRupiah(order.price),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.charcoal.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (order.items.length > 1) ...[
                            const SizedBox(height: 3),
                            Text(
                              '+${order.items.length - 1} produk lainnya',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.terracotta,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.greyLight.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 10),

                // 3. Footer: Total Pesanan dan Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Kolom Total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Pesanan',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.formatRupiah(order.totalPrice),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepRed,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),

                    // Tombol Aksi sesuai Status
                    _buildActionButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.cream,
      child: const Center(
        child: Icon(
          Icons.precision_manufacturing_outlined,
          color: AppColors.darkBrown,
          size: 30,
        ),
      ),
    );
  }

  /// Action Button Sesuai Revisi:
  /// - Menunggu Pembayaran: [ Bayar Sekarang ]
  /// - Diproses: [ Lihat Detail ]
  /// - Dikirim: [ Lihat Detail ]
  /// - Selesai: [ Beli Lagi ]
  /// - Dibatalkan: [ Lihat Detail ]
  Widget _buildActionButton(BuildContext context) {
    switch (order.status) {
      case OrderStatus.menungguPembayaran:
        return _buildPrimaryButton(
          text: 'Bayar Sekarang',
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else {
              _navigateToDetail(context);
            }
          },
        );

      case OrderStatus.diproses:
        return _buildPrimaryButton(
          text: 'Lihat Detail',
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else {
              _navigateToDetail(context);
            }
          },
        );

      case OrderStatus.dikirim:
        return _buildPrimaryButton(
          text: 'Lihat Detail',
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else {
              _navigateToDetail(context);
            }
          },
        );

      case OrderStatus.selesai:
        return _buildPrimaryButton(
          text: 'Beli Lagi',
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else {
              _showSnackBar(
                context,
                'Menambahkan produk "${order.productName}" ke keranjang.',
              );
            }
          },
        );

      case OrderStatus.dibatalkan:
        return _buildPrimaryButton(
          text: 'Lihat Detail',
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else {
              _navigateToDetail(context);
            }
          },
        );
    }
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 12, color: AppColors.white),
        ),
        backgroundColor: AppColors.charcoal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
