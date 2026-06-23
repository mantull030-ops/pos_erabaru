import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_app/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  User? _currentUser;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = _supabase.auth.currentUser;
    if (_currentUser != null) {
      _fetchUserProfile();
    }
    
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      _currentUser = session?.user;
      
      if (event == AuthChangeEvent.signedIn && _currentUser != null) {
        _fetchUserProfile();
      } else if (event == AuthChangeEvent.signedOut) {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile() async {
    if (_currentUser == null) return;
    
    try {
      _setLoading(true);
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', _currentUser!.id)
          .maybeSingle();
          
      if (response != null) {
        _userProfile = UserProfile.fromJson(response);
      }
      _clearError();
    } catch (e) {
      _setError('Gagal mengambil profil: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password, String storeName) async {
    try {
      _setLoading(true);
      // 1. Sign up di Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        // 2. Buat toko baru
        final storeResponse = await _supabase.from('stores').insert({
          'name': storeName,
        }).select().single();

        // 3. Simpan data profil sebagai owner
        await _supabase.from('users').insert({
          'id': user.id,
          'store_id': storeResponse['id'],
          'name': name,
          'role': 'owner',
        });
        
        _clearError();
        return true;
      }
      return false;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _clearError();
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _supabase.auth.signOut();
      _clearError();
    } catch (e) {
      _setError('Gagal logout: $e');
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
