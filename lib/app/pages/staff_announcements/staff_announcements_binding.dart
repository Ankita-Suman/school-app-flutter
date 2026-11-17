import 'package:get/get.dart';
import 'package:school_app/app/pages/staff_announcements/staff_announcements_controller.dart';
import 'package:school_app/app/pages/staff_announcements/staff_announcements_presenter.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

/// A list of bindings which will be used in the route of [ApplyLeaveScreen].
class StaffAnnouncementsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StaffAnnouncementsController>(
      StaffAnnouncementsController(
        Get.put(
          StaffAnnouncementsPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
