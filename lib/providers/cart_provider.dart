import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/models/cart_item.dart';
import 'package:pos_app/models/order.dart';

class CartProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeItem(product);
    } else {
      final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
      if (existingIndex >= 0) {
        _items[existingIndex].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> checkout(String storeId, double paymentAmount, String paymentMethod) async {
    if (_items.isEmpty) return false;
    if (paymentAmount < totalAmount) {
      _setError('Pembayaran kurang dari total belanja');
      return false;
    }

    try {
      _setLoading(true);
      
      // 1. Buat pesanan (Order)
      final orderResponse = await _supabase.from('orders').insert({
        'store_id': storeId,
        'total_amount': totalAmount,
        'payment_amount': paymentAmount,
        'payment_method': paymentMethod,
      }).select().single();
      
      final orderId = orderResponse['id'];

      // 2. Buat item pesanan (Order Items)
      final List<Map<String, dynamic>> orderItems = _items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.product.id,
          'quantity': item.quantity,
          'price': item.product.price,
        };
      }).toList();

      await _supabase.from('order_items').insert(orderItems);

      // 3. Update stok produk
      for (var item in _items) {
        final newStock = item.product.stock - item.quantity;
        await _supabase.from('products').update({'stock': newStock}).eq('id', item.product.id);
      }

      clearCart();
      _clearError();
      return true;
    } catch (e) {
      _setError('Gagal memproses pembayaran: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
