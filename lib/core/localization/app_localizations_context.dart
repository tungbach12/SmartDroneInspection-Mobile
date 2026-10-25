import 'package:flutter/widgets.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('en'));
}

String localizedFieldSessionStatus(AppLocalizations l10n, String status) =>
    switch (status) {
      'IN_PROGRESS' => l10n.fieldSessionStatusInProgress,
      'POSTPONED' => l10n.fieldSessionStatusPostponed,
      'ABORTED' => l10n.fieldSessionStatusAborted,
      'PLANNED' => l10n.fieldSessionStatusPlanned,
      'FIELD_COMPLETED' => l10n.fieldSessionStatusCompleted,
      _ => status,
    };

String localizedWorkflowStatus(AppLocalizations l10n, String status) =>
    switch (status) {
      'DRAFT' => l10n.statusDraft,
      'SUBMITTED' => l10n.statusSubmitted,
      'READY' => l10n.statusReady,
      'ACTIVE' => l10n.statusActive,
      'ACCEPTED' => l10n.statusAccepted,
      'REJECTED' => l10n.statusRejected,
      'SUSPENDED' => l10n.statusSuspended,
      _ => status,
    };

String localizedChecklistChoice(AppLocalizations l10n, String choice) =>
    switch (choice) {
      'PASS' => l10n.pass,
      'FAIL' => l10n.fail,
      'true' => l10n.yes,
      'false' => l10n.no,
      _ => choice,
    };

String localizedDecision(AppLocalizations l10n, String decision) =>
    switch (decision) {
      'ACCEPTED' => l10n.decisionAccepted,
      'ADDITIONAL_SESSION_REQUIRED' => l10n.decisionAdditionalSession,
      _ => decision.replaceAll('_', ' '),
    };

String localizedRole(AppLocalizations l10n, String role) => switch (role) {
  'ADMIN' => l10n.userRoleAdmin,
  'PLATFORM_MANAGER' => l10n.userRolePlatformManager,
  'ORG_MANAGER' => l10n.userRoleOrgManager,
  'INSPECTOR' => l10n.userRoleInspector,
  'MAINTENANCE_ENGINEER' => l10n.userRoleMaintenanceEngineer,
  'CLIENT' => l10n.userRoleClient,
  _ => role,
};

String localizedActorZone(AppLocalizations l10n, String zone) => switch (zone) {
  'PLATFORM' => l10n.actorZonePlatform,
  'CUSTOMER_ORGANIZATION' => l10n.actorZoneCustomerOrganization,
  'SERVICE_WORKFORCE' => l10n.actorZoneServiceWorkforce,
  _ => zone,
};

String localizedAssignmentStatus(AppLocalizations l10n, String status) =>
    switch (status) {
      'ACTIVE' => l10n.assignmentStatusActive,
      'SUSPENDED' => l10n.statusSuspended,
      _ => status,
    };

String localizedAssignmentResponse(AppLocalizations l10n, String response) =>
    switch (response) {
      'ACCEPTED' => l10n.assignmentResponseAccepted,
      'REJECTED' => l10n.assignmentResponseRejected,
      _ => response,
    };

String localizedAssetStatus(AppLocalizations l10n, String status) =>
    switch (status) {
      'ACTIVE' || 'Active' => l10n.assetStatusActive,
      'INACTIVE' => l10n.assetStatusInactive,
      'RETIRED' => l10n.assetStatusRetired,
      _ => status,
    };
