import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/reset_password_usecases.dart';
import 'staff_reset_password.dart';

/// A list of bindings which will be used in the route of [StaffResetPasswordScreen].
class StaffResetPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StaffResetPasswordController>(
      StaffResetPasswordController(
        Get.put(
          StaffResetPasswordPresenter(
            ResetPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
