import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'attendance_report.dart';

/// A list of bindings which will be used in the route of [AttendanceReportScreen].
class AttendanceReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AttendanceReportController>(
      AttendanceReportController(
        Get.put(
          AttendanceReportPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
