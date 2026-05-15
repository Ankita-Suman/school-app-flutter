import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/invoice/invoice_screen.dart';
import 'package:school_app/app/pages/login_student/login_student.dart';

import '../pages/invoice/invoice.dart';
import '../pages/invoice/invoice_screen.dart';
import '../pages/invoice/invoice_screen.dart';

/// A chunk of routes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        taken in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class RouteManagement {


  static void goToChooseOptions() {
    Get.offAllNamed(Routes.chooseOptions);
  }


  static void goToHome() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.home);
    // or Routes.dashboard
  }  static void goToLogin() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.login); // or Routes.dashboard
  }

  static void goToLoginTeacher() {
    Get.toNamed(Routes.loginTeacher);
  }

  // static void goToLoginStudentWithParam({required String role}) {
  //   Get.to(
  //         () =>  LoginStudentScreen(),
  //     arguments: {'fromScreen': role}, // Pass argument
  //   );
  // }

  static void goToInvoice({required String invoiceId}) {
    Get.toNamed(
      Routes.invoice,
      arguments: {'invoiceId': invoiceId ?? ''},
    );
  }

  static void goToLoginParent() {
    Get.toNamed(Routes.loginParent);
  }

  static void goToOtpVerification() {
    Get.toNamed(Routes.otpVerification);
  }
  static void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }
  static void goToNewForgotPassword() {
    Get.toNamed(Routes.newForgotPassword);
  }
  static void goToNewOtpVerification() {
    Get.toNamed(Routes.newOtpVerification);
  }
  static void goToChangePassword() {
    Get.toNamed(Routes.changePassword);
  }
  static void goToChangePasswordSuccessfully() {
    Get.toNamed(Routes.changePasswordSuccessfully);
  }
  static void goToResetPassword() {
    Get.toNamed(Routes.resetPassword);
  }
  static void goToNotifications() {
    Get.toNamed(Routes.notifications);
  }
  static void goToEvents() {
    Get.toNamed(Routes.events);
  }
  static void goToProfile() {
    Get.toNamed(Routes.profile);
  }
}
