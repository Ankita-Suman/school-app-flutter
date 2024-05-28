import 'dart:async';

import 'package:get/get.dart';

class OtpVerificationController extends GetxController
    with GetTickerProviderStateMixin {
  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
      } else {
        enableResend = true;
      }
      update();
    });
  }

  void resendCode() {
    secondsRemaining = 60;
    enableResend = false;
    update();
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }
}
