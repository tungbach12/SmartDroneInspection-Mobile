import 'package:flutter/material.dart';
import 'package:smart_drone_inspection/core/localization/app_localizations_context.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tasks)),
      body: Center(child: Text(context.l10n.assignedMaintenanceTickets)),
    );
  }
}
