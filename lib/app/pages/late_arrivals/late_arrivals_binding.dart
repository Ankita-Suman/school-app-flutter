import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'late_arrivals.dart';

/// A list of bindings which will be used in the route of [LateArrivalsScreen].
class LateArrivalsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<LateArrivalsController>(
      LateArrivalsController(
        Get.put(
          LateArrivalsPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
