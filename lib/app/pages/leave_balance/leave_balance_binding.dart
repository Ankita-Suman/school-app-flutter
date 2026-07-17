import 'package:get/get.dart';

import 'leave_balance.dart';

/// A list of bindings which will be used in the route of [ LeaveBalanceScreen].
class LeaveBalanceBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      LeaveBalanceController.new,
    );
  }
}
