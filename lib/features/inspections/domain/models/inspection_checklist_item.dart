import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_checklist_item.freezed.dart';
part 'inspection_checklist_item.g.dart';

@freezed
abstract class InspectionChecklistItem with _$InspectionChecklistItem {
  const factory InspectionChecklistItem({
    required String itemId,
    required String itemCode,
    String? sectionName,
    required String prompt,
    required String responseType,
    required bool required,
    required int displayOrder,
    String? guidance,
    String? validationConfig,
    Map<String, dynamic>? responseValue,
    String? notes,
    String? completedAt,
  }) = _InspectionChecklistItem;

  factory InspectionChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$InspectionChecklistItemFromJson(json);
}
