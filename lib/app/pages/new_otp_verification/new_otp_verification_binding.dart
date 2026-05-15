import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/verify_otp_usecases.dart';
import 'new_otp_verification.dart';

/// A list of bindings which will be used in the route of [NewForgotPasswordScreen].
class NewOtpVerificationBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<NewOtpVerificationController>(
      NewOtpVerificationController(
        Get.put(
          NewOtpVerificationPresenter(
            VerifyOTPUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
