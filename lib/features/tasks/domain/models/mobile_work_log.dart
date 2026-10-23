/// Mobile mirror of MaintenanceWorkLog.
class MobileWorkLog {
  const MobileWorkLog({
    required this.id,
    required this.taskId,
    required this.engineerUserId,
    required this.workHours,
    this.asLeftCondition,
    this.testReadings,
    this.status = 'DRAFT',
    this.startedAt,
    this.endedAt,
  });

  factory MobileWorkLog.fromJson(Map<String, dynamic> json) {
    return MobileWorkLog(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      engineerUserId: json['engineerUserId'] as String,
      workHours: (json['hours'] as num?)?.toDouble() ??
          (json['workHours'] as num?)?.toDouble() ??
          1.0,
      asLeftCondition: json['asLeftCondition'] as String?,
      testReadings: json['testReadings'] as String?,
      status: json['status'] as String? ?? 'DRAFT',
      startedAt: json['startedAt'] as String?,
      endedAt: json['endedAt'] as String?,
    );
  }

  final String id;
  final String taskId;
  final String engineerUserId;
  final double workHours;
  final String? asLeftCondition;
  final String? testReadings;
  final String status;
  final String? startedAt;
  final String? endedAt;
}
