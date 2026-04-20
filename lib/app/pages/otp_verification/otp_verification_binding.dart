import 'package:get/get.dart';

import '../../../domain/domain.dart';
import 'otp_verification.dart';

/// A list of bindings which will be used in the route of [OtpVerificationScreen].
class OtpVerificationBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<OtpVerificationController>(
      OtpVerificationController(
        Get.put(
          OtpVerificationPresenter(
            VerifyOTPUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
