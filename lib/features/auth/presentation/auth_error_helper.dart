import 'package:flutter/widgets.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';

String describeAuthFailure(BuildContext context, ApiFailure failure) {
  final l10n = context.l10n;
  return switch (failure) {
    UnauthorizedFailure() => l10n.invalidCredentials,
    ForbiddenFailure(:final detail) =>
      detail == customerOnlyErrorCode
          ? l10n.customerOnlyAccessNotice
          : (detail ?? l10n.accessDeniedError),
    ValidationFailure(:final errors) =>
      errors.entries
          .map((e) => e.key.isEmpty ? e.value : '${e.key}: ${e.value}')
          .join('\n'),
    ServerFailure(:final detail) => detail ?? l10n.serverError,
    NetworkFailure() => l10n.cannotReachServer,
    NotFoundFailure() => l10n.notFoundError,
    UnknownFailure(:final message) => message,
  };
}

String describeApiFailure(BuildContext context, ApiFailure failure) {
  final l10n = context.l10n;
  return switch (failure) {
    UnauthorizedFailure() => l10n.accessDeniedError,
    ForbiddenFailure(:final detail) => detail ?? l10n.accessDeniedError,
    ValidationFailure(:final errors) =>
      errors.entries
          .map((e) => e.key.isEmpty ? e.value : '${e.key}: ${e.value}')
          .join('\n'),
    ServerFailure(:final detail) => detail ?? l10n.serverError,
    NetworkFailure() => l10n.cannotReachServer,
    NotFoundFailure() => l10n.notFoundError,
    UnknownFailure(:final message) => message,
  };
}
