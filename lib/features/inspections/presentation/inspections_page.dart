import 'package:flutter/material.dart';

class InspectionsPage extends StatelessWidget {
  const InspectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspections')),
      body: const Center(child: Text('Assigned inspections list')),
    );
  }
}
