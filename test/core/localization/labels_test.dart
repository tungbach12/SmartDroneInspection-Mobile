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
    expect(localizedAssetStatus(english, 'INACTIVE'), 'Inactive');
    expect(localizedAssetStatus(english, 'RETIRED'), 'Retired');
    expect(localizedAssetStatus(vietnamese, 'INACTIVE'), 'Ngừng hoạt động');
    expect(localizedAssetStatus(vietnamese, 'RETIRED'), 'Đã ngừng sử dụng');
    expect(localizedAssetStatus(vietnamese, 'UNKNOWN'), 'UNKNOWN');

    // The mapping only changes the displayed label, not the supplied protocol value.
    const protocolValue = 'INACTIVE';
    localizedAssetStatus(vietnamese, protocolValue);
    expect(protocolValue, 'INACTIVE');

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
    expect(localizedRole(english, 'PLATFORM_MANAGER'), 'Platform Manager');
    expect(localizedRole(vietnamese, 'PLATFORM_MANAGER'), 'Quản lý nền tảng');
    expect(localizedRole(english, 'ORG_MANAGER'), 'Organization Manager');
    expect(localizedRole(vietnamese, 'ORG_MANAGER'), 'Quản lý tổ chức');
  });
}
