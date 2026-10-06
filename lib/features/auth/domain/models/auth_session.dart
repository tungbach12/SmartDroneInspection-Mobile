import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';

enum AuthStatus { anonymous, authenticated, passwordChangeRequired }

/// Session state held by AuthNotifier.
class AuthSession {
  const AuthSession._({required this.status, this.user});

  const AuthSession.anonymous() : this._(status: AuthStatus.anonymous);

  const AuthSession.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthSession.passwordChangeRequired(AuthUser user)
    : this._(status: AuthStatus.passwordChangeRequired, user: user);

  final AuthStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAnonymous => status == AuthStatus.anonymous;
  bool get requiresPasswordChange =>
      status == AuthStatus.passwordChangeRequired;
}
