import 'package:get/get.dart';

import 'staff_reset_password.dart';

/// A list of bindings which will be used in the route of [StaffResetPasswordScreen].
class StaffResetPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      StaffResetPasswordController.new,
    );
  }
}
