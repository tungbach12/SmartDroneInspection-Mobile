import 'dart:convert';

const int minimumInspectionLeadDays = 20;

String formatVnd(num? amount, {String suffix = ' ₫'}) {
  if (amount == null) return '—';
  final rounded = amount.round();
  final negative = rounded < 0;
  final digits = rounded.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final posFromRight = digits.length - i;
    if (i > 0 && posFromRight % 3 == 0) {
      buf.write(',');
    }
    buf.write(digits[i]);
  }
  return '${negative ? '-' : ''}${buf.toString()}$suffix';
}

String formatDateShort(String? iso) {
  if (iso == null || iso.trim().isEmpty) return '—';
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
}

String formatDateTimeShort(String? iso) {
  if (iso == null || iso.trim().isEmpty) return '—';
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
}

String formatBytes(int? bytes) {
  if (bytes == null || bytes < 0) return '—';
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

String formatLocationDisplay(String? raw) {
  if (raw == null || raw.trim().isEmpty) return '—';
  final trimmed = raw.trim();
  if (trimmed.startsWith('{')) {
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final label = decoded['label']?.toString().trim();
        if (label != null && label.isNotEmpty) return label;
      }
    } catch (_) {
      // Fallback to raw text.
    }
  }
  return trimmed;
}

DateTime earliestAllowedRequestDate([
  DateTime? now,
  int leadDays = minimumInspectionLeadDays,
]) {
  final base = (now ?? DateTime.now()).toLocal();
  final today = DateTime(base.year, base.month, base.day);
  final safeLeadDays = leadDays < 0 ? 0 : leadDays;
  return today.add(Duration(days: safeLeadDays));
}
