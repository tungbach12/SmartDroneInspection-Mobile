import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

/// Mobile mirror of the backend UserResponse contract (Customer-focused).
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    this.phoneNumber,
    this.avatarUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'];
    final roles = <UserRole>[];
    if (rawRoles is List) {
      for (final raw in rawRoles) {
        final role = UserRole.parse(raw);
        if (role != null && !roles.contains(role)) {
          roles.add(role);
        }
      }
    }
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      roles: roles,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  final String id;
  final String email;
  final String fullName;
  final List<UserRole> roles;
  final String? phoneNumber;
  final String? avatarUrl;

  bool hasRole(UserRole role) => roles.contains(role);

  /// Customer mobile app exclusively permits CUSTOMER.
  bool get isCustomer => roles.contains(UserRole.customer);

  AuthUser copyWith({
    String? id,
    String? email,
    String? fullName,
    List<UserRole>? roles,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      roles: roles ?? this.roles,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
