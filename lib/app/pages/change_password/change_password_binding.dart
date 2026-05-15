import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/reset_password_usecases.dart';
import 'change_password.dart';

/// A list of bindings which will be used in the route of [ChangePasswordScreen].
class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChangePasswordController>(
      ChangePasswordController(
        Get.put(
          ChangePasswordPresenter(
            ResetPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
