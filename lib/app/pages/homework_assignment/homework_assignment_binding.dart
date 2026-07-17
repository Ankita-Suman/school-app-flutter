import 'package:get/get.dart';

import 'homework_assignment.dart';

/// A list of bindings which will be used in the route of [HomeworkAssignmentScreen].
class HomeworkAssignmentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      HomeworkAssignmentController.new,
    );
  }
}
