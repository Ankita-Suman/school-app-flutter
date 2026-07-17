import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'term_attendance.dart';

/// A list of bindings which will be used in the route of [TermAttendanceScreen].
class TermAttendanceBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<TermAttendanceController>(
      TermAttendanceController(
        Get.put(
          TermAttendancePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
