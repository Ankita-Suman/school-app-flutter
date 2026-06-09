import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/add_leave/add_leave.dart';
import 'package:school_app/app/pages/apply_leave/apply_leave.dart';
import 'package:school_app/app/pages/change_password/change_password.dart';
import 'package:school_app/app/pages/change_password_successfully/change_password_successfully.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';
import 'package:school_app/app/pages/dashboard/dashboard.dart';
import 'package:school_app/app/pages/events/events.dart';
import 'package:school_app/app/pages/fees_details/fees_details.dart';
import 'package:school_app/app/pages/forgot_password/forgot_password.dart';
import 'package:school_app/app/pages/home/home.dart';
import 'package:school_app/app/pages/invoice/invoice.dart';
import 'package:school_app/app/pages/login/login.dart';
import 'package:school_app/app/pages/login_parent/login_parent.dart';
import 'package:school_app/app/pages/login_student/login_student.dart';
import 'package:school_app/app/pages/login_teacher/login_teacher.dart';
import 'package:school_app/app/pages/new_forgot_password/new_forgot_password.dart';
import 'package:school_app/app/pages/new_otp_verification/new_otp_verification.dart';
import 'package:school_app/app/pages/notice_board/notice_board.dart';
import 'package:school_app/app/pages/notifications/notifications.dart';
import 'package:school_app/app/pages/otp_verification/otp_verification.dart';
import 'package:school_app/app/pages/payment/payment.dart';
import 'package:school_app/app/pages/profile/profile.dart';
import 'package:school_app/app/pages/reset_password/reset_password.dart';
import 'package:school_app/app/pages/team_live_classes/team_live_classes.dart';
import 'package:school_app/app/pages/upcoming_events/upcoming_events.dart';
import 'package:school_app/app/pages/zoom_live_classes/zoom_live_classes.dart';

import '../pages/dashboard/dashboard_screen.dart';

part 'app_routes.dart';

/// Contains the list of pages or routes taken across the whole application.
/// This will prevent us in using context for navigation. And also providing
/// the blocs required in the next named routes.
///
/// [pages] : will contain all the pages in the application as a route
/// and will be used in the material app.
/// Will be ignored for test since all are static values and would not change.
class AppPages {
  static var transitionDuration = const Duration(milliseconds: 300);

  static const initial = Routes.splash ;

  static final pages = [
    GetPage<SplashScreen>(
      name: _Paths.splash,
      transitionDuration: transitionDuration,
      page: SplashScreen.new,
      binding: SplashBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ChooseOptionsScreen>(
      name: _Paths.chooseOptions,
      transitionDuration: transitionDuration,
      page: ChooseOptionsScreen.new,
      binding: ChooseOptionsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LoginTeacherScreen>(
      name: _Paths.loginTeacher,
      transitionDuration: transitionDuration,
      page: LoginTeacherScreen.new,
      binding: LoginTeacherBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LoginStudentScreen>(
      name: _Paths.loginStudent,
      transitionDuration: transitionDuration,
      page: LoginStudentScreen.new,
      binding: LoginStudentBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LoginParentScreen>(
      name: _Paths.loginParent,
      transitionDuration: transitionDuration,
      page: LoginParentScreen.new,
      binding: LoginParentBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<DashboardScreen>(
      name: _Paths.home,
      transitionDuration: transitionDuration,
      page: DashboardScreen.new,
      binding: DashboardBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ForgotPasswordScreen>(
      name: _Paths.forgotPassword,
      transitionDuration: transitionDuration,
      page: ForgotPasswordScreen.new,
      binding: ForgotPasswordBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<OtpVerificationScreen>(
      name: _Paths.otpVerification,
      transitionDuration: transitionDuration,
      page: OtpVerificationScreen.new,
      binding: OtpVerificationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<NotificationsScreen>(
      name: _Paths.notifications,
      transitionDuration: transitionDuration,
      page: NotificationsScreen.new,
      binding: NotificationsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<EventsScreen>(
      name: _Paths.events,
      transitionDuration: transitionDuration,
      page: EventsScreen.new,
      binding: EventsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<StaffProfileScreen>(
      name: _Paths.profile,
      transitionDuration: transitionDuration,
      page: StaffProfileScreen.new,
      binding: ProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ResetPasswordScreen>(
      name: _Paths.resetPassword,
      transitionDuration: transitionDuration,
      page: ResetPasswordScreen.new,
      binding: ResetPasswordBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LoginScreen>(
      name: _Paths.login,
      transitionDuration: transitionDuration,
      page: LoginScreen.new,
      binding: LoginBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<NewForgotPasswordScreen>(
      name: _Paths.newForgotPassword,
      transitionDuration: transitionDuration,
      page: NewForgotPasswordScreen.new,
      binding: NewForgotPasswordBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<NewOtpVerificationScreen>(
      name: _Paths.newOtpVerification,
      transitionDuration: transitionDuration,
      page: NewOtpVerificationScreen.new,
      binding: NewOtpVerificationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ChangePasswordScreen>(
      name: _Paths.changePassword,
      transitionDuration: transitionDuration,
      page: ChangePasswordScreen.new,
      binding: ChangePasswordBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ChangePasswordSuccessfullyScreen>(
      name: _Paths.changePasswordSuccessfully,
      transitionDuration: transitionDuration,
      page: ChangePasswordSuccessfullyScreen.new,
      binding: ChangePasswordSuccessfullyBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<FeesDetailsScreen>(
      name: _Paths.feesDetails,
      transitionDuration: transitionDuration,
      page: FeesDetailsScreen.new,
      binding: FeesDetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<InvoiceScreen>(
      name: _Paths.invoice,
      transitionDuration: transitionDuration,
      page: InvoiceScreen.new,
      binding: InvoiceBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<NoticeBoardScreen>(
      name: _Paths.noticeBoard,
      transitionDuration: transitionDuration,
      page: NoticeBoardScreen.new,
      binding: NoticeBoardBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<UpcomingEventsScreen>(
      name: _Paths.upcomingEvents,
      transitionDuration: transitionDuration,
      page: UpcomingEventsScreen.new,
      binding: UpcomingEventsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ZoomLiveClassesScreen>(
      name: _Paths.zoomLiveClasses,
      transitionDuration: transitionDuration,
      page: ZoomLiveClassesScreen.new,
      binding: ZoomLiveClassesBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<TeamLiveClassesScreen>(
      name: _Paths.teamLiveClasses,
      transitionDuration: transitionDuration,
      page: TeamLiveClassesScreen.new,
      binding: TeamLiveClassesBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ApplyLeaveScreen>(
      name: _Paths.applyLeave,
      transitionDuration: transitionDuration,
      page: ApplyLeaveScreen.new,
      binding: ApplyLeaveBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<AddLeaveScreen>(
      name: _Paths.addLeave,
      transitionDuration: transitionDuration,
      page: AddLeaveScreen.new,
      binding: AddLeaveBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<PaymentScreen>(
      name: _Paths.payment,
      transitionDuration: transitionDuration,
      page: PaymentScreen.new,
      binding: PaymentBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
