import 'package:school_app/app/app.dart';
import 'package:get/get.dart';

import '../pages/dashboard/widgets/fees_widget.dart';
/// A chunk of routes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        taken in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class RouteManagement {



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
  static void goToParentDashboard() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.home);
    // or Routes.dashboard
  }

  // static void goToLogin() {
  //   // Navigate to home screen (replace with your actual home route)
  //   Get.offAllNamed(Routes.login); // or Routes.dashboard
  // }
  static void goToVerifyBranchCode() {
    // Navigate to home screen (replace with your actual home route)
    Get.offAllNamed(Routes.verifyBranchCode); // or Routes.dashboard
  }
  static void goToLogin() {
    Get.offAllNamed(Routes.login);
  }
  static void goToPayment() {
    Get.toNamed(Routes.payment);
  }
  static void goToStaffAttendanceRecord() {
    Get.toNamed(Routes.staffAttendanceRecord);
  }
  static void goToAttendanceRecord() {
    Get.toNamed(Routes.attendanceRecord);
  }
  static Future<dynamic> goToFeesDetails() async {
    return Get.to(
          () => const FeesDetailsScreen(), // आपकी फीस स्क्रीन
      transition: Transition.rightToLeft, // एनिमेशन (आप अपने हिसाब से बदल सकते हैं)
    );
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
  static void goToJoinMeeting() {
    Get.toNamed(Routes.joinMeeting);
  }
  static void goToStudentFeeList() {
    Get.toNamed(Routes.studentFeeList);
  }
  static void goToDefaulterList() {
    Get.toNamed(Routes.defaulterList);
  }

  static void goToStudentProfile({required String studentId}) {
    Get.toNamed(
      Routes.studentProfile,
      arguments: {'studentId': studentId},
    );
  }
  static void goToAttendanceManagement() {
    Get.toNamed(Routes.attendanceManagement);
  }
  static void goToHomeworkAssignment() {
    Get.toNamed(Routes.homeworkAssignment);
  }
  static void goToLeaveBalance() {
    Get.toNamed(Routes.leaveBalance);
  }
  static void goToApprovalStatus() {
    Get.toNamed(Routes.approvalStatus);
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

  static void goToInvoice({required String invoiceId}) {
    Get.toNamed(
      Routes.invoice,
      arguments: {'invoiceId': invoiceId},
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

  static void goToStaffLeaveHistory() {
    Get.toNamed(Routes.staffLeaveHistory);
  }

  static void goToOtpVerification() {
    Get.toNamed(Routes.otpVerification);
  }
  static void goToExamSchedule() {
    Get.toNamed(Routes.examinationSchedule);
  }
  static void goToForgotPassword() {
    Get.toNamed(Routes.forgotPassword);
  }
  static void goToMarkEntry() {
    Get.toNamed(Routes.markEntry);
  }
  static void goToTermAttendance() {
    Get.toNamed(Routes.termAttendance);
  }
  static void goToExternalMarks() {
    Get.toNamed(Routes.externalMarks);
  }
  static void goToCurricularMarks() {
    Get.toNamed(Routes.curricularMarks);
  }
  static void goToInternalMarks() {
    Get.toNamed(Routes.internalMarks);
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
  static void goToMyChildrenList() {
    Get.toNamed(Routes.myChildrenList);
  }

  static void goToZoomLiveClasses() {
    Get.toNamed(Routes.zoomLiveClasses);
  }
  static void goToTeamLiveClasses() {
    Get.toNamed(Routes.teamLiveClasses);
  }
  static void goToStudentDocuments() {
    Get.toNamed(Routes.documents);
  }
  static void goToApplyLeave() {
    Get.toNamed(Routes.applyLeave);
  }
  static void goToMyClassmate() {
    Get.toNamed(Routes.myClassmates);
  }
  static void goToDeleteAccount() {
    Get.toNamed(Routes.deleteAccount);
  }
  static void goToStaffAnnouncements() {
    Get.toNamed(Routes.staffAnnouncements);
  }
  static void goToStaffApplyLeave() {
    Get.toNamed(Routes.staffApplyLeave);
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
  static void goToCreatePassword() {
    Get.toNamed(Routes.createPassword);
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
