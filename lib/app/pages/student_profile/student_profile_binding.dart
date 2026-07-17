import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'student_profile.dart';

/// A list of bindings which will be used in the route of [StudentProfileScreen].
class StudentProfileBinding extends Bindings {

  void dependencies() {
    Get.put<StudentProfileController>(
      StudentProfileController(
        Get.put(
          StudentProfilePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
