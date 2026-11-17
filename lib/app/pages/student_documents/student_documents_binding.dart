import 'package:get/get.dart';
import 'package:school_app/app/pages/student_documents/student_documents_controller.dart';
import 'package:school_app/app/pages/student_documents/student_documents_presenter.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

/// A list of bindings which will be used in the route of [StaffLeaveScreen].
class StudentDocumentsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StudentDocumentsController>(
      StudentDocumentsController(
        Get.put(
          StudentDocumentsPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
