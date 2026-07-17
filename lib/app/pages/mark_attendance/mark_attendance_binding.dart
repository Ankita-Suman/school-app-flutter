import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'mark_attendance.dart';

/// A list of bindings which will be used in the route of [MarkAttendanceScreen].
class MarkAttendanceBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MarkAttendanceController>(
      MarkAttendanceController(
        Get.put(
          MarkAttendancePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
