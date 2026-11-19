import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_session.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/auth_user.dart';
import 'package:smart_drone_inspection/features/auth/domain/models/user_role.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_chat.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/reinspection_verification.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/inspection_detail_page.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

const _pdfBytes = [37, 80, 68, 70];

Map<String, dynamic> _threadJson() => {
  'inspectionId': 'insp-1',
  'assetName': 'Nhat Tan Bridge',
  'counterpartName': 'Pham Van Bay',
  'counterpartRole': 'INSPECTOR',
  'messages': [
    {
      'id': 'msg-1',
      'inspectionId': 'insp-1',
      'authorUserId': 'inspector-1',
      'authorName': 'Pham Van Bay',
      'authorRole': 'INSPECTOR',
      'body': 'Field evidence uploaded.',
      'createdAt': '2026-11-18T09:00:00Z',
      'attachments': [
        {
          'id': 'att-1',
          'fileName': 'site.jpg',
          'contentType': 'image/jpeg',
          'sizeBytes': 1024,
        },
      ],
    },
  ],
};

class StubAuthNotifier extends AuthNotifier {
  @override
  Future<AuthSession> build() async {
    return AuthSession.authenticated(
      const AuthUser(
        id: 'customer-1',
        email: 'customer@test.com',
        fullName: 'Customer',
        roles: [UserRole.customer],
      ),
    );
  }
}

class StubInspectionRepository extends InspectionRepository {
  StubInspectionRepository() : super(Dio());

  @override
  Future<ApiResult<InspectionChatThread>> getInspectionChat(
    String inspectionId,
  ) async {
    return ApiResult.success(InspectionChatThread.fromJson(_threadJson()));
  }

  @override
  Future<ApiResult<InspectionChatThread>> markInspectionMessagesRead(
    String inspectionId,
  ) async {
    return ApiResult.success(InspectionChatThread.fromJson(_threadJson()));
  }
}

