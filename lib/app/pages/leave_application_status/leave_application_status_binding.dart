import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'leave_application_status.dart';

/// A list of bindings which will be used in the route of [LeaveApplicationStatusScreen].
class LeaveApplicationStatusBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<LeaveApplicationStatusController>(
      LeaveApplicationStatusController(
        Get.put(
          LeaveApplicationStatusPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
