import 'package:smart_drone_inspection/features/auth/domain/models/actor_zone.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

/// Mobile mirror of the backend UserResponse contract.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    this.actorZone,
    this.organizationId,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'];
    final roles = <UserRole>[];
    if (rawRoles is List) {
      for (final raw in rawRoles) {
        final role = UserRole.parse(raw);
        if (role != null) roles.add(role);
      }
    }
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      roles: roles,
      // Tolerant parse — unknown zones become null (fail closed), never crash.
      actorZone: ActorZone.parse(json['actorZone']),
      organizationId: json['organizationId'] as String?,
    );
  }

  final String id;
  final String email;
  final String fullName;
  final List<UserRole> roles;
  final ActorZone? actorZone;
  final String? organizationId;

  bool hasRole(UserRole role) => roles.contains(role);
}
