import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SmartDroneInspection'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SmartDroneInspection'**
  String get appTitle;

  /// No description provided for @navInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get navInspections;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPasswordRequirement.
  ///
  /// In en, this message translates to:
  /// **'New password (15+ characters)'**
  String get newPasswordRequirement;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordSetupNotice.
  ///
  /// In en, this message translates to:
  /// **'You must set a new password before continuing.'**
  String get passwordSetupNotice;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @minimum15Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 15 characters'**
  String get minimum15Characters;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get invalidCredentials;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error.'**
  String get serverError;

  /// No description provided for @cannotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server.'**
  String get cannotReachServer;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get notFoundError;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignments;

  /// No description provided for @acceptingDoesNotClear.
  ///
  /// In en, this message translates to:
  /// **'Accepting records that you took the work. It does not mean the mission may fly: a named organization reviewer decides that from the paperwork.'**
  String get acceptingDoesNotClear;

  /// No description provided for @nothingToAnswer.
  ///
  /// In en, this message translates to:
  /// **'Nothing to answer. An organization administrator pairs you with a Drone before preparation can start.'**
  String get nothingToAnswer;

  /// No description provided for @droneValidity.
  ///
  /// In en, this message translates to:
  /// **'Drone {serial} · valid from {from} to {until}'**
  String droneValidity(Object serial, Object from, Object until);

  /// No description provided for @unspecified.
  ///
  /// In en, this message translates to:
  /// **'unspecified'**
  String get unspecified;

  /// No description provided for @declineReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for declining'**
  String get declineReason;

  /// No description provided for @declineReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Required only when declining, so an administrator knows what to fix.'**
  String get declineReasonHint;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get recording;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @serverRefusedResponse.
  ///
  /// In en, this message translates to:
  /// **'The server refused this response.'**
  String get serverRefusedResponse;

  /// No description provided for @cannotAnswerAssignment.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to answer this assignment.'**
  String get cannotAnswerAssignment;

  /// No description provided for @assignmentNotFound.
  ///
  /// In en, this message translates to:
  /// **'This assignment was not found, or it belongs to another organization.'**
  String get assignmentNotFound;

  /// No description provided for @inspectionRecord.
  ///
  /// In en, this message translates to:
  /// **'Inspection record'**
  String get inspectionRecord;

  /// No description provided for @backToAssignments.
  ///
  /// In en, this message translates to:
  /// **'Back to assignments'**
  String get backToAssignments;

  /// No description provided for @inspectionNumber.
  ///
  /// In en, this message translates to:
  /// **'Inspection {id}'**
  String inspectionNumber(Object id);

  /// No description provided for @openFieldSession.
  ///
  /// In en, this message translates to:
  /// **'Open field session'**
  String get openFieldSession;

  /// No description provided for @openPreparation.
  ///
  /// In en, this message translates to:
  /// **'Open MF2 Preparation'**
  String get openPreparation;

  /// No description provided for @checklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get checklist;

  /// No description provided for @evidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidence;

  /// No description provided for @cameraPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Camera could not be opened. Check device permission and try again.'**
  String get cameraPermissionError;

  /// No description provided for @completeSessionBeforeEvidence.
  ///
  /// In en, this message translates to:
  /// **'Complete the field session before attaching evidence.'**
  String get completeSessionBeforeEvidence;

  /// No description provided for @evidenceUploaded.
  ///
  /// In en, this message translates to:
  /// **'Evidence uploaded securely.'**
  String get evidenceUploaded;

  /// No description provided for @evidenceDetails.
  ///
  /// In en, this message translates to:
  /// **'{contentType} · {size} bytes · {source}'**
  String evidenceDetails(Object contentType, Object size, Object source);

  /// No description provided for @evidenceSourceMobileUpload.
  ///
  /// In en, this message translates to:
  /// **'Mobile upload'**
  String get evidenceSourceMobileUpload;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get pass;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get fail;

  /// No description provided for @captureInspectionPhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture inspection photo'**
  String get captureInspectionPhoto;

  /// No description provided for @selectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selectedFile(Object name);

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploading;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// No description provided for @retryUpload.
  ///
  /// In en, this message translates to:
  /// **'Retry upload'**
  String get retryUpload;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed: {error}. The selected photo is kept so you can retry.'**
  String uploadFailed(Object error);

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnection;

  /// No description provided for @unauthorizedInspection.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this inspection.'**
  String get unauthorizedInspection;

  /// No description provided for @inspectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This inspection is no longer available.'**
  String get inspectionUnavailable;

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'The server could not complete this request.'**
  String get requestFailed;

  /// No description provided for @checklistSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Checklist was not saved: {error}'**
  String checklistSaveFailed(Object error);

  /// No description provided for @writeShotListComparison.
  ///
  /// In en, this message translates to:
  /// **'Write the shot-list comparison first.'**
  String get writeShotListComparison;

  /// No description provided for @stateWhySessionNeeded.
  ///
  /// In en, this message translates to:
  /// **'State why another field session is needed.'**
  String get stateWhySessionNeeded;

  /// No description provided for @additionalWorkRequested.
  ///
  /// In en, this message translates to:
  /// **'Additional field work requested. Continue in MF2 Preparation and wait for readiness review.'**
  String get additionalWorkRequested;

  /// No description provided for @evidenceSetAccepted.
  ///
  /// In en, this message translates to:
  /// **'Evidence set accepted for advisory analysis.'**
  String get evidenceSetAccepted;

  /// No description provided for @evidenceQualityDecision.
  ///
  /// In en, this message translates to:
  /// **'Evidence quality decision'**
  String get evidenceQualityDecision;

  /// No description provided for @evidenceQualityExplanation.
  ///
  /// In en, this message translates to:
  /// **'MF3-03: compare the completed capture set against the shot-list. Choose to accept it or request another MF2 session; weather or site safety during work belongs to postponement/abort.'**
  String get evidenceQualityExplanation;

  /// No description provided for @noDecisionRecorded.
  ///
  /// In en, this message translates to:
  /// **'No decision recorded yet.'**
  String get noDecisionRecorded;

  /// No description provided for @latestDecision.
  ///
  /// In en, this message translates to:
  /// **'Latest: {decision}'**
  String latestDecision(Object decision);

  /// No description provided for @loadingDecisionHistory.
  ///
  /// In en, this message translates to:
  /// **'Loading decision history…'**
  String get loadingDecisionHistory;

  /// No description provided for @decisionHistoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load decision history.'**
  String get decisionHistoryFailed;

  /// No description provided for @shotListComparison.
  ///
  /// In en, this message translates to:
  /// **'Shot-list comparison'**
  String get shotListComparison;

  /// No description provided for @shotListComparisonHint.
  ///
  /// In en, this message translates to:
  /// **'Required. What the set covers and what it does not.'**
  String get shotListComparisonHint;

  /// No description provided for @whyAnotherSession.
  ///
  /// In en, this message translates to:
  /// **'Why is another field session needed?'**
  String get whyAnotherSession;

  /// No description provided for @anotherSessionHint.
  ///
  /// In en, this message translates to:
  /// **'Required only when requesting another MF2 session.'**
  String get anotherSessionHint;

  /// No description provided for @acceptEvidenceSet.
  ///
  /// In en, this message translates to:
  /// **'Accept evidence set'**
  String get acceptEvidenceSet;

  /// No description provided for @additionalSessionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Additional session needed'**
  String get additionalSessionNeeded;

  /// No description provided for @response.
  ///
  /// In en, this message translates to:
  /// **'Response'**
  String get response;

  /// No description provided for @numericResponse.
  ///
  /// In en, this message translates to:
  /// **'Numeric response'**
  String get numericResponse;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @saveResponse.
  ///
  /// In en, this message translates to:
  /// **'Save response'**
  String get saveResponse;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @networkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The network is unavailable. The note you typed is kept, so try again.'**
  String get networkUnavailable;

  /// No description provided for @fieldSession.
  ///
  /// In en, this message translates to:
  /// **'Field session'**
  String get fieldSession;

  /// No description provided for @startingNotClearance.
  ///
  /// In en, this message translates to:
  /// **'Starting a session is not flight clearance. It records that the paperwork and the pre-flight checklist were in order.'**
  String get startingNotClearance;

  /// No description provided for @notStartable.
  ///
  /// In en, this message translates to:
  /// **'This inspection is not currently startable. Complete MF2 Preparation and independent readiness review first.'**
  String get notStartable;

  /// No description provided for @preFlightChecklistNote.
  ///
  /// In en, this message translates to:
  /// **'Pre-flight checklist note'**
  String get preFlightChecklistNote;

  /// No description provided for @preFlightChecklistHint.
  ///
  /// In en, this message translates to:
  /// **'Identify the assigned Drone and record what you checked on site.'**
  String get preFlightChecklistHint;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get starting;

  /// No description provided for @startFieldSession.
  ///
  /// In en, this message translates to:
  /// **'Start field session'**
  String get startFieldSession;

  /// No description provided for @abortSessionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Abort this session?'**
  String get abortSessionQuestion;

  /// No description provided for @abortIrreversible.
  ///
  /// In en, this message translates to:
  /// **'The session ends and will not resume under this record. This cannot be undone.'**
  String get abortIrreversible;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @abort.
  ///
  /// In en, this message translates to:
  /// **'Abort'**
  String get abort;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started {time} against readiness decision {decision}'**
  String startedAt(Object time, Object decision);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get unknown;

  /// No description provided for @reasonPostponing.
  ///
  /// In en, this message translates to:
  /// **'Reason for postponing'**
  String get reasonPostponing;

  /// No description provided for @postponeHint.
  ///
  /// In en, this message translates to:
  /// **'Weather or site safety. The mission can be attempted again.'**
  String get postponeHint;

  /// No description provided for @postpone.
  ///
  /// In en, this message translates to:
  /// **'Postpone'**
  String get postpone;

  /// No description provided for @fieldSessionOutcome.
  ///
  /// In en, this message translates to:
  /// **'Field session outcome'**
  String get fieldSessionOutcome;

  /// No description provided for @fieldSessionOutcomeHint.
  ///
  /// In en, this message translates to:
  /// **'Record coverage, observations, gaps and any incidents before ending the session.'**
  String get fieldSessionOutcomeHint;

  /// No description provided for @endFieldSession.
  ///
  /// In en, this message translates to:
  /// **'End field session'**
  String get endFieldSession;

  /// No description provided for @reasonAborting.
  ///
  /// In en, this message translates to:
  /// **'Reason for aborting'**
  String get reasonAborting;

  /// No description provided for @abortIrreversibleShort.
  ///
  /// In en, this message translates to:
  /// **'This session ends and will not resume under this record.'**
  String get abortIrreversibleShort;

  /// No description provided for @abortSession.
  ///
  /// In en, this message translates to:
  /// **'Abort session'**
  String get abortSession;

  /// No description provided for @cannotManageSession.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to manage this field session.'**
  String get cannotManageSession;

  /// No description provided for @preparationNotFound.
  ///
  /// In en, this message translates to:
  /// **'This inspection was not found, or it belongs to another organization.'**
  String get preparationNotFound;

  /// No description provided for @preparationServerRefused.
  ///
  /// In en, this message translates to:
  /// **'The server refused this request.'**
  String get preparationServerRefused;

  /// No description provided for @networkRetry.
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Try again when connected.'**
  String get networkRetry;

  /// No description provided for @fieldSessionStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get fieldSessionStatusInProgress;

  /// No description provided for @fieldSessionStatusPostponed.
  ///
  /// In en, this message translates to:
  /// **'Postponed'**
  String get fieldSessionStatusPostponed;

  /// No description provided for @fieldSessionStatusAborted.
  ///
  /// In en, this message translates to:
  /// **'Aborted'**
  String get fieldSessionStatusAborted;

  /// No description provided for @fieldSessionStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get fieldSessionStatusPlanned;

  /// No description provided for @fieldSessionStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Field completed'**
  String get fieldSessionStatusCompleted;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get statusSuspended;

  /// No description provided for @decisionAdditionalSession.
  ///
  /// In en, this message translates to:
  /// **'Additional session required'**
  String get decisionAdditionalSession;

  /// No description provided for @decisionAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get decisionAccepted;

  /// No description provided for @preparation.
  ///
  /// In en, this message translates to:
  /// **'MF2 Preparation'**
  String get preparation;

  /// No description provided for @bothPlannedTimes.
  ///
  /// In en, this message translates to:
  /// **'Set both planned start and end for the additional field session.'**
  String get bothPlannedTimes;

  /// No description provided for @preparationVersionSaved.
  ///
  /// In en, this message translates to:
  /// **'Preparation version {version} saved.'**
  String preparationVersionSaved(Object version);

  /// No description provided for @preparationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Preparation submitted for independent readiness review.'**
  String get preparationSubmitted;

  /// No description provided for @componentShotListJson.
  ///
  /// In en, this message translates to:
  /// **'Component shot-list (JSON)'**
  String get componentShotListJson;

  /// No description provided for @evidenceTypesJson.
  ///
  /// In en, this message translates to:
  /// **'Evidence types (JSON)'**
  String get evidenceTypesJson;

  /// No description provided for @accessConstraints.
  ///
  /// In en, this message translates to:
  /// **'Access constraints'**
  String get accessConstraints;

  /// No description provided for @plannedSessionStart.
  ///
  /// In en, this message translates to:
  /// **'Planned session start (local time)'**
  String get plannedSessionStart;

  /// No description provided for @plannedSessionEnd.
  ///
  /// In en, this message translates to:
  /// **'Planned session end (local time)'**
  String get plannedSessionEnd;

  /// No description provided for @safetyObservations.
  ///
  /// In en, this message translates to:
  /// **'Safety observations'**
  String get safetyObservations;

  /// No description provided for @safetyAcknowledgment.
  ///
  /// In en, this message translates to:
  /// **'Safety acknowledgment'**
  String get safetyAcknowledgment;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get saveDraft;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @submitPreparation.
  ///
  /// In en, this message translates to:
  /// **'Submit preparation'**
  String get submitPreparation;

  /// No description provided for @additionalSessionRequested.
  ///
  /// In en, this message translates to:
  /// **'Additional field session requested. Update the plan/window and submit it. An independent ORG_ADMIN must approve current readiness before Start becomes available.'**
  String get additionalSessionRequested;

  /// No description provided for @preparationVersionStatus.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · {status}'**
  String preparationVersionStatus(Object version, Object status);

  /// No description provided for @preparationApproved.
  ///
  /// In en, this message translates to:
  /// **'Preparation is approved. Readiness is bound to this version; changes require another review.'**
  String get preparationApproved;

  /// No description provided for @cannotEditPreparation.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to edit this preparation.'**
  String get cannotEditPreparation;

  /// No description provided for @inspectionNotInOrganization.
  ///
  /// In en, this message translates to:
  /// **'This inspection was not found in your organization.'**
  String get inspectionNotInOrganization;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @zone.
  ///
  /// In en, this message translates to:
  /// **'Zone: {zone}'**
  String zone(Object zone);

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Org: {organization}'**
  String organization(Object organization);

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in.'**
  String get notSignedIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Tasks'**
  String get tasks;

  /// No description provided for @assignedMaintenanceTickets.
  ///
  /// In en, this message translates to:
  /// **'Assigned maintenance tickets'**
  String get assignedMaintenanceTickets;

  /// No description provided for @userRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get userRoleAdmin;

  /// No description provided for @userRoleOrgAdmin.
  ///
  /// In en, this message translates to:
  /// **'Organization administrator'**
  String get userRoleOrgAdmin;

  /// No description provided for @userRoleInspector.
  ///
  /// In en, this message translates to:
  /// **'Inspector'**
  String get userRoleInspector;

  /// No description provided for @userRoleMaintenanceEngineer.
  ///
  /// In en, this message translates to:
  /// **'Maintenance engineer'**
  String get userRoleMaintenanceEngineer;

  /// No description provided for @userRoleClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get userRoleClient;

  /// No description provided for @actorZonePlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get actorZonePlatform;

  /// No description provided for @actorZoneCustomerOrganization.
  ///
  /// In en, this message translates to:
  /// **'Customer organization'**
  String get actorZoneCustomerOrganization;

  /// No description provided for @actorZoneServiceWorkforce.
  ///
  /// In en, this message translates to:
  /// **'Service workforce'**
  String get actorZoneServiceWorkforce;

  /// No description provided for @assignmentStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get assignmentStatusActive;

  /// No description provided for @assignmentResponseAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get assignmentResponseAccepted;

  /// No description provided for @assignmentResponseRejected.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get assignmentResponseRejected;

  /// No description provided for @assetStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get assetStatusActive;

  /// No description provided for @assetStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get assetStatusInactive;

  /// No description provided for @assetStatusRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get assetStatusRetired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
