import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/features/inspections/presentation/field_session_panel.dart';

/// MF2-09 to MF2-11 on its own screen, reached from the inspection detail page.
///
/// The field session is a separate act from reviewing a record. MF2-09 has the Inspector on site
/// identifying the assigned Drone and completing the pre-flight checklist, then asking to start,
/// postponing or aborting. That does not belong inside the checklist-and-evidence screen an
/// Inspector opens to read what was captured, so it gets its own route.
class FieldSessionPage extends StatelessWidget {
  const FieldSessionPage({required this.inspectionId, super.key});

  final String inspectionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field session')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [FieldSessionPanel(inspectionId: inspectionId)],
        ),
      ),
    );
  }
}
