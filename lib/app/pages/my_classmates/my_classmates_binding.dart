import 'package:get/get.dart';
import 'package:school_app/app/pages/student_documents/student_documents_controller.dart';
import 'package:school_app/app/pages/student_documents/student_documents_presenter.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_classmates_controller.dart';
import 'my_classmates_presenter.dart';

/// A list of bindings which will be used in the route of [StaffLeaveScreen].
class MyClassmatesBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MyClassmatesController>(
      MyClassmatesController(
        Get.put(
          MyClassmatesPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
