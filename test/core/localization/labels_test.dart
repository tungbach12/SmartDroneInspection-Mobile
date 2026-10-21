import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

void main() {
  test('localizes workflow values without changing protocol identifiers', () {
    final english = lookupAppLocalizations(const Locale('en'));
    final vietnamese = lookupAppLocalizations(const Locale('vi'));

    expect(localizedWorkflowStatus(english, 'READY'), 'Ready');
    expect(localizedWorkflowStatus(vietnamese, 'READY'), 'Sẵn sàng');
    expect(localizedWorkflowStatus(vietnamese, 'FUTURE_STATE'), 'FUTURE_STATE');
    expect(
      localizedDecision(vietnamese, 'ADDITIONAL_SESSION_REQUIRED'),
      'Yêu cầu phiên bổ sung',
    );
    expect(
      localizedFieldSessionStatus(vietnamese, 'FIELD_COMPLETED'),
      'Đã hoàn tất hiện trường',
    );
    expect(localizedChecklistChoice(vietnamese, 'true'), 'Có');
    expect(localizedChecklistChoice(vietnamese, 'PASS'), 'Đạt');
    expect(
      localizedChecklistChoice(vietnamese, 'SERVER_VALUE'),
      'SERVER_VALUE',
    );
  });
}
