import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/network/api_failure.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_chat.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_evidence.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/knowledge_recommendation.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/reinspection_verification.dart';

class CustomerInspectionBundle {
  const CustomerInspectionBundle({
    required this.inspection,
    this.workflowState,
    this.fieldSessions = const <FieldSessionSummary>[],
    this.evidence = const <InspectionEvidence>[],
    this.findings = const <InspectionFinding>[],
    this.reportVersions = const <InspectionReportVersion>[],
    this.paymentStatus,
    this.reinspectionVerifications = const <ReinspectionVerification>[],
  });

  final Inspection inspection;
  final InspectionWorkflowState? workflowState;
  final List<FieldSessionSummary> fieldSessions;
  final List<InspectionEvidence> evidence;
  final List<InspectionFinding> findings;
  final List<InspectionReportVersion> reportVersions;
  final ReportPaymentStatus? paymentStatus;
  final List<ReinspectionVerification> reinspectionVerifications;
}

final inspectionBundleProvider =
    FutureProvider.family<CustomerInspectionBundle, String>((
      ref,
      inspectionId,
    ) async {
      final repo = ref.read(inspectionRepositoryProvider);
      final inspectionRes = await repo.getInspection(inspectionId);
      final inspection = switch (inspectionRes) {
        ApiSuccess(:final data) => data,
        ApiError(:final failure) => throw ApiFailureException(failure),
      };

      final workflowFuture = repo.getWorkflowState(inspectionId);
      final sessionsFuture = repo.listFieldSessions(inspectionId);
      final evidenceFuture = repo.listEvidence(inspectionId);
      final findingsFuture = repo.listFindings(inspectionId);
      final versionsFuture = repo.listReportVersions(inspectionId);
      final paymentFuture = repo.getReportPaymentStatus(inspectionId);
      final verificationsFuture = repo.listReinspectionVerifications(
        inspectionId,
      );

      final workflowRes = await workflowFuture;
      final sessionsRes = await sessionsFuture;
      final evidenceRes = await evidenceFuture;
      final findingsRes = await findingsFuture;
      final versionsRes = await versionsFuture;
      final paymentRes = await paymentFuture;
      final verificationsRes = await verificationsFuture;

      return CustomerInspectionBundle(
        inspection: inspection,
        workflowState: workflowRes is ApiSuccess<InspectionWorkflowState>
            ? workflowRes.data
            : null,
        fieldSessions: sessionsRes is ApiSuccess<List<FieldSessionSummary>>
            ? sessionsRes.data
            : const <FieldSessionSummary>[],
        evidence: evidenceRes is ApiSuccess<List<InspectionEvidence>>
            ? evidenceRes.data.where((e) => !e.isDeleted).toList()
            : const <InspectionEvidence>[],
        findings: findingsRes is ApiSuccess<List<InspectionFinding>>
            ? findingsRes.data
            : const <InspectionFinding>[],
        reportVersions: versionsRes is ApiSuccess<List<InspectionReportVersion>>
            ? versionsRes.data
            : const <InspectionReportVersion>[],
        paymentStatus: paymentRes is ApiSuccess<ReportPaymentStatus>
            ? paymentRes.data
            : null,
        reinspectionVerifications:
            verificationsRes is ApiSuccess<List<ReinspectionVerification>>
            ? verificationsRes.data
            : const <ReinspectionVerification>[],
      );
    });

final reportAiSummaryProvider =
    FutureProvider.family<
      ReportAiSummary?,
      ({String inspectionId, String versionId})
    >((ref, args) async {
      final res = await ref
          .read(inspectionRepositoryProvider)
          .getReportAiSummary(
            inspectionId: args.inspectionId,
            versionId: args.versionId,
          );
      return switch (res) {
        ApiSuccess(:final data) => data,
        ApiError() => null,
      };
    });

/// Inspector <-> Customer chat thread. Null when the endpoint is unavailable.
final inspectionChatProvider =
    FutureProvider.family<InspectionChatThread?, String>((
      ref,
      inspectionId,
    ) async {
      final res = await ref
          .read(inspectionRepositoryProvider)
          .getInspectionChat(inspectionId);
      return switch (res) {
        ApiSuccess(:final data) => data,
        ApiError() => null,
      };
    });

/// Optional DroneKnowledgeAI references. A 404/older backend yields null.
final knowledgeRecommendationsProvider =
    FutureProvider.family<KnowledgeRecommendationResponse?, String>((
      ref,
      inspectionId,
    ) async {
      final res = await ref
          .read(inspectionRepositoryProvider)
          .getKnowledgeRecommendations(inspectionId, limit: 4);
      return switch (res) {
        ApiSuccess(:final data) => data,
        ApiError() => null,
      };
    });
