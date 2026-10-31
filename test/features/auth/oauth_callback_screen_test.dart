import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/auth/presentation/oauth_callback_screen.dart';

void main() {
  testWidgets('OAuthCallbackScreen displays loading indicator', (tester) async {
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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
