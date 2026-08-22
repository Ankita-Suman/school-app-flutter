import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_student_list.dart';

/// A list of bindings which will be used in the route of [MyStudentListScreen].
class MyStudentListBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MyStudentListController>(
      MyStudentListController(
        Get.put(
          MyStudentListPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
