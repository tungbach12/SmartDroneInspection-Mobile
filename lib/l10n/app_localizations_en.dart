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
  String get appTitle => 'SDI Customer';

  @override
  String get customerPortalSubtitle => 'Customer Portal';

  @override
  String get navDashboard => 'Home';

  @override
  String get navAssets => 'Assets';

  @override
  String get navRequests => 'Requests';

  @override
  String get navInspections => 'Inspections';

  @override
  String get navAccount => 'Account';

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
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get all => 'All';

  @override
  String get loading => 'Loading…';

  @override
  String get submitting => 'Submitting…';

  @override
  String get saving => 'Saving…';

  @override
  String get download => 'Download';

  @override
  String get viewDetails => 'View details';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInSubtitle =>
      'Sign in to manage assets, service requests, official reports, and payments.';

  @override
  String get authRegisterSubtitle =>
      'Set up your Customer Portal account and verify your email.';

  @override
  String get authResetSubtitle =>
      'Enter your registered email to receive a 6-digit reset code.';

  @override
  String get stepAccountDetails => 'Account details';

  @override
  String get stepEmailVerification => 'Verification';

  @override
  String get stepResetRequest => 'Verify email';

  @override
  String get stepResetVerify => 'Reset password';

  @override
  String passwordCharsProgress(Object count) {
    return '$count/15+ characters';
  }

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get or => 'or';

  @override
  String get createAccount => 'Create Customer account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get sendResetOtp => 'Send reset code';

  @override
  String get otpCodeLabel => '6-digit verification code';

  @override
  String get sendOtp => 'Send verification code';

  @override
  String get verifyOtp => 'Verify & continue';

  @override
  String otpPrompt(Object email) {
    return 'Enter the verification code sent to $email.';
  }

  @override
  String otpResendCountdown(Object seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendOtp => 'Resend code';

  @override
  String get fullName => 'Full name';

  @override
  String get phoneNumberOptional => 'Phone number (optional)';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordRequirement => 'New password (15+ characters)';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get setNewPassword => 'Set new password';

  @override
  String get passwordSetupNotice =>
      'You must set a new password before continuing.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get required => 'Required';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get minimum15Characters => 'Minimum 15 characters';

  @override
  String get invalidCredentials => 'Invalid email or password.';

  @override
  String get customerOnlyAccessNotice =>
      'This mobile app is exclusively for Customer accounts. Inspectors and Platform Managers should use the web portal.';

  @override
  String get registrationSuccess => 'Account created! You can now sign in.';

  @override
  String get pendingAirspaceReviewNotice =>
      'Registration submitted and pending airspace review. We will contact you after assessment.';

  @override
  String get passwordResetSuccess =>
      'Password updated. Sign in with your new password.';

  @override
  String get passwordChangedSuccess =>
      'Password changed. Please sign in again.';

  @override
  String get serverError => 'Server error. Please try again.';

  @override
  String get cannotReachServer =>
      'Cannot reach the server. Check your connection.';

  @override
  String get notFoundError => 'Record not found.';

  @override
  String get accessDeniedError => 'You are not allowed to perform this action.';

  @override
  String get dashboardTitle => 'Customer Overview';

  @override
  String get kpiRegisteredAssets => 'Registered assets';

  @override
  String get kpiInProgress => 'In progress';

  @override
  String get kpiOfficialReports => 'Official reports';

  @override
  String get kpiSettledFees => 'Settled fees';

  @override
  String get quickActionNewRequest => 'New request';

  @override
  String get quickActionRegisterAsset => 'Add asset';

  @override
  String get recentInspectionsTitle => 'Recent inspections & fees';

  @override
  String get assetOverviewTitle => 'Asset overview';

  @override
  String get viewAll => 'View all';

  @override
  String get noInspectionsYet => 'No inspections yet.';

  @override
  String get noAssetsYet => 'No registered assets yet.';

  @override
  String get assetsTitle => 'Assets';

  @override
  String get searchAssetsHint => 'Search by asset name, code, or location…';

  @override
  String get registerAsset => 'Register asset';

  @override
  String get editAsset => 'Edit asset';

  @override
  String get retireAsset => 'Retire asset';

  @override
  String retireAssetConfirm(Object name) {
    return 'Retire \"$name\"? Retired assets remain in history and cannot accept new requests.';
  }

  @override
  String get assetRetiredSuccess => 'Asset retired.';

  @override
  String get assetSavedSuccess => 'Asset saved.';

  @override
  String get assetName => 'Asset name';

  @override
  String get assetCode => 'Asset code';

  @override
  String get assetCategory => 'Category';

  @override
  String get assetLocation => 'Location address / description';

  @override
  String get assetDescription => 'Technical description (optional)';

  @override
  String get latitudeOptional => 'Latitude (optional)';

  @override
  String get longitudeOptional => 'Longitude (optional)';

  @override
  String get structureHeightMeters => 'Structure height (m, optional)';

  @override
  String get footprintAreaSqm => 'Footprint area (m², optional)';

  @override
  String get inspectionItemsLabel => 'Inspection checkpoints (comma-separated)';

  @override
  String get assetDocuments => 'Asset documents';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get documentUploaded => 'Document uploaded.';

  @override
  String get noDocumentsYet => 'No documents attached yet.';

  @override
  String documentSavedTo(Object name) {
    return 'Saved: $name';
  }

  @override
  String get assetStatusActive => 'Active';

  @override
  String get assetStatusPendingReview => 'Pending review';

  @override
  String get assetStatusInactive => 'Inactive';

  @override
  String get assetStatusRejected => 'Rejected';

  @override
  String get assetStatusRetired => 'Retired';

  @override
  String get requestsTitle => 'Service Requests';

  @override
  String get searchRequestsHint => 'Search by description or asset…';

  @override
  String get newServiceRequest => 'New service request';

  @override
  String get requestDetailsTitle => 'Service Request';

  @override
  String get selectAsset => 'Select active asset';

  @override
  String get noActiveAssetsForRequest =>
      'Register an Active asset before creating a service request.';

  @override
  String get requestTypeLabel => 'Service schedule';

  @override
  String get requestTypeOneTime => 'One-time';

  @override
  String get requestTypeRecurring => 'Recurring';

  @override
  String get preferredStartDate => 'Preferred inspection date';

  @override
  String leadTime20DaysNotice(Object days, Object date) {
    return 'Schedule at least $days days ahead (earliest: $date).';
  }

  @override
  String get leadTime20DaysError => 'Date must be at least 20 days from today.';

  @override
  String get timeWindowLabel => 'Inspection hours';

  @override
  String get recurrenceMonthsLabel => 'Repeat every (months)';

  @override
  String get occurrenceCountLabel => 'Number of cycles';

  @override
  String get scopeDescriptionLabel => 'Scope & inspection objectives';

  @override
  String get requestCreatedSuccess => 'Service request submitted.';

  @override
  String get quoteSectionTitle => 'Quotation';

  @override
  String get noQuoteYet =>
      'Platform Manager is reviewing your request and will issue a quotation shortly.';

  @override
  String get quoteScopeLabel => 'Scope summary';

  @override
  String get firstWindowLabel => 'Proposed window';

  @override
  String get quoteAmountLabel => 'Fee per inspection';

  @override
  String get acceptQuote => 'Accept quotation';

  @override
  String acceptQuoteConfirm(Object amount) {
    return 'Accept this quotation ($amount)? An inspection contract and occurrence schedule will be prepared.';
  }

  @override
  String get quoteAcceptedSuccess => 'Quotation accepted.';

  @override
  String get orderChatTitle => 'Order Chat';

  @override
  String unreadMessagesBadge(Object count) {
    return '$count unread';
  }

  @override
  String get typeMessageHint => 'Write a message to Platform Manager…';

  @override
  String get noMessagesYet =>
      'No messages yet. Ask questions about scope or pricing here.';

  @override
  String get signedContractTitle => 'Signed paper contract';

  @override
  String get contractNotUploadedYet =>
      'Pending signed paper contract scan from Platform Manager.';

  @override
  String get downloadContract => 'Download / Save contract';

  @override
  String get contractLegalBasisButton => 'Legal & e-signature basis';

  @override
  String get contractLegalBasisText =>
      'Offline wet-signed contracts uploaded as verified scans comply with Vietnamese Electronic Transactions & Civil Code record-keeping requirements for commercial service execution.';

  @override
  String get occurrencesTitle => 'Scheduled occurrences';

  @override
  String occurrenceNumber(Object index) {
    return 'Occurrence #$index';
  }

  @override
  String get openInspection => 'Open inspection';

  @override
  String get pendingAssignment => 'Pending dispatch';

  @override
  String get requestStatusOpen => 'Open';

  @override
  String get requestStatusQuoted => 'Quoted';

  @override
  String get requestStatusAccepted => 'Accepted';

  @override
  String get requestStatusContractSigned => 'Contract signed';

  @override
  String get requestStatusAssigned => 'Assigned';

  @override
  String get requestStatusCancelled => 'Cancelled';

  @override
  String get inspectionsTitle => 'Inspections & Reports';

  @override
  String get filterAll => 'All';

  @override
  String get filterInProgress => 'In progress';

  @override
  String get filterReportReady => 'Report ready';

  @override
  String get filterActionNeeded => 'Action needed';

  @override
  String get inspectionDetailTitle => 'Inspection Detail';

  @override
  String get tabTracking => 'Tracking';

  @override
  String get tabOfficialReport => 'Report';

  @override
  String get tabSettlement => 'Settlement';

  @override
  String get progressMilestonesTitle => 'Inspection lifecycle';

  @override
  String get milestoneMissionSetup => 'Mission setup & dispatch';

  @override
  String get milestoneDroneFlight => 'Drone aerial inspection';

  @override
  String get milestoneEvidenceAi => 'Evidence intake & AI detection';

  @override
  String get milestoneManagerReview => 'Platform Manager review';

  @override
  String get milestonePublished => 'Official report published';

  @override
  String get assignedDroneLabel => 'Assigned drone';

  @override
  String get inspectorLabel => 'Inspector';

  @override
  String get managerLabel => 'Manager';

  @override
  String get flightPermitLabel => 'Flight permit';

  @override
  String get fieldSessionsTitle => 'Field sessions';

  @override
  String get noFieldSessionsYet => 'No field sessions recorded yet.';

  @override
  String evidenceGalleryTitle(Object count) {
    return 'Captured evidence ($count)';
  }

  @override
  String get noEvidenceYet => 'No field evidence captured yet.';

  @override
  String confirmedFindingsTitle(Object count) {
    return 'Defect findings ($count)';
  }

  @override
  String get noFindingsYet => 'No defect findings recorded.';

  @override
  String get noteLabel => 'Note';

  @override
  String get noReportVersionsYet =>
      'The official report will appear here once published.';

  @override
  String reportVersionLabel(Object version) {
    return 'Version v$version';
  }

  @override
  String get aiExecutiveSummaryTitle => 'AI Executive Summary';

  @override
  String get keyHighlightsLabel => 'Key highlights';

  @override
  String get recommendedActionsLabel => 'Recommended actions';

  @override
  String overallRiskLabel(Object risk) {
    return 'Overall risk: $risk';
  }

  @override
  String get downloadOfficialPdf => 'Download official PDF';

  @override
  String get reportUnpublishedNotice =>
      'Report PDF download becomes available once Platform Manager publishes this version.';

  @override
  String get settlementStepAccept => '1. Accept official report';

  @override
  String get settlementStepPay => '2. Settle service fee';

  @override
  String get settlementStepFulfilled => '3. Service fulfilled';

  @override
  String get serviceInvoiceTitle => 'Service invoice';

  @override
  String get preVatBase => 'Pre-VAT base';

  @override
  String vatLabel(Object rate) {
    return 'VAT ($rate%)';
  }

  @override
  String get amountToPay => 'Amount due';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get acceptReport => 'Accept report';

  @override
  String acceptReportConfirm(Object version) {
    return 'Accepting official report v$version locks deliverable acceptance and starts payment settlement.';
  }

  @override
  String get reportAcceptedSuccess =>
      'Report accepted. Complete payment below.';

  @override
  String get requestClarification => 'Request clarification';

  @override
  String get clarificationTitle => 'Request clarification';

  @override
  String clarificationPolicyNote(Object attempt) {
    return 'Maximum 2 clarification requests allowed before acceptance (current attempt: $attempt/2).';
  }

  @override
  String get clarificationLimitReached =>
      'Maximum of 2 clarification requests reached. Contact Platform Manager directly for resolution.';

  @override
  String get clarificationReasonHint =>
      'Describe inaccurate defect locations, unclear photos, or severity questions…';

  @override
  String get clarificationSubmitted => 'Clarification request submitted.';

  @override
  String get payWithSepay => 'Pay via Sepay (VietQR)';

  @override
  String get payWithVnpay => 'Pay via VNPay';

  @override
  String get net15Notice =>
      'Net 15 payment term: Please settle within 15 days. Downloads prior to payment remain preview copies.';

  @override
  String get paymentPaidBanner =>
      'Payment confirmed! Inspection deliverables are officially verified and archived.';

  @override
  String sepayOrderReady(Object orderCode) {
    return 'Sepay Order #$orderCode ready. Open checkout link or scan VietQR.';
  }

  @override
  String get openPaymentLink => 'Open checkout link';

  @override
  String get refreshPaymentStatus => 'Refresh status';

  @override
  String get sepayQrTitle => 'Sepay VietQR payment';

  @override
  String get sepayQrSubtitle =>
      'Scan this VietQR code with your banking app. Payment confirms automatically within a few minutes.';

  @override
  String get bankLabel => 'Bank';

  @override
  String get accountNumberLabel => 'Account number';

  @override
  String get accountHolderLabel => 'Account holder';

  @override
  String get transferContentLabel => 'Transfer content';

  @override
  String get copiedLabel => 'Copied';

  @override
  String get copyLabel => 'Copy';

  @override
  String get qrUnavailableFallback =>
      'QR image unavailable. Use the bank details below to transfer manually.';

  @override
  String get keepTransferContentHint =>
      'Keep the transfer content unchanged so the payment can be matched automatically.';

  @override
  String get checkPaymentStatus => 'Check payment status';

  @override
  String get checkingPaymentStatus => 'Checking…';

  @override
  String get resetPaymentOrder => 'Reset payment order';

  @override
  String get paymentOrderCleared =>
      'Unpaid payment order cleared. You can choose a payment method again.';

  @override
  String get inspectionStatusScheduled => 'Scheduled';

  @override
  String get inspectionStatusInProgress => 'In progress';

  @override
  String get inspectionStatusFieldCompleted => 'Field completed';

  @override
  String get inspectionStatusUnderReview => 'Under review';

  @override
  String get inspectionStatusCompleted => 'Completed';

  @override
  String get inspectionStatusCancelled => 'Cancelled';

  @override
  String get reportStatusDraft => 'Draft';

  @override
  String get reportStatusSubmitted => 'Submitted';

  @override
  String get reportStatusReturned => 'Returned';

  @override
  String get reportStatusPublished => 'Published';

  @override
  String get reportStatusSuperseded => 'Superseded';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusDue => 'Payment due';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusNotApplicable => 'Pending acceptance';

  @override
  String get severityCritical => 'Critical';

  @override
  String get severityHigh => 'High';

  @override
  String get severityMedium => 'Medium';

  @override
  String get severityLow => 'Low';

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
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotificationsYet => 'You are all caught up.';

  @override
  String get unreadOnly => 'Unread only';

  @override
  String unreadChatSection(Object count) {
    return 'Unread order chat ($count)';
  }

  @override
  String get accountTitle => 'Account & Settings';

  @override
  String organizationLabel(Object id) {
    return 'Organization ID: $id';
  }

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get themeModeLabel => 'Appearance';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get securitySection => 'Security';

  @override
  String get changePassword => 'Change password';

  @override
  String get logoutAllDevices => 'Sign out all devices';

  @override
  String get logoutAllConfirm =>
      'Sign out of every active session on web and mobile?';

  @override
  String get signOut => 'Sign out';

  @override
  String get notSignedIn => 'Not signed in.';

  @override
  String get userRoleCustomer => 'Customer';

  @override
  String get userRolePlatformManager => 'Platform Manager';

  @override
  String get userRoleAdmin => 'Administrator';

  @override
  String get userRoleInspector => 'Inspector';

  @override
  String get userRoleMaintenanceEngineer => 'Maintenance Engineer';

  @override
  String verdictExpiredChip(Object count) {
    return '$count verdicts expired';
  }

  @override
  String verdictExpiringSoonChip(Object count) {
    return '$count verdicts expire in 14d';
  }

  @override
  String paymentDueOn(Object date) {
    return 'Due $date';
  }

  @override
  String get paymentOverdue => 'Overdue';

  @override
  String get paymentNoticePdf => 'Notice PDF';

  @override
  String get paymentReceiptPdf => 'Receipt PDF';

  @override
  String get inspectionChatTitle => 'Inspection chat';

  @override
  String get typeInspectionMessageHint => 'Message the inspector…';

  @override
  String get attachFile => 'Attach';

  @override
  String get knowledgeMatchesTitle => 'Matched cases & standards';

  @override
  String knowledgeMatchPercent(Object percent) {
    return '$percent% match';
  }

  @override
  String knowledgeCasesCount(Object count) {
    return '$count cases';
  }

  @override
  String knowledgeStandardsCount(Object count) {
    return '$count standards';
  }

  @override
  String get showDetails => 'Show details';
}
