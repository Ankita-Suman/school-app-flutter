import 'package:school_app/domain/domain.dart';

import '../models/class_attendance_response.dart';
import '../models/events_response.dart';
import '../models/get_student_attendance_response.dart';
import '../models/profile_response.dart';
import '../models/term_attendance_student_response.dart';

/// Use case for getting the data from the API
class TeacherHomeUseCases {
  TeacherHomeUseCases(this.repository);

  final Repository repository;

  Future<TeacherDashboardResponse?> getTeacherDashboardAPI(
      {required bool isLoading,
        required String token,
        required String branchId,
      }) async =>
      await repository.getTeacherDashboardAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );

  Future<StaffProfileResponse?> getStaffProfileData(
      {required bool isLoading,
        required String token,
        required String branchId,
      }) async =>
      await repository.getStaffProfileData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );


  Future<LateArrivalsResponse?> getLateArrivalData({required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async =>
      await repository.getLateArrivalData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,

      );

  Future<LeaveApplicationsResponse?> getLeaveStatusData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String filter,
      }) async =>
      await repository.getLeaveStatusData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        filter: filter,

      );

  Future<ProfileResponse?> getProfileDetailsAPI({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async =>
      await repository.getProfileDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        studentId: studentId,
      );

  Future<TeacherClassesResponse?> getMyClassData({required bool isLoading,
    required String token,
    required String branchId,
  }) async =>
      await repository.getMyClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );

  Future<TermClassResponse?> getTermClassData({required bool isLoading,
    required String token,
    required String branchId,
  }) async =>
      await repository.getTermClassData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );
  Future<ExaminationGroupResponse?> getExamGroupData({required bool isLoading,
    required String token,
    required String branchId,
  }) async =>
      await repository.getExamGroupData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,

      );

 Future<TermSectionResponse?> getTermSectionData({required bool isLoading,
    required String token,
    required String branchId,
   required String classId
  }) async =>
      await repository.getTermSectionData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,

      );
  Future<TermAttendanceStudentsResponse?> getTermAttendanceStudents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async =>
      await repository.getTermAttendanceStudents(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,
        examinationTermId: examinationTermId,
        classId: classId,
        sectionId: sectionId,
      );
Future<ExaminationTermResponse?> getExamTermData({required bool isLoading,
    required String token,
    required String branchId,
   required String examinationGroupId
  }) async =>
      await repository.getExamTermData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        examinationGroupId: examinationGroupId,

      );

  Future<ClassDetailsResponse?> getMyClassDetailsData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async =>
      await repository.getMyClassDetailsData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );

  Future<AttendanceReportResponse?> fetchClassAttendanceReport(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId,
        required String sectionId,
        required String date,
      }) async =>
      await repository.fetchClassAttendanceReport(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,
      );

  Future<GetStudentAttendanceResponse?> getStudentListData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId,
        required String sectionId,
        required String date,
      }) async =>
      await repository.getStudentListData(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
        date: date,
      );

  Future<StudentsResponse?> getAllStudentList({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async =>
      await repository.getAllStudentList(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        classId: classId,
        sectionId: sectionId,
      );

  Future<ClassAttendanceResponse?> getClassAttendance({required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId, required int perPage, required int page
  }) async =>
      await repository.getClassAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        attendanceDate: attendanceDate,
        classId: classId,
        sectionId: sectionId,
        perPage: perPage,
        page: page,
      );

  Future<ResponseModel?> logoutAPI(
      {required bool isLoading, required String token,
      }) async =>
      await repository.logoutAPI(
        isLoading: isLoading,
        token: token,
      );

  Future<SaveAttendanceResponse?> saveAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async =>
      await repository.saveAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );


  Future<SaveAttendanceResponse?> updateAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async =>
      await repository.updateAttendance(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
        payload: payload,
      );
  Future<SaveTermAttendanceResponse?> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await repository.saveTermAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
}