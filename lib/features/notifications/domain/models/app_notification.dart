class AppNotification {
  const AppNotification({
    required this.id,
    required this.eventType,
    required this.title,
    required this.body,
    required this.status,
    required this.createdAt,
    required this.read,
    this.targetPath,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] as String?) ?? 'SENT';
    final readFlag = json['read'] as bool?;
    return AppNotification(
      id: json['id'] as String,
      eventType: (json['eventType'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      targetPath: json['targetPath'] as String?,
      status: status,
      readAt: json['readAt'] as String?,
      createdAt: (json['createdAt'] as String?) ?? '',
      read:
          readFlag ??
          (status.toUpperCase() == 'READ' || json['readAt'] != null),
    );
  }

  final String id;
  final String eventType;
  final String title;
  final String body;
  final String? targetPath;
  final String status;
  final String? readAt;
  final String createdAt;
  final bool read;
}

/// Translates web notification `targetPath` values (e.g. `/client/inspections/abc`)
/// into Customer mobile GoRouter locations.
String? resolveMobileNotificationRoute(String? targetPath) {
  if (targetPath == null || targetPath.trim().isEmpty) return null;
  final path = targetPath.trim();
  final reqMatch = RegExp(r'/requests/([^/?#]+)').firstMatch(path);
  if (reqMatch != null) {
    final id = reqMatch.group(1);
    if (id != null && id != 'new') {
      if (path.contains('chat')) return '/requests/$id/chat';
      return '/requests/$id';
    }
    return '/requests';
  }
  final inspMatch = RegExp(r'/inspections/([^/?#]+)').firstMatch(path);
  if (inspMatch != null) {
    final id = inspMatch.group(1);
    if (id != null) return '/inspections/$id';
  }
  final reportMatch = RegExp(r'/reports/([^/?#]+)').firstMatch(path);
  if (reportMatch != null) {
    final id = reportMatch.group(1);
    if (id != null) return '/inspections/$id?tab=1';
  }
  final assetMatch = RegExp(r'/assets/([^/?#]+)').firstMatch(path);
  if (assetMatch != null) {
    final id = assetMatch.group(1);
    if (id != null) return '/assets/$id';
  }
  if (path.contains('/assets')) return '/assets';
  if (path.contains('/contracts')) return '/requests';
  return null;
}
