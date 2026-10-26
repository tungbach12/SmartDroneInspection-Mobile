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
    this.pilotLicenseNumber,
    this.pilotLicenseClass,
    this.pilotLicenseExpiresAt,
    this.pilotLicenseFileKey,
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
      pilotLicenseNumber: json['pilotLicenseNumber'] as String?,
      pilotLicenseClass: json['pilotLicenseClass'] as String?,
      pilotLicenseExpiresAt: json['pilotLicenseExpiresAt'] as String?,
      pilotLicenseFileKey: json['pilotLicenseFileKey'] as String?,
    );
  }

  final String id;
  final String email;
  final String fullName;
  final List<UserRole> roles;
  final ActorZone? actorZone;
  final String? organizationId;
  final String? pilotLicenseNumber;
  final String? pilotLicenseClass;
  final String? pilotLicenseExpiresAt;
  final String? pilotLicenseFileKey;

  bool hasRole(UserRole role) => roles.contains(role);

  AuthUser copyWith({
    String? id,
    String? email,
    String? fullName,
    List<UserRole>? roles,
    ActorZone? actorZone,
    String? organizationId,
    String? pilotLicenseNumber,
    String? pilotLicenseClass,
    String? pilotLicenseExpiresAt,
    String? pilotLicenseFileKey,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      roles: roles ?? this.roles,
      actorZone: actorZone ?? this.actorZone,
      organizationId: organizationId ?? this.organizationId,
      pilotLicenseNumber: pilotLicenseNumber ?? this.pilotLicenseNumber,
      pilotLicenseClass: pilotLicenseClass ?? this.pilotLicenseClass,
      pilotLicenseExpiresAt:
          pilotLicenseExpiresAt ?? this.pilotLicenseExpiresAt,
      pilotLicenseFileKey: pilotLicenseFileKey ?? this.pilotLicenseFileKey,
    );
  }
}
