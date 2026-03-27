class Order {
  final String id;
  final String transactionId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final String paymentMethod;
  final String shippingTier;
  final String? couponCode;
  final DateTime createdAt;
  final String status;

  const Order({
    required this.id,
    required this.transactionId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.shippingTier,
    this.couponCode,
    required this.createdAt,
    required this.status,
  });
}

class OrderItem {
  final String sku;
  final String name;
  final String brand;
  final String category;
  final double price;
  final int quantity;
  final String variant;

  const OrderItem({
    required this.sku,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.quantity,
    required this.variant,
  });
}
