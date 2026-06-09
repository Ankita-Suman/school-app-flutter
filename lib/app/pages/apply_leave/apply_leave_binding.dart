import 'package:get/get.dart';

import 'apply_leave.dart';

/// A list of bindings which will be used in the route of [ApplyLeaveScreen].
class ApplyLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ApplyLeaveController.new,
    );
  }
}
