import 'package:get/get.dart';

import 'forgot_password.dart';

/// A list of bindings which will be used in the route of [ForgotPasswordScreen].
class ForgotPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ForgotPasswordController.new,
    );
  }
}
