import 'package:school_app/app/app.dart';
import 'package:get/get.dart';
import 'package:school_app/app/pages/add_leave/add_leave.dart';
import 'package:school_app/app/pages/apply_leave/apply_leave.dart';
import 'package:school_app/app/pages/approval_status/approval_status.dart';
import 'package:school_app/app/pages/attendance_management/attendance_management.dart';
import 'package:school_app/app/pages/attendance_report/attendance_report.dart';
import 'package:school_app/app/pages/change_password/change_password.dart';
import 'package:school_app/app/pages/change_password_successfully/change_password_successfully.dart';
import 'package:school_app/app/pages/choose_options/choose_options.dart';
import 'package:school_app/app/pages/create_homework/create_homework.dart';
import 'package:school_app/app/pages/create_lesson_plan/create_lesson_plan.dart';
import 'package:school_app/app/pages/dashboard/dashboard.dart';
import 'package:school_app/app/pages/edit_attendance/edit_attendance.dart';
import 'package:school_app/app/pages/events/events.dart';
import 'package:school_app/app/pages/fees_details/fees_details.dart';
import 'package:school_app/app/pages/forgot_password/forgot_password.dart';
import 'package:school_app/app/pages/home/home.dart';
import 'package:school_app/app/pages/homework_assignment/homework_assignment.dart';
import 'package:school_app/app/pages/homework_history/homework_history.dart';
import 'package:school_app/app/pages/internal_marks/internal_marks.dart';
import 'package:school_app/app/pages/invoice/invoice.dart';
import 'package:school_app/app/pages/late_arrivals/late_arrivals.dart';
import 'package:school_app/app/pages/leave_application_status/leave_application_status.dart';
import 'package:school_app/app/pages/leave_balance/leave_balance.dart';
import 'package:school_app/app/pages/lesson_planning/lesson_planning.dart';
import 'package:school_app/app/pages/login/login.dart';
import 'package:school_app/app/pages/login_parent/login_parent.dart';
import 'package:school_app/app/pages/login_student/login_student.dart';
import 'package:school_app/app/pages/login_teacher/login_teacher.dart';
import 'package:school_app/app/pages/mark_attendance/mark_attendance.dart';
import 'package:school_app/app/pages/my_class_details/my_class_details.dart';
import 'package:school_app/app/pages/my_classes/my_classes.dart';
import 'package:school_app/app/pages/my_classes/my_classes_screen.dart';
import 'package:school_app/app/pages/my_student_list/my_student_list.dart';
import 'package:school_app/app/pages/new_forgot_password/new_forgot_password.dart';
import 'package:school_app/app/pages/new_otp_verification/new_otp_verification.dart';
import 'package:school_app/app/pages/notice_board/notice_board.dart';
import 'package:school_app/app/pages/notifications/notifications.dart';
import 'package:school_app/app/pages/otp_verification/otp_verification.dart';
import 'package:school_app/app/pages/payment/payment.dart';
import 'package:school_app/app/pages/profile/profile.dart';
import 'package:school_app/app/pages/reset_password/reset_password.dart';
import 'package:school_app/app/pages/staff_apply_leave/staff_apply_leave.dart';
import 'package:school_app/app/pages/staff_leave/staff_leave.dart';
import 'package:school_app/app/pages/staff_reset_password/staff_reset_password.dart';
import 'package:school_app/app/pages/student_profile/student_profile.dart';
import 'package:school_app/app/pages/teacher_dashboard/teacher_dashboard_screen.dart';
import 'package:school_app/app/pages/team_live_classes/team_live_classes.dart';
import 'package:school_app/app/pages/term_attendance/term_attendance.dart';
import 'package:school_app/app/pages/upcoming_events/upcoming_events.dart';
import 'package:school_app/app/pages/zoom_live_classes/zoom_live_classes.dart';

