import 'package:school_app/app/app.dart';
import 'package:get/get.dart';

/// A chunk of routes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        taken in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class RouteManagement {


  static void goToChooseOptions() {
    Get.offAllNamed<void>(Routes.chooseOptions);
  }

  static void goToLoginTeacher() {
    Get.offAllNamed<void>(Routes.loginTeacher);
  }
  static void goToLoginStudent() {
    Get.offAllNamed<void>(Routes.loginStudent);
  }
  static void goToLoginParent() {
    Get.offAllNamed<void>(Routes.loginParent);
  }
  static void goToHome() {
    Get.offAllNamed<void>(Routes.home);
  }
  static void goToOtpVerification() {
    Get.toNamed<void>(Routes.otpVerification);
  }
  static void goToForgotPassword() {
    Get.toNamed<void>(
      Routes.forgotPassword,
    );
  }
}
