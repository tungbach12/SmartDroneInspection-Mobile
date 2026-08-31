import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

/// Builds UI from AsyncValue with standard loading/error/empty states.
/// Usage: AsyncValueWidget(value: ref.watch(provider), builder: (data) => ...).
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
        message: error.toString(),
      ),
      data: (data) => emptyCheck != null && emptyCheck!(data)
          ? const EmptyState(icon: Icons.inbox_outlined, title: 'Nothing here yet')
          : builder(data),
    );
  }
}
