enum UserRole {
  platformAdmin('PLATFORM_ADMIN'),
  platformOperator('PLATFORM_OPERATOR'),
  client('CLIENT'),
  providerManager('PROVIDER_MANAGER'),
  inspector('INSPECTOR'),
  maintenanceEngineer('MAINTENANCE_ENGINEER');

  const UserRole(this.code);

  final String code;

  /// Tolerant parse — unknown role codes are ignored (no crash on
  /// forward-compatible server payloads).
  static UserRole? parse(Object? raw) {
    if (raw is! String) return null;
    for (final role in UserRole.values) {
      if (role.code == raw) return role;
    }
    return null;
  }
}
