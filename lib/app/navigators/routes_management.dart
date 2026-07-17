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
  }

  static void goToTeacherDashboard() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.teacherHome);
    // or Routes.dashboard
  }

  static void goToLogin() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.login); // or Routes.dashboard
  }

  static void goToLoginTeacher() {
    Get.toNamed(Routes.loginTeacher);
  }
  static void goToPayment() {
    Get.toNamed(Routes.payment);
  }
  static void goToMyClasses() {
    Get.toNamed(Routes.myClasses);
  }

  static void goToStudentList({
    required String classId,
    required String sectionId,
  }) {
    Get.toNamed(
      Routes.myStudentList,
      arguments: {
        'classId': classId,
        'sectionId': sectionId,
      },
    );
  }
  static void goToMyStudentClassList() {
    Get.toNamed(Routes.myStudentClass);
  }

  static void goToStudentProfile({required String studentId}) {
    Get.toNamed(
      Routes.studentProfile,
      arguments: {'studentId': studentId ?? ''},
    );
  }
  static void goToAttendanceManagement() {
    Get.toNamed(Routes.attendanceManagement);
  }
  static void goToHomeworkAssignment() {
    Get.toNamed(Routes.homeworkAssignment);
  }
  static void goToLessonPlanning() {
    Get.toNamed(Routes.lessonPlanning);
  }
  static void goToExamination() {
    Get.toNamed(Routes.examination);
  }
  static void goToStaffLeave() {
    Get.toNamed(Routes.staffLeave);
  }
  static void goToFeeCollection() {
    Get.toNamed(Routes.feeCollection);
  }
  static void goToCreateLiveClass() {
    Get.toNamed(Routes.createLiveClass);
  }
  static void goToStudentClass() {
    Get.toNamed(Routes.myStudentClass);
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

  static void goToMyClassDetails({
    required String classId,
    required String sectionId,
  }) {
    Get.toNamed(
      Routes.myClassDetails,
      arguments: {
        'classId': classId,
        'sectionId': sectionId,
      },
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
  static void goToNoticeBored() {
    Get.toNamed(Routes.noticeBoard);
  }
  static void goToUpcomingEvents() {
    Get.toNamed(Routes.upcomingEvents);
  }
  static void goToZoomLiveClasses() {
    Get.toNamed(Routes.zoomLiveClasses);
  }
  static void goToTeamLiveClasses() {
    Get.toNamed(Routes.teamLiveClasses);
  }
  static void goToApplyLeave() {
    Get.toNamed(Routes.applyLeave);
  }
  static void goToAddLeave() {
    Get.toNamed(Routes.addLeave);
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
  static void goToStaffResetPassword() {
    Get.toNamed(Routes.staffResetPassword);
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
