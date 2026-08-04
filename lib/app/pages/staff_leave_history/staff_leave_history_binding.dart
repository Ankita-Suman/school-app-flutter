import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'staff_leave_history.dart';

/// A list of bindings which will be used in the route of [StaffLeaveHistoryScreen].
class StaffLeaveHistoryBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StaffLeaveHistoryController>(
      StaffLeaveHistoryController(
        Get.put(
          StaffLeaveHistoryPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
