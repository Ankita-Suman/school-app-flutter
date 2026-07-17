// lib/domain/models/save_attendance_response.dart

import 'dart:convert';
import 'package:flutter/material.dart';

SaveAttendanceResponse saveAttendanceResponseFromJson(String str) =>
    SaveAttendanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String saveAttendanceResponseToJson(SaveAttendanceResponse data) =>
    json.encode(data.toJson());

class SaveAttendanceResponse {
  final bool status;
  final String message;
  final SaveAttendanceData? data;

  SaveAttendanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SaveAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return SaveAttendanceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? SaveAttendanceData.fromJson(json['data'] as Map<String, dynamic>)
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

  // ========== HELPER METHODS ==========
  bool get isSuccess => status == true;
  bool get hasData => data != null && data!.students != null && data!.students!.isNotEmpty;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  int get totalStudents => data?.students?.length ?? 0;
  List<SavedAttendanceStudent>? get studentList => data?.students;
}

class SaveAttendanceData {
  final AttendanceInfos? attendanceInfo;
  final ClassInf? classInfo;
  final List<SavedAttendanceStudent>? students;

  SaveAttendanceData({
    this.attendanceInfo,
    this.classInfo,
    this.students,
  });

  factory SaveAttendanceData.fromJson(Map<String, dynamic> json) {
    return SaveAttendanceData(
      attendanceInfo: json['attendance_info'] != null
          ? AttendanceInfos.fromJson(json['attendance_info'] as Map<String, dynamic>)
          : null,
      classInfo: json['class_info'] != null
          ? ClassInf.fromJson(json['class_info'] as Map<String, dynamic>)
          : null,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => SavedAttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_info': attendanceInfo?.toJson(),
      'class_info': classInfo?.toJson(),
      'students': students?.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasStudents => students != null && students!.isNotEmpty;
  int get studentCount => students?.length ?? 0;
}

class AttendanceInfos {
  final String date;

  AttendanceInfos({
    required this.date,
  });

  factory AttendanceInfos.fromJson(Map<String, dynamic> json) {
    return AttendanceInfos(
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
    };
  }
}

class ClassInf {
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final String fullName;

  ClassInf({
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.fullName,
  });

  factory ClassInf.fromJson(Map<String, dynamic> json) {
    return ClassInf(
      classId: json['class_id'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      sectionName: json['section_name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'section_id': sectionId,
      'section_name': sectionName,
      'full_name': fullName,
    };
  }
}

class SavedAttendanceStudent {
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String registrationNumber;
  final String admissionNumber;
  final String? photo;
  final String currentStatus;
  final List<String> attendanceStatuses;
  final String? remarks;
  final String? markedAt;
  final String? markedBy;

  SavedAttendanceStudent({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.registrationNumber,
    required this.admissionNumber,
    this.photo,
    required this.currentStatus,
    required this.attendanceStatuses,
    this.remarks,
    this.markedAt,
    this.markedBy,
  });

  factory SavedAttendanceStudent.fromJson(Map<String, dynamic> json) {
    return SavedAttendanceStudent(
      studentId: json['student_id'] as String? ?? '',
      studentName: json['student_name'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      photo: json['photo'] as String?,
      currentStatus: json['current_status'] as String? ?? '',
      attendanceStatuses: (json['attendance_statuses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      remarks: json['remarks'] as String?,
      markedAt: json['marked_at'] as String?,
      markedBy: json['marked_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'photo': photo,
      'current_status': currentStatus,
      'attendance_statuses': attendanceStatuses,
      'remarks': remarks,
      'marked_at': markedAt,
      'marked_by': markedBy,
    };
  }

  // ========== HELPER METHODS ==========

  bool get isPresent => currentStatus.toUpperCase() == 'PRESENT';
  bool get isAbsent => currentStatus.toUpperCase() == 'ABSENT';
  bool get isLate => currentStatus.toUpperCase() == 'LATE';
  bool get isHalfDay => currentStatus.toUpperCase() == 'HALF_DAY';
  bool get isLeave => currentStatus.toUpperCase() == 'LEAVE';
  bool get isMarked => currentStatus.isNotEmpty;

  String get displayStatus {
    switch (currentStatus.toUpperCase()) {
      case 'PRESENT': return 'Present';
      case 'ABSENT': return 'Absent';
      case 'LATE': return 'Late';
      case 'HALF_DAY': return 'Half Day';
      case 'LEAVE': return 'Leave';
      default: return currentStatus;
    }
  }

  Color get statusColor {
    switch (currentStatus.toUpperCase()) {
      case 'PRESENT': return Colors.green;
      case 'ABSENT': return Colors.red;
      case 'LATE': return Colors.orange;
      case 'HALF_DAY': return Colors.purple;
      case 'LEAVE': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
  bool get hasRemarks => remarks != null && remarks!.isNotEmpty;
  bool get hasMarkedAt => markedAt != null && markedAt!.isNotEmpty;
  bool get hasMarkedBy => markedBy != null && markedBy!.isNotEmpty;
}

// ========== EXTENSION METHODS ==========

extension SavedAttendanceListExt on List<SavedAttendanceStudent> {
  List<SavedAttendanceStudent> get present => where((item) => item.isPresent).toList();
  List<SavedAttendanceStudent> get absent => where((item) => item.isAbsent).toList();
  List<SavedAttendanceStudent> get late => where((item) => item.isLate).toList();
  List<SavedAttendanceStudent> get halfDay => where((item) => item.isHalfDay).toList();
  List<SavedAttendanceStudent> get leave => where((item) => item.isLeave).toList();

  List<SavedAttendanceStudent> searchByName(String query) {
    if (query.isEmpty) return this;
    final searchQuery = query.toLowerCase().trim();
    return where((item) =>
    item.studentName.toLowerCase().contains(searchQuery) ||
        item.rollNumber.contains(searchQuery)
    ).toList();
  }
}