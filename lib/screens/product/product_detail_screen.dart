import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive.dart';
import 'checkout_po_screen.dart';
import 'custom_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  String orderType = 'standar'; // 'standar' atau 'custom'

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: isDesktop
          ? Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: _buildContent(context),
              ),
            )
          : _buildContent(context),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (orderType == 'standar') ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {
                          setState(() => quantity++);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (orderType == 'standar') {
                        // INI YANG PENTING: Buka Form PO, BUKAN keranjang!
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPOScreen(
                              productName: 'La Marzocco Linea PB',
                              price: 185000000,
                              quantity: quantity,
                            ),
                          ),
                        );
                      } else {
                        // Buka Form Custom
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CustomProductScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      orderType == 'standar' ? 'Beli Sekarang' : 'Ajukan Custom',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.coffee_maker,
                    size: 150,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Stok Tersedia',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'La Marzocco Linea PB',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        const Text('4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(' (120)', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mesin Espresso Komersial',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rp 185.000.000',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryRed),
                ),
                const Divider(height: 32),
                const Text(
                  'Pilih Tipe Pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOrderOption(
                        type: 'standar',
                        title: 'Standar (Ready)',
                        subtitle: 'Estimasi 3 hari',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOrderOption(
                        type: 'custom',
                        title: 'Custom Order',
                        subtitle: 'Estimasi 30-45 hari',
                        icon: Icons.build_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Deskripsi Produk',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'La Marzocco Linea PB adalah mesin espresso komersial kelas atas yang dirancang untuk volume tinggi. Dengan teknologi double boiler dan sistem pre-infusi, mesin ini menjamin ekstraksi kopi yang sempurna dan konsisten untuk bisnis cafe Anda.',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Spesifikasi Teknis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildSpecRow('Tipe Mesin', 'Semi-Otomatis (2 Group)'),
                _buildSpecRow('Daya Listrik', '3200 Watt'),
                _buildSpecRow('Kapasitas Boiler', '3.5 Liter + 1.5 Liter'),
                _buildSpecRow('Material', 'Stainless Steel 304'),
                _buildSpecRow('Garansi', '1 Tahun Resmi'),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderOption({
    required String type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = orderType == type;
    return GestureDetector(
      onTap: () => setState(() => orderType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed.withValues(alpha: 0.05) : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryRed : AppColors.textSecondary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryRed : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}