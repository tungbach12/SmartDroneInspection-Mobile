class InspectorRatingItem {
  const InspectorRatingItem({
    required this.id,
    required this.inspectionId,
    required this.inspectorId,
    required this.raterUserId,
    required this.raterRole,
    required this.overallScore,
    required this.criterionScores,
    required this.createdAt,
    required this.updatedAt,
    required this.editableUntil,
    required this.editable,
    this.raterName,
    this.assetName,
    this.comment,
  });

  factory InspectorRatingItem.fromJson(Map<String, dynamic> json) {
    final criteriaRaw = json['criterionScores'];
    final criteria = <String, int>{};
    if (criteriaRaw is Map) {
      for (final entry in criteriaRaw.entries) {
        final v = entry.value;
        if (v is num) {
          criteria[entry.key.toString()] = v.toInt();
        }
      }
    }
    return InspectorRatingItem(
      id: (json['id'] as String?) ?? '',
      inspectionId: (json['inspectionId'] as String?) ?? '',
      inspectorId: (json['inspectorId'] as String?) ?? '',
      raterUserId: (json['raterUserId'] as String?) ?? '',
      raterRole: (json['raterRole'] as String?) ?? 'CUSTOMER',
      raterName: json['raterName'] as String?,
      assetName: json['assetName'] as String?,
      overallScore: (json['overallScore'] as num?)?.toInt() ?? 5,
      criterionScores: criteria,
      comment: json['comment'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
      updatedAt: (json['updatedAt'] as String?) ?? '',
      editableUntil: (json['editableUntil'] as String?) ?? '',
      editable: (json['editable'] as bool?) ?? false,
    );
  }

  final String id;
  final String inspectionId;
  final String inspectorId;
  final String raterUserId;
  final String raterRole;
  final String? raterName;
  final String? assetName;
  final int overallScore;
  final Map<String, int> criterionScores;
  final String? comment;
  final String createdAt;
  final String updatedAt;
  final String editableUntil;
  final bool editable;
}

class InspectorRatingBundle {
  const InspectorRatingBundle({
    required this.inspectionId,
    required this.canRate,
    required this.actorRole,
    this.inspectorId,
    this.inspectorName,
    this.ineligibleReason,
    this.expectedCriteriaKeys = const <String>[],
    this.editableUntil,
    this.myRating,
    this.inspectorAverageRating,
    this.inspectorRatingCount = 0,
  });

  factory InspectorRatingBundle.fromJson(Map<String, dynamic> json) {
    final keysRaw = json['expectedCriteriaKeys'];
    final myRaw = json['myRating'];
    return InspectorRatingBundle(
      inspectionId: (json['inspectionId'] as String?) ?? '',
      inspectorId: json['inspectorId'] as String?,
      inspectorName: json['inspectorName'] as String?,
      canRate: (json['canRate'] as bool?) ?? false,
      ineligibleReason: json['ineligibleReason'] as String?,
      actorRole: (json['actorRole'] as String?) ?? 'CUSTOMER',
      expectedCriteriaKeys: keysRaw is List
          ? keysRaw.map((e) => e.toString()).toList()
          : const <String>[],
      editableUntil: json['editableUntil'] as String?,
      myRating: myRaw is Map
          ? InspectorRatingItem.fromJson(Map<String, dynamic>.from(myRaw))
          : null,
      inspectorAverageRating: (json['inspectorAverageRating'] as num?)?.toDouble(),
      inspectorRatingCount: (json['inspectorRatingCount'] as num?)?.toInt() ?? 0,
    );
  }

  final String inspectionId;
  final String? inspectorId;
  final String? inspectorName;
  final bool canRate;
  final String? ineligibleReason;
  final String actorRole;
  final List<String> expectedCriteriaKeys;
  final String? editableUntil;
  final InspectorRatingItem? myRating;
  final double? inspectorAverageRating;
  final int inspectorRatingCount;
}

class UpsertInspectorRatingRequest {
  const UpsertInspectorRatingRequest({
    required this.overallScore,
    required this.criterionScores,
    this.comment,
  });

  final int overallScore;
  final Map<String, int> criterionScores;
  final String? comment;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'overallScore': overallScore,
        'criterionScores': criterionScores,
        if (comment != null && comment!.trim().isNotEmpty)
          'comment': comment!.trim(),
      };
}
