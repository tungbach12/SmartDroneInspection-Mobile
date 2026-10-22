// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SmartDroneInspection';

  @override
  String get appTitle => 'SmartDroneInspection';

  @override
  String get navInspections => 'Inspections';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navProfile => 'Profile';

  @override
  String get notFound => 'Not found';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get signIn => 'Sign in';

  @override
  String get setNewPassword => 'Set new password';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPasswordRequirement => 'New password (15+ characters)';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get passwordSetupNotice =>
      'You must set a new password before continuing.';

  @override
  String get passwordsDoNotMatch => 'New passwords do not match.';

  @override
  String get required => 'Required';

  @override
  String get minimum15Characters => 'Minimum 15 characters';

  @override
  String get invalidCredentials => 'Invalid credentials.';

  @override
  String get serverError => 'Server error.';

  @override
  String get cannotReachServer => 'Cannot reach the server.';

  @override
  String get notFoundError => 'Not found.';

  @override
  String get assets => 'Assets';

  @override
  String get active => 'Active';

  @override
  String get assignments => 'Assignments';

  @override
  String get acceptingDoesNotClear =>
      'Accepting records that you took the work. It does not mean the mission may fly: a named organization reviewer decides that from the paperwork.';

  @override
  String get nothingToAnswer =>
      'Nothing to answer. An organization administrator pairs you with a Drone before preparation can start.';

  @override
  String droneValidity(Object serial, Object from, Object until) {
    return 'Drone $serial · valid from $from to $until';
  }

  @override
  String get unspecified => 'unspecified';

  @override
  String get declineReason => 'Reason for declining';

  @override
  String get declineReasonHint =>
      'Required only when declining, so an administrator knows what to fix.';

  @override
  String get recording => 'Recording…';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get serverRefusedResponse => 'The server refused this response.';

  @override
  String get cannotAnswerAssignment =>
      'You are not allowed to answer this assignment.';

  @override
  String get assignmentNotFound =>
      'This assignment was not found, or it belongs to another organization.';

  @override
  String get inspectionRecord => 'Inspection record';

  @override
  String get backToAssignments => 'Back to assignments';

  @override
  String inspectionNumber(Object id) {
    return 'Inspection $id';
  }

  @override
  String get openFieldSession => 'Open field session';

  @override
  String get openPreparation => 'Open MF2 Preparation';

  @override
  String get checklist => 'Checklist';

  @override
  String get evidence => 'Evidence';

  @override
  String get cameraPermissionError =>
      'Camera could not be opened. Check device permission and try again.';

  @override
  String get completeSessionBeforeEvidence =>
      'Complete the field session before attaching evidence.';

  @override
  String get evidenceUploaded => 'Evidence uploaded securely.';

  @override
  String evidenceDetails(Object contentType, Object size, Object source) {
    return '$contentType · $size bytes · $source';
  }

  @override
  String get evidenceSourceMobileUpload => 'Mobile upload';

  @override
  String get pass => 'Pass';

  @override
  String get fail => 'Fail';

  @override
  String get captureInspectionPhoto => 'Capture inspection photo';

  @override
  String selectedFile(Object name) {
    return 'Selected: $name';
  }

  @override
  String get uploading => 'Uploading…';

  @override
  String get uploadPhoto => 'Upload photo';

  @override
  String get retryUpload => 'Retry upload';

  @override
  String uploadFailed(Object error) {
    return 'Upload failed: $error. The selected photo is kept so you can retry.';
  }

  @override
  String get checkConnection => 'Check your connection and try again.';

  @override
  String get unauthorizedInspection =>
      'You are not authorized to access this inspection.';

  @override
  String get inspectionUnavailable => 'This inspection is no longer available.';

  @override
  String get requestFailed => 'The server could not complete this request.';

  @override
  String checklistSaveFailed(Object error) {
    return 'Checklist was not saved: $error';
  }

  @override
  String get writeShotListComparison => 'Write the shot-list comparison first.';

  @override
  String get stateWhySessionNeeded =>
      'State why another field session is needed.';

  @override
  String get additionalWorkRequested =>
      'Additional field work requested. Continue in MF2 Preparation and wait for readiness review.';

  @override
  String get evidenceSetAccepted =>
      'Evidence set accepted for advisory analysis.';

  @override
  String get evidenceQualityDecision => 'Evidence quality decision';

  @override
  String get evidenceQualityExplanation =>
      'MF3-03: compare the completed capture set against the shot-list. Choose to accept it or request another MF2 session; weather or site safety during work belongs to postponement/abort.';

  @override
  String get noDecisionRecorded => 'No decision recorded yet.';

  @override
  String latestDecision(Object decision) {
    return 'Latest: $decision';
  }

  @override
  String get loadingDecisionHistory => 'Loading decision history…';

  @override
  String get decisionHistoryFailed => 'Could not load decision history.';

  @override
  String get shotListComparison => 'Shot-list comparison';

  @override
  String get shotListComparisonHint =>
      'Required. What the set covers and what it does not.';

  @override
  String get whyAnotherSession => 'Why is another field session needed?';

  @override
  String get anotherSessionHint =>
      'Required only when requesting another MF2 session.';

  @override
  String get acceptEvidenceSet => 'Accept evidence set';

  @override
  String get additionalSessionNeeded => 'Additional session needed';

  @override
  String get response => 'Response';

  @override
  String get numericResponse => 'Numeric response';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get saving => 'Saving…';

  @override
  String get saveResponse => 'Save response';

  @override
  String get saved => 'Saved';

  @override
  String get networkUnavailable =>
      'The network is unavailable. The note you typed is kept, so try again.';

  @override
  String get fieldSession => 'Field session';

  @override
  String get startingNotClearance =>
      'Starting a session is not flight clearance. It records that the paperwork and the pre-flight checklist were in order.';

  @override
  String get notStartable =>
      'This inspection is not currently startable. Complete MF2 Preparation and independent readiness review first.';

  @override
  String get preFlightChecklistNote => 'Pre-flight checklist note';

  @override
  String get preFlightChecklistHint =>
      'Identify the assigned Drone and record what you checked on site.';

  @override
  String get starting => 'Starting…';

  @override
  String get startFieldSession => 'Start field session';

  @override
  String get abortSessionQuestion => 'Abort this session?';

  @override
  String get abortIrreversible =>
      'The session ends and will not resume under this record. This cannot be undone.';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get abort => 'Abort';

  @override
  String startedAt(Object time, Object decision) {
    return 'Started $time against readiness decision $decision';
  }

  @override
  String get justNow => 'just now';

  @override
  String get unknown => 'unknown';

  @override
  String get reasonPostponing => 'Reason for postponing';

  @override
  String get postponeHint =>
      'Weather or site safety. The mission can be attempted again.';

  @override
  String get postpone => 'Postpone';

  @override
  String get fieldSessionOutcome => 'Field session outcome';

  @override
  String get fieldSessionOutcomeHint =>
      'Record coverage, observations, gaps and any incidents before ending the session.';

  @override
  String get endFieldSession => 'End field session';

  @override
  String get reasonAborting => 'Reason for aborting';

  @override
  String get abortIrreversibleShort =>
      'This session ends and will not resume under this record.';

  @override
  String get abortSession => 'Abort session';

  @override
  String get cannotManageSession =>
      'You are not allowed to manage this field session.';

  @override
  String get preparationNotFound =>
      'This inspection was not found, or it belongs to another organization.';

  @override
  String get preparationServerRefused => 'The server refused this request.';

  @override
  String get networkRetry => 'Network unavailable. Try again when connected.';

  @override
  String get fieldSessionStatusInProgress => 'In progress';

  @override
  String get fieldSessionStatusPostponed => 'Postponed';

  @override
  String get fieldSessionStatusAborted => 'Aborted';

  @override
  String get fieldSessionStatusPlanned => 'Planned';

  @override
  String get fieldSessionStatusCompleted => 'Field completed';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusActive => 'Active';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusSuspended => 'Suspended';

  @override
  String get decisionAdditionalSession => 'Additional session required';

  @override
  String get decisionAccepted => 'Accepted';

  @override
  String get preparation => 'MF2 Preparation';

  @override
  String get bothPlannedTimes =>
      'Set both planned start and end for the additional field session.';

  @override
  String preparationVersionSaved(Object version) {
    return 'Preparation version $version saved.';
  }

  @override
  String get preparationSubmitted =>
      'Preparation submitted for independent readiness review.';

  @override
  String get componentShotListJson => 'Component shot-list (JSON)';

  @override
  String get evidenceTypesJson => 'Evidence types (JSON)';

  @override
  String get accessConstraints => 'Access constraints';

  @override
  String get plannedSessionStart => 'Planned session start (local time)';

  @override
  String get plannedSessionEnd => 'Planned session end (local time)';

  @override
  String get safetyObservations => 'Safety observations';

  @override
  String get safetyAcknowledgment => 'Safety acknowledgment';

  @override
  String get saveDraft => 'Save draft';

  @override
  String get submitting => 'Submitting…';

  @override
  String get submitPreparation => 'Submit preparation';

  @override
  String get additionalSessionRequested =>
      'Additional field session requested. Update the plan/window and submit it. An independent ORG_ADMIN must approve current readiness before Start becomes available.';

  @override
  String preparationVersionStatus(Object version, Object status) {
    return 'Version $version · $status';
  }

  @override
  String get preparationApproved =>
      'Preparation is approved. Readiness is bound to this version; changes require another review.';

  @override
  String get cannotEditPreparation =>
      'You are not allowed to edit this preparation.';

  @override
  String get inspectionNotInOrganization =>
      'This inspection was not found in your organization.';

  @override
  String get profile => 'Profile';

  @override
  String zone(Object zone) {
    return 'Zone: $zone';
  }

  @override
  String organization(Object organization) {
    return 'Org: $organization';
  }

  @override
  String get notSignedIn => 'Not signed in.';

  @override
  String get signOut => 'Sign out';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get tasks => 'Maintenance Tasks';

  @override
  String get assignedMaintenanceTickets => 'Assigned maintenance tickets';

  @override
  String get userRoleAdmin => 'Administrator';

  @override
  String get userRoleOrgAdmin => 'Organization administrator';

  @override
  String get userRoleInspector => 'Inspector';

  @override
  String get userRoleMaintenanceEngineer => 'Maintenance engineer';

  @override
  String get userRoleClient => 'Client';

  @override
  String get actorZonePlatform => 'Platform';

  @override
  String get actorZoneCustomerOrganization => 'Customer organization';

  @override
  String get actorZoneServiceWorkforce => 'Service workforce';

  @override
  String get assignmentStatusActive => 'Active';

  @override
  String get assignmentResponseAccepted => 'Accepted';

  @override
  String get assignmentResponseRejected => 'Declined';

  @override
  String get assetStatusActive => 'Active';

  @override
  String get assetStatusInactive => 'Inactive';

  @override
  String get assetStatusRetired => 'Retired';
}
