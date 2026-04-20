import 'package:get/get.dart';
import 'package:school_app/domain/usecases/login_usecases.dart';

import '../../../domain/repositories/repository.dart';
import 'login_student.dart';

/// A list of bindings which will be used in the route of [LoginTeacherScreen].
class LoginStudentBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<LoginStudentController>(
      LoginStudentController(
        Get.put(
          LoginStudentPresenter(
            LoginUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
