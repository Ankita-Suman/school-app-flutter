import 'package:get/get.dart';

import 'login_parent.dart';

/// A list of bindings which will be used in the route of [LoginParentScreen].
class LoginParentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      LoginParentController.new,
    );
  }
}
