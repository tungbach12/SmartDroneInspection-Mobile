/// A historical inspection case retrieved by DroneKnowledgeAI (FE-06/FE-07).
class KnowledgeCase {
  const KnowledgeCase({
    required this.id,
    this.defectLabel,
    this.severity,
    this.assetCategory,
    this.assetLabel,
    this.sameAsset = false,
    this.sameOrganization = false,
    this.similarity = 0,
    this.technicalNotes,
    this.outcome,
    this.publishedAt,
  });

  factory KnowledgeCase.fromJson(Map<String, dynamic> json) {
    return KnowledgeCase(
      id: (json['id'] as String?) ?? '',
      defectLabel: json['defectLabel'] as String?,
      severity: json['severity'] as String?,
      assetCategory: json['assetCategory'] as String?,
      assetLabel: json['assetLabel'] as String?,
      sameAsset: (json['sameAsset'] as bool?) ?? false,
      sameOrganization: (json['sameOrganization'] as bool?) ?? false,
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0,
      technicalNotes: json['technicalNotes'] as String?,
      outcome: json['outcome'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  final String id;
  final String? defectLabel;
  final String? severity;
  final String? assetCategory;
  final String? assetLabel;
  final bool sameAsset;
  final bool sameOrganization;
  final double similarity;
  final String? technicalNotes;
  final String? outcome;
  final String? publishedAt;

  /// Whole-number percentage for compact chip labels.
  int get matchPercent => (similarity.clamp(0, 1) * 100).round();
}

/// A technical standard / repair norm retrieved by DroneKnowledgeAI.
class KnowledgeGuideline {
  const KnowledgeGuideline({
    required this.id,
    this.standardCode,
    this.title,
    this.severity,
    this.similarity = 0,
    this.guidance,
    this.referenceUrl,
  });

  factory KnowledgeGuideline.fromJson(Map<String, dynamic> json) {
    return KnowledgeGuideline(
      id: (json['id'] as String?) ?? '',
      standardCode: json['standardCode'] as String?,
      title: json['title'] as String?,
      severity: json['severity'] as String?,
      similarity: (json['similarity'] as num?)?.toDouble() ?? 0,
      guidance: json['guidance'] as String?,
      referenceUrl: json['referenceUrl'] as String?,
    );
  }

  final String id;
  final String? standardCode;
  final String? title;
  final String? severity;
  final double similarity;
  final String? guidance;
  final String? referenceUrl;

  int get matchPercent => (similarity.clamp(0, 1) * 100).round();
}

/// Payload of `GET /inspections/{id}/knowledge-recommendations?limit=4`.
class KnowledgeRecommendationResponse {
  const KnowledgeRecommendationResponse({
    this.retrievalMode,
    this.cases = const <KnowledgeCase>[],
    this.guidelines = const <KnowledgeGuideline>[],
  });

  factory KnowledgeRecommendationResponse.fromJson(Map<String, dynamic> json) {
    final casesRaw = json['cases'];
    final guidelinesRaw = json['guidelines'];
    return KnowledgeRecommendationResponse(
      retrievalMode: json['retrievalMode'] as String?,
      cases: casesRaw is List
          ? casesRaw
                .map(
                  (e) => KnowledgeCase.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <KnowledgeCase>[],
      guidelines: guidelinesRaw is List
          ? guidelinesRaw
                .map(
                  (e) => KnowledgeGuideline.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <KnowledgeGuideline>[],
    );
  }

  final String? retrievalMode;
  final List<KnowledgeCase> cases;
  final List<KnowledgeGuideline> guidelines;

  bool get isEmpty => cases.isEmpty && guidelines.isEmpty;
}
