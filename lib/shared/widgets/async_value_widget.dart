import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

/// Builds UI from AsyncValue with standard loading/error/empty states.
/// Usage: AsyncValueWidget(value: ref.watch(provider), builder: (data) => ...).
String _localizedErrorMessage(BuildContext context, Object error) =>
    switch (error) {
      ApiFailureException(:final failure) => _localizedApiFailure(
        context,
        failure,
      ),
      final ApiFailure failure => _localizedApiFailure(context, failure),
      Exception() => error.toString(),
      Error() => context.l10n.somethingWentWrong,
      String() => error,
      _ => context.l10n.somethingWentWrong,
    };

String _localizedApiFailure(BuildContext context, ApiFailure failure) =>
    switch (failure) {
      NetworkFailure() => context.l10n.cannotReachServer,
      ValidationFailure(:final errors) => errors.values.join(' '),
      UnauthorizedFailure() => context.l10n.unauthorizedInspection,
      NotFoundFailure() => context.l10n.notFoundError,
      ServerFailure(:final detail) => detail ?? context.l10n.requestFailed,
      UnknownFailure(:final message) => message,
    };

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
    this.emptyCheck,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final bool Function(T data)? emptyCheck;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const CenteredSpinner(),
      error: (error, stackTrace) => ErrorRetryWidget(
        onRetry: onRetry ?? () {},
        message: _localizedErrorMessage(context, error),
      ),
      data: (data) => emptyCheck != null && emptyCheck!(data)
          ? EmptyState(
              icon: Icons.inbox_outlined,
              title: context.l10n.nothingHereYet,
            )
          : builder(data),
    );
  }
}
