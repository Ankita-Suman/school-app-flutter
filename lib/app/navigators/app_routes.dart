// coverage:ignore-file
part of 'app_pages.dart';

/// A chunks of routes and the path names which will be used to create
/// routes in [AppPages].
abstract class Routes {
  static const splash = _Paths.splash;
  static const chooseOptions = _Paths.chooseOptions;
  static const loginTeacher = _Paths.loginTeacher;
  static const loginStudent = _Paths.loginStudent;
  static const loginParent = _Paths.loginParent;
  static const home = _Paths.home;
  static const forgotPassword = _Paths.forgotPassword;
  static const otpVerification = _Paths.otpVerification;
  static const notifications = _Paths.notifications;
  static const events = _Paths.events;
  static const profile = _Paths.profile;
  static const resetPassword = _Paths.resetPassword;
  static const login = _Paths.login;
  static const newForgotPassword = _Paths.newForgotPassword;
  static const newOtpVerification = _Paths.newOtpVerification;
  static const changePassword = _Paths.changePassword;
  static const changePasswordSuccessfully = _Paths.changePasswordSuccessfully;
  static const feesDetails = _Paths.feesDetails;
  static const invoice = _Paths.invoice;
  static const noticeBoard = _Paths.noticeBoard;

}

abstract class _Paths {
  static const splash = '/splash-screen';
  static const chooseOptions = '/choose-options-screen';
  static const loginTeacher = '/Login-Teacher-screen';
  static const loginStudent = '/Login-Student-screen';
  static const loginParent = '/Login-Parent-screen';
  static const home = '/Home-screen';
  static const forgotPassword = '/Forgot-Password-screen';
  static const otpVerification = '/Otp-Verification-screen';
  static const notifications = '/Notifications-screen';
  static const events = '/Events-screen';
  static const profile = '/Profile-screen';
  static const resetPassword = '/Reset-Password-screen';
  static const login = '/Login-screen';
  static const newForgotPassword = '/New-Forgot_password-screen';
  static const changePassword = '/Change-Password-screen';
  static const changePasswordSuccessfully = '/Change-Password-Successfully-screen';
  static const newOtpVerification = '/New-Otp-verification-screen';
  static const feesDetails = '/Fees_details-screen';
  static const invoice = '/Invoice-screen';
  static const noticeBoard = '/Notice-Board-screen';

}
