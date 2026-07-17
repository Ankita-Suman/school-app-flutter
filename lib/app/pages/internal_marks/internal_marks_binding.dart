import 'package:get/get.dart';

import 'internal_marks.dart';

/// A list of bindings which will be used in the route of [InternalMarksScreen].
class InternalMarksBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      InternalMarksController.new,
    );
  }
}
