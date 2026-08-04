import 'package:get/get.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'internal_marks.dart'; // imports InternalMarksController and InternalMarksPresenter

/// A list of bindings which will be used in the route of [InternalMarksScreen].
class InternalMarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InternalMarksController>(
      InternalMarksController(
        Get.put(
          InternalMarksPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}