// mark_attendance_presenter.dart
import 'dart:convert';
import 'package:school_app/domain/domain.dart';
import '../../../domain/models/class_attendance_response.dart';

class MarkAttendancePresenter {
  MarkAttendancePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

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

  Future<ClassAttendanceResponse?> getClassAttendance({
    required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId,
    required int perPage,
    required int page,
  }) async {
    return await homeUseCases.getClassAttendance(
      isLoading: isLoading,
      token: token,
      attendanceDate: attendanceDate,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      perPage: perPage,
      page: page,
    );
  }

  // ✅ Save Attendance
  Future<SaveAttendanceResponse?> saveAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await homeUseCases.saveAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
}