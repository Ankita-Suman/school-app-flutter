import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/reset_password_usecases.dart';
import 'create_password.dart';

/// A list of bindings which will be used in the route of [CreatePasswordScreen].
class CreatePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CreatePasswordController>(
      CreatePasswordController(
        Get.put(
          CreatePasswordPresenter(
            ResetPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
