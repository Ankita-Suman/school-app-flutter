import 'package:get/get.dart';

import 'staff_leave.dart';

/// A list of bindings which will be used in the route of [StaffLeaveScreen].
class StaffLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      StaffLeaveController.new,
    );
  }
}
