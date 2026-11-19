import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/inspections/data/inspection_repository.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_chat.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

/// Compact Inspector <-> Customer chat, styled after the order chat thread.
class InspectionChatPage extends ConsumerStatefulWidget {
  const InspectionChatPage({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  ConsumerState<InspectionChatPage> createState() => _InspectionChatPageState();
}

class _InspectionChatPageState extends ConsumerState<InspectionChatPage> {
  final _messageCtrl = TextEditingController();
  final _pendingFiles = <InspectionChatAttachmentInput>[];
  bool _sending = false;
  bool _markedReadOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markReadIfNeeded());
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  void _invalidate() =>
      ref.invalidate(inspectionChatProvider(widget.inspectionId));

  Future<void> _markReadIfNeeded() async {
    if (_markedReadOnce) return;
    _markedReadOnce = true;
    await ref
        .read(inspectionRepositoryProvider)
        .markInspectionMessagesRead(widget.inspectionId);
    if (!mounted) return;
    _invalidate();
  }

  Future<void> _pickFiles() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;
    final picked = <InspectionChatAttachmentInput>[];
    for (final file in files) {
      final name = file.name;
      if (name.isEmpty) continue;
      Uint8List? bytes;
      try {
        bytes = await file.readAsBytes();
      } catch (_) {
        bytes = null;
      }
      if (bytes != null && bytes.isNotEmpty) {
        picked.add(InspectionChatAttachmentInput(fileName: name, bytes: bytes));
      } else if (file.path != null) {
        picked.add(
          InspectionChatAttachmentInput(fileName: name, path: file.path),
        );
      }
    }
    if (!mounted) return;
    setState(() => _pendingFiles.addAll(picked));
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if ((text.isEmpty && _pendingFiles.isEmpty) || _sending) return;
    setState(() => _sending = true);
    final res = await ref
        .read(inspectionRepositoryProvider)
        .postInspectionMessage(
          inspectionId: widget.inspectionId,
          body: text,
          files: List<InspectionChatAttachmentInput>.from(_pendingFiles),
        );
    if (!mounted) return;
    setState(() => _sending = false);

    switch (res) {
      case ApiSuccess():
        _messageCtrl.clear();
        _pendingFiles.clear();
        _invalidate();
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  Future<void> _openAttachment(
    String messageId,
    InspectionChatAttachment attachment,
  ) async {
    final res = await ref
        .read(inspectionRepositoryProvider)
        .downloadInspectionMessageAttachment(
          inspectionId: widget.inspectionId,
          messageId: messageId,
          attachmentId: attachment.id,
        );
    if (!mounted) return;
    switch (res) {
      case ApiSuccess(:final data):
        final name = attachment.fileName ?? 'attachment';
        if (attachment.isImage) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(data, fit: BoxFit.contain),
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(context.l10n.close),
                ),
              ],
            ),
          );
        } else {
          final saved = await FilePicker.saveFile(
            dialogTitle: name,
            fileName: name,
            bytes: data,
          );
          if (mounted && saved != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.documentSavedTo(name))),
            );
          }
        }
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final threadAsync = ref.watch(inspectionChatProvider(widget.inspectionId));
    final currentUserId = ref.watch(authNotifierProvider).value?.user?.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inspectionChatTitle),
        actions: [
          IconButton(
            onPressed: _invalidate,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AsyncValueWidget<InspectionChatThread?>(
              value: threadAsync,
              onRetry: _invalidate,
              builder: (thread) {
                final messages =
                    thread?.messages ?? const <InspectionChatMessage>[];
                if (messages.isEmpty) {
                  return EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: l10n.noMessagesYet,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMine =
                        currentUserId != null &&
                        msg.authorUserId == currentUserId;
                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMine
                                ? scheme.primary
                                : scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMine &&
                                  (msg.authorName != null ||
                                      msg.authorRole != null))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    msg.authorName ??
                                        localizedRole(
                                          l10n,
                                          msg.authorRole ?? '',
                                        ),
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: scheme.primary,
                                    ),
                                  ),
                                ),
                              if (msg.body != null &&
                                  msg.body!.trim().isNotEmpty)
                                Text(
                                  msg.body!.trim(),
                                  style: TextStyle(
                                    color: isMine
                                        ? Colors.white
                                        : scheme.onSurface,
                                  ),
                                ),
                              for (final att in msg.attachments)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: InkWell(
                                    onTap: () => _openAttachment(msg.id, att),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMine
                                            ? Colors.white24
                                            : scheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            att.isImage
                                                ? Icons.image_outlined
                                                : Icons.attach_file_rounded,
                                            size: 14,
                                            color: isMine
                                                ? Colors.white
                                                : scheme.primary,
                                          ),
                                          const SizedBox(width: 5),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.5,
                                            ),
                                            child: Text(
                                              att.fileName ?? '—',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isMine
                                                    ? Colors.white
                                                    : scheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                formatDateTimeShort(msg.createdAt),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isMine
                                      ? Colors.white70
                                      : scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(top: BorderSide(color: scheme.outlineVariant)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_pendingFiles.isNotEmpty)
                    SizedBox(
                      height: 30,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _pendingFiles.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          final file = _pendingFiles[index];
                          return Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text(
                              file.fileName,
                              style: const TextStyle(fontSize: 11),
                            ),
                            onDeleted: () =>
                                setState(() => _pendingFiles.removeAt(index)),
                          );
                        },
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: l10n.attachFile,
                        onPressed: _sending ? null : _pickFiles,
                        icon: const Icon(Icons.attach_file_rounded),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageCtrl,
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: l10n.typeInspectionMessageHint,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sending ? null : _send,
                        icon: _sending
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
