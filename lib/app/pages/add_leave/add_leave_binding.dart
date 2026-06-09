import 'package:get/get.dart';

import 'add_leave.dart';

/// A list of bindings which will be used in the route of [ApplyLeaveScreen].
class AddLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      AddLeaveController.new,
    );
  }
}
