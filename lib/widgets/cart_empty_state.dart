import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CartEmptyState extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const CartEmptyState({
    super.key,
    this.onStartShopping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container Ikon Keranjang Kosong
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.greyLight,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 40,
                color: AppColors.terracotta,
              ),
            ),
            const SizedBox(height: 20),

            // Text Judul
            const Text(
              'Keranjang masih kosong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Text Keterangan
            const Text(
              'Belum ada produk yang ditambahkan ke keranjang.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.greyMuted,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Tombol Mulai Belanja
            SizedBox(
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepRed,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                onPressed: () {
                  if (onStartShopping != null) {
                    onStartShopping!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Membuka katalog produk industri PT Manufactur Dynamic Indonesia...',
                          style: TextStyle(fontSize: 12),
                        ),
                        backgroundColor: AppColors.charcoal,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text('Mulai Belanja'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
