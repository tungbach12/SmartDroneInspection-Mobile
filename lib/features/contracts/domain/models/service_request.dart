class ServiceRequestMessage {
  const ServiceRequestMessage({
    required this.id,
    required this.authorUserId,
    required this.body,
    required this.createdAt,
    this.authorName,
    this.authorRole,
    this.readAt,
  });

  factory ServiceRequestMessage.fromJson(Map<String, dynamic> json) {
    return ServiceRequestMessage(
      id: json['id'] as String,
      authorUserId: (json['authorUserId'] as String?) ?? '',
      authorName: json['authorName'] as String?,
      authorRole: json['authorRole'] as String?,
      body: (json['body'] as String?) ?? '',
      createdAt: (json['createdAt'] as String?) ?? '',
      readAt: json['readAt'] as String?,
    );
  }

  final String id;
  final String authorUserId;
  final String? authorName;
  final String? authorRole;
  final String body;
  final String createdAt;
  final String? readAt;
}

class ServiceRequestQuote {
  const ServiceRequestQuote({
    required this.id,
    required this.scopeSnapshot,
    required this.firstOccurrenceStartAt,
    required this.firstOccurrenceEndAt,
    required this.inspectorId,
    required this.droneId,
    required this.pricePerOccurrenceUsd,
    required this.rowVersion,
    required this.createdAt,
    required this.updatedAt,
    this.currency,
    this.pricePerOccurrenceVnd,
  });

  factory ServiceRequestQuote.fromJson(Map<String, dynamic> json) {
    return ServiceRequestQuote(
      id: json['id'] as String,
      scopeSnapshot: (json['scopeSnapshot'] as String?) ?? '',
      firstOccurrenceStartAt: (json['firstOccurrenceStartAt'] as String?) ?? '',
      firstOccurrenceEndAt: (json['firstOccurrenceEndAt'] as String?) ?? '',
      inspectorId: (json['inspectorId'] as String?) ?? '',
      droneId: (json['droneId'] as String?) ?? '',
      currency: json['currency'] as String?,
      pricePerOccurrenceVnd: (json['pricePerOccurrenceVnd'] as num?)
          ?.toDouble(),
      pricePerOccurrenceUsd:
          (json['pricePerOccurrenceUsd'] as num?)?.toDouble() ?? 0,
      rowVersion: (json['rowVersion'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] as String?) ?? '',
      updatedAt: (json['updatedAt'] as String?) ?? '',
    );
  }

  final String id;
  final String scopeSnapshot;
  final String firstOccurrenceStartAt;
  final String firstOccurrenceEndAt;
  final String inspectorId;
  final String droneId;
  final String? currency;
  final double? pricePerOccurrenceVnd;
  final double pricePerOccurrenceUsd;
  final int rowVersion;
  final String createdAt;
  final String updatedAt;
}

class ServiceRequestOccurrence {
  const ServiceRequestOccurrence({
    required this.id,
    required this.occurrenceIndex,
    required this.plannedStartAt,
    required this.plannedEndAt,
    required this.status,
    this.inspectorId,
    this.droneId,
    this.inspectionId,
    this.assignedAt,
    this.totalPrice,
    this.paymentStatus,
    this.reportAcceptedAt,
  });

