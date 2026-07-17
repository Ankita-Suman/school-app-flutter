import 'package:get/get.dart';

import 'daily_teaching_log.dart';

/// A list of bindings which will be used in the route of [DailyTeachingLogScreen].
class DailyTeachingLogBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      DailyTeachingLogController.new,
    );
  }
}
