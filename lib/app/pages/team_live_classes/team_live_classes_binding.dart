import 'package:get/get.dart';

import 'team_live_classes.dart';

/// A list of bindings which will be used in the route of [TeamLiveClassesScreen].
class TeamLiveClassesBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      TeamLiveClassesController.new,
    );
  }
}
