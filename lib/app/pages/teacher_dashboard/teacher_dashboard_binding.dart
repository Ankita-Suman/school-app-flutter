import 'package:get/get.dart';
import 'package:school_app/app/pages/dashboard/dashboard_presenter.dart';
import 'package:school_app/domain/domain.dart';

import 'teacher_dashboard.dart';

/// A list of bindings which will be used in the route of HomeScreen].
class TeacherDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TeacherDashboardController>(
      TeacherDashboardController(
        Get.put(
          TeacherDashboardPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
