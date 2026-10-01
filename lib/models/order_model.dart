enum OrderStatus {
  menungguPembayaran,
  diproses,
  dikirim,
  selesai,
  dibatalkan,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return 'Menunggu Pembayaran';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.dikirim:
        return 'Dikirim';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String get actionButtonLabel {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return 'Bayar Sekarang';
      case OrderStatus.diproses:
        return 'Lihat Detail';
      case OrderStatus.dikirim:
        return 'Lihat Detail';
      case OrderStatus.selesai:
        return 'Beli Lagi';
      case OrderStatus.dibatalkan:
        return 'Lihat Detail';
    }
  }
}

class OrderItem {
  final String productName;
  final String? productCategory;
  final String? imageUrl;
  final int quantity;
  final String unit;
  final int unitPrice;

  const OrderItem({
    required this.productName,
    this.productCategory,
    this.imageUrl,
    required this.quantity,
    this.unit = 'unit',
    required this.unitPrice,
  });

  int get subtotal => unitPrice * quantity;
}

class OrderModel {
  final String orderNumber;
  final String date;
  final OrderStatus status;
  final List<OrderItem> items;
  final int shippingFee;
  final int adminFee;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String paymentMethod;

  const OrderModel({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.items,
    this.shippingFee = 150000,
    this.adminFee = 25000,
    this.recipientName = 'Agnes Riskiyah',
    this.recipientPhone = '0812-3456-7890',
    this.recipientAddress =
        'Kawasan Industri MM2100, Blok C-12, Cikarang Barat, Bekasi, Jawa Barat 17530',
    this.paymentMethod = 'Transfer Bank',
  });

  // Perhitungan Rincian Pembayaran
  int get subtotalProducts =>
      items.fold(0, (sum, item) => sum + item.subtotal);

  int get totalPayment => subtotalProducts + shippingFee + adminFee;

  // Shortcut untuk kartu pesanan
  OrderItem get firstItem => items.first;
  String get productName => firstItem.productName;
  String? get productCategory => firstItem.productCategory;
  String? get imageUrl => firstItem.imageUrl;
  int get quantity => firstItem.quantity;
  String get unit => firstItem.unit;
  int get price => firstItem.unitPrice;
  int get totalPrice => totalPayment;

  static List<OrderModel> get sampleOrders => [
        const OrderModel(
          orderNumber: 'ORD-2026-00124',
          date: '26 September 2026',
          status: OrderStatus.diproses,
          shippingFee: 150000,
          adminFee: 25000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Kawasan Industri MM2100, Blok C-12, Cikarang Barat, Bekasi, Jawa Barat 17530',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Mesin CNC Milling 3-Axis Heavy Duty',
              productCategory: 'Mesin Industri CNC',
              imageUrl:
                  'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300&q=80',
              quantity: 1,
              unit: 'unit',
              unitPrice: 25000000,
            ),
          ],
        ),
        const OrderModel(
          orderNumber: 'ORD-2026-00123',
          date: '25 September 2026',
          status: OrderStatus.dikirim,
          shippingFee: 200000,
          adminFee: 25000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Jl. Rungkut Industri Raya No. 45, Rungkut, Surabaya, Jawa Timur 60293',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Mesin Bubut Precision Lathe Metal 750W',
              productCategory: 'Mesin Bubut Metal',
              imageUrl:
                  'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=300&q=80',
              quantity: 2,
              unit: 'unit',
              unitPrice: 18500000,
            ),
          ],
        ),
        const OrderModel(
          orderNumber: 'ORD-2026-00122',
          date: '24 September 2026',
          status: OrderStatus.menungguPembayaran,
          shippingFee: 300000,
          adminFee: 25000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Kawasan Industri Jababeka 1, Cikarang, Jawa Barat 17530',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Hydraulic Press Brake 100 Ton Automatic',
              productCategory: 'Metal Forming Equipment',
              imageUrl:
                  'https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?w=300&q=80',
              quantity: 1,
              unit: 'unit',
              unitPrice: 45000000,
            ),
          ],
        ),
        const OrderModel(
          orderNumber: 'ORD-2026-00121',
          date: '20 September 2026',
          status: OrderStatus.selesai,
          shippingFee: 250000,
          adminFee: 25000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Jl. Ahmad Yani No. 12, Wonokromo, Surabaya, Jawa Timur 60243',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Industrial Robotic Arm 6-Axis Welding Cell',
              productCategory: 'Otomasi Pabrikasi',
              imageUrl:
                  'https://images.unsplash.com/photo-1563986768609-322da13575f3?w=300&q=80',
              quantity: 1,
              unit: 'set',
              unitPrice: 68000000,
            ),
          ],
        ),
        const OrderModel(
          orderNumber: 'ORD-2026-00120',
          date: '18 September 2026',
          status: OrderStatus.selesai,
          shippingFee: 50000,
          adminFee: 10000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Bengkel Teknik Presisi, Jl. Merdeka No. 88, Tangerang, Banten 15111',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Mata Bor End Mill Carbide Tungsten Set (10 pcs)',
              productCategory: 'Sparepart & Tooling',
              imageUrl:
                  'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?w=300&q=80',
              quantity: 5,
              unit: 'set',
              unitPrice: 1200000,
            ),
            OrderItem(
              productName: 'Collet Chuck Set ER32 Presisi Tinggi',
              productCategory: 'Aksesoris Mesin',
              imageUrl:
                  'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300&q=80',
              quantity: 1,
              unit: 'set',
              unitPrice: 1850000,
            ),
          ],
        ),
        const OrderModel(
          orderNumber: 'ORD-2026-00119',
          date: '15 September 2026',
          status: OrderStatus.dibatalkan,
          shippingFee: 500000,
          adminFee: 25000,
          recipientName: 'Agnes Riskiyah',
          recipientPhone: '0812-9876-5432',
          recipientAddress:
              'Kawasan Berikat Nusantara, Cakung, Jakarta Utara 14140',
          paymentMethod: 'Transfer Bank',
          items: [
            OrderItem(
              productName: 'Mesin Fiber Laser Cutting Metal Sheet 1500W',
              productCategory: 'Mesin Laser Industri',
              imageUrl:
                  'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=300&q=80',
              quantity: 1,
              unit: 'unit',
              unitPrice: 85000000,
            ),
          ],
        ),
      ];
}
