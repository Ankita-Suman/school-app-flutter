import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'staff_apply_leave.dart';

/// A list of bindings which will be used in the route of [StaffApplyLeaveScreen].
class StaffApplyLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StaffApplyLeaveController>(
      StaffApplyLeaveController(
        Get.put(
          StaffApplyLeavePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
