// lib/domain/models/leave_applications_response.dart

import 'dart:convert';

import 'package:flutter/material.dart';

LeaveApplicationsResponse leaveApplicationsResponseFromJson(String str) =>
    LeaveApplicationsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String leaveApplicationsResponseToJson(LeaveApplicationsResponse data) =>
    json.encode(data.toJson());

class LeaveApplicationsResponse {
  final bool status;
  final String message;
  final LeaveApplicationsData? data;

  LeaveApplicationsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveApplicationsResponse.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LeaveApplicationsData.fromJson(json['data'] as Map<String, dynamic>)
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
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null && data!.data != null && data!.data!.isNotEmpty;
  int get totalLeaveApplications => data?.total ?? 0;
}

class LeaveApplicationsData {
  final List<LeaveApplication>? data;
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;

  LeaveApplicationsData({
    this.data,
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  factory LeaveApplicationsData.fromJson(Map<String, dynamic> json) {
    return LeaveApplicationsData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LeaveApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasMorePages => currentPage != null && lastPage != null && currentPage! < lastPage!;
  bool get isNotEmpty => data != null && data!.isNotEmpty;
  bool get isEmpty => data == null || data!.isEmpty;
  int get totalCount => total ?? 0;
}

class LeaveApplication {
  final String? attendanceId;
  final String? attendanceDate;
  final String? status;
  final String? remarks;
  final LeaveStudent? student;
  final LeaveClass? classInfo;
  final LeaveSection? section;

  LeaveApplication({
    this.attendanceId,
    this.attendanceDate,
    this.status,
    this.remarks,
    this.student,
    this.classInfo,
    this.section,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      attendanceId: json['attendance_id'] as String?,
      attendanceDate: json['attendance_date'] as String?,
      status: json['status'] as String?,
      remarks: json['remarks'] as String?,
      student: json['student'] != null
          ? LeaveStudent.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      classInfo: json['class'] != null
          ? LeaveClass.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      section: json['section'] != null
          ? LeaveSection.fromJson(json['section'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'attendance_date': attendanceDate,
      'status': status,
      'remarks': remarks,
      'student': student?.toJson(),
      'class': classInfo?.toJson(),
      'section': section?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========
  String get studentName => student?.fullName ?? '';
  String get studentRollNumber => student?.rollNumber ?? '';
  String get studentRegistrationNumber => student?.registrationNumber ?? '';
  String get className => classInfo?.name ?? '';
  String get sectionName => section?.name ?? '';
  String get fullClass => '$className - $sectionName';

  bool get hasRemarks => remarks != null && remarks!.isNotEmpty;

  String get formattedDate {
    try {
      if (attendanceDate != null && attendanceDate!.contains('-')) {
        final parts = attendanceDate!.split('-');
        if (parts.length == 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      }
      return attendanceDate ?? '';
    } catch (e) {
      return attendanceDate ?? '';
    }
  }

  String get statusDisplay {
    switch (status?.toUpperCase()) {
      case 'PRESENT':
        return 'Present';
      case 'ABSENT':
        return 'Absent';
      case 'LATE':
        return 'Late';
      case 'HALF_DAY':
        return 'Half Day';
      case 'LEAVE':
        return 'Leave';
      default:
        return status ?? 'Not Marked';
    }
  }

  bool get isLeave => status?.toUpperCase() == 'LEAVE';
  bool get isPresent => status?.toUpperCase() == 'PRESENT';
  bool get isAbsent => status?.toUpperCase() == 'ABSENT';
  bool get isLate => status?.toUpperCase() == 'LATE';
  bool get isHalfDay => status?.toUpperCase() == 'HALF_DAY';

  // Color for avatar based on student name
  Color get avatarColor {
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];
    final index = studentName.hashCode.abs() % colors.length;
    return colors[index];
  }

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

class LeaveStudent {
  final String? id;
  final String? registrationNumber;
  final String? admissionNumber;
  final String? rollNumber;
  final String? fullName;
  final String? photo;

  LeaveStudent({
    this.id,
    this.registrationNumber,
    this.admissionNumber,
    this.rollNumber,
    this.fullName,
    this.photo,
  });

  factory LeaveStudent.fromJson(Map<String, dynamic> json) {
    return LeaveStudent(
      id: json['id'] as String?,
      registrationNumber: json['registration_number'] as String?,
      admissionNumber: json['admission_number'] as String?,
      rollNumber: json['roll_number'] as String?,
      fullName: json['full_name'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'full_name': fullName,
      'photo': photo,
    };
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
}

class LeaveClass {
  final String? id;
  final String? name;

  LeaveClass({
    this.id,
    this.name,
  });

  factory LeaveClass.fromJson(Map<String, dynamic> json) {
    return LeaveClass(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LeaveSection {
  final String? id;
  final String? name;

  LeaveSection({
    this.id,
    this.name,
  });

  factory LeaveSection.fromJson(Map<String, dynamic> json) {
    return LeaveSection(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ========== EXTENSION METHODS ==========

extension LeaveApplicationsResponseExt on LeaveApplicationsResponse {
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null && data!.data != null && data!.data!.isNotEmpty;
  int get total => data?.total ?? 0;
  int get currentPage => data?.currentPage ?? 1;
  int get lastPage => data?.lastPage ?? 1;
  bool get hasMorePages => currentPage < lastPage;
  bool get isEmpty => data == null || data!.data == null || data!.data!.isEmpty;
  bool get isNotEmpty => !isEmpty;

  // Get applications by status
  List<LeaveApplication> get leaveApplications => data?.data ?? [];
  List<LeaveApplication> get pendingApplications =>
      data?.data?.where((e) => e.status?.toUpperCase() == 'LEAVE').toList() ?? [];
}

extension LeaveApplicationListExt on List<LeaveApplication> {
  // Filter by date
  List<LeaveApplication> get todayApplications {
    final today = DateTime.now();
    return where((e) {
      final date = DateTime.tryParse(e.attendanceDate ?? '');
      if (date == null) return false;
      return date.year == today.year && date.month == today.month && date.day == today.day;
    }).toList();
  }

  List<LeaveApplication> get thisWeekApplications {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return where((e) {
      final date = DateTime.tryParse(e.attendanceDate ?? '');
      if (date == null) return false;
      return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  List<LeaveApplication> get thisMonthApplications {
    final today = DateTime.now();
    return where((e) {
      final date = DateTime.tryParse(e.attendanceDate ?? '');
      if (date == null) return false;
      return date.year == today.year && date.month == today.month;
    }).toList();
  }

  List<LeaveApplication> get withRemarks => where((e) => e.hasRemarks).toList();
  List<LeaveApplication> get withoutRemarks => where((e) => !e.hasRemarks).toList();

  List<LeaveApplication> searchByStudentName(String query) {
    if (query.isEmpty) return this;
    final searchQuery = query.toLowerCase().trim();
    return where((e) =>
    e.studentName.toLowerCase().contains(searchQuery) ||
        e.studentRollNumber.contains(searchQuery) ||
        e.studentRegistrationNumber.toLowerCase().contains(searchQuery)
    ).toList();
  }

  List<LeaveApplication> sortedByDate() {
    final list = List<LeaveApplication>.from(this);
    list.sort((a, b) => (b.attendanceDate ?? '').compareTo(a.attendanceDate ?? ''));
    return list;
  }

  List<LeaveApplication> sortedByStudentName() {
    final list = List<LeaveApplication>.from(this);
    list.sort((a, b) => a.studentName.compareTo(b.studentName));
    return list;
  }

  List<LeaveApplication> filterByDate(String date) {
    if (date.isEmpty) return this;
    return where((e) => e.attendanceDate == date).toList();
  }

  // Group by date
  Map<String, List<LeaveApplication>> groupByDate() {
    final map = <String, List<LeaveApplication>>{};
    for (var item in this) {
      final date = item.attendanceDate ?? 'Unknown';
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(item);
    }
    return map;
  }
}