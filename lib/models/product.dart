class Product {
  final String id;
  final String storeId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? sku;
  final String? imageUrl;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    this.description,
    required this.price,
    this.stock = 0,
    this.sku,
    this.imageUrl,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      storeId: json['store_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      sku: json['sku'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'sku': sku,
      'image_url': imageUrl,
    };
  }
}
