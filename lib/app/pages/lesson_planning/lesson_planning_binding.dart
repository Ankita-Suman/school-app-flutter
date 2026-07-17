import 'package:get/get.dart';

import 'lesson_planning.dart';

/// A list of bindings which will be used in the route of [LessonPlanningScreen].
class LessonPlanningBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      LessonPlanningController.new,
    );
  }
}
