import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_drone_inspection/core/network/api_result.dart';
import 'package:smart_drone_inspection/features/tasks/data/maintenance_task_repository.dart';
import 'package:smart_drone_inspection/features/tasks/domain/models/maintenance_task.dart';

typedef PickMaintenancePhoto = Future<XFile?> Function();

final maintenancePhotoPickerProvider = Provider<PickMaintenancePhoto>((ref) {
  final picker = ImagePicker();
  return () => picker.pickImage(source: ImageSource.camera, imageQuality: 90);
});

class MaintenanceTaskListNotifier extends AsyncNotifier<List<MaintenanceTask>> {
  @override
  Future<List<MaintenanceTask>> build() async {
    final result = await ref.watch(maintenanceTaskRepositoryProvider).listMyTasks();
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw Exception(failure),
    };
  }
}

final maintenanceTaskListProvider =
    AsyncNotifierProvider<MaintenanceTaskListNotifier, List<MaintenanceTask>>(
  MaintenanceTaskListNotifier.new,
);
