import 'package:get/get.dart';

import 'notifications.dart';

/// A list of bindings which will be used in the route of [NotificationsScreen].
class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      NotificationsController.new,
    );
  }
}
