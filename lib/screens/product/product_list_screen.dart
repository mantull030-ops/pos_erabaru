import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/providers/auth_provider.dart';
import 'package:pos_app/providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = context.read<AuthProvider>().userProfile;
      if (userProfile != null) {
        context.read<ProductProvider>().fetchProducts(userProfile.storeId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.searchProducts(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showProductDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: productProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text('Tidak ada produk.'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: product.imageUrl != null
                                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                                    : const Icon(Icons.inventory_2),
                              ),
                              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Rp ${product.price.toStringAsFixed(0)} | Stok: ${product.stock}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showProductDialog(context, product: product);
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final skuController = TextEditingController(text: product?.sku ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Tambah Produk' : 'Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: skuController,
                  decoration: const InputDecoration(labelText: 'SKU (Opsional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (product != null) {
                  final storeId = context.read<AuthProvider>().userProfile!.storeId;
                  context.read<ProductProvider>().deleteProduct(product.id, storeId);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(product != null ? 'Hapus' : 'Batal', style: TextStyle(color: product != null ? Colors.red : null)),
            ),
            ElevatedButton(
              onPressed: () {
                final storeId = context.read<AuthProvider>().userProfile!.storeId;
                final newProduct = Product(
                  id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  storeId: storeId,
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  sku: skuController.text,
                  createdAt: product?.createdAt ?? DateTime.now(),
                );

                if (product == null) {
                  context.read<ProductProvider>().addProduct(newProduct);
                } else {
                  context.read<ProductProvider>().updateProduct(newProduct);
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
