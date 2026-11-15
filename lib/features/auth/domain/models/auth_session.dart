import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';

enum AuthStatus {
  anonymous,
  authenticated,
  passwordChangeRequired,
  otpRequired,
}

/// Session state held by AuthNotifier.
class AuthSession {
  const AuthSession._({
    required this.status,
    this.user,
    this.challengeToken,
    this.availableOtpChannels = const <String>[],
    this.pendingEmail,
  });

  const AuthSession.anonymous() : this._(status: AuthStatus.anonymous);

  const AuthSession.authenticated(AuthUser user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthSession.passwordChangeRequired(AuthUser user)
    : this._(status: AuthStatus.passwordChangeRequired, user: user);

  const AuthSession.otpRequired({
    required String challengeToken,
    List<String> availableOtpChannels = const <String>[],
    String? pendingEmail,
    AuthUser? user,
  }) : this._(
         status: AuthStatus.otpRequired,
         challengeToken: challengeToken,
         availableOtpChannels: availableOtpChannels,
         pendingEmail: pendingEmail,
         user: user,
       );

  final AuthStatus status;
  final AuthUser? user;
  final String? challengeToken;
  final List<String> availableOtpChannels;
  final String? pendingEmail;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAnonymous => status == AuthStatus.anonymous;
  bool get requiresPasswordChange =>
      status == AuthStatus.passwordChangeRequired;
  bool get requiresOtp => status == AuthStatus.otpRequired;
}
