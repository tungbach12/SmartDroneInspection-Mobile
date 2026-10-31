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
  String get appTitle => 'SmartDroneInspection';

  @override
  String get navInspections => 'Kiểm tra';

  @override
  String get navTasks => 'Công việc';

  @override
  String get navProfile => 'Hồ sơ';

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
  String get signIn => 'Đăng nhập';

  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get or => 'hoặc';

  @override
  String get setNewPassword => 'Đặt mật khẩu mới';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPasswordRequirement => 'Mật khẩu mới (ít nhất 15 ký tự)';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get passwordSetupNotice =>
      'Bạn cần đặt mật khẩu mới trước khi tiếp tục.';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu mới không khớp.';

  @override
  String get required => 'Bắt buộc';

  @override
  String get minimum15Characters => 'Tối thiểu 15 ký tự';

  @override
  String get invalidCredentials => 'Thông tin đăng nhập không hợp lệ.';

  @override
  String get serverError => 'Lỗi máy chủ.';

  @override
  String get cannotReachServer => 'Không thể kết nối đến máy chủ.';

  @override
  String get notFoundError => 'Không tìm thấy.';

  @override
  String get assets => 'Tài sản';

  @override
  String get active => 'Đang hoạt động';

  @override
  String get assignments => 'Phân công';

  @override
  String get acceptingDoesNotClear =>
      'Chấp nhận nghĩa là bạn nhận công việc, không có nghĩa là được phép bay. Người đánh giá được chỉ định của tổ chức sẽ quyết định dựa trên hồ sơ.';

  @override
  String get nothingToAnswer =>
      'Không có phân công nào cần phản hồi. Quản lý tổ chức sẽ ghép bạn với máy bay không người lái trước khi bắt đầu chuẩn bị.';

  @override
  String droneValidity(Object serial, Object from, Object until) {
    return 'Máy bay không người lái $serial · hiệu lực từ $from đến $until';
  }

  @override
  String get unspecified => 'chưa xác định';

  @override
  String get declineReason => 'Lý do từ chối';

  @override
  String get declineReasonHint =>
      'Chỉ bắt buộc khi từ chối để quản trị viên biết cần khắc phục điều gì.';

  @override
  String get recording => 'Đang ghi nhận…';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get decline => 'Từ chối';

  @override
  String get serverRefusedResponse => 'Máy chủ đã từ chối phản hồi này.';

  @override
  String get cannotAnswerAssignment =>
      'Bạn không được phép phản hồi phân công này.';

  @override
  String get assignmentNotFound =>
      'Không tìm thấy phân công này hoặc phân công thuộc tổ chức khác.';

  @override
  String get inspectionRecord => 'Hồ sơ kiểm tra';

  @override
  String get backToAssignments => 'Quay lại danh sách phân công';

  @override
  String inspectionNumber(Object id) {
    return 'Kiểm tra $id';
  }

  @override
  String get openFieldSession => 'Mở phiên hiện trường';

  @override
  String get openPreparation => 'Mở bước chuẩn bị MF2';

  @override
  String get checklist => 'Danh sách kiểm tra';

  @override
  String get evidence => 'Bằng chứng';

  @override
  String get cameraPermissionError =>
      'Không thể mở máy ảnh. Hãy kiểm tra quyền truy cập thiết bị rồi thử lại.';

  @override
  String get completeSessionBeforeEvidence =>
      'Hãy hoàn tất phiên hiện trường trước khi đính kèm bằng chứng.';

  @override
  String get evidenceUploaded => 'Bằng chứng đã được tải lên an toàn.';

  @override
  String get selectVideoFile => 'Chọn tệp video';

  @override
  String selectedVideo(Object name) {
    return 'Video đã chọn: $name';
  }

  @override
  String get uploadVideoEvidence => 'Tải video làm bằng chứng';

  @override
  String get retryVideoUpload => 'Thử tải video lại';

  @override
  String get filePickerError =>
      'Không mở được trình chọn tệp. Vui lòng thử lại.';

  @override
  String evidenceFileTooLarge(Object limit) {
    return 'Tệp vượt quá giới hạn tải bằng chứng $limit.';
  }

  @override
  String evidenceDetails(Object contentType, Object size, Object source) {
    return '$contentType · $size byte · $source';
  }

  @override
  String get evidenceSourceMobileUpload => 'Tải lên từ ứng dụng di động';

  @override
  String get pass => 'Đạt';

  @override
  String get fail => 'Không đạt';

  @override
  String get captureInspectionPhoto => 'Chụp ảnh kiểm tra';

  @override
  String selectedFile(Object name) {
    return 'Đã chọn: $name';
  }

  @override
  String get uploading => 'Đang tải lên…';

  @override
  String get uploadPhoto => 'Tải ảnh lên';

  @override
  String get retryUpload => 'Thử tải lên lại';

  @override
  String uploadFailed(Object error) {
    return 'Tải lên thất bại: $error. Ảnh đã chọn vẫn được giữ lại để bạn thử lại.';
  }

  @override
  String get checkConnection => 'Kiểm tra kết nối rồi thử lại.';

  @override
  String get unauthorizedInspection =>
      'Bạn không được phép truy cập cuộc kiểm tra này.';

  @override
  String get inspectionUnavailable => 'Cuộc kiểm tra này không còn khả dụng.';

  @override
  String get requestFailed => 'Máy chủ không thể hoàn tất yêu cầu này.';

  @override
  String checklistSaveFailed(Object error) {
    return 'Không lưu được danh sách kiểm tra: $error';
  }

  @override
  String get writeShotListComparison =>
      'Trước tiên, hãy ghi nội dung đối chiếu danh sách ảnh chụp.';

  @override
  String get stateWhySessionNeeded =>
      'Hãy nêu lý do cần thêm một phiên hiện trường.';

  @override
  String get additionalWorkRequested =>
      'Đã yêu cầu thêm công việc hiện trường. Hãy tiếp tục ở bước chuẩn bị MF2 và chờ đánh giá mức độ sẵn sàng.';

  @override
  String get evidenceSetAccepted =>
      'Bộ bằng chứng đã được chấp nhận để phân tích hỗ trợ.';

  @override
  String get evidenceQualityDecision => 'Đánh giá chất lượng bằng chứng';

  @override
  String get evidenceQualityExplanation =>
      'MF3-03: đối chiếu bộ ảnh đã hoàn tất với danh sách ảnh cần chụp. Chọn chấp nhận hoặc yêu cầu thêm phiên MF2; vấn đề thời tiết hoặc an toàn tại hiện trường cần được xử lý bằng hoãn hoặc hủy phiên.';

  @override
  String get noDecisionRecorded => 'Chưa có quyết định nào được ghi nhận.';

  @override
  String latestDecision(Object decision) {
    return 'Mới nhất: $decision';
  }

  @override
  String get loadingDecisionHistory => 'Đang tải lịch sử quyết định…';

  @override
  String get decisionHistoryFailed => 'Không tải được lịch sử quyết định.';

  @override
  String get shotListComparison => 'Đối chiếu danh sách ảnh chụp';

  @override
  String get shotListComparisonHint =>
      'Bắt buộc. Nêu những nội dung bộ ảnh đã bao quát và chưa bao quát.';

  @override
  String get whyAnotherSession => 'Vì sao cần thêm một phiên hiện trường?';

  @override
  String get anotherSessionHint =>
      'Chỉ bắt buộc khi yêu cầu thêm một phiên MF2.';

  @override
  String get acceptEvidenceSet => 'Chấp nhận bộ bằng chứng';

  @override
  String get additionalSessionNeeded => 'Cần thêm phiên hiện trường';

  @override
  String get response => 'Phản hồi';

  @override
  String get numericResponse => 'Phản hồi dạng số';

  @override
  String get notesOptional => 'Ghi chú (không bắt buộc)';

  @override
  String get yes => 'Có';

  @override
  String get no => 'Không';

  @override
  String get saving => 'Đang lưu…';

  @override
  String get saveResponse => 'Lưu phản hồi';

  @override
  String get saved => 'Đã lưu';

  @override
  String get networkUnavailable =>
      'Mạng không khả dụng. Ghi chú bạn đã nhập vẫn được giữ lại; hãy thử lại.';

  @override
  String get fieldSession => 'Phiên hiện trường';

  @override
  String get startingNotClearance =>
      'Bắt đầu phiên không đồng nghĩa với việc được phép bay. Thao tác này ghi nhận hồ sơ và danh sách kiểm tra trước chuyến bay đã đầy đủ.';

  @override
  String get notStartable =>
      'Hiện chưa thể bắt đầu cuộc kiểm tra này. Trước tiên hãy hoàn tất bước chuẩn bị MF2 và quy trình đánh giá mức độ sẵn sàng độc lập.';

  @override
  String get preFlightChecklistNote =>
      'Ghi chú danh sách kiểm tra trước chuyến bay';

  @override
  String get preFlightChecklistHint =>
      'Xác định máy bay không người lái được phân công và ghi lại các mục đã kiểm tra tại hiện trường.';

  @override
  String get starting => 'Đang bắt đầu…';

  @override
  String get startFieldSession => 'Bắt đầu phiên hiện trường';

  @override
  String get abortSessionQuestion => 'Hủy phiên này?';

  @override
  String get abortIrreversible =>
      'Phiên sẽ kết thúc và không thể tiếp tục bằng hồ sơ này. Thao tác này không thể hoàn tác.';

  @override
  String get keepGoing => 'Tiếp tục';

  @override
  String get abort => 'Hủy';

  @override
  String startedAt(Object time, Object decision) {
    return 'Bắt đầu lúc $time theo quyết định sẵn sàng $decision';
  }

  @override
  String get justNow => 'vừa xong';

  @override
  String get unknown => 'không xác định';

  @override
  String get reasonPostponing => 'Lý do hoãn';

  @override
  String get postponeHint =>
      'Thời tiết hoặc an toàn tại hiện trường. Có thể thực hiện nhiệm vụ vào lần khác.';

  @override
  String get postpone => 'Hoãn';

  @override
  String get fieldSessionOutcome => 'Kết quả phiên hiện trường';

  @override
  String get fieldSessionOutcomeHint =>
      'Ghi lại phạm vi, quan sát, thiếu sót và sự cố (nếu có) trước khi kết thúc phiên.';

  @override
  String get endFieldSession => 'Kết thúc phiên hiện trường';

  @override
  String get reasonAborting => 'Lý do hủy';

  @override
  String get abortIrreversibleShort =>
      'Phiên sẽ kết thúc và không thể tiếp tục bằng hồ sơ này.';

  @override
  String get abortSession => 'Hủy phiên';

  @override
  String get cannotManageSession =>
      'Bạn không được phép quản lý phiên hiện trường này.';

  @override
  String get preparationNotFound =>
      'Không tìm thấy cuộc kiểm tra này hoặc cuộc kiểm tra thuộc tổ chức khác.';

  @override
  String get preparationServerRefused => 'Máy chủ đã từ chối yêu cầu này.';

  @override
  String get networkRetry => 'Mạng không khả dụng. Hãy thử lại khi có kết nối.';

  @override
  String get fieldSessionStatusInProgress => 'Đang thực hiện';

  @override
  String get fieldSessionStatusPostponed => 'Đã hoãn';

  @override
  String get fieldSessionStatusAborted => 'Đã hủy';

  @override
  String get fieldSessionStatusPlanned => 'Đã lên kế hoạch';

  @override
  String get fieldSessionStatusCompleted => 'Đã hoàn tất hiện trường';

  @override
  String get statusDraft => 'Bản nháp';

  @override
  String get statusSubmitted => 'Đã gửi';

  @override
  String get statusReady => 'Sẵn sàng';

  @override
  String get statusActive => 'Đang hoạt động';

  @override
  String get statusAccepted => 'Đã chấp nhận';

  @override
  String get statusRejected => 'Đã từ chối';

  @override
  String get statusSuspended => 'Đã tạm dừng';

  @override
  String get decisionAdditionalSession => 'Yêu cầu phiên bổ sung';

  @override
  String get decisionAccepted => 'Đã chấp nhận';

  @override
  String get preparation => 'Bước chuẩn bị MF2';

  @override
  String get bothPlannedTimes =>
      'Hãy đặt cả thời gian bắt đầu và kết thúc dự kiến cho phiên hiện trường bổ sung.';

  @override
  String preparationVersionSaved(Object version) {
    return 'Đã lưu phiên bản chuẩn bị $version.';
  }

  @override
  String get preparationSubmitted =>
      'Đã gửi bước chuẩn bị để đánh giá mức độ sẵn sàng độc lập.';

  @override
  String get componentShotListJson => 'Danh sách ảnh chụp bộ phận (JSON)';

  @override
  String get evidenceTypesJson => 'Loại bằng chứng (JSON)';

  @override
  String get accessConstraints => 'Hạn chế tiếp cận';

  @override
  String get plannedSessionStart =>
      'Thời gian bắt đầu phiên dự kiến (giờ địa phương)';

  @override
  String get plannedSessionEnd =>
      'Thời gian kết thúc phiên dự kiến (giờ địa phương)';

  @override
  String get safetyObservations => 'Quan sát về an toàn';

  @override
  String get safetyAcknowledgment => 'Xác nhận an toàn';

  @override
  String get saveDraft => 'Lưu bản nháp';

  @override
  String get submitting => 'Đang gửi…';

  @override
  String get submitPreparation => 'Gửi bước chuẩn bị';

  @override
  String get additionalSessionRequested =>
      'Đã yêu cầu thêm phiên hiện trường. Hãy cập nhật kế hoạch/khung giờ và gửi lại. ORG_MANAGER độc lập phải phê duyệt mức độ sẵn sàng hiện tại trước khi có thể bắt đầu.';

  @override
  String preparationVersionStatus(Object version, Object status) {
    return 'Phiên bản $version · $status';
  }

  @override
  String get preparationApproved =>
      'Bước chuẩn bị đã được phê duyệt. Mức độ sẵn sàng áp dụng cho phiên bản này; mọi thay đổi cần được đánh giá lại.';

  @override
  String get cannotEditPreparation =>
      'Bạn không được phép chỉnh sửa bước chuẩn bị này.';

  @override
  String get inspectionNotInOrganization =>
      'Không tìm thấy cuộc kiểm tra này trong tổ chức của bạn.';

  @override
  String get profile => 'Hồ sơ';

  @override
  String zone(Object zone) {
    return 'Khu vực: $zone';
  }

  @override
  String organization(Object organization) {
    return 'Tổ chức: $organization';
  }

  @override
  String get notSignedIn => 'Chưa đăng nhập.';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get tasks => 'Công việc bảo trì';

  @override
  String get assignedMaintenanceTickets => 'Phiếu bảo trì được giao';

  @override
  String get userRoleAdmin => 'Quản trị viên';

  @override
  String get userRolePlatformManager => 'Quản lý nền tảng';

  @override
  String get userRoleOrgManager => 'Quản lý tổ chức';

  @override
  String get userRoleInspector => 'Thanh tra viên';

  @override
  String get userRoleMaintenanceEngineer => 'Kỹ sư bảo trì';

  @override
  String get userRoleClient => 'Khách hàng';

  @override
  String get actorZonePlatform => 'Nền tảng';

  @override
  String get actorZoneCustomerOrganization => 'Tổ chức khách hàng';

  @override
  String get actorZoneServiceWorkforce => 'Đội ngũ dịch vụ';

  @override
  String get assignmentStatusActive => 'Đang hoạt động';

  @override
  String get assignmentResponseAccepted => 'Đã chấp nhận';

  @override
  String get assignmentResponseRejected => 'Đã từ chối';

  @override
  String get assetStatusActive => 'Đang hoạt động';

  @override
  String get assetStatusInactive => 'Ngừng hoạt động';

  @override
  String get assetStatusRetired => 'Đã ngừng sử dụng';

  @override
  String get maintenanceWorkOrders => 'Lệnh bảo trì sửa chữa';

  @override
  String get noAssignedTasks => 'Chưa có nhiệm vụ bảo trì nào được giao';

  @override
  String get assignedWorkOrdersDescription =>
      'Các lệnh bảo trì được giao cho đội của bạn sẽ hiển thị tại đây.';

  @override
  String workOrderTitle(Object id) {
    return 'Lệnh #$id';
  }

  @override
  String orderPriority(Object priority) {
    return 'Mức ưu tiên: $priority';
  }

  @override
  String get correctiveScope => 'Phạm vi khắc phục:';

  @override
  String get acceptanceCriteria => 'Tiêu chuẩn nghiệm thu:';

  @override
  String get startExecutionOnSite => 'Bắt đầu thi công tại hiện trường';

  @override
  String get recordLog => 'Ghi nhật ký';

  @override
  String get declareComplete => 'Tuyên bố hoàn thành';

  @override
  String get plannedTasks => 'Nhiệm vụ đã lập kế hoạch';

  @override
  String get noTasksPlanned => 'Chưa có nhiệm vụ nào được lập cho lệnh này.';

  @override
  String get workLogs => 'Nhật ký công việc';

  @override
  String get noWorkLogs => 'Chưa có nhật ký công việc nào được ghi nhận.';

  @override
  String hoursWorkedLabel(Object hours) {
    return '$hours giờ làm việc';
  }

  @override
  String asLeftLabel(Object condition) {
    return 'Tình trạng sau sửa: $condition';
  }

  @override
  String testReadingsLabel(Object readings) {
    return 'Thí nghiệm: $readings';
  }

  @override
  String get recordWorkLog => 'Ghi nhận nhật ký công việc';

  @override
  String get task => 'Nhiệm vụ';

  @override
  String get hoursWorked => 'Số giờ làm việc';

  @override
  String get asLeftCondition => 'Tình trạng sau khi hoàn tất';

  @override
  String get testReadings => 'Số liệu đo đạc / Thí nghiệm kiểm tra';

  @override
  String get submitWorkLog => 'Nộp nhật ký công việc';

  @override
  String get executionStarted => 'Đã bắt đầu thi công';

  @override
  String get workDeclaredCompleted => 'Đã tuyên bố hoàn thành thi công';

  @override
  String get workLogSubmitted => 'Đã nộp nhật ký công việc để xác nhận';
}
