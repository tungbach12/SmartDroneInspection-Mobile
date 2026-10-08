class MaintenanceTask {
  const MaintenanceTask({
    required this.id,
    required this.maintenanceTicketId,
    this.maintenanceOrderId,
    required this.engineerUserId,
    required this.assignedByUserId,
    required this.assignmentType,
    required this.status,
    this.deadline,
    this.respondedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  final String id;
  final String maintenanceTicketId;
  final String? maintenanceOrderId;
  final String engineerUserId;
  final String assignedByUserId;
  final String assignmentType;
  final String status;
  final String? deadline;
  final String? respondedAt;
  final String? rejectionReason;
  final String createdAt;

  factory MaintenanceTask.fromJson(Map<String, dynamic> json) => MaintenanceTask(
        id: json['id'] as String,
        maintenanceTicketId: json['maintenanceTicketId'] as String,
        maintenanceOrderId: json['maintenanceOrderId'] as String?,
        engineerUserId: json['engineerUserId'] as String,
        assignedByUserId: json['assignedByUserId'] as String,
        assignmentType: json['assignmentType'] as String,
        status: json['status'] as String,
        deadline: json['deadline'] as String?,
        respondedAt: json['respondedAt'] as String?,
        rejectionReason: json['rejectionReason'] as String?,
        createdAt: json['createdAt'] as String,
      );
}
