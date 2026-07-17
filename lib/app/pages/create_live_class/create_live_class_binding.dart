import 'package:get/get.dart';

import 'create_live_class.dart';

/// A list of bindings which will be used in the route of [CreateLiveClassScreen].
class CreateLiveClassBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      CreateLiveClassController.new,
    );
  }
}
