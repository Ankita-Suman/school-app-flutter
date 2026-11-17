import 'package:get/get.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'curricular_marks.dart'; // imports InternalMarksController and InternalMarksPresenter

/// A list of bindings which will be used in the route of [CurricularMarksScreen].
class CurricularMarksBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CurricularMarksController>(
      CurricularMarksController(
        Get.put(
          CurricularMarksPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}