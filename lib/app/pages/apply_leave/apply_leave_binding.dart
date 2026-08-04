import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'apply_leave.dart';

/// A list of bindings which will be used in the route of [ApplyLeaveScreen].
class ApplyLeaveBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ApplyLeaveController>(
      ApplyLeaveController(
        Get.put(
          ApplyLeavePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
