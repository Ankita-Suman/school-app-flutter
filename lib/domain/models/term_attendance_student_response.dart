// lib/domain/models/term_attendance_students_response.dart

import 'dart:convert';

TermAttendanceStudentsResponse termAttendanceStudentsResponseFromJson(String str) =>
    TermAttendanceStudentsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String termAttendanceStudentsResponseToJson(TermAttendanceStudentsResponse data) =>
    json.encode(data.toJson());

class TermAttendanceStudentsResponse {
  final bool status;
  final String message;
  final TermAttendanceStudentsData? data;

  TermAttendanceStudentsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TermAttendanceStudentsResponse.fromJson(Map<String, dynamic> json) {
    return TermAttendanceStudentsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TermAttendanceStudentsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  bool get isSuccess => status == true;
  bool get hasData => data != null && data!.students.isNotEmpty;
}

class TermAttendanceStudentsData {
  final int maxAttendance;
  final List<TermAttendanceStudent> students;

  TermAttendanceStudentsData({
    required this.maxAttendance,
    required this.students,
  });

  factory TermAttendanceStudentsData.fromJson(Map<String, dynamic> json) {
    return TermAttendanceStudentsData(
      maxAttendance: json['max_attendance'] as int? ?? 0,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => TermAttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_attendance': maxAttendance,
      'students': students.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasStudents => students.isNotEmpty;
  int get studentCount => students.length;
}

class TermAttendanceStudent {
  final String studentId;
  final String registrationNumber;
  final String admissionNumber;
  final String rollNumber;
  final String studentName;
  final int? existingAttendance;
  final int maxAttendance;

  TermAttendanceStudent({
    required this.studentId,
    required this.registrationNumber,
    required this.admissionNumber,
    required this.rollNumber,
    required this.studentName,
    this.existingAttendance,
    required this.maxAttendance,
  });

  factory TermAttendanceStudent.fromJson(Map<String, dynamic> json) {
    return TermAttendanceStudent(
      studentId: json['student_id'] as String? ?? '',
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      studentName: json['student_name'] as String? ?? '',
      existingAttendance: json['existing_attendance'] as int?,
      maxAttendance: json['max_attendance'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'student_name': studentName,
      'existing_attendance': existingAttendance,
      'max_attendance': maxAttendance,
    };
  }

  bool get hasExistingAttendance => existingAttendance != null;
  String get displayName => studentName;
  String get reg => registrationNumber;
}