void main() {
  group('inspection Customer feature repository', () {
    late Dio dio;
    late InspectionRepository repository;
    late List<RequestOptions> requests;

    setUp(() {
      requests = [];
      dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            switch (options.path) {
              case '/inspections/insp-1/reinspection-verifications':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: [
                      {
                        'id': 'verif-1',
                        'reinspectionId': 're-1',
                        'sourceFindingId': 'f-1',
                        'resolutionStatus': 'RESOLVED',
                        'verifiedAt': '2026-11-01T08:00:00Z',
                        'validUntil': '2026-12-01T08:00:00Z',
                      },
                    ],
                  ),
                );
              case '/inspections/insp-1/report/payment-document':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: _pdfBytes,
                  ),
                );
              case '/inspections/insp-1/report/payment-status':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'reportAccepted': true,
                      'paid': false,
                      'paymentStatus': 'PAYMENT_DUE',
                      'amount': 11000000,
                      'paymentDueAt': '2026-01-01T00:00:00Z',
                    },
                  ),
                );
              case '/inspections/insp-1/messages':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: options.method == 'POST' ? 201 : 200,
                    data: _threadJson(),
                  ),
                );
              case '/inspections/insp-1/messages/read':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: _threadJson(),
                  ),
                );
              case '/inspections/insp-1/messages/msg-1/attachments/att-1':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: _pdfBytes,
                  ),
                );
              case '/inspections/insp-1/knowledge-recommendations':
                handler.resolve(
                  Response(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'retrievalMode': 'HYBRID',
                      'cases': [
                        {
                          'id': 'case-1',
                          'defectLabel': 'Bolt corrosion',
                          'similarity': 0.92,
                          'technicalNotes': 'Reseal joint',
                          'outcome': 'RESOLVED',
                        },
                      ],
                      'guidelines': [
                        {
                          'id': 'g-1',
                          'standardCode': 'TCVN 9343:2012',
                          'similarity': 0.8,
                        },
                      ],
                    },
                  ),
                );
              default:
                handler.reject(DioException(requestOptions: options));
            }
          },
        ),
      );
      repository = InspectionRepository(dio);
    });

    test('downloadPaymentDocument returns notice/receipt PDF bytes', () async {
      final res = await repository.downloadPaymentDocument('insp-1');
      expect(res, isA<ApiSuccess<Uint8List>>());
      expect(
        (res as ApiSuccess<Uint8List>).data,
        Uint8List.fromList(_pdfBytes),
      );
      expect(requests.last.path, '/inspections/insp-1/report/payment-document');
    });

    test('payment status parses due date and overdue calculation', () async {
      final res = await repository.getReportPaymentStatus('insp-1');
      final status = (res as ApiSuccess<ReportPaymentStatus>).data;
      expect(status.isPaymentDue, isTrue);
      expect(status.paymentDueAt, '2026-01-01T00:00:00Z');
      expect(status.isPaymentOverdue(DateTime.utc(2026, 11, 19)), isTrue);
      expect(status.isPaymentOverdue(DateTime.utc(2025, 12, 1)), isFalse);
    });

    test('re-inspection verdicts expose verifiedAt and validUntil', () async {
      final res = await repository.listReinspectionVerifications('insp-1');
      final item =
          (res as ApiSuccess<List<ReinspectionVerification>>).data.single;
      expect(item.isResolved, isTrue);
      expect(item.verifiedAt, '2026-11-01T08:00:00Z');
      expect(item.validUntil, '2026-12-01T08:00:00Z');
    });

    test(
      'chat thread, multipart post, read, and attachment download',
      () async {
        final thread = await repository.getInspectionChat('insp-1');
        expect(
          (thread as ApiSuccess<InspectionChatThread>)
              .data
              .messages
              .single
              .body,
          'Field evidence uploaded.',
        );
        expect(thread.data.messages.single.attachments.single.isImage, isTrue);

        final posted = await repository.postInspectionMessage(
          inspectionId: 'insp-1',
          body: 'Please confirm.',
          files: [
            InspectionChatAttachmentInput(
              fileName: 'notes.txt',
              bytes: Uint8List.fromList([1, 2, 3]),
            ),
          ],
        );
        expect(posted, isA<ApiSuccess<InspectionChatThread>>());
        final form = requests.last.data as FormData;
        expect(
          form.fields.firstWhere((e) => e.key == 'body').value,
          'Please confirm.',
        );
        expect(form.files, hasLength(1));
        expect(form.files.first.key, 'files');

        final read = await repository.markInspectionMessagesRead('insp-1');
        expect(read, isA<ApiSuccess<InspectionChatThread>>());
        expect(requests.last.method, 'POST');

        final attachment = await repository.downloadInspectionMessageAttachment(
          inspectionId: 'insp-1',
          messageId: 'msg-1',
          attachmentId: 'att-1',
        );
        expect(
          (attachment as ApiSuccess<Uint8List>).data,
          Uint8List.fromList(_pdfBytes),
        );
      },
    );

    test(
      'knowledge recommendations request limit=4 and parse payload',
      () async {
        final res = await repository.getKnowledgeRecommendations('insp-1');
        expect(requests.last.queryParameters['limit'], 4);
        final data = (res as ApiSuccess).data;
        expect(data.cases.single.matchPercent, 92);
        expect(data.guidelines.single.standardCode, 'TCVN 9343:2012');
      },
    );
  });

  group('inspection detail compact Customer UI', () {
    testWidgets('shows verdict banner, payment badge, PDF action, and chat', (
      tester,
    ) async {
      final past = DateTime.now().subtract(const Duration(days: 1));
      final bundle = CustomerInspectionBundle(
        inspection: Inspection(
          id: 'insp-1',
          assetId: 'a-1',
          assetName: 'Nhat Tan Bridge',
          status: 'COMPLETED',
          reportStatus: 'PUBLISHED',
          paymentStatus: 'PAYMENT_DUE',
        ),
        reportVersions: [
          const InspectionReportVersion(
            id: 'ver-1',
            versionNo: 1,
            status: 'PUBLISHED',
            createdAt: '2026-10-02T08:00:00Z',
          ),
        ],
        paymentStatus: ReportPaymentStatus(
          reportAccepted: true,
          paid: false,
          paymentStatus: 'PAYMENT_DUE',
          paymentDueAt: past.toIso8601String(),
        ),
        reinspectionVerifications: [
          ReinspectionVerification.fromJson({
            'id': 'verif-1',
            'reinspectionId': 're-1',
            'sourceFindingId': 'f-1',
            'resolutionStatus': 'RESOLVED',
            'validUntil': past.toIso8601String(),
          }),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(StubAuthNotifier.new),
            inspectionRepositoryProvider.overrideWithValue(
              StubInspectionRepository(),
            ),
            inspectionBundleProvider('insp-1')
                .overrideWith((ref) async => bundle),
            reportAiSummaryProvider((
              inspectionId: 'insp-1',
              versionId: 'ver-1',
            )).overrideWith((ref) async => null),
            knowledgeRecommendationsProvider('insp-1')
                .overrideWith((ref) async => null),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            supportedLocales: const [Locale('en'), Locale('vi')],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const InspectionDetailPage(inspectionId: 'insp-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('verdict-expiry-banner')), findsOneWidget);
      expect(find.text('1 verdicts expired'), findsOneWidget);
      expect(find.byKey(const Key('inspection-chat-btn')), findsOneWidget);

      await tester.tap(find.text('Settlement'));
      await tester.pumpAndSettle();
      expect(find.text('Overdue'), findsOneWidget);
      expect(find.byKey(const Key('payment-document-btn')), findsOneWidget);
      expect(find.text('Notice PDF'), findsOneWidget);

      await tester.tap(find.byKey(const Key('inspection-chat-btn')));
      await tester.pumpAndSettle();
      expect(find.text('Inspection chat'), findsOneWidget);
      expect(find.text('Field evidence uploaded.'), findsOneWidget);
      expect(find.text('site.jpg'), findsOneWidget);
    });
  });
}
