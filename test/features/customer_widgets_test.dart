import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/assets/domain/models/asset.dart';
import 'package:smart_drone_inspection/features/assets/presentation/providers/asset_list_provider.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';
import 'package:smart_drone_inspection/features/auth/presentation/forgot_password_page.dart';
import 'package:smart_drone_inspection/features/auth/presentation/login_page.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/auth/presentation/register_page.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/features/dashboard/presentation/customer_dashboard_page.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_detail_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspections_provider.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/widgets/sepay_qr_dialog.dart';
import 'package:smart_drone_inspection/features/notifications/domain/models/app_notification.dart';
import 'package:smart_drone_inspection/features/notifications/presentation/providers/notification_providers.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

class _RejectingNonCustomerAuthNotifier extends AuthNotifier {
  @override
  Future<AuthSession> build() async => const AuthSession.anonymous();

  @override
  Future<ApiResult<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    return const ApiResult.failure(ForbiddenFailure(customerOnlyErrorCode));
  }
}

class _StubAssetsNotifier extends AssetListNotifier {
  _StubAssetsNotifier(this._items);
  final List<Asset> _items;
  @override
  Future<List<Asset>> build() async => _items;
}

class _StubInspectionsNotifier extends InspectionsNotifier {
  _StubInspectionsNotifier(this._items);
  final List<Inspection> _items;
  @override
  Future<List<Inspection>> build() async => _items;
}

class _StubRequestsNotifier extends ServiceRequestsNotifier {
  _StubRequestsNotifier(this._items);
  final List<ServiceRequest> _items;
  @override
  Future<List<ServiceRequest>> build() async => _items;
}

class _StubNotificationsNotifier extends NotificationsNotifier {
  @override
  Future<List<AppNotification>> build() async => const <AppNotification>[];
}

Widget _wrapApp(Widget home, List<dynamic> overrides) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('vi')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    ),
  );
}

