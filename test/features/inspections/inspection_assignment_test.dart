import 'package:flutter_test/flutter_test.dart';
import 'package:smart_drone_inspection/features/inspections/domain/models/inspection_assignment.dart';

void main() {
  test('maps the scoped assignment response and nullable inspection id', () {
    final assignment = InspectionAssignment.fromJson({
      'assignmentId': 'assignment-1',
      'serviceOrderId': 'order-1',
      'assetId': 'asset-1',
      'deadline': '2026-10-01T08:00:00Z',
      'status': 'ACCEPTED',
      'inspectionId': null,
    });

    expect(assignment.assignmentId, 'assignment-1');
    expect(assignment.status, 'ACCEPTED');
    expect(assignment.inspectionId, isNull);
  });
}
