enum UserRole {
  admin('ADMIN'),
  manager('MANAGER'),
  customer('CUSTOMER'),
  inspector('INSPECTOR');

  const UserRole(this.code);

  final String code;

  static UserRole? parse(Object? raw) {
    if (raw is! String) return null;
    final normalized = raw.trim().toUpperCase();
    return switch (normalized) {
      'CUSTOMER' => UserRole.customer,
      'MANAGER' => UserRole.manager,
      'ADMIN' => UserRole.admin,
      'INSPECTOR' => UserRole.inspector,
      _ => null,
    };
  }
}
