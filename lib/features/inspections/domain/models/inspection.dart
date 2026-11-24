class Inspection {
  const Inspection({
    required this.id,
    required this.assetId,
    required this.status,
    this.ownerCustomerId,
    this.assetName,
    this.assetCode,
    this.assetLocation,
    this.locationText,
    this.objective,
    this.inspectorId,
    this.inspectorName,
    this.inspectorAverageRating,
    this.inspectorRatingCount = 0,
    this.managerName,
    this.managerEmail,
    this.managerPhone,
    this.paymentDueAt,
    this.droneId,
    this.droneSerialNumber,
    this.droneModel,
    this.flightPermitFileKey,
    this.flightPermitFileName,
    this.flightPermitUploadedAt,
    this.plannedStartAt,
    this.plannedEndAt,
    this.inspectionItems = const <String>[],
    this.reportId,
    this.reportStatus,
    this.reportVersionNo,
    this.reportAccepted,
    this.paymentStatus,
    this.paymentAmount,
    this.clarificationCount = 0,
  });

  factory Inspection.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['inspectionItems'];
    return Inspection(
      id: json['id'] as String,
      ownerCustomerId: json['ownerCustomerId'] as String?,
      assetId: (json['assetId'] as String?) ?? '',
      assetName: json['assetName'] as String?,
      assetCode: json['assetCode'] as String?,
      assetLocation: json['assetLocation'] as String?,
      locationText: json['locationText'] as String?,
      objective: json['objective'] as String?,
      inspectorId: json['inspectorId'] as String?,
      inspectorName: json['inspectorName'] as String?,
      inspectorAverageRating: (json['inspectorAverageRating'] as num?)
          ?.toDouble(),
      inspectorRatingCount:
          (json['inspectorRatingCount'] as num?)?.toInt() ?? 0,
      managerName: json['managerName'] as String?,
      managerEmail: json['managerEmail'] as String?,
      managerPhone: json['managerPhone'] as String?,
      paymentDueAt: json['paymentDueAt'] as String?,
      droneId: json['droneId'] as String?,
      droneSerialNumber: json['droneSerialNumber'] as String?,
      droneModel: json['droneModel'] as String?,
      status: (json['status'] as String?) ?? 'SCHEDULED',
      flightPermitFileKey: json['flightPermitFileKey'] as String?,
      flightPermitFileName: json['flightPermitFileName'] as String?,
      flightPermitUploadedAt: json['flightPermitUploadedAt'] as String?,
      plannedStartAt: json['plannedStartAt'] as String?,
      plannedEndAt: json['plannedEndAt'] as String?,
      inspectionItems: itemsRaw is List
          ? itemsRaw.map((e) => e.toString()).toList()
          : const <String>[],
      reportId: json['reportId'] as String?,
      reportStatus: json['reportStatus'] as String?,
      reportVersionNo: (json['reportVersionNo'] as num?)?.toInt(),
      reportAccepted: json['reportAccepted'] as bool?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentAmount: (json['paymentAmount'] as num?)?.toDouble(),
      clarificationCount: (json['clarificationCount'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String? ownerCustomerId;
  final String assetId;
  final String? assetName;
  final String? assetCode;
  final String? assetLocation;
  final String? locationText;
  final String? objective;
  final String? inspectorId;
  final String? inspectorName;
  final double? inspectorAverageRating;
  final int inspectorRatingCount;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final String? paymentDueAt;
  final String? droneId;
  final String? droneSerialNumber;
  final String? droneModel;
  final String status;
  final String? flightPermitFileKey;
  final String? flightPermitFileName;
  final String? flightPermitUploadedAt;
  final String? plannedStartAt;
  final String? plannedEndAt;
  final List<String> inspectionItems;
  final String? reportId;
  final String? reportStatus;
  final int? reportVersionNo;
  final bool? reportAccepted;
  final String? paymentStatus;
  final double? paymentAmount;
  final int clarificationCount;

  bool get hasPublishedReport => reportStatus == 'PUBLISHED';
  bool get isPaid => (paymentStatus ?? '').toUpperCase() == 'PAID';
}

class InspectionWorkflowState {
  const InspectionWorkflowState({
    required this.status,
    this.findingsConfirmedAt,
  });

  factory InspectionWorkflowState.fromJson(Map<String, dynamic> json) {
    return InspectionWorkflowState(
      status: (json['status'] as String?) ?? 'SCHEDULED',
      findingsConfirmedAt: json['findingsConfirmedAt'] as String?,
    );
  }

  final String status;
  final String? findingsConfirmedAt;
}

class FieldSessionSummary {
  const FieldSessionSummary({
    required this.id,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.preFlightChecklistNote,
    this.postponementReason,
    this.abortReason,
    this.outcomeNotes,
    this.droneSerialNumber,
    this.droneManufacturer,
    this.droneModel,
  });

  factory FieldSessionSummary.fromJson(Map<String, dynamic> json) {
    return FieldSessionSummary(
      id: json['id'] as String,
      status: (json['status'] as String?) ?? 'PLANNED',
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
      preFlightChecklistNote: json['preFlightChecklistNote'] as String?,
      postponementReason: json['postponementReason'] as String?,
      abortReason: json['abortReason'] as String?,
      outcomeNotes: json['outcomeNotes'] as String?,
      droneSerialNumber: json['droneSerialNumber'] as String?,
      droneManufacturer: json['droneManufacturer'] as String?,
      droneModel: json['droneModel'] as String?,
    );
  }

  final String id;
  final String status;
  final String? startedAt;
  final String? endedAt;
  final String? preFlightChecklistNote;
  final String? postponementReason;
  final String? abortReason;
  final String? outcomeNotes;
  final String? droneSerialNumber;
  final String? droneManufacturer;
  final String? droneModel;
}

class InspectionFinding {
  const InspectionFinding({
    required this.id,
    required this.inspectionId,
    required this.status,
    required this.findingCode,
    required this.defectLabel,
    required this.severity,
    required this.technicalNotes,
    this.evidenceId,
    this.modelName,
    this.confidence,
    this.isDeleted = false,
  });

  factory InspectionFinding.fromJson(Map<String, dynamic> json) {
    return InspectionFinding(
      id: json['id'] as String,
      inspectionId: (json['inspectionId'] as String?) ?? '',
      evidenceId: json['evidenceId'] as String?,
      status: (json['status'] as String?) ?? 'PENDING',
      findingCode: (json['findingCode'] as String?) ?? '',
      defectLabel: (json['defectLabel'] as String?) ?? '',
      severity: (json['severity'] as String?) ?? 'LOW',
      technicalNotes: (json['technicalNotes'] as String?) ?? '',
      modelName: json['modelName'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      isDeleted: (json['isDeleted'] as bool?) ?? false,
    );
  }

  final String id;
  final String inspectionId;
  final String? evidenceId;
  final String status;
  final String findingCode;
  final String defectLabel;
  final String severity;
  final String technicalNotes;
  final String? modelName;
  final double? confidence;
  final bool isDeleted;
}

class InspectionReportVersion {
  const InspectionReportVersion({
    required this.id,
    required this.versionNo,
    required this.status,
    required this.createdAt,
    this.inspectionReportId,
    this.submittedAt,
    this.reviewedAt,
    this.returnReason,
    this.publishedAt,
    this.summary,
    this.clarificationRequested = false,
    this.droneSummary,
    this.flightPermitFileName,
  });

  factory InspectionReportVersion.fromJson(Map<String, dynamic> json) {
    final ctx = json['reportContext'];
    String? droneSummary;
    String? permitName;
    if (ctx is Map) {
      final drone = ctx['assignedDrone'];
      if (drone is Map) {
        final parts =
            [
                  drone['manufacturer']?.toString(),
                  drone['model']?.toString(),
                  drone['serialNumber']?.toString(),
                ]
                .where((e) => e != null && e.trim().isNotEmpty)
                .cast<String>()
                .toList();
        if (parts.isNotEmpty) droneSummary = parts.join(' · ');
      }
      permitName = ctx['flightPermitFileName'] as String?;
    }
    return InspectionReportVersion(
      id: json['id'] as String,
      inspectionReportId: json['inspectionReportId'] as String?,
      versionNo: (json['versionNo'] as num?)?.toInt() ?? 1,
      status: (json['status'] as String?) ?? 'DRAFT',
      submittedAt: json['submittedAt'] as String?,
      reviewedAt: json['reviewedAt'] as String?,
      returnReason: json['returnReason'] as String?,
      publishedAt: json['publishedAt'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
      summary: json['summary'] as String?,
      clarificationRequested:
          (json['clarificationRequested'] as bool?) ?? false,
      droneSummary: droneSummary,
      flightPermitFileName: permitName,
    );
  }

  final String id;
  final String? inspectionReportId;
  final int versionNo;
  final String status;
  final String? submittedAt;
  final String? reviewedAt;
  final String? returnReason;
  final String? publishedAt;
  final String createdAt;
  final String? summary;
  final bool clarificationRequested;
  final String? droneSummary;
  final String? flightPermitFileName;

  bool get isPublished => status == 'PUBLISHED';
}

class ReportAiSummary {
  const ReportAiSummary({
    required this.summary,
    required this.keyHighlights,
    required this.recommendedActions,
    required this.overallRisk,
  });

  factory ReportAiSummary.fromJson(Map<String, dynamic> json) {
    final rawHighlights = json['keyHighlights'];
    return ReportAiSummary(
      summary: (json['summary'] as String?) ?? '',
      keyHighlights: rawHighlights is List
          ? rawHighlights.map((e) => e.toString()).toList()
          : const <String>[],
      recommendedActions: (json['recommendedActions'] as String?) ?? '',
      overallRisk: (json['overallRisk'] as String?) ?? 'LOW',
    );
  }

  final String summary;
  final List<String> keyHighlights;
  final String recommendedActions;
  final String overallRisk;
}

class ReportPaymentStatus {
  const ReportPaymentStatus({
    required this.reportAccepted,
    required this.paid,
    required this.paymentStatus,
    this.orderCode,
    this.amount,
    this.checkoutUrl,
    this.serviceBaseAmount,
    this.vatRate,
    this.vatAmount,
    this.paymentMethod,
    this.paymentReference,
    this.paymentDueAt,
  });

  factory ReportPaymentStatus.fromJson(Map<String, dynamic> json) {
    return ReportPaymentStatus(
      reportAccepted: (json['reportAccepted'] as bool?) ?? false,
      paid: (json['paid'] as bool?) ?? false,
      paymentStatus: (json['paymentStatus'] as String?) ?? 'PENDING',
      orderCode: (json['orderCode'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      checkoutUrl: json['checkoutUrl'] as String?,
      serviceBaseAmount: (json['serviceBaseAmount'] as num?)?.toDouble(),
      vatRate: (json['vatRate'] as num?)?.toDouble(),
      vatAmount: (json['vatAmount'] as num?)?.toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      paymentReference: json['paymentReference'] as String?,
      paymentDueAt: json['paymentDueAt'] as String?,
    );
  }

  final bool reportAccepted;
  final bool paid;
  final String paymentStatus;
  final int? orderCode;
  final double? amount;
  final String? checkoutUrl;
  final double? serviceBaseAmount;
  final double? vatRate;
  final double? vatAmount;
  final String? paymentMethod;
  final String? paymentReference;
  final String? paymentDueAt;

  bool get isPaymentDue => paymentStatus.toUpperCase() == 'PAYMENT_DUE';

  /// True once the Net-15 window has lapsed (used for the compact overdue chip).
  bool isPaymentOverdue([DateTime? now]) {
    if (paymentDueAt == null) return false;
    final due = DateTime.tryParse(paymentDueAt!)?.toLocal();
    if (due == null) return false;
    return !(now ?? DateTime.now()).isBefore(due);
  }
}

class SepayCheckoutDetails {
  const SepayCheckoutDetails({
    required this.orderCode,
    required this.amount,
    required this.paymentLinkId,
    required this.checkoutUrl,
    required this.qrCode,
  });

  factory SepayCheckoutDetails.fromJson(Map<String, dynamic> json) {
    return SepayCheckoutDetails(
      orderCode: (json['orderCode'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paymentLinkId: (json['paymentLinkId'] as String?) ?? '',
      checkoutUrl: (json['checkoutUrl'] as String?) ?? '',
      qrCode: (json['qrCode'] as String?) ?? '',
    );
  }

  final int orderCode;
  final double amount;
  final String paymentLinkId;
  final String checkoutUrl;
  final String qrCode;
}

class VnpayCheckoutDetails {
  const VnpayCheckoutDetails({
    required this.orderCode,
    required this.amount,
    required this.txnRef,
    required this.checkoutUrl,
  });

  factory VnpayCheckoutDetails.fromJson(Map<String, dynamic> json) {
    return VnpayCheckoutDetails(
      orderCode: (json['orderCode'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      txnRef: (json['txnRef'] as String?) ?? '',
      checkoutUrl: (json['checkoutUrl'] as String?) ?? '',
    );
  }

  final int orderCode;
  final double amount;
  final String txnRef;
  final String checkoutUrl;
}
