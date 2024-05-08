import 'package:get/get.dart';

import 'otp_verification.dart';

/// A list of bindings which will be used in the route of [OtpVerificationScreen].
class OtpVerificationBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(
      OtpVerificationController.new,
    );
  }
}
