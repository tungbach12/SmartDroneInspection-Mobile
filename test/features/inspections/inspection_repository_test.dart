import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';

void main() {
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
          if (options.method == 'GET' && options.path == '/inspections') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'items': [_inspectionJson()],
                  'totalCount': 1,
                },
              ),
            );
            return;
          }
          if (options.method == 'GET' &&
              options.path == '/inspections/insp-1/report/versions') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {
                    'id': 'ver-1',
                    'versionNo': 2,
                    'status': 'PUBLISHED',
                    'createdAt': '2026-10-02T08:00:00Z',
                    'publishedAt': '2026-10-03T10:00:00Z',
                    'reportContext': {
                      'flightPermitFileName': 'permit-2026.pdf',
                      'assignedDrone': {
                        'manufacturer': 'DJI',
                        'model': 'Matrice 350 RTK',
                        'serialNumber': 'SN-001',
                      },
                    },
                  },
                ],
              ),
            );
            return;
          }
          if (options.method == 'GET' &&
              options.path ==
                  '/inspections/insp-1/report/versions/ver-1/ai-summary') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'summary': 'Minor joint corrosion observed.',
                  'keyHighlights': ['Joint A needs resealing'],
                  'recommendedActions': 'Schedule repair within 30 days.',
                  'overallRisk': 'MEDIUM',
                },
              ),
            );
            return;
          }
          if (options.method == 'GET' &&
              options.path ==
                  '/inspections/insp-1/report/versions/ver-1/document') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [37, 80, 68, 70],
              ),
            );
            return;
          }
          if (options.method == 'POST' &&
              options.path ==
                  '/inspections/insp-1/report/versions/ver-1/accept') {
            handler.resolve(Response(requestOptions: options, statusCode: 204));
            return;
          }
          if (options.method == 'POST' &&
              options.path ==
                  '/inspections/insp-1/report/versions/ver-1/clarification') {
            handler.resolve(Response(requestOptions: options, statusCode: 200));
            return;
          }
          if (options.method == 'GET' &&
              options.path == '/inspections/insp-1/report/payment-status') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'reportAccepted': true,
                  'paid': false,
                  'paymentStatus': 'PAYMENT_DUE',
                  'amount': 11000000,
                  'serviceBaseAmount': 10000000,
                  'vatRate': 10,
                  'vatAmount': 1000000,
                },
              ),
            );
            return;
          }
          if (options.method == 'POST' &&
              options.path == '/inspections/insp-1/sepay/create-payment-link') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'orderCode': 998877,
                  'amount': 11000000,
                  'paymentLinkId': 'pl-1',
                  'checkoutUrl': 'https://pay.sepay.vn/web/998877',
                  'qrCode': '000201010212...',
                },
              ),
            );
            return;
          }
          if (options.method == 'POST' &&
              options.path == '/inspections/insp-1/vnpay/create-payment-url') {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'orderCode': 556677,
                  'amount': 11000000,
                  'txnRef': 'TXN556677',
                  'checkoutUrl':
                      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
                },
              ),
            );
            return;
          }
          handler.reject(DioException(requestOptions: options));
        },
      ),
    );
    repository = InspectionRepository(dio);
  });

  test('listInspections unwraps paginated items map', () async {
    final result = await repository.listInspections();
    expect(result, isA<ApiSuccess<List<Inspection>>>());
    final items = (result as ApiSuccess<List<Inspection>>).data;
    expect(items, hasLength(1));
    expect(items.first.id, 'insp-1');
    expect(items.first.hasPublishedReport, isTrue);
  });

  test('listReportVersions, ai-summary, and PDF download parse Customer deliverable', () async {
    final versions = await repository.listReportVersions('insp-1');
    expect(versions, isA<ApiSuccess<List<InspectionReportVersion>>>());
    final v =
        (versions as ApiSuccess<List<InspectionReportVersion>>).data.single;
    expect(v.versionNo, 2);
    expect(v.droneSummary, 'DJI · Matrice 350 RTK · SN-001');
    expect(v.flightPermitFileName, 'permit-2026.pdf');

    final ai = await repository.getReportAiSummary(
      inspectionId: 'insp-1',
      versionId: 'ver-1',
    );
    expect(ai, isA<ApiSuccess<ReportAiSummary>>());
    expect((ai as ApiSuccess<ReportAiSummary>).data.overallRisk, 'MEDIUM');

    final pdf = await repository.downloadOfficialReportPdf(
      inspectionId: 'insp-1',
      versionId: 'ver-1',
    );
    expect(pdf, isA<ApiSuccess<Uint8List>>());
    expect(
      (pdf as ApiSuccess<Uint8List>).data,
      Uint8List.fromList([37, 80, 68, 70]),
    );
  });

  test('settlement flow calls accept, clarification with reason query, Sepay, and VNPay', () async {
    final acceptRes = await repository.acceptReport(
      inspectionId: 'insp-1',
      versionId: 'ver-1',
    );
    expect(acceptRes, isA<ApiSuccess<void>>());

    final clarRes = await repository.requestReportClarification(
      inspectionId: 'insp-1',
      versionId: 'ver-1',
      reason: 'Verify north tower cable close-up.',
    );
    expect(clarRes, isA<ApiSuccess<void>>());
    expect(
      requests.last.queryParameters['reason'],
      'Verify north tower cable close-up.',
    );

    final paymentStatus = await repository.getReportPaymentStatus('insp-1');
    expect(paymentStatus, isA<ApiSuccess<ReportPaymentStatus>>());
    expect((paymentStatus as ApiSuccess<ReportPaymentStatus>).data.vatRate, 10);

    final sepay = await repository.createSepayPaymentLink('insp-1');
    expect((sepay as ApiSuccess<SepayCheckoutDetails>).data.orderCode, 998877);

    final vnpay = await repository.createVnpayPaymentUrl('insp-1');
    expect(
      (vnpay as ApiSuccess<VnpayCheckoutDetails>).data.txnRef,
      'TXN556677',
    );
  });
}

Map<String, dynamic> _inspectionJson() => {
  'id': 'insp-1',
  'assetId': 'asset-1',
  'assetName': 'Cau Nhat Tan',
  'status': 'COMPLETED',
  'reportStatus': 'PUBLISHED',
  'reportVersionNo': 2,
  'paymentStatus': 'PAYMENT_DUE',
};
