import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/cart_item_model.dart';
import '../screens/checkout_screen.dart';
import '../screens/pesanan_screen.dart';
import '../utils/currency_formatter.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item_card.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  // Daftar item di keranjang belanja
  late List<CartItemModel> _cartItems;
  bool _isSummaryExpanded = false;

  // Nilai aturan biaya pengiriman & admin standar industri
  final int _shippingFeeRate = 150000;
  final int _adminFeeRate = 25000;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(CartItemModel.initialCartItems);
  }

  // Helper getters
  List<CartItemModel> get _selectedItems =>
      _cartItems.where((item) => item.isSelected).toList();

  int get _selectedCount => _selectedItems.length;

  bool get _isAllSelected =>
      _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);

  int get _subtotalProducts =>
      _selectedItems.fold(0, (sum, item) => sum + item.subtotal);

  int get _shippingFee => _selectedCount > 0 ? _shippingFeeRate : 0;
  int get _adminFee => _selectedCount > 0 ? _adminFeeRate : 0;

  int get _totalPayment => _subtotalProducts + _shippingFee + _adminFee;

  // Toggle Pilih Semua
  void _toggleSelectAll(bool? value) {
    final newValue = value ?? false;
    setState(() {
      _cartItems = _cartItems
          .map((item) => item.copyWith(isSelected: newValue))
          .toList();
    });
  }

  // Toggle Satu Produk
  void _toggleItemSelection(int index, bool isSelected) {
    setState(() {
      _cartItems[index] = _cartItems[index].copyWith(isSelected: isSelected);
    });
  }

  // Update Kuantitas
  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity < 1) return;
    final item = _cartItems[index];
    if (newQuantity > item.stock) return;

    setState(() {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
    });
  }

  // Konfirmasi & Hapus Produk
  void _confirmDeleteItem(int index) {
    final item = _cartItems[index];

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Hapus Produk?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.charcoal,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${item.productName}" dari keranjang belanja?',
          style: const TextStyle(fontSize: 13, color: AppColors.charcoal, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.greyMuted, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepRed,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {
                _cartItems.removeAt(index);
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${item.productName} dihapus dari keranjang.',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppColors.charcoal,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Navigasi ke Checkout (Hanya membawa item terpilih)
  void _navigateToCheckout() {
    if (_selectedCount == 0) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan pilih minimal 1 produk untuk checkout.',
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: AppColors.charcoal,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          selectedItems: _selectedItems,
          onCheckoutSuccess: () {
            // Hapus item yang berhasil dicheckout dari keranjang
            setState(() {
              _cartItems.removeWhere((item) => item.isSelected);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = _cartItems.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.cream,
      // 1. Header: Dark Brown #3A2118, Sederhana & Menampilkan Jumlah Produk
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 56,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keranjang',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            if (!isEmpty)
              Text(
                '${_cartItems.length} Produk',
                style: const TextStyle(
                  color: AppColors.greyLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),

      body: isEmpty
          ? CartEmptyState(
              onStartShopping: () {
                // Alur kembali ke produk/pesanan
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PesananScreen()),
                );
              },
            )
          : Column(
              children: [
                // 2. Bar "Pilih Semua" (Select All)
                _buildSelectAllBar(),

                // 3. Daftar Card Produk dalam Keranjang
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItemCard(
                        item: item,
                        onToggleSelect: (val) => _toggleItemSelection(index, val),
                        onQuantityChanged: (qty) => _updateQuantity(index, qty),
                        onDelete: () => _confirmDeleteItem(index),
                      );
                    },
                  ),
                ),

                // 4. Ringkasan Belanja & Checkout Floating Section
                _buildBottomCheckoutBar(),
              ],
            ),

      // Bottom Navigation Bar (Menu Keranjang aktif di Deep Red)
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Bar Pilih Semua
  Widget _buildSelectAllBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _isAllSelected,
                  activeColor: AppColors.deepRed,
                  checkColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(
                    color: AppColors.greyMuted,
                    width: 1.5,
                  ),
                  onChanged: _toggleSelectAll,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _toggleSelectAll(!_isAllSelected),
                child: Text(
                  'Pilih Semua ($_selectedCount/${_cartItems.length})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
              ),
            ],
          ),
          if (_selectedCount > 0)
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: const Text(
                      'Hapus Produk Terpilih?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoal,
                      ),
                    ),
                    content: Text(
                      'Hapus $_selectedCount produk terpilih dari keranjang belanja?',
                      style: const TextStyle(fontSize: 13, color: AppColors.charcoal),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal', style: TextStyle(color: AppColors.greyMuted)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepRed,
                          foregroundColor: AppColors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _cartItems.removeWhere((item) => item.isSelected);
                          });
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Hapus Terpilih',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.terracotta,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Ringkasan Belanja & Tombol Checkout
  Widget _buildBottomCheckoutBar() {
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Toggle Ringkasan Belanja
            InkWell(
              onTap: () {
                setState(() {
                  _isSummaryExpanded = !_isSummaryExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Ringkasan Belanja',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.charcoal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isSummaryExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 18,
                          color: AppColors.greyMuted,
                        ),
                      ],
                    ),
                    Text(
                      CurrencyFormatter.formatRupiah(_totalPayment),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Konten Detail Ringkasan Belanja (HANYA 3 KOMPONEN: Subtotal, Ongkir, Biaya Layanan)
            if (_isSummaryExpanded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    const Divider(height: 1, color: AppColors.greyLight),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Subtotal Produk',
                      CurrencyFormatter.formatRupiah(_subtotalProducts),
                    ),
                    const SizedBox(height: 6),
                    _buildSummaryRow(
                      'Ongkos Kirim',
                      CurrencyFormatter.formatRupiah(_shippingFee),
                    ),
                    const SizedBox(height: 6),
                    _buildSummaryRow(
                      'Biaya Layanan & Admin',
                      CurrencyFormatter.formatRupiah(_adminFee),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],

            const Divider(height: 1, color: AppColors.greyLight),

            // Baris Checkout Utama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Total Pembayaran Kolom Kiri
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.greyMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          CurrencyFormatter.formatRupiah(_totalPayment),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepRed,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol Utama "Checkout"
                  SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCount > 0
                            ? AppColors.deepRed
                            : AppColors.greyMuted.withValues(alpha: 0.5),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _selectedCount > 0 ? _navigateToCheckout : null,
                      child: Text(
                        _selectedCount > 0 ? 'Checkout ($_selectedCount)' : 'Checkout',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.greyMuted),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  /// 7. Bottom Navigation Bar (Keranjang = index 2 active Deep Red)
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
      ),
      child: BottomNavigationBar(
        currentIndex: 2, // 2 = Keranjang
        onTap: (index) {
          if (index == 2) {
            // Sudah di Keranjang
            return;
          } else if (index == 1) {
            // Buka Pesanan
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PesananScreen()),
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
