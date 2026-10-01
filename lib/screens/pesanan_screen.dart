import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/order_model.dart';
import '../widgets/order_card.dart';
import '../widgets/order_empty_state.dart';
import 'keranjang_screen.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({super.key});

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  // Pilihan Tab Status Filter
  final List<String> _tabs = [
    'Semua',
    'Menunggu Pembayaran',
    'Diproses',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  int _selectedTabIndex = 0;
  int _currentNavIndex = 1; // 1 = Pesanan (Active state)

  // Data pesanan (berdasarkan model)
  final List<OrderModel> _allOrders = OrderModel.sampleOrders;

  // Filter pesanan sesuai tab yang aktif
  List<OrderModel> get _filteredOrders {
    if (_selectedTabIndex == 0) {
      return _allOrders;
    }

    final activeStatusName = _tabs[_selectedTabIndex];

    return _allOrders.where((order) {
      return order.status.label.toLowerCase() == activeStatusName.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredOrders;

    return Scaffold(
      backgroundColor: AppColors.cream,
      // 1. Header: Sederhana, tidak terlalu tinggi, Dark Brown #3A2118
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        elevation: 0,
        toolbarHeight: 52,
        centerTitle: false,
        title: const Text(
          'Pesanan',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.white,
              size: 22,
            ),
            tooltip: 'Cari Pesanan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Pencarian nomor pesanan manufaktur...',
                    style: TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.charcoal,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // 2. Filter Status Horizontal
          _buildHorizontalFilterTabs(),

          // 3. Daftar Pesanan atau Empty State
          Expanded(
            child: filteredList.isEmpty
                ? OrderEmptyState(
                    onStartShopping: () {
                      setState(() {
                        _selectedTabIndex = 0; // Kembalikan ke tab semua
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: filteredList[index]);
                    },
                  ),
          ),
        ],
      ),

      // 7. Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 2. Filter Status Horizontal Tabs
  Widget _buildHorizontalFilterTabs() {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            final title = _tabs[index];

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.deepRed : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.deepRed
                          : AppColors.greyLight,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.deepRed.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.charcoal,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 7. Bottom Navigation Bar: Beranda, Pesanan (Active Deep Red), Keranjang, Profil
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.greyLight.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          if (index == 1) {
            setState(() {
              _currentNavIndex = index;
            });
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KeranjangScreen()),
            );
          } else {
            final pageNames = ['Beranda', 'Pesanan', 'Keranjang', 'Profil'];
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Halaman ${pageNames[index]} dikelola oleh modul terpisah.',
                  style: const TextStyle(fontSize: 12, color: AppColors.white),
                ),
                backgroundColor: AppColors.charcoal,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.deepRed,
        unselectedItemColor: AppColors.greyMuted,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
