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

}
