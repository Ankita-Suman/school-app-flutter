import 'package:school_app/domain/domain.dart';

import '../../../domain/models/get_student_attendance_response.dart';

class EditAttendancePresenter {
  EditAttendancePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<GetStudentAttendanceResponse?> getStudentListData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    return await homeUseCases.getStudentListData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
  }
  Future<TeacherClassesResponse?> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId
  }) async {
    return await homeUseCases.getMyClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }
// ✅ Save Attendance
  Future<SaveAttendanceResponse?> updateAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await homeUseCases.updateAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
}
