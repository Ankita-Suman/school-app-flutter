import 'package:get/get.dart';

import 'homework_history.dart';

/// A list of bindings which will be used in the route of [HomeworkHistoryScreen].
class HomeworkHistoryBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      HomeworkHistoryController.new,
    );
  }
}
