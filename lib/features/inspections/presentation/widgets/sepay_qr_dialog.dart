import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/core/utils/formatters.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection.dart';

/// Shows an in-app VietQR image, copyable bank details (`SDI<orderCode>`), and
/// automatically polls [checkPaymentStatus] until settlement completes.
class SepayQrDialog extends StatefulWidget {
  const SepayQrDialog({
    super.key,
    required this.details,
    required this.checkPaymentStatus,
    required this.onSettled,
  });

  final SepayCheckoutDetails details;
  final Future<ApiResult<ReportPaymentStatus>> Function() checkPaymentStatus;
  final VoidCallback onSettled;

  @override
  State<SepayQrDialog> createState() => _SepayQrDialogState();
}

class _SepayQrDialogState extends State<SepayQrDialog> {
  Timer? _pollTimer;
  bool _checking = false;
  bool _qrLoadError = false;
  String? _copiedKey;

  late final ({String? bank, String? accountNumber, String? accountHolder})
  _bankInfo = _parseBankInfo(widget.details.checkoutUrl);

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _pollStatus(silent: true),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  static ({String? bank, String? accountNumber, String? accountHolder})
  _parseBankInfo(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return (bank: null, accountNumber: null, accountHolder: null);
    }
    String? clean(String key) {
      final value = uri.queryParameters[key]?.trim();
      return (value == null || value.isEmpty) ? null : value;
    }

    return (
      bank: clean('bank'),
      accountNumber: clean('acc'),
      accountHolder: clean('holder'),
    );
  }

  Future<void> _pollStatus({bool silent = false}) async {
    if (_checking) return;
    if (!silent) {
      setState(() => _checking = true);
    }
    final res = await widget.checkPaymentStatus();
    if (!mounted) return;
    if (!silent) {
      setState(() => _checking = false);
    }
    if (res case ApiSuccess(:final data)) {
      if (data.paid || data.paymentStatus.toUpperCase() == 'PAID') {
        _pollTimer?.cancel();
        Navigator.of(context).pop(true);
        widget.onSettled();
      }
    }
  }

  Future<void> _copy(String key, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copiedKey = key);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted && _copiedKey == key) {
        setState(() => _copiedKey = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final transferContent = widget.details.qrCode.trim().isNotEmpty
        ? widget.details.qrCode.trim()
        : 'SDI${widget.details.orderCode}';

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.qr_code_2_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.sepayQrTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.sepayQrSubtitle,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            if (widget.details.checkoutUrl.isNotEmpty && !_qrLoadError)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Image.network(
                  widget.details.checkoutUrl,
                  width: 210,
                  height: 210,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && !_qrLoadError) {
                        setState(() => _qrLoadError = true);
                      }
                    });
                    return const SizedBox(width: 210, height: 120);
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.qrUnavailableFallback,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(
                    label: l10n.amountToPay,
                    value: formatVnd(widget.details.amount),
                    bold: true,
                  ),
                  if (_bankInfo.bank != null) ...[
                    const Divider(height: 14),
                    _DetailRow(label: l10n.bankLabel, value: _bankInfo.bank!),
                  ],
                  if (_bankInfo.accountNumber != null) ...[
                    const SizedBox(height: 6),
                    _CopyableRow(
                      label: l10n.accountNumberLabel,
                      value: _bankInfo.accountNumber!,
                      copied: _copiedKey == 'account',
                      tooltip: _copiedKey == 'account'
                          ? l10n.copiedLabel
                          : l10n.copyLabel,
                      onCopy: () => _copy('account', _bankInfo.accountNumber!),
                    ),
                  ],
                  if (_bankInfo.accountHolder != null) ...[
                    const SizedBox(height: 6),
                    _DetailRow(
                      label: l10n.accountHolderLabel,
                      value: _bankInfo.accountHolder!,
                    ),
                  ],
                  const Divider(height: 14),
                  _CopyableRow(
                    label: l10n.transferContentLabel,
                    value: transferContent,
                    copied: _copiedKey == 'content',
                    tooltip: _copiedKey == 'content'
                        ? l10n.copiedLabel
                        : l10n.copyLabel,
                    highlight: true,
                    onCopy: () => _copy('content', transferContent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _copiedKey == 'content'
                  ? l10n.copiedLabel
                  : l10n.keepTransferContentHint,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('sepay-check-status-btn'),
          onPressed: _checking ? null : () => _pollStatus(silent: false),
          child: Text(
            _checking ? l10n.checkingPaymentStatus : l10n.checkPaymentStatus,
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: bold ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _CopyableRow extends StatelessWidget {
  const _CopyableRow({
    required this.label,
    required this.value,
    required this.copied,
    required this.tooltip,
    required this.onCopy,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool copied;
  final String tooltip;
  final VoidCallback onCopy;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 8),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    color: highlight ? scheme.primary : null,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.only(left: 4),
                constraints: const BoxConstraints(),
                tooltip: tooltip,
                icon: Icon(
                  copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: 16,
                  color: copied ? const Color(0xFF16A34A) : null,
                ),
                onPressed: onCopy,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
