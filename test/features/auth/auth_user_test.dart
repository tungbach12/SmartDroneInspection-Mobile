import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

void main() {
  group('UserRole.parse', () {
    test('parses only the four active roles', () {
      expect(UserRole.parse('CUSTOMER'), UserRole.customer);
      expect(UserRole.parse(' customer '), UserRole.customer);
      expect(UserRole.parse('MANAGER'), UserRole.manager);
      expect(UserRole.parse('ADMIN'), UserRole.admin);
      expect(UserRole.parse('INSPECTOR'), UserRole.inspector);
      expect(UserRole.parse('ORG_MANAGER'), isNull);
      expect(UserRole.parse('PLATFORM_MANAGER'), isNull);
      expect(UserRole.parse('MAINTENANCE_ENGINEER'), isNull);
    });

    test('returns null for unknown or non-string roles', () {
      expect(UserRole.parse('UNKNOWN_ROLE'), isNull);
      expect(UserRole.parse(null), isNull);
      expect(UserRole.parse(123), isNull);
    });
  });

  group('AuthUser.fromJson', () {
    test('parses Customer payload and sets isCustomer true', () {
      final user = AuthUser.fromJson({
        'id': 'user-1',
        'email': 'customer@example.com',
        'fullName': 'Minh Customer',
        'roles': ['CUSTOMER'],
        'phoneNumber': '+84901234567',
      });

      expect(user.id, 'user-1');
      expect(user.email, 'customer@example.com');
      expect(user.fullName, 'Minh Customer');
      expect(user.roles, [UserRole.customer]);
      expect(user.isCustomer, isTrue);
      expect(user.phoneNumber, '+84901234567');
    });

    test('identifies non-Customer account with isCustomer false', () {
      final inspector = AuthUser.fromJson({
        'id': 'user-2',
        'email': 'inspector@example.com',
        'fullName': 'Lan Inspector',
        'roles': ['INSPECTOR'],
      });

      expect(inspector.hasRole(UserRole.inspector), isTrue);
      expect(inspector.isCustomer, isFalse);
    });

    test('copyWith updates optional fields cleanly', () {
      const user = AuthUser(
        id: 'u1',
        email: 'a@b.c',
        fullName: 'A B',
        roles: [UserRole.customer],
      );

      final updated = user.copyWith(
        fullName: 'A Updated',
        phoneNumber: '+84909998887',
      );

      expect(updated.fullName, 'A Updated');
      expect(updated.phoneNumber, '+84909998887');
      expect(updated.email, 'a@b.c');
      expect(updated.isCustomer, isTrue);
    });
  });
}
