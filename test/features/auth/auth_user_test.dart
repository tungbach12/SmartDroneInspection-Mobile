import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/actor_zone.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';

void main() {
  group('AuthUser.fromJson', () {
    test('parses and retains all four canonical enterprise roles', () {
      const canonicalRoles = [
        'ADMIN',
        'ORG_ADMIN',
        'INSPECTOR',
        'MAINTENANCE_ENGINEER',
      ];
      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': canonicalRoles,
        'actorZone': 'PLATFORM',
        'organizationId': null,
      });

      expect(user.roles.map((role) => role.code), canonicalRoles);
      expect(UserRole.values.map((role) => role.code), canonicalRoles);
      expect(user.actorZone, ActorZone.platform);
      expect(user.organizationId, isNull);
    });

    test('does not accept legacy client or provider roles', () {
      expect(UserRole.parse('CLIENT'), isNull);
      expect(UserRole.parse('PROVIDER_MANAGER'), isNull);

      final user = AuthUser.fromJson({
        'id': 'u1',
        'email': 'a@b.c',
        'fullName': 'A B',
        'roles': ['ADMIN', 'CLIENT', 'PROVIDER_MANAGER', 'LEGACY_SUPERUSER'],
        'actorZone': 'CUSTOMER_ORGANIZATION',
        'organizationId': 'org-1',
      });

      expect(user.roles.map((role) => role.code), ['ADMIN']);
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
