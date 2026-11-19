/// A single target-defect verdict recorded during a re-inspection.
///
/// Only `RESOLVED` verdicts carry a validity window (`verifiedAt` / `validUntil`).
/// The backend blocks report authoring, submission and publication once that
/// window lapses, so the mobile portal surfaces the expiry compactly.
class ReinspectionVerification {
  const ReinspectionVerification({
    required this.id,
    required this.reinspectionId,
    required this.sourceFindingId,
    required this.resolutionStatus,
    this.sourceFindingCode,
    this.sourceDefectLabel,
    this.sourceSeverity,
    this.sourceTechnicalNotes,
    this.sourceEvidenceId,
    this.sourceEvidenceFileKey,
    this.sourceLocationDescription,
    this.newEvidenceId,
    this.newEvidenceFileKey,
    this.inspectorNotes,
    this.verifiedAt,
    this.validUntil,
    this.createdAt,
    this.updatedAt,
  });

  factory ReinspectionVerification.fromJson(Map<String, dynamic> json) {
    return ReinspectionVerification(
      id: (json['id'] as String?) ?? '',
      reinspectionId: (json['reinspectionId'] as String?) ?? '',
      sourceFindingId: (json['sourceFindingId'] as String?) ?? '',
      resolutionStatus: (json['resolutionStatus'] as String?) ?? '',
      sourceFindingCode: json['sourceFindingCode'] as String?,
      sourceDefectLabel: json['sourceDefectLabel'] as String?,
      sourceSeverity: json['sourceSeverity'] as String?,
      sourceTechnicalNotes: json['sourceTechnicalNotes'] as String?,
      sourceEvidenceId: json['sourceEvidenceId'] as String?,
      sourceEvidenceFileKey: json['sourceEvidenceFileKey'] as String?,
      sourceLocationDescription: json['sourceLocationDescription'] as String?,
      newEvidenceId: json['newEvidenceId'] as String?,
      newEvidenceFileKey: json['newEvidenceFileKey'] as String?,
      inspectorNotes: json['inspectorNotes'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
      validUntil: json['validUntil'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  final String id;
  final String reinspectionId;
  final String sourceFindingId;
  final String resolutionStatus;
  final String? sourceFindingCode;
  final String? sourceDefectLabel;
  final String? sourceSeverity;
  final String? sourceTechnicalNotes;
  final String? sourceEvidenceId;
  final String? sourceEvidenceFileKey;
  final String? sourceLocationDescription;
  final String? newEvidenceId;
  final String? newEvidenceFileKey;
  final String? inspectorNotes;
  final String? verifiedAt;
  final String? validUntil;
  final String? createdAt;
  final String? updatedAt;

  bool get isResolved => resolutionStatus.toUpperCase() == 'RESOLVED';
}
