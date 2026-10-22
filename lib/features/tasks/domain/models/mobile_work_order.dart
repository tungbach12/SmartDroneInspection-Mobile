/// Mobile mirror of the backend WorkOrderResponse for field engineers.
class MobileWorkOrder {
  const MobileWorkOrder({
    required this.id,
    required this.assetId,
    required this.status,
    required this.priority,
    required this.correctiveScope,
    this.acceptanceCriteria,
    this.dueAt,
    required this.createdAt,
    this.teamLeadUserId,
    this.reportAuthorUserId,
  });

  factory MobileWorkOrder.fromJson(Map<String, dynamic> json) {
    return MobileWorkOrder(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      status: json['status'] as String? ?? 'DRAFT',
      priority: json['priority'] as String? ?? 'MEDIUM',
      correctiveScope: json['correctiveScope'] as String? ?? '',
      acceptanceCriteria: json['acceptanceCriteria'] as String?,
      dueAt: json['dueAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      teamLeadUserId: json['teamLeadUserId'] as String?,
      reportAuthorUserId: json['reportAuthorUserId'] as String?,
    );
  }

  final String id;
  final String assetId;
  final String status;
  final String priority;
  final String correctiveScope;
  final String? acceptanceCriteria;
  final String? dueAt;
  final String createdAt;
  final String? teamLeadUserId;
  final String? reportAuthorUserId;

  bool get isReady => status == 'READY';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isCompleted => status == 'WORK_COMPLETED' || status == 'ACCEPTED' || status == 'CLOSED';
}