void main() {
  testWidgets(
    'LoginPage displays Customer-only rejection banner and registration link',
    (tester) async {
      await tester.pumpWidget(
        _wrapApp(const LoginPage(), [
          authNotifierProvider.overrideWith(
            _RejectingNonCustomerAuthNotifier.new,
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('go-register-btn')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('login-email-field')),
        'inspector@sdi.test',
      );
      await tester.enterText(
        find.byKey(const Key('login-password-field')),
        'Password123456789!',
      );
      await tester.tap(find.byKey(const Key('login-submit-btn')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('exclusively for Customer accounts'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'CustomerDashboardPage shows KPIs, quick actions, and unread bell badge',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      const asset = Asset(
        id: 'a-1',
        name: 'Nhat Tan Bridge',
        code: 'NT-01',
        status: 'ACTIVE',
        categoryId: 'cat-bridge',
        createdAt: '2026-10-01T08:00:00Z',
        locationText: 'Hanoi',
      );
      const insp = Inspection(
        id: 'insp-1',
        assetId: 'a-1',
        assetName: 'Nhat Tan Bridge',
        status: 'COMPLETED',
        plannedStartAt: '2026-10-01T08:00:00Z',
        reportStatus: 'PUBLISHED',
        paymentStatus: 'PAID',
      );

      await tester.pumpWidget(
        _wrapApp(const CustomerDashboardPage(), [
          assetListProvider.overrideWith(
            () => _StubAssetsNotifier(const [asset]),
          ),
          inspectionsNotifierProvider.overrideWith(
            () => _StubInspectionsNotifier(const [insp]),
          ),
          serviceRequestsProvider.overrideWith(
            () => _StubRequestsNotifier(const []),
          ),
          notificationsProvider.overrideWith(_StubNotificationsNotifier.new),
          totalUnreadBadgeProvider.overrideWithValue(3),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Customer Overview'), findsOneWidget);
      expect(find.text('1 / 1'), findsOneWidget);
      expect(find.text('Nhat Tan Bridge'), findsWidgets);
      expect(find.text('3'), findsOneWidget);
    },
  );

  testWidgets(
    'InspectionDetailPage shows Tracking, Official Report, and Settlement actions',
    (tester) async {
      const version = InspectionReportVersion(
        id: 'ver-1',
        versionNo: 1,
        status: 'PUBLISHED',
        createdAt: '2026-10-02T08:00:00Z',
        publishedAt: '2026-10-03T08:00:00Z',
        droneSummary: 'DJI · Matrice 350 RTK · SN-001',
        flightPermitFileName: 'permit-2026.pdf',
      );
      const bundle = CustomerInspectionBundle(
        inspection: Inspection(
          id: 'insp-1',
          assetId: 'a-1',
          assetName: 'Nhat Tan Bridge',
          status: 'COMPLETED',
          inspectorName: 'Pham Van Bay',
          managerName: 'Tran Minh Quan Ly',
          droneModel: 'Matrice 350 RTK',
          droneSerialNumber: 'SN-001',
          flightPermitFileName: 'permit-2026.pdf',
          reportStatus: 'PUBLISHED',
          reportVersionNo: 1,
          reportAccepted: false,
          paymentStatus: 'PAYMENT_DUE',
          clarificationCount: 0,
        ),
        findings: [
          InspectionFinding(
            id: 'f-1',
            inspectionId: 'insp-1',
            status: 'CONFIRMED',
            findingCode: 'F-1',
            defectLabel: 'Bolt oxidation',
            severity: 'HIGH',
            technicalNotes: 'Light surface oxidation on span 2 bolts.',
          ),
        ],
        reportVersions: [version],
        paymentStatus: ReportPaymentStatus(
          reportAccepted: false,
          paid: false,
          paymentStatus: 'PAYMENT_DUE',
          amount: 11000000,
          serviceBaseAmount: 10000000,
          vatRate: 10,
          vatAmount: 1000000,
        ),
      );
      const aiSummary = ReportAiSummary(
        summary: 'Deck surface shows light oxidation in Zone 2.',
        keyHighlights: ['Zone 2 fastener rust'],
        recommendedActions: 'Coat affected bolts during scheduled window.',
        overallRisk: 'LOW',
      );

      await tester.pumpWidget(
        _wrapApp(const InspectionDetailPage(inspectionId: 'insp-1'), [
          inspectionBundleProvider('insp-1')
              .overrideWith((ref) async => bundle),
          reportAiSummaryProvider((inspectionId: 'insp-1', versionId: 'ver-1'))
              .overrideWith((ref) async => aiSummary),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inspector: Pham Van Bay'), findsOneWidget);
      expect(find.text('Manager: Tran Minh Quan Ly'), findsOneWidget);
      expect(find.textContaining('SN-001'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('F-1 · Bolt oxidation'),
        200,
        scrollable: find.descendant(
          of: find.byType(ListView).first,
          matching: find.byType(Scrollable),
        ),
      );
      expect(find.text('F-1 · Bolt oxidation'), findsOneWidget);
      expect(
        find.text(
          'Note: Light surface oxidation on span 2 bolts.',
          findRichText: true,
        ),
        findsOneWidget,
      );

      // Switch to Report tab.
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('download-official-pdf-btn')),
        findsOneWidget,
      );
      expect(find.textContaining('Zone 2 fastener rust'), findsOneWidget);

      // Switch to Settlement tab.
      await tester.tap(find.text('Settlement'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('settlement-download-pdf-btn')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('accept-report-btn')), findsOneWidget);
      expect(
        find.byKey(const Key('request-clarification-btn')),
        findsOneWidget,
      );
      expect(find.text('11,000,000 ₫'), findsOneWidget);
    },
  );

  testWidgets(
    'RegisterPage and ForgotPasswordPage show step progress and password bar',
    (tester) async {
      await tester.pumpWidget(_wrapApp(const RegisterPage(), const []));
      await tester.pumpAndSettle();

      expect(find.text('Account details'), findsOneWidget);
      expect(find.text('Verification'), findsOneWidget);
      expect(find.text('0/15+ characters'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('register-password-field')),
        'StrongPass123456!',
      );
      await tester.pumpAndSettle();
      expect(find.text('17/15+ characters'), findsOneWidget);

      await tester.pumpWidget(_wrapApp(const ForgotPasswordPage(), const []));
      await tester.pumpAndSettle();
      expect(find.text('Verify email'), findsOneWidget);
      expect(find.text('Reset password'), findsWidgets);
    },
  );

  testWidgets(
    'SepayQrDialog shows bank details, SDI transfer content, and settles when check succeeds',
    (tester) async {
      var settled = false;
      const details = SepayCheckoutDetails(
        orderCode: 987654321,
        amount: 5000000,
        paymentLinkId: '987654321',
        checkoutUrl:
            'https://vietqr.app/img?acc=07723264801&bank=TPB&amount=5000000&des=SDI987654321&holder=TEST%20HOLDER',
        qrCode: 'SDI987654321',
      );

      await tester.pumpWidget(
        _wrapApp(
          SepayQrDialog(
            details: details,
            checkPaymentStatus: () async => const ApiResult.success(
              ReportPaymentStatus(
                reportAccepted: true,
                paid: true,
                paymentStatus: 'PAID',
              ),
            ),
            onSettled: () => settled = true,
          ),
          const [],
        ),
      );
      await tester.pump();

      expect(find.text('Sepay VietQR payment'), findsOneWidget);
      expect(find.text('TPB'), findsOneWidget);
      expect(find.text('07723264801'), findsOneWidget);
      expect(find.text('SDI987654321'), findsOneWidget);

      await tester.tap(find.byKey(const Key('sepay-check-status-btn')));
      await tester.pumpAndSettle();

      expect(settled, isTrue);
    },
  );
}
