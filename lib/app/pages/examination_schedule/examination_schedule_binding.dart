import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'examination_schedule.dart';

/// A list of bindings which will be used in the route of [ExaminationScheduleScreen].
class ExaminationScheduleBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ExaminationScheduleController>(
      ExaminationScheduleController(
        Get.put(
          ExaminationSchedulePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
