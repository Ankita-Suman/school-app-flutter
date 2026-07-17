// lib/domain/models/save_term_attendance_response.dart

import 'dart:convert';

SaveTermAttendanceResponse saveTermAttendanceResponseFromJson(String str) =>
    SaveTermAttendanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String saveTermAttendanceResponseToJson(SaveTermAttendanceResponse data) =>
    json.encode(data.toJson());

class SaveTermAttendanceResponse {
  final bool status;
  final String message;
  final List<AttendanceRecord> data;

  SaveTermAttendanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SaveTermAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return SaveTermAttendanceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  bool get isSuccess => status == true;
  bool get hasData => data.isNotEmpty;
}

class AttendanceRecord {
  final String attendanceId;
  final String studentId;
  final String examinationGroupId;
  final String examinationTermId;
  final String classId;
  final String sectionId;
  final int attendance;
  final int maxAttendance;

  AttendanceRecord({
    required this.attendanceId,
    required this.studentId,
    required this.examinationGroupId,
    required this.examinationTermId,
    required this.classId,
    required this.sectionId,
    required this.attendance,
    required this.maxAttendance,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      attendanceId: json['attendance_id'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      examinationGroupId: json['examination_group_id'] as String? ?? '',
      examinationTermId: json['examination_term_id'] as String? ?? '',
      classId: json['class_id'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      attendance: json['attendance'] as int? ?? 0,
      maxAttendance: json['max_attendance'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'student_id': studentId,
      'examination_group_id': examinationGroupId,
      'examination_term_id': examinationTermId,
      'class_id': classId,
      'section_id': sectionId,
      'attendance': attendance,
      'max_attendance': maxAttendance,
    };
  }
}