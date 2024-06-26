import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';
import 'package:school_app/app/pages/home/home.dart';
import 'package:school_app/app/pages/login_parent/login_parent.dart';
import 'package:school_app/app/pages/login_student/login_student.dart';
import 'package:school_app/app/pages/login_teacher/login_teacher.dart';

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

  static const initial = Routes.home;

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
    GetPage<HomeScreen>(
      name: _Paths.home,
      transitionDuration: transitionDuration,
      page: HomeScreen.new,
      binding: HomeBinding(),
      transition: Transition.cupertino,
    ),
   ];
}
