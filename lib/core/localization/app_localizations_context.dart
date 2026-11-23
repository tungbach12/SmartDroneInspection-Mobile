import 'package:flutter/widgets.dart';
import 'package:smart_drone_inspection/l10n/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('en'));
}

String localizedRole(AppLocalizations l10n, String role) => switch (role) {
  'CUSTOMER' => l10n.userRoleCustomer,
  'MANAGER' => l10n.userRoleManager,
  'ADMIN' => l10n.userRoleAdmin,
  'INSPECTOR' => l10n.userRoleInspector,
  _ => role,
};

String localizedAssetStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'ACTIVE' => l10n.assetStatusActive,
      'PENDING_REVIEW' => l10n.assetStatusPendingReview,
      'INACTIVE' => l10n.assetStatusInactive,
      'REJECTED' => l10n.assetStatusRejected,
      'RETIRED' => l10n.assetStatusRetired,
      _ => status,
    };

String localizedServiceRequestStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'OPEN' => l10n.requestStatusOpen,
      'QUOTED' => l10n.requestStatusQuoted,
      'ACCEPTED' => l10n.requestStatusAccepted,
      'CONTRACT_SIGNED' => l10n.requestStatusContractSigned,
      'ASSIGNED' => l10n.requestStatusAssigned,
      'CANCELLED' => l10n.requestStatusCancelled,
      _ => status,
    };

String localizedInspectionStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'SCHEDULED' => l10n.inspectionStatusScheduled,
      'IN_PROGRESS' => l10n.inspectionStatusInProgress,
      'FIELD_COMPLETED' => l10n.inspectionStatusFieldCompleted,
      'UNDER_REVIEW' => l10n.inspectionStatusUnderReview,
      'COMPLETED' => l10n.inspectionStatusCompleted,
      'CANCELLED' => l10n.inspectionStatusCancelled,
      _ => status,
    };

String localizedReportStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'DRAFT' => l10n.reportStatusDraft,
      'SUBMITTED' => l10n.reportStatusSubmitted,
      'RETURNED' => l10n.reportStatusReturned,
      'PUBLISHED' => l10n.reportStatusPublished,
      'SUPERSEDED' => l10n.reportStatusSuperseded,
      _ => status,
    };

String localizedPaymentStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'PAID' => l10n.paymentStatusPaid,
      'PAYMENT_DUE' => l10n.paymentStatusDue,
      'PENDING' => l10n.paymentStatusPending,
      _ => l10n.paymentStatusNotApplicable,
    };

String localizedFindingSeverity(AppLocalizations l10n, String severity) =>
    switch (severity.toUpperCase()) {
      'CRITICAL' => l10n.severityCritical,
      'HIGH' => l10n.severityHigh,
      'MEDIUM' => l10n.severityMedium,
      'LOW' => l10n.severityLow,
      _ => severity,
    };

String localizedFieldSessionStatus(AppLocalizations l10n, String status) =>
    switch (status.toUpperCase()) {
      'IN_PROGRESS' => l10n.fieldSessionStatusInProgress,
      'POSTPONED' => l10n.fieldSessionStatusPostponed,
      'ABORTED' => l10n.fieldSessionStatusAborted,
      'PLANNED' => l10n.fieldSessionStatusPlanned,
      'FIELD_COMPLETED' => l10n.fieldSessionStatusCompleted,
      _ => status,
    };
