import 'package:get/get.dart';

import 'events.dart';

/// A list of bindings which will be used in the route of [EventsScreen].
class EventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      EventsController.new,
    );
  }
}
