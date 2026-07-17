import 'package:get/get.dart';

import 'examination_schedule.dart';

/// A list of bindings which will be used in the route of [ExaminationScheduleScreen].
class ExaminationScheduleBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      ExaminationScheduleController.new,
    );
  }
}
