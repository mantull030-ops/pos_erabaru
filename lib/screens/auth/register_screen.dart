import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_app/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _storeNameController.text.trim(),
    );
    
    if (!mounted) return;
    
    if (success) {
      Navigator.pop(context); // Kembali ke login setelah daftar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar KasirKu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buat Toko Baru',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Daftarkan diri Anda sebagai Owner',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Nama Pemilik Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        validator: (value) => 
                          (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),

                      // Nama Toko Field
                      TextFormField(
                        controller: _storeNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Toko',
                          prefixIcon: const Icon(Icons.storefront_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        validator: (value) => 
                          (value == null || value.isEmpty) ? 'Nama Toko tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
                          if (!value.contains('@')) return 'Format email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility_off : Icons.visibility
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                          if (value.length < 6) return 'Password minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading ? null : _handleRegister,
                          child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Daftar & Buat Toko'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
