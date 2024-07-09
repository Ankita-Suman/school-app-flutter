import 'package:get/get.dart';

import 'profile.dart';

/// A list of bindings which will be used in the route of [ProfileScreen].
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      ProfileController.new,
    );
  }
}
