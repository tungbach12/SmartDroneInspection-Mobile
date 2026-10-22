/// Mobile mirror of MaintenanceTask for task execution on device.
class MobileTaskItem {
  const MobileTaskItem({
    required this.id,
    required this.taskNumber,
    required this.name,
    this.method,
    this.status = 'PENDING',
    this.assignedEngineerUserId,
    this.acceptanceCriteria,
  });

  factory MobileTaskItem.fromJson(Map<String, dynamic> json) {
    return MobileTaskItem(
      id: json['id'] as String,
      taskNumber: (json['taskNumber'] as num?)?.toInt() ?? 1,
      name: json['name'] as String? ?? '',
      method: json['method'] as String?,
      status: json['status'] as String? ?? 'PENDING',
      assignedEngineerUserId: json['assignedEngineerUserId'] as String?,
      acceptanceCriteria: json['acceptanceCriteria'] as String?,
    );
  }

  final String id;
  final int taskNumber;
  final String name;
  final String? method;
  final String status;
  final String? assignedEngineerUserId;
  final String? acceptanceCriteria;
}
