import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'external_marks.dart';

/// A list of bindings which will be used in the route of [ExternalMarksScreen].
class ExternalMarksBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ExternalMarksController>(
      ExternalMarksController(
        Get.put(
          ExternalMarksPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
