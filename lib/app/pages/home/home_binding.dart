import 'package:get/get.dart';

import 'home.dart';

/// A list of bindings which will be used in the route of HomeScreen].
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      HomeController.new,
    );
  }
}
