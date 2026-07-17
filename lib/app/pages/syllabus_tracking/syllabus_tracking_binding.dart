import 'package:get/get.dart';

import 'syllabus_tracking.dart';

/// A list of bindings which will be used in the route of [SyllabusTrackingScreen].
class SyllabusTrackingBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      SyllabusTrackingController.new,
    );
  }
}
