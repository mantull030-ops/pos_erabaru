class UserProfile {
  final String id;
  final String? storeId;
  final String name;
  final String? phone;
  final String? avatarUrl;
  final String role;
  final bool isActive;

  UserProfile({
    required this.id,
    this.storeId,
    required this.name,
    this.phone,
    this.avatarUrl,
    this.role = 'kasir',
    this.isActive = true,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      storeId: json['store_id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'kasir',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role,
      'is_active': isActive,
    };
  }
}
