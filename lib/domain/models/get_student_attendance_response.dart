import 'dart:convert';
import 'package:flutter/material.dart';

GetStudentAttendanceResponse getStudentAttendanceResponseFromJson(String str) =>
    GetStudentAttendanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String getStudentAttendanceResponseToJson(GetStudentAttendanceResponse data) =>
    json.encode(data.toJson());

class GetStudentAttendanceResponse {
  final bool status;
  final String message;
  final List<StudentAttendance>? data;

  GetStudentAttendanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetStudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return GetStudentAttendanceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StudentAttendance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null && data!.isNotEmpty;
  int get totalStudents => data?.length ?? 0;
}

class StudentAttendance {
  final String studentId;
  final String registrationNumber;
  final String admissionNumber;
  final String rollNumber;
  final String fullName;
  final String? photo;
  final ClassInfo? classInfo;
  final SectionInfo? sectionInfo;
  final AttendanceInfo? attendance;

  StudentAttendance({
    required this.studentId,
    required this.registrationNumber,
    required this.admissionNumber,
    required this.rollNumber,
    required this.fullName,
    this.photo,
    this.classInfo,
    this.sectionInfo,
    this.attendance,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId: json['student_id'] as String? ?? '',
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
      classInfo: json['class'] != null
          ? ClassInfo.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      sectionInfo: json['section'] != null
          ? SectionInfo.fromJson(json['section'] as Map<String, dynamic>)
          : null,
      attendance: json['attendance'] != null
          ? AttendanceInfo.fromJson(json['attendance'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'full_name': fullName,
      'photo': photo,
      'class': classInfo?.toJson(),
      'section': sectionInfo?.toJson(),
      'attendance': attendance?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasAttendance => attendance != null && attendance!.attendanceId != null;
  String get displayStatus => attendance?.status ?? 'Not Marked';
  Color get statusColor {
    if (attendance == null) return Colors.grey;
    switch (attendance!.status?.toUpperCase()) {
      case 'PRESENT': return Colors.green;
      case 'ABSENT': return Colors.red;
      case 'LATE': return Colors.orange;
      case 'HALF_DAY': return Colors.purple;
      case 'LEAVE': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

class ClassInfo {
  final String id;
  final String name;

  ClassInfo({required this.id, required this.name});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class SectionInfo {
  final String id;
  final String name;

  SectionInfo({required this.id, required this.name});

  factory SectionInfo.fromJson(Map<String, dynamic> json) {
    return SectionInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AttendanceInfo {
  final String? attendanceId;
  final String? attendanceDate;
  final String? status;
  final String? remarks;
  final String? markedAt;

  AttendanceInfo({
    this.attendanceId,
    this.attendanceDate,
    this.status,
    this.remarks,
    this.markedAt,
  });

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceInfo(
      attendanceId: json['attendance_id'] as String?,
      attendanceDate: json['attendance_date'] as String?,
      status: json['status'] as String?,
      remarks: json['remarks'] as String?,
      markedAt: json['marked_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'attendance_date': attendanceDate,
      'status': status,
      'remarks': remarks,
      'marked_at': markedAt,
    };
  }
}