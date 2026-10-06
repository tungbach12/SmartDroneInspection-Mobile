import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/actor_zone.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

void main() {
  group('AuthUser.fromJson', () {
    test('parses all six canonical roles', () {
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': [
          'PLATFORM_ADMIN',
          'PLATFORM_OPERATOR',
          'CLIENT',
          'PROVIDER_MANAGER',
          'INSPECTOR',
          'MAINTENANCE_ENGINEER',
        ],
        'actorZone': 'PLATFORM',
        'organizationId': null,
      });

      expect(user.roles, hasLength(6));
      expect(user.roles, contains(UserRole.platformAdmin));
      expect(user.roles, contains(UserRole.maintenanceEngineer));
      expect(user.actorZone, ActorZone.platform);
      expect(user.organizationId, isNull);
    });

    test('drops unknown roles instead of crashing', () {
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': ['CLIENT', 'LEGACY_SUPERUSER'],
        'actorZone': 'CUSTOMER_ORGANIZATION',
        'organizationId': 'org-1',
      });

      expect(user.roles, [UserRole.client]);
      expect(user.actorZone, ActorZone.customerOrganization);
      expect(user.organizationId, 'org-1');
    });

    test('unknown actorZone becomes null (fail closed)', () {
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': const <String>[],
        'actorZone': 'BROKER_ZONE',
        'organizationId': null,
      });

      expect(user.actorZone, isNull);
      expect(user.roles, isEmpty);
    });

    test('UserRole.parse returns null for unknown', () {
      expect(UserRole.parse('SERVICE_MANAGER'), isNull);
      expect(UserRole.parse(42), isNull);
      expect(ActorZone.parse('NOPE'), isNull);
    });
  });
}
