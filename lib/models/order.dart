class Order {
  final String id;
  final String storeId;
  final double totalAmount;
  final double paymentAmount;
  final String paymentMethod;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.storeId,
    required this.totalAmount,
    required this.paymentAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'total_amount': totalAmount,
      'payment_amount': paymentAmount,
      'payment_method': paymentMethod,
    };
  }
}

class OrderItem {
  final String orderId;
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
