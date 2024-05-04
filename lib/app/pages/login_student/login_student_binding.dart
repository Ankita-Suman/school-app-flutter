import 'package:get/get.dart';

import 'login_student.dart';

/// A list of bindings which will be used in the route of [LoginTeacherScreen].
class LoginStudentBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      LoginStudentController.new,
    );
  }
}
