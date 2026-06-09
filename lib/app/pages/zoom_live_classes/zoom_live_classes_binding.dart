import 'package:get/get.dart';

import 'zoom_live_classes.dart';

/// A list of bindings which will be used in the route of [ZoomLiveClassesScreen].
class ZoomLiveClassesBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ZoomLiveClassesController.new,
    );
  }
}
