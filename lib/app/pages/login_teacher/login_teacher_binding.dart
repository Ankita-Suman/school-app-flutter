import 'package:get/get.dart';
import 'login_teacher.dart';

/// A list of bindings which will be used in the route of [LoginTeacherScreen].
class LoginTeacherBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      LoginTeacherController.new,
    );
  }
}
