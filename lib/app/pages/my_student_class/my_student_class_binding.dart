import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_student_class.dart';

/// A list of bindings which will be used in the route of [MyStudentClassScreen].
class MyStudentClassBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MyStudentClassController>(
      MyStudentClassController(
        Get.put(
          MyStudentClassPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
