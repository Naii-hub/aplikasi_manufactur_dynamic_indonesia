import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/responsive.dart';
import '../auth/login_screen.dart';
import '../product/product_detail_screen.dart';
import '../order/order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.coffee_maker, color: AppColors.primaryWhite, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'CoffeeStore',
              style: TextStyle(
                color: AppColors.primaryWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryWhite),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primaryWhite),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Search Bar (Full Width) ---
            Container(
              width: double.infinity,
              color: AppColors.primaryWhite,
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari mesin kopi impianmu...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- Banner Promo (Full Width) ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Container(
                    height: isMobile ? 180 : 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlack, AppColors.primaryRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'MESIN KOPI PREMIUM',
                                style: TextStyle(
                                  color: AppColors.primaryWhite,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Kualitas Barista Profesional',
                                style: TextStyle(
                                  color: AppColors.primaryWhite,
                                  fontSize: isMobile ? 22 : 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Temukan mesin kopi kelas industri untuk cafe dan restoran Anda.',
                                style: TextStyle(
                                  color: AppColors.primaryWhite,
                                  fontSize: isMobile ? 12 : 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryWhite,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Lihat Katalog →',
                                  style: TextStyle(
                                    color: AppColors.primaryRed,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -10,
                          bottom: -20,
                          child: Icon(
                            Icons.coffee_maker,
                            size: isMobile ? 130 : 200,
                            color: AppColors.primaryWhite.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Konten Lainnya (Dibatasi maxWidth agar rapi di web) ---
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Kategori ---
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori Pilihan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pilih kategori untuk memfilter produk',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
                        children: const [
                          CategoryItem(icon: Icons.grid_view, label: 'Semua', isActive: true),
                          CategoryItem(icon: Icons.coffee_maker, label: 'Espresso', isActive: false),
                          CategoryItem(icon: Icons.local_cafe, label: 'Manual', isActive: false),
                          CategoryItem(icon: Icons.blender, label: 'Grinder', isActive: false),
                          CategoryItem(icon: Icons.water_drop, label: 'Aksesoris', isActive: false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Produk Terlaris / Semua Produk ---
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.local_fire_department, color: AppColors.primaryRed, size: 22),
                              SizedBox(width: 6),
                              Text(
                                'Produk Terlaris',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '6 Produk',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.getGridColumns(context),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isMobile ? 0.65 : 0.7,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          final products = [
                            ProductData(name: 'La Marzocco Linea PB', originalPrice: 'Rp 185.000.000', price: 'Rp 185.000.000', rating: 4.9, sold: '45', discount: 0, badge: 'BEST SELLER'),
                            ProductData(name: 'Nuova Simonelli Aurelia II', originalPrice: 'Rp 125.000.000', price: 'Rp 125.000.000', rating: 4.8, sold: '38', discount: 0, badge: 'PREMIUM'),
                            ProductData(name: 'Faema E71E Commercial', originalPrice: 'Rp 95.000.000', price: 'Rp 95.000.000', rating: 4.7, sold: '52', discount: 0, badge: 'TERLARIS'),
                            ProductData(name: 'Rancilio Classe 11', originalPrice: 'Rp 78.000.000', price: 'Rp 78.000.000', rating: 4.8, sold: '29', discount: 0, badge: 'BEST SELLER'),
                            ProductData(name: 'Victoria Arduino Black Eagle', originalPrice: 'Rp 220.000.000', price: 'Rp 220.000.000', rating: 5.0, sold: '18', discount: 0, badge: 'PREMIUM'),
                            ProductData(name: 'Synesso MVP Hydra', originalPrice: 'Rp 165.000.000', price: 'Rp 165.000.000', rating: 4.9, sold: '22', discount: 0, badge: 'TERLARIS'),
                          ];
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProductDetailScreen()),
                              );
                            },
                            child: ProductCard(product: products[index]),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // --- BOTTOM NAVIGATION BAR (DIPERBAIKI) ---
      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.primaryWhite,
                selectedItemColor: AppColors.primaryRed,
                unselectedItemColor: AppColors.textSecondary,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                elevation: 0,
                currentIndex: 0,
                onTap: (index) {
                  if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderScreen()),
                    );
                  }
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
                  BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Katalog'),
                  BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Pesanan'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
                ],
              ),
            ), // <--- Tutup Container
    ); // <--- Tutup Scaffold
  } // <--- Tutup method build
} // <--- Tutup class HomeScreen

// --- Data Produk ---
class ProductData {
  final String name;
  final String originalPrice;
  final String price;
  final double rating;
  final String sold;
  final int discount;
  final String badge;

  const ProductData({
    required this.name,
    required this.originalPrice,
    required this.price,
    required this.rating,
    required this.sold,
    required this.discount,
    required this.badge,
  });
}

// --- Widget Kategori ---
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const CategoryItem({super.key, required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryRed : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? AppColors.primaryRed : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primaryWhite : AppColors.textPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primaryRed : AppColors.textPrimary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// --- Widget Card Produk ---
class ProductCard extends StatelessWidget {
  final ProductData product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: const Icon(Icons.coffee_maker, size: 50, color: AppColors.textSecondary),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.badge,
                    style: const TextStyle(
                      color: AppColors.primaryWhite,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text('${product.rating}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(width: 4),
                      Text('| ${product.sold} terjual', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_shopping_cart, color: AppColors.primaryWhite, size: 14),
                        SizedBox(width: 4),
                        Text('+ Keranjang', style: TextStyle(color: AppColors.primaryWhite, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}