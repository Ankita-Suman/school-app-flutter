import 'package:school_app/domain/domain.dart';

import '../../../domain/models/class_attendance_response.dart';

class AttendanceReportPresenter {
  AttendanceReportPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<AttendanceReportResponse?> fetchClassAttendanceReport({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    return await homeUseCases.fetchClassAttendanceReport(
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
}
