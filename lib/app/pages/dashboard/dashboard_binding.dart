import 'package:get/get.dart';
import 'package:school_app/domain/domain.dart';

import 'dashboard.dart';

/// A list of bindings which will be used in the route of HomeScreen].
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(
      DashboardController(
        Get.put(
          DashboardPresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
