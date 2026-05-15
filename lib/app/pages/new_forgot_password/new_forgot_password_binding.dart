import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/forgot_password_usecases.dart';
import 'new_forgot_password.dart';

/// A list of bindings which will be used in the route of [NewForgotPasswordScreen].
class NewForgotPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<NewForgotPasswordController>(
      NewForgotPasswordController(
        Get.put(
          NewForgotPasswordPresenter(
            ForgotPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
