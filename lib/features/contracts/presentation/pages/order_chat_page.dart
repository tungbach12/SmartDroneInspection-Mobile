import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/auth/presentation/auth_error_helper.dart';
import 'package:smart_drone_inspection/features/auth/presentation/providers/session_provider.dart';
import 'package:smart_drone_inspection/features/contracts/data/contract_repository.dart';
import 'package:smart_drone_inspection/features/contracts/domain/models/service_request.dart';
import 'package:smart_drone_inspection/features/contracts/presentation/providers/contract_providers.dart';
import 'package:smart_drone_inspection/shared/widgets/async_value_widget.dart';
import 'package:smart_drone_inspection/shared/widgets/common_widgets.dart';

class OrderChatPage extends ConsumerStatefulWidget {
  const OrderChatPage({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<OrderChatPage> createState() => _OrderChatPageState();
}

class _OrderChatPageState extends ConsumerState<OrderChatPage> {
  final _messageCtrl = TextEditingController();
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

  Future<void> _markReadIfNeeded() async {
    if (_markedReadOnce) return;
    _markedReadOnce = true;
    await ref
        .read(contractRepositoryProvider)
        .markMessagesRead(widget.requestId);
    if (!mounted) return;
    ref.invalidate(serviceRequestDetailProvider(widget.requestId));
    ref.read(serviceRequestsProvider.notifier).refresh();
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final res = await ref
        .read(contractRepositoryProvider)
        .postMessage(requestId: widget.requestId, body: text);
    if (!mounted) return;
    setState(() => _sending = false);

    switch (res) {
      case ApiSuccess():
        _messageCtrl.clear();
        ref.invalidate(serviceRequestDetailProvider(widget.requestId));
        ref.read(serviceRequestsProvider.notifier).refresh();
      case ApiError(:final failure):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(describeApiFailure(context, failure))),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reqAsync = ref.watch(serviceRequestDetailProvider(widget.requestId));
    final currentUserId = ref.watch(authNotifierProvider).value?.user?.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderChatTitle),
        actions: [
          IconButton(
            onPressed: () =>
                ref.invalidate(serviceRequestDetailProvider(widget.requestId)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AsyncValueWidget<ServiceRequest>(
              value: reqAsync,
              onRetry: () => ref.invalidate(
                serviceRequestDetailProvider(widget.requestId),
              ),
              builder: (req) {
                if (req.messages.isEmpty) {
                  return EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: l10n.noMessagesYet,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: req.messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final msg = req.messages[index];
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
                              Text(
                                msg.body,
                                style: TextStyle(
                                  color: isMine
                                      ? Colors.white
                                      : scheme.onSurface,
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: l10n.typeMessageHint,
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
            ),
          ),
        ],
      ),
    );
  }
}
