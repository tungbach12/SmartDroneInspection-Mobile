enum UserRole {
  admin('ADMIN'),
  platformManager('MANAGER'),
  orgManager('CUSTOMER'),
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