  factory ServiceRequestOccurrence.fromJson(Map<String, dynamic> json) {
    return ServiceRequestOccurrence(
      id: json['id'] as String,
      occurrenceIndex: (json['occurrenceIndex'] as num?)?.toInt() ?? 1,
      plannedStartAt: (json['plannedStartAt'] as String?) ?? '',
      plannedEndAt: (json['plannedEndAt'] as String?) ?? '',
      status: (json['status'] as String?) ?? 'PENDING_ASSIGNMENT',
      inspectorId: json['inspectorId'] as String?,
      droneId: json['droneId'] as String?,
      inspectionId: json['inspectionId'] as String?,
      assignedAt: json['assignedAt'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      paymentStatus: json['paymentStatus'] as String?,
      reportAcceptedAt: json['reportAcceptedAt'] as String?,
    );
  }

  final String id;
  final int occurrenceIndex;
  final String plannedStartAt;
  final String plannedEndAt;
  final String status;
  final String? inspectorId;
  final String? droneId;
  final String? inspectionId;
  final String? assignedAt;
  final double? totalPrice;
  final String? paymentStatus;
  final String? reportAcceptedAt;
}

class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.ownerCustomerId,
    required this.assetId,
    required this.description,
    required this.requestedFrom,
    required this.requestedUntil,
    required this.timezone,
    required this.windowStart,
    required this.windowEnd,
    required this.requestType,
    required this.status,
    required this.createdAt,
    this.recurrenceUnit,
    this.recurrenceInterval,
    this.occurrenceCount,
    this.recurrenceEndDate,
    this.acceptedQuoteId,
    this.acceptedAt,
    this.contractFileName,
    this.contractContentType,
    this.contractSizeBytes,
    this.contractUploadedAt,
    this.currentQuote,
    this.occurrences = const <ServiceRequestOccurrence>[],
    this.messages = const <ServiceRequestMessage>[],
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    final quoteRaw = json['currentQuote'];
    final occRaw = json['occurrences'];
    final msgRaw = json['messages'];
    return ServiceRequest(
      id: json['id'] as String,
      ownerCustomerId: (json['ownerCustomerId'] as String?) ?? '',
      assetId: (json['assetId'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      requestedFrom: (json['requestedFrom'] as String?) ?? '',
      requestedUntil: (json['requestedUntil'] as String?) ?? '',
      timezone: (json['timezone'] as String?) ?? 'Asia/Ho_Chi_Minh',
      windowStart: (json['windowStart'] as String?) ?? '08:00',
      windowEnd: (json['windowEnd'] as String?) ?? '17:00',
      requestType: (json['requestType'] as String?) ?? 'ONE_TIME',
      recurrenceUnit: json['recurrenceUnit'] as String?,
      recurrenceInterval: (json['recurrenceInterval'] as num?)?.toInt(),
      occurrenceCount: (json['occurrenceCount'] as num?)?.toInt(),
      recurrenceEndDate: json['recurrenceEndDate'] as String?,
      status: (json['status'] as String?) ?? 'OPEN',
      acceptedQuoteId: json['acceptedQuoteId'] as String?,
      acceptedAt: json['acceptedAt'] as String?,
      contractFileName: json['contractFileName'] as String?,
      contractContentType: json['contractContentType'] as String?,
      contractSizeBytes: (json['contractSizeBytes'] as num?)?.toInt(),
      contractUploadedAt: json['contractUploadedAt'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
      currentQuote: quoteRaw is Map
          ? ServiceRequestQuote.fromJson(Map<String, dynamic>.from(quoteRaw))
          : null,
      occurrences: occRaw is List
          ? occRaw
                .map(
                  (e) => ServiceRequestOccurrence.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <ServiceRequestOccurrence>[],
      messages: msgRaw is List
          ? msgRaw
                .map(
                  (e) => ServiceRequestMessage.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <ServiceRequestMessage>[],
    );
  }

  final String id;
  final String ownerCustomerId;
  final String assetId;
  final String description;
  final String requestedFrom;
  final String requestedUntil;
  final String timezone;
  final String windowStart;
  final String windowEnd;
  final String requestType;
  final String? recurrenceUnit;
  final int? recurrenceInterval;
  final int? occurrenceCount;
  final String? recurrenceEndDate;
  final String status;
  final String? acceptedQuoteId;
  final String? acceptedAt;
  final String? contractFileName;
  final String? contractContentType;
  final int? contractSizeBytes;
  final String? contractUploadedAt;
  final String createdAt;
  final ServiceRequestQuote? currentQuote;
  final List<ServiceRequestOccurrence> occurrences;
  final List<ServiceRequestMessage> messages;

  /// Matches frontend `getEffectiveRequestStatus`: if occurrences already moved
  /// to ASSIGNED / COMPLETED, elevate OPEN -> ASSIGNED.
  String get effectiveStatus {
    if (status == 'OPEN' &&
        occurrences.any(
          (o) => o.status == 'ASSIGNED' || o.status == 'COMPLETED',
        )) {
      return 'ASSIGNED';
    }
    return status;
  }

  int unreadCountForUser(String? currentUserId) {
    return messages
        .where((m) => m.readAt == null && m.authorUserId != currentUserId)
        .length;
  }
}

class CreateServiceRequestInput {
  const CreateServiceRequestInput({
    required this.assetId,
    required this.requestedFrom,
    required this.requestType,
    this.description,
    this.requestedUntil,
    this.timezone = 'Asia/Ho_Chi_Minh',
    this.windowStart = '08:00',
    this.windowEnd = '17:00',
    this.recurrenceUnit,
    this.recurrenceInterval,
    this.occurrenceCount,
  });

  final String assetId;
  final String? description;
  final String requestedFrom;
  final String? requestedUntil;
  final String timezone;
  final String windowStart;
  final String windowEnd;
  final String requestType;
  final String? recurrenceUnit;
  final int? recurrenceInterval;
  final int? occurrenceCount;

  Map<String, dynamic> toJson() => {
    'assetId': assetId,
    if (description != null && description!.isNotEmpty)
      'description': description,
    'requestedFrom': requestedFrom,
    if (requestedUntil != null && requestedUntil!.isNotEmpty)
      'requestedUntil': requestedUntil,
    'timezone': timezone,
    'windowStart': windowStart,
    'windowEnd': windowEnd,
    'requestType': requestType,
    if (recurrenceUnit != null) 'recurrenceUnit': recurrenceUnit,
    if (recurrenceInterval != null) 'recurrenceInterval': recurrenceInterval,
    if (occurrenceCount != null) 'occurrenceCount': occurrenceCount,
  };
}
