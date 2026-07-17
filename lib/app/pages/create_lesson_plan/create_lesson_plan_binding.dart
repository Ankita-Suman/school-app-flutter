import 'package:get/get.dart';

import 'create_lesson_plan.dart';

/// A list of bindings which will be used in the route of [CreateLessonPlanScreen].
class CreateLessonPlanBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      CreateLessonPlanController.new,
    );
  }
}
