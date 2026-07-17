// lib/domain/models/class_attendance_response.dart

import 'dart:convert';
import 'package:flutter/material.dart';

ClassAttendanceResponse classAttendanceResponseFromJson(String str) =>
    ClassAttendanceResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String classAttendanceResponseToJson(ClassAttendanceResponse data) =>
    json.encode(data.toJson());

class ClassAttendanceResponse {
  final bool status;
  final String message;
  final ClassAttendanceData? data;

  ClassAttendanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ClassAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ClassAttendanceData.fromJson(json['data'] as Map<String, dynamic>)
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
  bool get hasData => data != null && data!.students != null && data!.students!.isNotEmpty;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  int get totalStudents => data?.students?.length ?? 0;
  List<AttendanceStudent>? get studentList => data?.students;

  // ✅ Pagination getters
  int get currentPage => data?.currentPage ?? 1;
  int get lastPage => data?.lastPage ?? 1;
  int get perPage => data?.perPage ?? 10;
  int get total => data?.total ?? 0;
}

class ClassAttendanceData {
  final AttendanceInfo? attendanceInfo;
  final ClassInfo? classInfo;
  final List<AttendanceStudent>? students;

  // ✅ Pagination fields
  final int? currentPage;
  final int? lastPage;
  final int? perPage;
  final int? total;

  ClassAttendanceData({
    this.attendanceInfo,
    this.classInfo,
    this.students,
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory ClassAttendanceData.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceData(
      attendanceInfo: json['attendance_info'] != null
          ? AttendanceInfo.fromJson(json['attendance_info'] as Map<String, dynamic>)
          : null,
      classInfo: json['class_info'] != null
          ? ClassInfo.fromJson(json['class_info'] as Map<String, dynamic>)
          : null,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => AttendanceStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      perPage: json['per_page'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_info': attendanceInfo?.toJson(),
      'class_info': classInfo?.toJson(),
      'students': students?.map((e) => e.toJson()).toList(),
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }

  bool get hasStudents => students != null && students!.isNotEmpty;
  int get studentCount => students?.length ?? 0;

  // ✅ Pagination helpers
  bool get hasMorePages => currentPage != null && lastPage != null && currentPage! < lastPage!;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;
}

class AttendanceInfo {
  final String date;

  AttendanceInfo({
    required this.date,
  });

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceInfo(
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
    };
  }
}

class ClassInfo {
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final String fullName;

  ClassInfo({
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.fullName,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
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

class AttendanceStudent {
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String registrationNumber;
  final String admissionNumber;
  final String? photo;
  String? currentStatus;
  final List<String> attendanceStatuses;
  String? remarks;
  final String? markedAt;
  final String? markedBy;

  AttendanceStudent({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.registrationNumber,
    required this.admissionNumber,
    this.photo,
    this.currentStatus,
    required this.attendanceStatuses,
    this.remarks,
    this.markedAt,
    this.markedBy,
  });

  factory AttendanceStudent.fromJson(Map<String, dynamic> json) {
    return AttendanceStudent(
      studentId: json['student_id'] as String? ?? '',
      studentName: json['student_name'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      photo: json['photo'] as String?,
      currentStatus: json['current_status'] as String?,
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

  bool get isPresent => currentStatus?.toUpperCase() == 'PRESENT';
  bool get isAbsent => currentStatus?.toUpperCase() == 'ABSENT';
  bool get isLate => currentStatus?.toUpperCase() == 'LATE';
  bool get isHalfDay => currentStatus?.toUpperCase() == 'HALF_DAY';
  bool get isLeave => currentStatus?.toUpperCase() == 'LEAVE';
  bool get isMarked => currentStatus != null && currentStatus!.isNotEmpty;

  String get displayStatus {
    if (currentStatus == null) return 'Not Marked';
    switch (currentStatus!.toUpperCase()) {
      case 'PRESENT': return 'Present';
      case 'ABSENT': return 'Absent';
      case 'LATE': return 'Late';
      case 'HALF_DAY': return 'Half Day';
      case 'LEAVE': return 'Leave';
      default: return currentStatus!;
    }
  }

  Color get statusColor {
    if (currentStatus == null) return Colors.grey;
    switch (currentStatus!.toUpperCase()) {
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
}

// ========== EXTENSION METHODS ==========

extension AttendanceStudentListExt on List<AttendanceStudent> {
  List<AttendanceStudent> get marked => where((item) => item.isMarked).toList();
  List<AttendanceStudent> get unmarked => where((item) => !item.isMarked).toList();
  List<AttendanceStudent> get present => where((item) => item.isPresent).toList();
  List<AttendanceStudent> get absent => where((item) => item.isAbsent).toList();
  List<AttendanceStudent> get late => where((item) => item.isLate).toList();
  List<AttendanceStudent> get halfDay => where((item) => item.isHalfDay).toList();
  List<AttendanceStudent> get leave => where((item) => item.isLeave).toList();

  List<AttendanceStudent> searchByName(String query) {
    if (query.isEmpty) return this;
    final searchQuery = query.toLowerCase().trim();
    return where((item) =>
    item.studentName.toLowerCase().contains(searchQuery) ||
        item.rollNumber.contains(searchQuery)
    ).toList();
  }
}