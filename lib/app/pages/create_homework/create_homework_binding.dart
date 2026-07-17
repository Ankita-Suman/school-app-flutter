import 'package:get/get.dart';

import 'create_homework.dart';

/// A list of bindings which will be used in the route of [CreateHomeworkScreen].
class CreateHomeworkBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      CreateHomeworkController.new,
    );
  }
}
