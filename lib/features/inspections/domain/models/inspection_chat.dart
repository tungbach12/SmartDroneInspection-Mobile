/// Attachment metadata attached to an inspection chat message.
class InspectionChatAttachment {
  const InspectionChatAttachment({
    required this.id,
    this.fileName,
    this.contentType,
    this.sizeBytes = 0,
    this.checksumSha256,
    this.createdAt,
  });

  factory InspectionChatAttachment.fromJson(Map<String, dynamic> json) {
    return InspectionChatAttachment(
      id: (json['id'] as String?) ?? '',
      fileName: json['fileName'] as String?,
      contentType: json['contentType'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      checksumSha256: json['checksumSha256'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  final String id;
  final String? fileName;
  final String? contentType;
  final int sizeBytes;
  final String? checksumSha256;
  final String? createdAt;

  bool get isImage => (contentType ?? '').toLowerCase().startsWith('image/');
}

/// A single message in the Inspector <-> Customer inspection chat thread.
class InspectionChatMessage {
  const InspectionChatMessage({
    required this.id,
    this.inspectionId,
    this.authorUserId,
    this.authorName,
    this.authorRole,
    this.body,
    this.readAt,
    this.createdAt,
    this.attachments = const <InspectionChatAttachment>[],
  });

  factory InspectionChatMessage.fromJson(Map<String, dynamic> json) {
    final attachmentsRaw = json['attachments'];
    return InspectionChatMessage(
      id: (json['id'] as String?) ?? '',
      inspectionId: json['inspectionId'] as String?,
      authorUserId: json['authorUserId'] as String?,
      authorName: json['authorName'] as String?,
      authorRole: json['authorRole'] as String?,
      body: json['body'] as String?,
      readAt: json['readAt'] as String?,
      createdAt: json['createdAt'] as String?,
      attachments: attachmentsRaw is List
          ? attachmentsRaw
                .map(
                  (e) => InspectionChatAttachment.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <InspectionChatAttachment>[],
    );
  }

  final String id;
  final String? inspectionId;
  final String? authorUserId;
  final String? authorName;
  final String? authorRole;
  final String? body;
  final String? readAt;
  final String? createdAt;
  final List<InspectionChatAttachment> attachments;
}

/// Response of `GET /inspections/{id}/messages`.
class InspectionChatThread {
  const InspectionChatThread({
    this.inspectionId,
    this.assetName,
    this.counterpartName,
    this.counterpartRole,
    this.messages = const <InspectionChatMessage>[],
  });

  factory InspectionChatThread.fromJson(Map<String, dynamic> json) {
    final messagesRaw = json['messages'];
    return InspectionChatThread(
      inspectionId: json['inspectionId'] as String?,
      assetName: json['assetName'] as String?,
      counterpartName: json['counterpartName'] as String?,
      counterpartRole: json['counterpartRole'] as String?,
      messages: messagesRaw is List
          ? messagesRaw
                .map(
                  (e) => InspectionChatMessage.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const <InspectionChatMessage>[],
    );
  }

  final String? inspectionId;
  final String? assetName;
  final String? counterpartName;
  final String? counterpartRole;
  final List<InspectionChatMessage> messages;
}
