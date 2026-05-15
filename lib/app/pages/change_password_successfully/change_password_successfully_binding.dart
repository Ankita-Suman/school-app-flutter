import 'package:get/get.dart';

import 'change_password_successfully.dart';

/// A list of bindings which will be used in the route of [ChangePasswordSuccessfullyScreen].
class ChangePasswordSuccessfullyBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ChangePasswordSuccessfullyController.new,
    );
  }
}
