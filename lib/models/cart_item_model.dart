class CartItemModel {
  final String id;
  final String productName;
  final String? productCategory;
  final String? imageUrl;
  final int unitPrice;
  final int quantity;
  final String unit;
  final int stock;
  final bool isSelected;

  const CartItemModel({
    required this.id,
    required this.productName,
    this.productCategory,
    this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.unit = 'unit',
    this.stock = 10,
    this.isSelected = true,
  });

  int get subtotal => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    String? productName,
    String? productCategory,
    String? imageUrl,
    int? unitPrice,
    int? quantity,
    String? unit,
    int? stock,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productCategory: productCategory ?? this.productCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  /// Initial sample cart items untuk aplikasi PT Manufactur Dynamic Indonesia
  static List<CartItemModel> get initialCartItems => [
        const CartItemModel(
          id: 'CART-001',
          productName: 'Mesin CNC Milling 3-Axis Heavy Duty',
          productCategory: 'Mesin Industri CNC',
          imageUrl:
              'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=300&q=80',
          unitPrice: 25000000,
          quantity: 1,
          unit: 'unit',
          stock: 4,
          isSelected: true,
        ),
        const CartItemModel(
          id: 'CART-002',
          productName: 'Mesin Bubut Precision Lathe Metal 750W',
          productCategory: 'Mesin Bubut Metal',
          imageUrl:
              'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=300&q=80',
          unitPrice: 18500000,
          quantity: 2,
          unit: 'unit',
          stock: 6,
          isSelected: true,
        ),
        const CartItemModel(
          id: 'CART-003',
          productName: 'Mata Bor End Mill Carbide Tungsten Set (10 pcs)',
          productCategory: 'Sparepart & Tooling',
          imageUrl:
              'https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?w=300&q=80',
          unitPrice: 1200000,
          quantity: 3,
          unit: 'set',
          stock: 15,
          isSelected: true,
        ),
      ];
}
