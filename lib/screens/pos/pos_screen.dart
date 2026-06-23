import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/models/product.dart';
import 'package:pos_app/providers/auth_provider.dart';
import 'package:pos_app/providers/product_provider.dart';
import 'package:pos_app/providers/cart_provider.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
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
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildProductList(),
          ),
          if (isDesktop) const VerticalDivider(width: 1, thickness: 1),
          if (isDesktop)
            Expanded(
              flex: 1,
              child: _buildCart(),
            ),
        ],
      ),
      floatingActionButton: !isDesktop
          ? FloatingActionButton.extended(
              onPressed: () {
                _showCartBottomSheet(context);
              },
              icon: const Icon(Icons.shopping_cart),
              label: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Text('${cart.items.length} Item - Rp ${cart.totalAmount.toStringAsFixed(0)}');
                },
              ),
            )
          : null,
    );
  }

  Widget _buildProductList() {
    return Column(
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
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              final products = productProvider.searchProducts(_searchQuery);
              
              if (productProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (products.isEmpty) {
                return const Center(child: Text('Tidak ada produk.'));
              }
              
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductCard(product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        if (product.stock > 0) {
          context.read<CartProvider>().addItem(product);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stok habis!')),
          );
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: product.imageUrl != null
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.inventory_2, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stok: ${product.stock}',
                    style: TextStyle(fontSize: 12, color: product.stock > 0 ? Colors.grey[600] : Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCart() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: const Row(
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 8),
                  Text('Keranjang Belanja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Keranjang kosong'))
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('Rp ${item.product.price.toStringAsFixed(0)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  cart.updateQuantity(item.product, item.quantity - 1);
                                },
                              ),
                              Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  if (item.quantity < item.product.stock) {
                                    cart.updateQuantity(item.product, item.quantity + 1);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Stok tidak cukup')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Rp ${cart.totalAmount.toStringAsFixed(0)}', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: cart.items.isEmpty ? null : () {
                        _showPaymentDialog(context, cart);
                      },
                      child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: _buildCart(),
        );
      },
    );
  }

  void _showPaymentDialog(BuildContext context, CartProvider cart) {
    final paymentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Tagihan: Rp ${cart.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: paymentController,
                decoration: const InputDecoration(labelText: 'Jumlah Uang Tunai'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final paymentAmount = double.tryParse(paymentController.text) ?? 0.0;
                final storeId = context.read<AuthProvider>().userProfile!.storeId;
                
                final success = await cart.checkout(storeId, paymentAmount, 'CASH');
                
                if (success && mounted) {
                  Navigator.pop(context); // Close dialog
                  if (!MediaQuery.of(context).size.width.isFinite || MediaQuery.of(context).size.width < 800) {
                     Navigator.pop(context); // Close bottom sheet if mobile
                  }
                  
                  // Reload products to update stock
                  context.read<ProductProvider>().fetchProducts(storeId);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pembayaran Berhasil!')),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(cart.errorMessage ?? 'Gagal membayar')),
                  );
                }
              },
              child: cart.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) 
                : const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }
}
