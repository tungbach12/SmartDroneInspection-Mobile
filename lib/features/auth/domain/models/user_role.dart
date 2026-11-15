enum UserRole {
  admin('ADMIN'),
  manager('MANAGER'),
  customer('CUSTOMER'),
  inspector('INSPECTOR'),
  maintenanceEngineer('MAINTENANCE_ENGINEER');

  const UserRole(this.code);

  final String code;

  /// Tolerant parse normalizing legacy ORG_MANAGER -> CUSTOMER and
  /// PLATFORM_MANAGER -> MANAGER matching live frontend authApi.ts.
  static UserRole? parse(Object? raw) {
    if (raw is! String) return null;
    final normalized = raw.trim().toUpperCase();
    return switch (normalized) {
      'CUSTOMER' || 'ORG_MANAGER' => UserRole.customer,
      'MANAGER' || 'PLATFORM_MANAGER' => UserRole.manager,
      'ADMIN' => UserRole.admin,
      'INSPECTOR' => UserRole.inspector,
      'MAINTENANCE_ENGINEER' => UserRole.maintenanceEngineer,
      _ => null,
    };
  }
}
