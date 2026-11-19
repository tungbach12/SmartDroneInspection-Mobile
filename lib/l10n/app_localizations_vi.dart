// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'SmartDroneInspection';

  @override
  String get appTitle => 'SDI Khách hàng';

  @override
  String get customerPortalSubtitle => 'Cổng Khách hàng';

  @override
  String get navDashboard => 'Tổng quan';

  @override
  String get navAssets => 'Tài sản';

  @override
  String get navRequests => 'Yêu cầu';

  @override
  String get navInspections => 'Kiểm định';

  @override
  String get navAccount => 'Tài khoản';

  @override
  String get notFound => 'Không tìm thấy';

  @override
  String get pageNotFound => 'Không tìm thấy trang';

  @override
  String get nothingHereYet => 'Chưa có dữ liệu';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get close => 'Đóng';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get refresh => 'Làm mới';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get all => 'Tất cả';

  @override
  String get loading => 'Đang tải…';

  @override
  String get submitting => 'Đang gửi…';

  @override
  String get saving => 'Đang lưu…';

  @override
  String get download => 'Tải xuống';

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signInSubtitle =>
      'Đăng nhập để quản lý tài sản, yêu cầu dịch vụ, báo cáo chính thức và thanh toán.';

  @override
  String get authRegisterSubtitle =>
      'Thiết lập tài khoản Cổng Khách hàng và xác thực email của bạn.';

  @override
  String get authResetSubtitle =>
      'Nhập email đã đăng ký để nhận mã khôi phục 6 chữ số.';

  @override
  String get stepAccountDetails => 'Thông tin tài khoản';

  @override
  String get stepEmailVerification => 'Xác thực email';

  @override
  String get stepResetRequest => 'Xác thực email';

  @override
  String get stepResetVerify => 'Đặt lại mật khẩu';

  @override
  String passwordCharsProgress(Object count) {
    return '$count/15+ ký tự';
  }

  @override
  String get signInWithGoogle => 'Tiếp tục với Google';

  @override
  String get or => 'hoặc';

  @override
  String get createAccount => 'Tạo tài khoản Khách hàng';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? Đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get sendResetOtp => 'Gửi mã đặt lại';

  @override
  String get otpCodeLabel => 'Mã xác thực 6 chữ số';

  @override
  String get sendOtp => 'Gửi mã xác thực';

  @override
  String get verifyOtp => 'Xác nhận & tiếp tục';

  @override
  String otpPrompt(Object email) {
    return 'Nhập mã xác thực đã gửi tới $email.';
  }

  @override
  String otpResendCountdown(Object seconds) {
    return 'Gửi lại sau $seconds giây';
  }

  @override
  String get resendOtp => 'Gửi lại mã';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get phoneNumberOptional => 'Số điện thoại (không bắt buộc)';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get newPasswordRequirement => 'Mật khẩu mới (tối thiểu 15 ký tự)';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get setNewPassword => 'Đặt mật khẩu mới';

  @override
  String get passwordSetupNotice =>
      'Bạn cần đặt mật khẩu mới trước khi tiếp tục.';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu xác nhận không khớp.';

  @override
  String get required => 'Bắt buộc';

  @override
  String get invalidEmail => 'Vui lòng nhập email hợp lệ.';

  @override
  String get minimum15Characters => 'Tối thiểu 15 ký tự';

  @override
  String get invalidCredentials => 'Email hoặc mật khẩu không đúng.';

  @override
  String get customerOnlyAccessNotice =>
      'Ứng dụng di động chỉ dành riêng cho tài khoản Khách hàng. Kiểm định viên và Quản lý nền tảng vui lòng sử dụng cổng web.';

  @override
  String get registrationSuccess =>
      'Tạo tài khoản thành công! Bạn có thể đăng nhập ngay.';

  @override
  String get pendingAirspaceReviewNotice =>
      'Đã gửi đăng ký và đang chờ xét duyệt vùng bay. Chúng tôi sẽ liên hệ sau khi đánh giá.';

  @override
  String get passwordResetSuccess =>
      'Đã cập nhật mật khẩu. Vui lòng đăng nhập bằng mật khẩu mới.';

  @override
  String get passwordChangedSuccess =>
      'Đã đổi mật khẩu. Vui lòng đăng nhập lại.';

  @override
  String get serverError => 'Lỗi máy chủ. Vui lòng thử lại.';

  @override
  String get cannotReachServer =>
      'Không thể kết nối máy chủ. Kiểm tra mạng và thử lại.';

  @override
  String get notFoundError => 'Không tìm thấy dữ liệu.';

  @override
  String get accessDeniedError => 'Bạn không có quyền thực hiện thao tác này.';

  @override
  String get dashboardTitle => 'Tổng quan Khách hàng';

  @override
  String get kpiRegisteredAssets => 'Tài sản đã đăng ký';

  @override
  String get kpiInProgress => 'Đang thực hiện';

  @override
  String get kpiOfficialReports => 'Báo cáo chính thức';

  @override
  String get kpiSettledFees => 'Đã thanh toán';

  @override
  String get quickActionNewRequest => 'Tạo yêu cầu';

  @override
  String get quickActionRegisterAsset => 'Thêm tài sản';

  @override
  String get recentInspectionsTitle => 'Kiểm định & thanh toán gần đây';

  @override
  String get assetOverviewTitle => 'Tổng quan tài sản';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get noInspectionsYet => 'Chưa có đợt kiểm định nào.';

  @override
  String get noAssetsYet => 'Chưa có tài sản nào được đăng ký.';

  @override
  String get assetsTitle => 'Tài sản';

  @override
  String get searchAssetsHint => 'Tìm theo tên, mã tài sản hoặc địa điểm…';

  @override
  String get registerAsset => 'Đăng ký tài sản';

  @override
  String get editAsset => 'Chỉnh sửa tài sản';

  @override
  String get retireAsset => 'Ngừng sử dụng tài sản';

  @override
  String retireAssetConfirm(Object name) {
    return 'Ngừng sử dụng \"$name\"? Tài sản ngừng sử dụng vẫn giữ trong lịch sử và không thể tạo yêu cầu mới.';
  }

  @override
  String get assetRetiredSuccess => 'Đã ngừng sử dụng tài sản.';

  @override
  String get assetSavedSuccess => 'Đã lưu thông tin tài sản.';

  @override
  String get assetName => 'Tên tài sản';

  @override
  String get assetCode => 'Mã tài sản';

  @override
  String get assetCategory => 'Danh mục';

  @override
  String get assetLocation => 'Địa chỉ / Mô tả vị trí';

  @override
  String get assetDescription => 'Mô tả kỹ thuật (không bắt buộc)';

  @override
  String get latitudeOptional => 'Vĩ độ (không bắt buộc)';

  @override
  String get longitudeOptional => 'Kinh độ (không bắt buộc)';

  @override
  String get structureHeightMeters =>
      'Chiều cao công trình (m, không bắt buộc)';

  @override
  String get footprintAreaSqm => 'Diện tích mặt bằng (m², không bắt buộc)';

  @override
  String get inspectionItemsLabel =>
      'Hạng mục kiểm định (cách nhau bởi dấu phẩy)';

  @override
  String get assetDocuments => 'Tài liệu tài sản';

  @override
  String get uploadDocument => 'Tải tài liệu lên';

  @override
  String get documentUploaded => 'Đã tải tài liệu lên.';

  @override
  String get noDocumentsYet => 'Chưa có tài liệu đính kèm.';

  @override
  String documentSavedTo(Object name) {
    return 'Đã lưu: $name';
  }

  @override
  String get assetStatusActive => 'Đang hoạt động';

  @override
  String get assetStatusPendingReview => 'Chờ duyệt';

  @override
  String get assetStatusInactive => 'Ngừng hoạt động';

  @override
  String get assetStatusRejected => 'Bị từ chối';

  @override
  String get assetStatusRetired => 'Đã ngừng sử dụng';

  @override
  String get requestsTitle => 'Yêu cầu dịch vụ';

  @override
  String get searchRequestsHint => 'Tìm theo mô tả hoặc tài sản…';

  @override
  String get newServiceRequest => 'Tạo yêu cầu dịch vụ';

  @override
  String get requestDetailsTitle => 'Chi tiết yêu cầu dịch vụ';

  @override
  String get selectAsset => 'Chọn tài sản đang hoạt động';

  @override
  String get noActiveAssetsForRequest =>
      'Vui lòng đăng ký tài sản Đang hoạt động trước khi tạo yêu cầu.';

  @override
  String get requestTypeLabel => 'Hình thức lịch trình';

  @override
  String get requestTypeOneTime => 'Một lần';

  @override
  String get requestTypeRecurring => 'Định kỳ';

  @override
  String get preferredStartDate => 'Ngày kiểm định dự kiến';

  @override
  String leadTime20DaysNotice(Object days, Object date) {
    return 'Đặt lịch trước tối thiểu $days ngày (sớm nhất: $date).';
  }

  @override
  String get leadTime20DaysError =>
      'Ngày bắt đầu phải cách hôm nay tối thiểu 20 ngày.';

  @override
  String get timeWindowLabel => 'Khung giờ kiểm định';

  @override
  String get recurrenceMonthsLabel => 'Chu kỳ lặp (tháng)';

  @override
  String get occurrenceCountLabel => 'Số đợt kiểm định';

  @override
  String get scopeDescriptionLabel => 'Phạm vi & mục tiêu kiểm định';

  @override
  String get requestCreatedSuccess => 'Đã gửi yêu cầu dịch vụ.';

  @override
  String get quoteSectionTitle => 'Báo giá dịch vụ';

  @override
  String get noQuoteYet =>
      'Quản lý nền tảng đang xem xét yêu cầu và sẽ phát hành báo giá sớm.';

  @override
  String get quoteScopeLabel => 'Tóm tắt phạm vi';

  @override
  String get firstWindowLabel => 'Khung thời gian đề xuất';

  @override
  String get quoteAmountLabel => 'Đơn giá mỗi đợt';

  @override
  String get acceptQuote => 'Chấp nhận báo giá';

  @override
  String acceptQuoteConfirm(Object amount) {
    return 'Chấp nhận báo giá ($amount)? Hợp đồng và lịch thực hiện sẽ được chuẩn bị.';
  }

  @override
  String get quoteAcceptedSuccess => 'Đã chấp nhận báo giá.';

  @override
  String get orderChatTitle => 'Trao đổi đơn hàng';

  @override
  String unreadMessagesBadge(Object count) {
    return '$count chưa đọc';
  }

  @override
  String get typeMessageHint => 'Nhắn tin cho Quản lý nền tảng…';

  @override
  String get noMessagesYet =>
      'Chưa có tin nhắn. Hãy trao đổi phạm vi hoặc báo giá tại đây.';

  @override
  String get signedContractTitle => 'Hợp đồng giấy đã ký';

  @override
  String get contractNotUploadedYet =>
      'Đang chờ Quản lý nền tảng tải bản scan hợp đồng đã ký.';

  @override
  String get downloadContract => 'Tải / Lưu hợp đồng';

  @override
  String get contractLegalBasisButton => 'Cơ sở pháp lý';

  @override
  String get contractLegalBasisText =>
      'Hợp đồng ký tay được quét và lưu trữ đáp ứng yêu cầu lưu trữ chứng từ giao dịch thương mại và Bộ luật Dân sự.';

  @override
  String get occurrencesTitle => 'Các đợt thực hiện';

  @override
  String occurrenceNumber(Object index) {
    return 'Đợt #$index';
  }

  @override
  String get openInspection => 'Mở kiểm định';

  @override
  String get pendingAssignment => 'Chờ điều phối';

  @override
  String get requestStatusOpen => 'Đang mở';

  @override
  String get requestStatusQuoted => 'Đã báo giá';

  @override
  String get requestStatusAccepted => 'Đã chấp nhận';

  @override
  String get requestStatusContractSigned => 'Đã ký hợp đồng';

  @override
  String get requestStatusAssigned => 'Đã phân công';

  @override
  String get requestStatusCancelled => 'Đã hủy';

  @override
  String get inspectionsTitle => 'Kiểm định & Báo cáo';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterInProgress => 'Đang thực hiện';

  @override
  String get filterReportReady => 'Đã có báo cáo';

  @override
  String get filterActionNeeded => 'Cần xử lý';

  @override
  String get inspectionDetailTitle => 'Chi tiết kiểm định';

  @override
  String get tabTracking => 'Tiến độ';

  @override
  String get tabOfficialReport => 'Báo cáo';

  @override
  String get tabSettlement => 'Thanh toán';

  @override
  String get progressMilestonesTitle => 'Tiến trình kiểm định';

  @override
  String get milestoneMissionSetup => 'Chuẩn bị & điều phối';

  @override
  String get milestoneDroneFlight => 'Bay thu thập dữ liệu';

  @override
  String get milestoneEvidenceAi => 'Dữ liệu hiện trường & AI';

  @override
  String get milestoneManagerReview => 'Quản lý thẩm định';

  @override
  String get milestonePublished => 'Phát hành báo cáo chính thức';

  @override
  String get assignedDroneLabel => 'Drone phân công';

  @override
  String get inspectorLabel => 'Kiểm định viên';

  @override
  String get managerLabel => 'Quản lý';

  @override
  String get flightPermitLabel => 'Giấy phép bay';

  @override
  String get fieldSessionsTitle => 'Phiên thực địa';

  @override
  String get noFieldSessionsYet => 'Chưa có phiên thực địa nào được ghi nhận.';

  @override
  String evidenceGalleryTitle(Object count) {
    return 'Bằng chứng hiện trường ($count)';
  }

  @override
  String get noEvidenceYet => 'Chưa có ảnh hoặc video hiện trường.';

  @override
  String confirmedFindingsTitle(Object count) {
    return 'Phát hiện lỗi ($count)';
  }

  @override
  String get noFindingsYet => 'Chưa ghi nhận lỗi nào.';

  @override
  String get noteLabel => 'Ghi chú';

  @override
  String get noReportVersionsYet =>
      'Báo cáo chính thức sẽ hiển thị tại đây sau khi được phát hành.';

  @override
  String reportVersionLabel(Object version) {
    return 'Phiên bản v$version';
  }

  @override
  String get aiExecutiveSummaryTitle => 'Tóm tắt điều hành AI';

  @override
  String get keyHighlightsLabel => 'Điểm nổi bật';

  @override
  String get recommendedActionsLabel => 'Hành động khuyến nghị';

  @override
  String overallRiskLabel(Object risk) {
    return 'Mức rủi ro tổng thể: $risk';
  }

  @override
  String get downloadOfficialPdf => 'Tải báo cáo PDF chính thức';

  @override
  String get reportUnpublishedNotice =>
      'Bản PDF chính thức sẽ mở tải xuống sau khi Quản lý nền tảng phát hành phiên bản này.';

  @override
  String get settlementStepAccept => '1. Nghiệm thu báo cáo';

  @override
  String get settlementStepPay => '2. Thanh toán phí dịch vụ';

  @override
  String get settlementStepFulfilled => '3. Hoàn tất dịch vụ';

  @override
  String get serviceInvoiceTitle => 'Hóa đơn dịch vụ';

  @override
  String get preVatBase => 'Giá trước VAT';

  @override
  String vatLabel(Object rate) {
    return 'Thuế VAT ($rate%)';
  }

  @override
  String get amountToPay => 'Số tiền cần thanh toán';

  @override
  String get totalPaid => 'Tổng đã thanh toán';

  @override
  String get acceptReport => 'Nghiệm thu báo cáo';

  @override
  String acceptReportConfirm(Object version) {
    return 'Nghiệm thu báo cáo v$version sẽ xác nhận bàn giao và chuyển sang bước thanh toán phí dịch vụ.';
  }

  @override
  String get reportAcceptedSuccess =>
      'Đã nghiệm thu báo cáo. Vui lòng hoàn tất thanh toán bên dưới.';

  @override
  String get requestClarification => 'Yêu cầu làm rõ';

  @override
  String get clarificationTitle => 'Yêu cầu làm rõ báo cáo';

  @override
  String clarificationPolicyNote(Object attempt) {
    return 'Cho phép tối đa 02 lần yêu cầu làm rõ trước khi nghiệm thu (lần hiện tại: $attempt/2).';
  }

  @override
  String get clarificationLimitReached =>
      'Đã đạt giới hạn tối đa 02 lần yêu cầu làm rõ. Vui lòng liên hệ Quản lý nền tảng để đối soát.';

  @override
  String get clarificationReasonHint =>
      'Nêu rõ vị trí lỗi chưa chính xác, ảnh mờ hoặc mức độ nghiêm trọng cần xem xét lại…';

  @override
  String get clarificationSubmitted => 'Đã gửi yêu cầu làm rõ.';

  @override
  String get payWithPayos => 'Thanh toán PayOS (VietQR)';

  @override
  String get payWithVnpay => 'Thanh toán VNPay';

  @override
  String get net15Notice =>
      'Thời hạn thanh toán Net 15: Vui lòng thanh toán trong vòng 15 ngày. Bản PDF tải trước khi thanh toán mang dấu xem trước.';

  @override
  String get paymentPaidBanner =>
      'Thanh toán thành công! Dịch vụ kiểm định và hồ sơ bàn giao đã được xác thực hoàn tất.';

  @override
  String payosOrderReady(Object orderCode) {
    return 'Đã tạo đơn PayOS #$orderCode. Mở liên kết hoặc quét VietQR để thanh toán.';
  }

  @override
  String get openPaymentLink => 'Mở trang thanh toán';

  @override
  String get refreshPaymentStatus => 'Cập nhật trạng thái';

  @override
  String get inspectionStatusScheduled => 'Đã lên lịch';

  @override
  String get inspectionStatusInProgress => 'Đang thực hiện';

  @override
  String get inspectionStatusFieldCompleted => 'Hoàn tất bay';

  @override
  String get inspectionStatusUnderReview => 'Đang thẩm định';

  @override
  String get inspectionStatusCompleted => 'Hoàn thành';

  @override
  String get inspectionStatusCancelled => 'Đã hủy';

  @override
  String get reportStatusDraft => 'Bản nháp';

  @override
  String get reportStatusSubmitted => 'Đã nộp';

  @override
  String get reportStatusReturned => 'Bị trả lại';

  @override
  String get reportStatusPublished => 'Đã phát hành';

  @override
  String get reportStatusSuperseded => 'Đã thay thế';

  @override
  String get paymentStatusPaid => 'Đã thanh toán';

  @override
  String get paymentStatusDue => 'Chờ thanh toán';

  @override
  String get paymentStatusPending => 'Chờ xử lý';

  @override
  String get paymentStatusNotApplicable => 'Chờ nghiệm thu';

  @override
  String get severityCritical => 'Nghiêm trọng';

  @override
  String get severityHigh => 'Cao';

  @override
  String get severityMedium => 'Trung bình';

  @override
  String get severityLow => 'Thấp';

  @override
  String get fieldSessionStatusInProgress => 'Đang tiến hành';

  @override
  String get fieldSessionStatusPostponed => 'Tạm hoãn';

  @override
  String get fieldSessionStatusAborted => 'Đã hủy giữa chừng';

  @override
  String get fieldSessionStatusPlanned => 'Đã lên lịch';

  @override
  String get fieldSessionStatusCompleted => 'Đã hoàn tất hiện trường';

  @override
  String get notificationsTitle => 'Thông báo';

  @override
  String get noNotificationsYet => 'Bạn không có thông báo mới.';

  @override
  String get unreadOnly => 'Chỉ chưa đọc';

  @override
  String unreadChatSection(Object count) {
    return 'Tin nhắn trao đổi chưa đọc ($count)';
  }

  @override
  String get accountTitle => 'Tài khoản & Cài đặt';

  @override
  String organizationLabel(Object id) {
    return 'Mã tổ chức: $id';
  }

  @override
  String get preferencesSection => 'Tùy chọn hiển thị';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get themeModeLabel => 'Giao diện';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get securitySection => 'Bảo mật';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get logoutAllDevices => 'Đăng xuất khỏi mọi thiết bị';

  @override
  String get logoutAllConfirm =>
      'Đăng xuất khỏi tất cả phiên đang hoạt động trên web và di động?';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get notSignedIn => 'Chưa đăng nhập.';

  @override
  String get userRoleCustomer => 'Khách hàng';

  @override
  String get userRolePlatformManager => 'Quản lý nền tảng';

  @override
  String get userRoleAdmin => 'Quản trị viên';

  @override
  String get userRoleInspector => 'Kiểm định viên';

  @override
  String get userRoleMaintenanceEngineer => 'Kỹ sư bảo trì';

  @override
  String verdictExpiredChip(Object count) {
    return '$count kết luận hết hạn';
  }

  @override
  String verdictExpiringSoonChip(Object count) {
    return '$count hết hạn trong 14 ngày';
  }

  @override
  String paymentDueOn(Object date) {
    return 'Đến hạn $date';
  }

  @override
  String get paymentOverdue => 'Quá hạn';

  @override
  String get paymentNoticePdf => 'PDF thông báo';

  @override
  String get paymentReceiptPdf => 'PDF biên lai';

  @override
  String get inspectionChatTitle => 'Trao đổi kiểm định';

  @override
  String get typeInspectionMessageHint => 'Nhắn cho kiểm định viên…';

  @override
  String get attachFile => 'Đính kèm';

  @override
  String get knowledgeMatchesTitle => 'Ca tương đồng & tiêu chuẩn';

  @override
  String knowledgeMatchPercent(Object percent) {
    return '$percent% khớp';
  }

  @override
  String knowledgeCasesCount(Object count) {
    return '$count ca';
  }

  @override
  String knowledgeStandardsCount(Object count) {
    return '$count tiêu chuẩn';
  }

  @override
  String get showDetails => 'Xem chi tiết';
}
