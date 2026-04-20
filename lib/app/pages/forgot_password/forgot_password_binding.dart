import 'package:get/get.dart';
import '../../../domain/domain.dart';
import 'forgot_password.dart';

/// A list of bindings which will be used in the route of [ForgotPasswordScreen].
class ForgotPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ForgotPasswordController>(
      ForgotPasswordController(
        Get.put(
          ForgotPasswordPresenter(
            ForgotPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
