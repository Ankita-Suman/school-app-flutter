import 'package:get/get.dart';

import 'attendance_management.dart';

/// A list of bindings which will be used in the route of [AttendanceManagementScreen].
class AttendanceManagementBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      AttendanceManagementController.new,
    );
  }
}