import '../pages/create_live_class/create_live_class_binding.dart';
import '../pages/create_live_class/create_live_class_screen.dart';
import '../pages/daily_teaching_log/daily_teaching_log_binding.dart';
import '../pages/daily_teaching_log/daily_teaching_log_screen.dart';
import '../pages/dashboard/dashboard_screen.dart';
import '../pages/defaulter_list/defaulter_list_binding.dart';
import '../pages/defaulter_list/defaulter_list_screen.dart';
import '../pages/examination/examination_binding.dart';
import '../pages/examination/examination_screen.dart';
import '../pages/examination_schedule/examination_schedule_binding.dart';
import '../pages/examination_schedule/examination_schedule_screen.dart';
import '../pages/fee_collection/fee_collection_binding.dart';
import '../pages/fee_collection/fee_collection_screen.dart';
import '../pages/join_meeting/join_meeting_binding.dart';
import '../pages/join_meeting/join_meeting_screen.dart';
import '../pages/mark_entry/mark_entry_binding.dart';
import '../pages/mark_entry/mark_entry_screen.dart';
import '../pages/my_student_class/my_student_class_binding.dart';
import '../pages/my_student_class/my_student_class_screen.dart';
import '../pages/share_material/share_material_binding.dart';
import '../pages/share_material/share_material_screen.dart';
import '../pages/student_fee_list/student_fee_list_binding.dart';
import '../pages/student_fee_list/student_fee_list_screen.dart';
import '../pages/syllabus_tracking/syllabus_tracking_binding.dart';
import '../pages/syllabus_tracking/syllabus_tracking_screen.dart';
import '../pages/teacher_dashboard/teacher_dashboard_binding.dart';

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

  static const initial = Routes.teacherHome;

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
    GetPage<TeacherDashboardScreen>(
      name: _Paths.teacherHome,
      transitionDuration: transitionDuration,
      page: TeacherDashboardScreen.new,
      binding: TeacherDashboardBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<MyClassesScreen>(
      name: _Paths.myClasses,
      transitionDuration: transitionDuration,
      page: MyClassesScreen.new,
      binding: MyClassesBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<MyClassDetailsScreen>(
      name: _Paths.myClassDetails,
      transitionDuration: transitionDuration,
      page: MyClassDetailsScreen.new,
      binding: MyClassDetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<AttendanceManagementScreen>(
      name: _Paths.attendanceManagement,
      transitionDuration: transitionDuration,
      page: AttendanceManagementScreen.new,
      binding: AttendanceManagementBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<HomeworkAssignmentScreen>(
      name: _Paths.homeworkAssignment,
      transitionDuration: transitionDuration,
      page: HomeworkAssignmentScreen.new,
      binding: HomeworkAssignmentBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<MyStudentListScreen>(
      name: _Paths.myStudentList,
      transitionDuration: transitionDuration,
      page: MyStudentListScreen.new,
      binding: MyStudentListBinding(),
      transition: Transition.cupertino,
    ),

    GetPage<MarkAttendanceScreen>(
      name: _Paths.markAttendance,
      transitionDuration: transitionDuration,
      page: MarkAttendanceScreen.new,
      binding: MarkAttendanceBinding(),
      transition: Transition.cupertino,
    ),

    GetPage<MyStudentClassScreen>(
      name: _Paths.myStudentClass,
      transitionDuration: transitionDuration,
      page: MyStudentClassScreen.new,
      binding: MyStudentClassBinding(),
      transition: Transition.cupertino,
    ),

    GetPage<TermAttendanceScreen>(
      name: _Paths.termAttendance,
      transitionDuration: transitionDuration,
      page: TermAttendanceScreen.new,
      binding: TermAttendanceBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<EditAttendanceScreen>(
      name: _Paths.editAttendance,
      transitionDuration: transitionDuration,
      page: EditAttendanceScreen.new,
      binding: EditAttendanceBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LateArrivalsScreen>(
      name: _Paths.lateArrival,
      transitionDuration: transitionDuration,
      page: LateArrivalsScreen.new,
      binding: LateArrivalsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LeaveApplicationStatusScreen>(
      name: _Paths.leaveApplications,
      transitionDuration: transitionDuration,
      page: LeaveApplicationStatusScreen.new,
      binding: LeaveApplicationStatusBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<AttendanceReportScreen>(
      name: _Paths.attendanceReport,
      transitionDuration: transitionDuration,
      page: AttendanceReportScreen.new,
      binding: AttendanceReportBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<StudentProfileScreen>(
      name: _Paths.studentProfile,
      transitionDuration: transitionDuration,
      page: StudentProfileScreen.new,
      binding: StudentProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<HomeworkHistoryScreen>(
      name: _Paths.homeworkHistory,
      transitionDuration: transitionDuration,
      page: HomeworkHistoryScreen.new,
      binding: HomeworkHistoryBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<CreateHomeworkScreen>(
      name: _Paths.createHomework,
      transitionDuration: transitionDuration,
      page: CreateHomeworkScreen.new,
      binding: CreateHomeworkBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<InternalMarksScreen>(
      name: _Paths.internalMarks,
      transitionDuration: transitionDuration,
      page: InternalMarksScreen.new,
      binding: InternalMarksBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LessonPlanningScreen>(
      name: _Paths.lessonPlanning,
      transitionDuration: transitionDuration,
      page: LessonPlanningScreen.new,
      binding: LessonPlanningBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<StaffLeaveScreen>(
      name: _Paths.staffLeave,
      transitionDuration: transitionDuration,
      page: StaffLeaveScreen.new,
      binding: StaffLeaveBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<StaffApplyLeaveScreen>(
      name: _Paths.staffApplyLeave,
      transitionDuration: transitionDuration,
      page: StaffApplyLeaveScreen.new,
      binding: StaffApplyLeaveBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<LeaveBalanceScreen>(
      name: _Paths.leaveBalance,
      transitionDuration: transitionDuration,
      page: LeaveBalanceScreen.new,
      binding: LeaveBalanceBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ApprovalStatusScreen>(
      name: _Paths.approvalStatus,
      transitionDuration: transitionDuration,
      page: ApprovalStatusScreen.new,
      binding: ApprovalStatusBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<CreateLessonPlanScreen>(
      name: _Paths.createLessonPlan,
      transitionDuration: transitionDuration,
      page: CreateLessonPlanScreen.new,
      binding: CreateLessonPlanBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<DailyTeachingLogScreen>(
      name: _Paths.dailyTeachingLog,
      transitionDuration: transitionDuration,
      page: DailyTeachingLogScreen.new,
      binding: DailyTeachingLogBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<SyllabusTrackingScreen>(
      name: _Paths.syllabusTracking,
      transitionDuration: transitionDuration,
      page: SyllabusTrackingScreen.new,
      binding: SyllabusTrackingBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ExaminationScreen>(
      name: _Paths.examination,
      transitionDuration: transitionDuration,
      page: ExaminationScreen.new,
      binding: ExaminationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ExaminationScheduleScreen>(
      name: _Paths.examinationSchedule,
      transitionDuration: transitionDuration,
      page: ExaminationScheduleScreen.new,
      binding: ExaminationScheduleBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<MarkEntryScreen>(
      name: _Paths.markEntry,
      transitionDuration: transitionDuration,
      page: MarkEntryScreen.new,
      binding: MarkEntryBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<CreateLiveClassScreen>(
      name: _Paths.createLiveClass,
      transitionDuration: transitionDuration,
      page: CreateLiveClassScreen.new,
      binding: CreateLiveClassBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<JoinMeetingScreen>(
      name: _Paths.joinMeeting,
      transitionDuration: transitionDuration,
      page: JoinMeetingScreen.new,
      binding: JoinMeetingBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<ShareMaterialScreen>(
      name: _Paths.shareMaterial,
      transitionDuration: transitionDuration,
      page: ShareMaterialScreen.new,
      binding: ShareMaterialBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<FeeCollectionScreen>(
      name: _Paths.feeCollection,
      transitionDuration: transitionDuration,
      page: FeeCollectionScreen.new,
      binding: FeeCollectionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<DefaulterListScreen>(
      name: _Paths.defaulterList,
      transitionDuration: transitionDuration,
      page: DefaulterListScreen.new,
      binding: DefaulterListBinding(),
      transition: Transition.cupertino,
    ),
    GetPage<StaffResetPasswordScreen>(
      name: _Paths.staffResetPassword,
      transitionDuration: transitionDuration,
      page: StaffResetPasswordScreen.new,
      binding: StaffResetPasswordBinding(),
      transition: Transition.cupertino,
    ),
  ];

}
