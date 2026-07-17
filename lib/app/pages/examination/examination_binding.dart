import 'package:get/get.dart';

import 'examination.dart';

/// A list of bindings which will be used in the route of [ExaminationScreen].
class ExaminationBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ExaminationController.new,
    );
  }
}
