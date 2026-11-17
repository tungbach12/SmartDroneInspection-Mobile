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
  /// **'SDI Customer'**
  String get appTitle;

  /// No description provided for @customerPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Portal'**
  String get customerPortalSubtitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navDashboard;

  /// No description provided for @navAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get navAssets;

  /// No description provided for @navRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navRequests;

  /// No description provided for @navInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get navInspections;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage assets, service requests, official reports, and payments.'**
  String get signInSubtitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your Customer Portal account and verify your email.'**
  String get authRegisterSubtitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email to receive a 6-digit reset code.'**
  String get authResetSubtitle;

  /// No description provided for @stepAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get stepAccountDetails;

  /// No description provided for @stepEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get stepEmailVerification;

  /// No description provided for @stepResetRequest.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get stepResetRequest;

  /// No description provided for @stepResetVerify.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get stepResetVerify;

  /// No description provided for @passwordCharsProgress.
  ///
  /// In en, this message translates to:
  /// **'{count}/15+ characters'**
  String passwordCharsProgress(Object count);

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Customer account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @sendResetOtp.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get sendResetOtp;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit verification code'**
  String get otpCodeLabel;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify & continue'**
  String get verifyOtp;

  /// No description provided for @otpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to {email}.'**
  String otpPrompt(Object email);

  /// No description provided for @otpResendCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String otpResendCountdown(Object seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendOtp;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @phoneNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone number (optional)'**
  String get phoneNumberOptional;

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

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

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

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @passwordSetupNotice.
  ///
  /// In en, this message translates to:
  /// **'You must set a new password before continuing.'**
  String get passwordSetupNotice;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @minimum15Characters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 15 characters'**
  String get minimum15Characters;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidCredentials;

  /// No description provided for @customerOnlyAccessNotice.
  ///
  /// In en, this message translates to:
  /// **'This mobile app is exclusively for Customer accounts. Inspectors and Platform Managers should use the web portal.'**
  String get customerOnlyAccessNotice;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created! You can now sign in.'**
  String get registrationSuccess;

  /// No description provided for @pendingAirspaceReviewNotice.
  ///
  /// In en, this message translates to:
  /// **'Registration submitted and pending airspace review. We will contact you after assessment.'**
  String get pendingAirspaceReviewNotice;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Sign in with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Please sign in again.'**
  String get passwordChangedSuccess;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again.'**
  String get serverError;

  /// No description provided for @cannotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Check your connection.'**
  String get cannotReachServer;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'Record not found.'**
  String get notFoundError;

  /// No description provided for @accessDeniedError.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to perform this action.'**
  String get accessDeniedError;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Overview'**
  String get dashboardTitle;

  /// No description provided for @kpiRegisteredAssets.
  ///
  /// In en, this message translates to:
  /// **'Registered assets'**
  String get kpiRegisteredAssets;

  /// No description provided for @kpiInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get kpiInProgress;

  /// No description provided for @kpiOfficialReports.
  ///
  /// In en, this message translates to:
  /// **'Official reports'**
  String get kpiOfficialReports;

  /// No description provided for @kpiSettledFees.
  ///
  /// In en, this message translates to:
  /// **'Settled fees'**
  String get kpiSettledFees;

  /// No description provided for @quickActionNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get quickActionNewRequest;

  /// No description provided for @quickActionRegisterAsset.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get quickActionRegisterAsset;

  /// No description provided for @recentInspectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent inspections & fees'**
  String get recentInspectionsTitle;

  /// No description provided for @assetOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset overview'**
  String get assetOverviewTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @noInspectionsYet.
  ///
  /// In en, this message translates to:
  /// **'No inspections yet.'**
  String get noInspectionsYet;

  /// No description provided for @noAssetsYet.
  ///
  /// In en, this message translates to:
  /// **'No registered assets yet.'**
  String get noAssetsYet;

  /// No description provided for @assetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assetsTitle;

  /// No description provided for @searchAssetsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by asset name, code, or location…'**
  String get searchAssetsHint;

  /// No description provided for @registerAsset.
  ///
  /// In en, this message translates to:
  /// **'Register asset'**
  String get registerAsset;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get editAsset;

  /// No description provided for @retireAsset.
  ///
  /// In en, this message translates to:
  /// **'Retire asset'**
  String get retireAsset;

  /// No description provided for @retireAssetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Retire \"{name}\"? Retired assets remain in history and cannot accept new requests.'**
  String retireAssetConfirm(Object name);

  /// No description provided for @assetRetiredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset retired.'**
  String get assetRetiredSuccess;

  /// No description provided for @assetSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Asset saved.'**
  String get assetSavedSuccess;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset name'**
  String get assetName;

  /// No description provided for @assetCode.
  ///
  /// In en, this message translates to:
  /// **'Asset code'**
  String get assetCode;

  /// No description provided for @assetCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get assetCategory;

  /// No description provided for @assetLocation.
  ///
  /// In en, this message translates to:
  /// **'Location address / description'**
  String get assetLocation;

  /// No description provided for @assetDescription.
  ///
  /// In en, this message translates to:
  /// **'Technical description (optional)'**
  String get assetDescription;

  /// No description provided for @latitudeOptional.
  ///
  /// In en, this message translates to:
  /// **'Latitude (optional)'**
  String get latitudeOptional;

  /// No description provided for @longitudeOptional.
  ///
  /// In en, this message translates to:
  /// **'Longitude (optional)'**
  String get longitudeOptional;

  /// No description provided for @structureHeightMeters.
  ///
  /// In en, this message translates to:
  /// **'Structure height (m, optional)'**
  String get structureHeightMeters;

  /// No description provided for @footprintAreaSqm.
  ///
  /// In en, this message translates to:
  /// **'Footprint area (m², optional)'**
  String get footprintAreaSqm;

  /// No description provided for @inspectionItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspection checkpoints (comma-separated)'**
  String get inspectionItemsLabel;

  /// No description provided for @assetDocuments.
  ///
  /// In en, this message translates to:
  /// **'Asset documents'**
  String get assetDocuments;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded.'**
  String get documentUploaded;

  /// No description provided for @noDocumentsYet.
  ///
  /// In en, this message translates to:
  /// **'No documents attached yet.'**
  String get noDocumentsYet;

  /// No description provided for @documentSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved: {name}'**
  String documentSavedTo(Object name);

  /// No description provided for @assetStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get assetStatusActive;

  /// No description provided for @assetStatusPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get assetStatusPendingReview;

  /// No description provided for @assetStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get assetStatusInactive;

  /// No description provided for @assetStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get assetStatusRejected;

  /// No description provided for @assetStatusRetired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get assetStatusRetired;

  /// No description provided for @requestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Requests'**
  String get requestsTitle;

  /// No description provided for @searchRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by description or asset…'**
  String get searchRequestsHint;

  /// No description provided for @newServiceRequest.
  ///
  /// In en, this message translates to:
  /// **'New service request'**
  String get newServiceRequest;

  /// No description provided for @requestDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Request'**
  String get requestDetailsTitle;

  /// No description provided for @selectAsset.
  ///
  /// In en, this message translates to:
  /// **'Select active asset'**
  String get selectAsset;

  /// No description provided for @noActiveAssetsForRequest.
  ///
  /// In en, this message translates to:
  /// **'Register an Active asset before creating a service request.'**
  String get noActiveAssetsForRequest;

  /// No description provided for @requestTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Service schedule'**
  String get requestTypeLabel;

  /// No description provided for @requestTypeOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get requestTypeOneTime;

  /// No description provided for @requestTypeRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get requestTypeRecurring;

  /// No description provided for @preferredStartDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred inspection date'**
  String get preferredStartDate;

  /// No description provided for @leadTime20DaysNotice.
  ///
  /// In en, this message translates to:
  /// **'Schedule at least {days} days ahead (earliest: {date}).'**
  String leadTime20DaysNotice(Object days, Object date);

  /// No description provided for @leadTime20DaysError.
  ///
  /// In en, this message translates to:
  /// **'Date must be at least 20 days from today.'**
  String get leadTime20DaysError;

  /// No description provided for @timeWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspection hours'**
  String get timeWindowLabel;

  /// No description provided for @recurrenceMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat every (months)'**
  String get recurrenceMonthsLabel;

  /// No description provided for @occurrenceCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of cycles'**
  String get occurrenceCountLabel;

  /// No description provided for @scopeDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Scope & inspection objectives'**
  String get scopeDescriptionLabel;

  /// No description provided for @requestCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Service request submitted.'**
  String get requestCreatedSuccess;

  /// No description provided for @quoteSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quoteSectionTitle;

  /// No description provided for @noQuoteYet.
  ///
  /// In en, this message translates to:
  /// **'Platform Manager is reviewing your request and will issue a quotation shortly.'**
  String get noQuoteYet;

  /// No description provided for @quoteScopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Scope summary'**
  String get quoteScopeLabel;

  /// No description provided for @firstWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'Proposed window'**
  String get firstWindowLabel;

  /// No description provided for @quoteAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee per inspection'**
  String get quoteAmountLabel;

  /// No description provided for @acceptQuote.
  ///
  /// In en, this message translates to:
  /// **'Accept quotation'**
  String get acceptQuote;

  /// No description provided for @acceptQuoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Accept this quotation ({amount})? An inspection contract and occurrence schedule will be prepared.'**
  String acceptQuoteConfirm(Object amount);

  /// No description provided for @quoteAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Quotation accepted.'**
  String get quoteAcceptedSuccess;

  /// No description provided for @orderChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Chat'**
  String get orderChatTitle;

  /// No description provided for @unreadMessagesBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadMessagesBadge(Object count);

  /// No description provided for @typeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message to Platform Manager…'**
  String get typeMessageHint;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Ask questions about scope or pricing here.'**
  String get noMessagesYet;

  /// No description provided for @signedContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Signed paper contract'**
  String get signedContractTitle;

  /// No description provided for @contractNotUploadedYet.
  ///
  /// In en, this message translates to:
  /// **'Pending signed paper contract scan from Platform Manager.'**
  String get contractNotUploadedYet;

  /// No description provided for @downloadContract.
  ///
  /// In en, this message translates to:
  /// **'Download / Save contract'**
  String get downloadContract;

  /// No description provided for @contractLegalBasisButton.
  ///
  /// In en, this message translates to:
  /// **'Legal & e-signature basis'**
  String get contractLegalBasisButton;

  /// No description provided for @contractLegalBasisText.
  ///
  /// In en, this message translates to:
  /// **'Offline wet-signed contracts uploaded as verified scans comply with Vietnamese Electronic Transactions & Civil Code record-keeping requirements for commercial service execution.'**
  String get contractLegalBasisText;

  /// No description provided for @occurrencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled occurrences'**
  String get occurrencesTitle;

  /// No description provided for @occurrenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Occurrence #{index}'**
  String occurrenceNumber(Object index);

  /// No description provided for @openInspection.
  ///
  /// In en, this message translates to:
  /// **'Open inspection'**
  String get openInspection;

  /// No description provided for @pendingAssignment.
  ///
  /// In en, this message translates to:
  /// **'Pending dispatch'**
  String get pendingAssignment;

  /// No description provided for @requestStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get requestStatusOpen;

  /// No description provided for @requestStatusQuoted.
  ///
  /// In en, this message translates to:
  /// **'Quoted'**
  String get requestStatusQuoted;

  /// No description provided for @requestStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get requestStatusAccepted;

  /// No description provided for @requestStatusContractSigned.
  ///
  /// In en, this message translates to:
  /// **'Contract signed'**
  String get requestStatusContractSigned;

  /// No description provided for @requestStatusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get requestStatusAssigned;

  /// No description provided for @requestStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get requestStatusCancelled;

  /// No description provided for @inspectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspections & Reports'**
  String get inspectionsTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get filterInProgress;

  /// No description provided for @filterReportReady.
  ///
  /// In en, this message translates to:
  /// **'Report ready'**
  String get filterReportReady;

  /// No description provided for @filterActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get filterActionNeeded;

  /// No description provided for @inspectionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection Detail'**
  String get inspectionDetailTitle;

  /// No description provided for @tabTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tabTracking;

  /// No description provided for @tabOfficialReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get tabOfficialReport;

  /// No description provided for @tabSettlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get tabSettlement;

  /// No description provided for @progressMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspection lifecycle'**
  String get progressMilestonesTitle;

  /// No description provided for @milestoneMissionSetup.
  ///
  /// In en, this message translates to:
  /// **'Mission setup & dispatch'**
  String get milestoneMissionSetup;

  /// No description provided for @milestoneDroneFlight.
  ///
  /// In en, this message translates to:
  /// **'Drone aerial inspection'**
  String get milestoneDroneFlight;

  /// No description provided for @milestoneEvidenceAi.
  ///
  /// In en, this message translates to:
  /// **'Evidence intake & AI detection'**
  String get milestoneEvidenceAi;

  /// No description provided for @milestoneManagerReview.
  ///
  /// In en, this message translates to:
  /// **'Platform Manager review'**
  String get milestoneManagerReview;

  /// No description provided for @milestonePublished.
  ///
  /// In en, this message translates to:
  /// **'Official report published'**
  String get milestonePublished;

  /// No description provided for @assignedDroneLabel.
  ///
  /// In en, this message translates to:
  /// **'Assigned drone'**
  String get assignedDroneLabel;

  /// No description provided for @inspectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Inspector'**
  String get inspectorLabel;

  /// No description provided for @managerLabel.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get managerLabel;

  /// No description provided for @flightPermitLabel.
  ///
  /// In en, this message translates to:
  /// **'Flight permit'**
  String get flightPermitLabel;

  /// No description provided for @fieldSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Field sessions'**
  String get fieldSessionsTitle;

  /// No description provided for @noFieldSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No field sessions recorded yet.'**
  String get noFieldSessionsYet;

  /// No description provided for @evidenceGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Captured evidence ({count})'**
  String evidenceGalleryTitle(Object count);

  /// No description provided for @noEvidenceYet.
  ///
  /// In en, this message translates to:
  /// **'No field evidence captured yet.'**
  String get noEvidenceYet;

  /// No description provided for @confirmedFindingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Defect findings ({count})'**
  String confirmedFindingsTitle(Object count);

  /// No description provided for @noFindingsYet.
  ///
  /// In en, this message translates to:
  /// **'No defect findings recorded.'**
  String get noFindingsYet;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @noReportVersionsYet.
  ///
  /// In en, this message translates to:
  /// **'The official report will appear here once published.'**
  String get noReportVersionsYet;

  /// No description provided for @reportVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version v{version}'**
  String reportVersionLabel(Object version);

  /// No description provided for @aiExecutiveSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Executive Summary'**
  String get aiExecutiveSummaryTitle;

  /// No description provided for @keyHighlightsLabel.
  ///
  /// In en, this message translates to:
  /// **'Key highlights'**
  String get keyHighlightsLabel;

  /// No description provided for @recommendedActionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended actions'**
  String get recommendedActionsLabel;

  /// No description provided for @overallRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall risk: {risk}'**
  String overallRiskLabel(Object risk);

  /// No description provided for @downloadOfficialPdf.
  ///
  /// In en, this message translates to:
  /// **'Download official PDF'**
  String get downloadOfficialPdf;

  /// No description provided for @reportUnpublishedNotice.
  ///
  /// In en, this message translates to:
  /// **'Report PDF download becomes available once Platform Manager publishes this version.'**
  String get reportUnpublishedNotice;

  /// No description provided for @settlementStepAccept.
  ///
  /// In en, this message translates to:
  /// **'1. Accept official report'**
  String get settlementStepAccept;

  /// No description provided for @settlementStepPay.
  ///
  /// In en, this message translates to:
  /// **'2. Settle service fee'**
  String get settlementStepPay;

  /// No description provided for @settlementStepFulfilled.
  ///
  /// In en, this message translates to:
  /// **'3. Service fulfilled'**
  String get settlementStepFulfilled;

  /// No description provided for @serviceInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service invoice'**
  String get serviceInvoiceTitle;

  /// No description provided for @preVatBase.
  ///
  /// In en, this message translates to:
  /// **'Pre-VAT base'**
  String get preVatBase;

  /// No description provided for @vatLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT ({rate}%)'**
  String vatLabel(Object rate);

  /// No description provided for @amountToPay.
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get amountToPay;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get totalPaid;

  /// No description provided for @acceptReport.
  ///
  /// In en, this message translates to:
  /// **'Accept report'**
  String get acceptReport;

  /// No description provided for @acceptReportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Accepting official report v{version} locks deliverable acceptance and starts payment settlement.'**
  String acceptReportConfirm(Object version);

  /// No description provided for @reportAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report accepted. Complete payment below.'**
  String get reportAcceptedSuccess;

  /// No description provided for @requestClarification.
  ///
  /// In en, this message translates to:
  /// **'Request clarification'**
  String get requestClarification;

  /// No description provided for @clarificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Request clarification'**
  String get clarificationTitle;

  /// No description provided for @clarificationPolicyNote.
  ///
  /// In en, this message translates to:
  /// **'Maximum 2 clarification requests allowed before acceptance (current attempt: {attempt}/2).'**
  String clarificationPolicyNote(Object attempt);

  /// No description provided for @clarificationLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum of 2 clarification requests reached. Contact Platform Manager directly for resolution.'**
  String get clarificationLimitReached;

  /// No description provided for @clarificationReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Describe inaccurate defect locations, unclear photos, or severity questions…'**
  String get clarificationReasonHint;

  /// No description provided for @clarificationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Clarification request submitted.'**
  String get clarificationSubmitted;

  /// No description provided for @payWithPayos.
  ///
  /// In en, this message translates to:
  /// **'Pay via PayOS (VietQR)'**
  String get payWithPayos;

  /// No description provided for @payWithVnpay.
  ///
  /// In en, this message translates to:
  /// **'Pay via VNPay'**
  String get payWithVnpay;

  /// No description provided for @net15Notice.
  ///
  /// In en, this message translates to:
  /// **'Net 15 payment term: Please settle within 15 days. Downloads prior to payment remain preview copies.'**
  String get net15Notice;

  /// No description provided for @paymentPaidBanner.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed! Inspection deliverables are officially verified and archived.'**
  String get paymentPaidBanner;

  /// No description provided for @payosOrderReady.
  ///
  /// In en, this message translates to:
  /// **'PayOS Order #{orderCode} ready. Open checkout link or scan VietQR.'**
  String payosOrderReady(Object orderCode);

  /// No description provided for @openPaymentLink.
  ///
  /// In en, this message translates to:
  /// **'Open checkout link'**
  String get openPaymentLink;

  /// No description provided for @refreshPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get refreshPaymentStatus;

  /// No description provided for @inspectionStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get inspectionStatusScheduled;

  /// No description provided for @inspectionStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inspectionStatusInProgress;

  /// No description provided for @inspectionStatusFieldCompleted.
  ///
  /// In en, this message translates to:
  /// **'Field completed'**
  String get inspectionStatusFieldCompleted;

  /// No description provided for @inspectionStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get inspectionStatusUnderReview;

  /// No description provided for @inspectionStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get inspectionStatusCompleted;

  /// No description provided for @inspectionStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get inspectionStatusCancelled;

  /// No description provided for @reportStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get reportStatusDraft;

  /// No description provided for @reportStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get reportStatusSubmitted;

  /// No description provided for @reportStatusReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get reportStatusReturned;

  /// No description provided for @reportStatusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get reportStatusPublished;

  /// No description provided for @reportStatusSuperseded.
  ///
  /// In en, this message translates to:
  /// **'Superseded'**
  String get reportStatusSuperseded;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Payment due'**
  String get paymentStatusDue;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'Pending acceptance'**
  String get paymentStatusNotApplicable;

  /// No description provided for @severityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get severityCritical;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get severityHigh;

  /// No description provided for @severityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get severityMedium;

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get severityLow;

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

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up.'**
  String get noNotificationsYet;

  /// No description provided for @unreadOnly.
  ///
  /// In en, this message translates to:
  /// **'Unread only'**
  String get unreadOnly;

  /// No description provided for @unreadChatSection.
  ///
  /// In en, this message translates to:
  /// **'Unread order chat ({count})'**
  String unreadChatSection(Object count);

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & Settings'**
  String get accountTitle;

  /// No description provided for @organizationLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization ID: {id}'**
  String organizationLabel(Object id);

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

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

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeModeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @logoutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Sign out all devices'**
  String get logoutAllDevices;

  /// No description provided for @logoutAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of every active session on web and mobile?'**
  String get logoutAllConfirm;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in.'**
  String get notSignedIn;

  /// No description provided for @userRoleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get userRoleCustomer;

  /// No description provided for @userRolePlatformManager.
  ///
  /// In en, this message translates to:
  /// **'Platform Manager'**
  String get userRolePlatformManager;

  /// No description provided for @userRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get userRoleAdmin;

  /// No description provided for @userRoleInspector.
  ///
  /// In en, this message translates to:
  /// **'Inspector'**
  String get userRoleInspector;

  /// No description provided for @userRoleMaintenanceEngineer.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Engineer'**
  String get userRoleMaintenanceEngineer;
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
