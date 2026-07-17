import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'edit_attendance.dart';

/// A list of bindings which will be used in the route of [EditAttendanceScreen].
class EditAttendanceBinding extends Bindings {


  @override
  void dependencies() {
    Get.put<EditAttendanceController>(
      EditAttendanceController(
        Get.put(
          EditAttendancePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
