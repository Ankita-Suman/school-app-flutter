import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';
import 'login.dart';

/// A list of bindings which will be used in the route of [LoginScreen].
class LoginBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(
        Get.put(
          LoginPresenter(
            LoginUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
