import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts(String storeId) async {
    try {
      _setLoading(true);
      final response = await _supabase
          .from('products')
          .select()
          .eq('store_id', storeId)
          .order('name');
          
      _products = (response as List).map((e) => Product.fromJson(e)).toList();
      _clearError();
    } catch (e) {
      _setError('Gagal mengambil data produk: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      _setLoading(true);
      await _supabase.from('products').insert(product.toJson());
      
      // Refresh list
      await fetchProducts(product.storeId);
      return true;
    } catch (e) {
      _setError('Gagal menambah produk: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      _setLoading(true);
      await _supabase
          .from('products')
          .update(product.toJson())
          .eq('id', product.id);
          
      // Refresh list
      await fetchProducts(product.storeId);
      return true;
    } catch (e) {
      _setError('Gagal mengubah produk: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProduct(String id, String storeId) async {
    try {
      _setLoading(true);
      await _supabase.from('products').delete().eq('id', id);
      
      // Refresh list
      await fetchProducts(storeId);
      return true;
    } catch (e) {
      _setError('Gagal menghapus produk: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    final lowerQuery = query.toLowerCase();
    return _products.where((p) => 
      p.name.toLowerCase().contains(lowerQuery) || 
      (p.sku?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
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
