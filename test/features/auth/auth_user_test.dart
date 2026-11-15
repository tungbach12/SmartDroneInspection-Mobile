import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

void main() {
  group('AuthUser.fromJson', () {
    test('parses and retains supported mobile roles', () {
      const canonicalRoles = [
        'ADMIN',
        'PLATFORM_MANAGER',
        'ORG_MANAGER',
        'INSPECTOR',
      ];
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': canonicalRoles,
        'organizationId': null,
      });

      expect(user.roles, [
        UserRole.admin,
        UserRole.platformManager,
        UserRole.orgManager,
        UserRole.inspector,
      ]);
      expect(user.roles.map((role) => role.code), canonicalRoles);
      expect(UserRole.values.map((role) => role.code), canonicalRoles);
      expect(user.organizationId, isNull);
    });

    test('does not accept legacy client or provider roles', () {
      expect(UserRole.parse('CLIENT'), isNull);
      expect(UserRole.parse('PROVIDER_MANAGER'), isNull);
      expect(UserRole.parse('MAINTENANCE_ENGINEER'), isNull);

      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': ['ADMIN', 'CLIENT', 'PROVIDER_MANAGER', 'LEGACY_SUPERUSER'],
        'organizationId': 'org-1',
      });

      expect(user.roles.map((role) => role.code), ['ADMIN']);
      expect(user.organizationId, 'org-1');
    });

    test('UserRole.parse returns null for unknown', () {
      expect(UserRole.parse('SERVICE_MANAGER'), isNull);
      expect(UserRole.parse(42), isNull);
    });

    test('parses and copies pilot license information for inspector', () {
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'inspector@test.com',
        'fullName': 'Test Inspector',
        'roles': ['INSPECTOR'],
        'pilotLicenseNumber': 'VN-PL-9988',
        'pilotLicenseClass': 'CLASS_A',
        'pilotLicenseExpiresAt': '2028-12-31T23:59:59Z',
        'pilotLicenseFileKey': 'licenses/u1.pdf',
      });

      expect(user.pilotLicenseNumber, 'VN-PL-9988');
      expect(user.pilotLicenseClass, 'CLASS_A');
      expect(user.pilotLicenseExpiresAt, '2028-12-31T23:59:59Z');
      expect(user.pilotLicenseFileKey, 'licenses/u1.pdf');

      final updated = user.copyWith(
        pilotLicenseNumber: 'VN-PL-1122',
        pilotLicenseClass: 'CLASS_B',
      );
      expect(updated.pilotLicenseNumber, 'VN-PL-1122');
      expect(updated.pilotLicenseClass, 'CLASS_B');
      expect(updated.pilotLicenseExpiresAt, '2028-12-31T23:59:59Z');
    });
  });
}
