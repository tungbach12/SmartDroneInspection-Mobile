import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/presentation/oauth_callback_screen.dart';
import 'package:smart_drone_inspection/shared/widgets/brand_loading_view.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

void main() {
  testWidgets('OAuthCallbackScreen displays branded loading animation', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OAuthCallbackScreen(
            accessToken: 'token-123',
            refreshToken: 'refresh-123',
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byType(BrandLoadingView), findsOneWidget);
    expect(find.text('SDI'), findsOneWidget);
  });

  testWidgets('CenteredSpinner displays compact animated IrisLoadingSpinner', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CenteredSpinner())),
    );
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byType(IrisLoadingSpinner), findsOneWidget);
  });
}
