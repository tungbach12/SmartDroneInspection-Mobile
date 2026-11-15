import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/localization/locale_labels.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

void main() {
  test('localizes roles including legacy aliases in EN and VI', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final vi = lookupAppLocalizations(const Locale('vi'));

    expect(localizedRole(en, 'CUSTOMER'), 'Customer');
    expect(localizedRole(en, 'ORG_MANAGER'), 'Customer');
    expect(localizedRole(en, 'MANAGER'), 'Platform Manager');
    expect(localizedRole(en, 'PLATFORM_MANAGER'), 'Platform Manager');
    expect(localizedRole(vi, 'CUSTOMER'), 'Khách hàng');
    expect(localizedRole(vi, 'ORG_MANAGER'), 'Khách hàng');
    expect(localizedRole(vi, 'INSPECTOR'), 'Kiểm định viên');
  });

  test('localizes asset, service request, and inspection statuses', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final vi = lookupAppLocalizations(const Locale('vi'));

    expect(localizedAssetStatus(en, 'ACTIVE'), 'Active');
    expect(localizedAssetStatus(vi, 'RETIRED'), 'Đã ngừng sử dụng');

    expect(localizedServiceRequestStatus(en, 'QUOTED'), 'Quoted');
    expect(
      localizedServiceRequestStatus(vi, 'CONTRACT_SIGNED'),
      'Đã ký hợp đồng',
    );

    expect(localizedInspectionStatus(en, 'UNDER_REVIEW'), 'Under review');
    expect(localizedInspectionStatus(vi, 'COMPLETED'), 'Hoàn thành');
  });

  test('localizes report, payment, severity, and field session statuses', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final vi = lookupAppLocalizations(const Locale('vi'));

    expect(localizedReportStatus(en, 'PUBLISHED'), 'Published');
    expect(localizedReportStatus(vi, 'PUBLISHED'), 'Đã phát hành');

    expect(localizedPaymentStatus(en, 'PAYMENT_DUE'), 'Payment due');
    expect(localizedPaymentStatus(en, 'UNKNOWN'), 'Pending acceptance');
    expect(localizedPaymentStatus(vi, 'PAID'), 'Đã thanh toán');

    expect(localizedFindingSeverity(en, 'CRITICAL'), 'Critical');
    expect(localizedFindingSeverity(vi, 'HIGH'), 'Cao');

    expect(localizedFieldSessionStatus(en, 'ABORTED'), 'Aborted');
    expect(localizedFieldSessionStatus(vi, 'IN_PROGRESS'), 'Đang tiến hành');
  });
}
