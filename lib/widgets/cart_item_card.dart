import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/cart_item_model.dart';
import '../utils/currency_formatter.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final ValueChanged<bool> onToggleSelect;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onToggleSelect,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = item.stock <= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isSelected
              ? AppColors.deepRed.withValues(alpha: 0.35)
              : AppColors.greyLight.withValues(alpha: 0.8),
          width: item.isSelected ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Baris Atas: Checkbox, Foto, Info Produk, Tombol Hapus
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Checkbox Pilih Produk
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 6),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: item.isSelected,
                      activeColor: AppColors.deepRed,
                      checkColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(
                        color: AppColors.greyMuted,
                        width: 1.5,
                      ),
                      onChanged: isOutOfStock
                          ? null
                          : (val) {
                              if (val != null) {
                                onToggleSelect(val);
                              }
                            },
                    ),
                  ),
                ),

                // 2. Foto Produk
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 68,
                    height: 68,
                    color: AppColors.cream,
                    child: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildFallbackImage(),
                            loadingBuilder: (context, child, progress) {
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

                // 3. Info Nama, Kategori, Harga Satuan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.productCategory != null)
                                  Text(
                                    item.productCategory!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.terracotta,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                Text(
                                  item.productName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isOutOfStock
                                        ? AppColors.greyMuted
                                        : AppColors.charcoal,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tombol Hapus (Ikon Tong Sampah / Teks Hapus)
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 19,
                              color: AppColors.greyMuted,
                            ),
                            tooltip: 'Hapus dari Keranjang',
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDelete,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Harga Satuan
                      Text(
                        CurrencyFormatter.formatRupiah(item.unitPrice),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.charcoal,
                        ),
                      ),

                      if (isOutOfStock)
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            'Stok Habis',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepRed,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Tersedia: ${item.stock} ${item.unit}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.greyMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(
              height: 1,
              thickness: 1,
              color: AppColors.greyLight.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),

            // Baris Bawah: Subtotal Produk & Stepper Quantity [-] Qty [+]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subtotal Produk
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.greyMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      CurrencyFormatter.formatRupiah(item.subtotal),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepRed,
                      ),
                    ),
                  ],
                ),

                // Stepper [-] qty [+]
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.greyLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Tombol Minus
                      _buildQuantityButton(
                        icon: Icons.remove,
                        enabled: item.quantity > 1 && !isOutOfStock,
                        onTap: () {
                          if (item.quantity > 1) {
                            onQuantityChanged(item.quantity - 1);
                          }
                        },
                      ),

                      // Angka Quantity
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                      ),

                      // Tombol Plus
                      _buildQuantityButton(
                        icon: Icons.add,
                        enabled: item.quantity < item.stock && !isOutOfStock,
                        onTap: () {
                          if (item.quantity < item.stock) {
                            onQuantityChanged(item.quantity + 1);
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Maksimal stok tercapai: ${item.stock} ${item.unit}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: AppColors.charcoal,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Icon(
            icon,
            size: 15,
            color: enabled ? AppColors.charcoal : AppColors.greyMuted.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return const Center(
      child: Icon(
        Icons.precision_manufacturing_outlined,
        color: AppColors.darkBrown,
        size: 28,
      ),
    );
  }
}
