import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';

void main() {
  testWidgets('shows localized backend error details in async error state', (
    tester,
  ) async {
    const backendDetail = 'Phiên bản dữ liệu đã thay đổi';
    final value = AsyncValue<ApiFailure>.error(
      ApiFailureException(const ServerFailure(409, backendDetail)),
      StackTrace.current,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: const [Locale('en'), Locale('vi')],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: AsyncValueWidget<ApiFailure>(
            value: value,
            builder: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
    );

    expect(find.text(backendDetail), findsOneWidget);
  });
}
