import 'package:get/get.dart';

import 'staff_apply_leave.dart';

/// A list of bindings which will be used in the route of [StaffApplyLeaveScreen].
class StaffApplyLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      StaffApplyLeaveController.new,
    );
  }
}
