import 'package:get/get.dart';

import 'approval_status.dart';

/// A list of bindings which will be used in the route of [ApprovalStatuscreen].
class ApprovalStatusBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ApprovalStatusController.new,
    );
  }
}
