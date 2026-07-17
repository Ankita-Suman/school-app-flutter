// lib/domain/models/attendance_report_response.dart

import 'dart:convert';

import 'package:flutter/material.dart';

AttendanceReportResponse attendanceReportResponseFromJson(String str) =>
    AttendanceReportResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String attendanceReportResponseToJson(AttendanceReportResponse data) =>
    json.encode(data.toJson());

class AttendanceReportResponse {
  final bool status;
  final String message;
  final AttendanceReportData? data;

  AttendanceReportResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? AttendanceReportData.fromJson(json['data'] as Map<String, dynamic>)
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
  bool get hasData => data != null;
}

class AttendanceReportData {
  final ReportInfo? reportInfo;
  final AttendanceSummary? attendanceSummary;
  final List<AttendanceStat>? attendanceStats;
  final List<TopDefaulter>? topDefaulters;

  AttendanceReportData({
    this.reportInfo,
    this.attendanceSummary,
    this.attendanceStats,
    this.topDefaulters,
  });

  factory AttendanceReportData.fromJson(Map<String, dynamic> json) {
    return AttendanceReportData(
      reportInfo: json['report_info'] != null
          ? ReportInfo.fromJson(json['report_info'] as Map<String, dynamic>)
          : null,
      attendanceSummary: json['attendance_summary'] != null
          ? AttendanceSummary.fromJson(json['attendance_summary'] as Map<String, dynamic>)
          : null,
      attendanceStats: (json['attendance_stats'] as List<dynamic>?)
          ?.map((e) => AttendanceStat.fromJson(e as Map<String, dynamic>))
          .toList(),
      topDefaulters: (json['top_defaulters'] as List<dynamic>?)
          ?.map((e) => TopDefaulter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_info': reportInfo?.toJson(),
      'attendance_summary': attendanceSummary?.toJson(),
      'attendance_stats': attendanceStats?.map((e) => e.toJson()).toList(),
      'top_defaulters': topDefaulters?.map((e) => e.toJson()).toList(),
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasReportInfo => reportInfo != null;
  bool get hasAttendanceSummary => attendanceSummary != null;
  bool get hasAttendanceStats => attendanceStats != null && attendanceStats!.isNotEmpty;
  bool get hasTopDefaulters => topDefaulters != null && topDefaulters!.isNotEmpty;

  String get className => reportInfo?.fullClassName ?? '';
  String get month => reportInfo?.month ?? '';
  int get totalStudents => attendanceSummary?.totalStudents ?? 0;
  int get overallPercentage => attendanceSummary?.overallAttendancePercentage ?? 0;
}

class ReportInfo {
  final String? month;
  final int? year;
  final int? monthNumber;
  final String? className;
  final String? sectionName;
  final String? fullClassName;

  ReportInfo({
    this.month,
    this.year,
    this.monthNumber,
    this.className,
    this.sectionName,
    this.fullClassName,
  });

  factory ReportInfo.fromJson(Map<String, dynamic> json) {
    return ReportInfo(
      month: json['month'] as String?,
      year: json['year'] as int?,
      monthNumber: json['month_number'] as int?,
      className: json['class_name'] as String?,
      sectionName: json['section_name'] as String?,
      fullClassName: json['full_class_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'month_number': monthNumber,
      'class_name': className,
      'section_name': sectionName,
      'full_class_name': fullClassName,
    };
  }
}

class AttendanceSummary {
  final int? totalStudents;
  final int? overallAttendancePercentage;
  final AttendanceCount? present;
  final AttendanceCount? absent;
  final AttendanceCount? leave;
  final AttendanceCount? late;
  final AttendanceCount? halfDay;

  AttendanceSummary({
    this.totalStudents,
    this.overallAttendancePercentage,
    this.present,
    this.absent,
    this.leave,
    this.late,
    this.halfDay,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalStudents: json['total_students'] as int?,
      overallAttendancePercentage: json['overall_attendance_percentage'] as int?,
      present: json['present'] != null
          ? AttendanceCount.fromJson(json['present'] as Map<String, dynamic>)
          : null,
      absent: json['absent'] != null
          ? AttendanceCount.fromJson(json['absent'] as Map<String, dynamic>)
          : null,
      leave: json['leave'] != null
          ? AttendanceCount.fromJson(json['leave'] as Map<String, dynamic>)
          : null,
      late: json['late'] != null
          ? AttendanceCount.fromJson(json['late'] as Map<String, dynamic>)
          : null,
      halfDay: json['half_day'] != null
          ? AttendanceCount.fromJson(json['half_day'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'overall_attendance_percentage': overallAttendancePercentage,
      'present': present?.toJson(),
      'absent': absent?.toJson(),
      'leave': leave?.toJson(),
      'late': late?.toJson(),
      'half_day': halfDay?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========
  List<AttendanceCount> get allStats => [
    if (present != null) present!,
    if (absent != null) absent!,
    if (late != null) late!,
    if (halfDay != null) halfDay!,
    if (leave != null) leave!,
  ];

  AttendanceCount? getStatByLabel(String label) {
    switch (label.toLowerCase()) {
      case 'present':
        return present;
      case 'absent':
        return absent;
      case 'late':
        return late;
      case 'half_day':
        return halfDay;
      case 'leave':
        return leave;
      default:
        return null;
    }
  }
}

class AttendanceCount {
  final int? count;
  final int? percentage;

  AttendanceCount({
    this.count,
    this.percentage,
  });

  factory AttendanceCount.fromJson(Map<String, dynamic> json) {
    return AttendanceCount(
      count: json['count'] as int?,
      percentage: json['percentage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'percentage': percentage,
    };
  }
}

class AttendanceStat {
  final String? id;
  final String? label;
  final int? count;
  final int? percentage;
  final String? color;
  final String? icon;

  AttendanceStat({
    this.id,
    this.label,
    this.count,
    this.percentage,
    this.color,
    this.icon,
  });

  factory AttendanceStat.fromJson(Map<String, dynamic> json) {
    return AttendanceStat(
      id: json['id'] as String?,
      label: json['label'] as String?,
      count: json['count'] as int?,
      percentage: json['percentage'] as int?,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'count': count,
      'percentage': percentage,
      'color': color,
      'icon': icon,
    };
  }

  // ========== HELPER METHODS ==========
  Color get colorValue {
    if (color == null) return Colors.grey;
    try {
      final hex = color!.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  String get iconAsset {
    switch (icon) {
      case 'ic_present':
        return 'assets/icons/ic_present.svg';
      case 'ic_absent':
        return 'assets/icons/ic_absent.svg';
      case 'ic_late':
        return 'assets/icons/ic_late.svg';
      case 'ic_half_day':
        return 'assets/icons/ic_half_day.svg';
      case 'ic_leave':
        return 'assets/icons/ic_leave.svg';
      default:
        return 'assets/icons/ic_default.svg';
    }
  }
}

class TopDefaulter {
  final String? studentId;
  final String? studentName;
  final String? rollNumber;
  final String? registrationNumber;
  final String? photo;
  final int? attendancePercentage;
  final int? presentDays;
  final int? totalDays;
  final int? absentDays;
  final String? initials;

  TopDefaulter({
    this.studentId,
    this.studentName,
    this.rollNumber,
    this.registrationNumber,
    this.photo,
    this.attendancePercentage,
    this.presentDays,
    this.totalDays,
    this.absentDays,
    this.initials,
  });

  factory TopDefaulter.fromJson(Map<String, dynamic> json) {
    return TopDefaulter(
      studentId: json['student_id'] as String?,
      studentName: json['student_name'] as String?,
      rollNumber: json['roll_number'] as String?,
      registrationNumber: json['registration_number'] as String?,
      photo: json['photo'] as String?,
      attendancePercentage: json['attendance_percentage'] as int?,
      presentDays: json['present_days'] as int?,
      totalDays: json['total_days'] as int?,
      absentDays: json['absent_days'] as int?,
      initials: json['initials'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'roll_number': rollNumber,
      'registration_number': registrationNumber,
      'photo': photo,
      'attendance_percentage': attendancePercentage,
      'present_days': presentDays,
      'total_days': totalDays,
      'absent_days': absentDays,
      'initials': initials,
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasPhoto => photo != null && photo!.isNotEmpty;

  String get attendanceStatus {
    final percentage = attendancePercentage ?? 0;
    if (percentage >= 75) return 'Good';
    if (percentage >= 50) return 'Average';
    if (percentage >= 25) return 'Poor';
    return 'Critical';
  }

  Color get statusColor {
    final percentage = attendancePercentage ?? 0;
    if (percentage >= 75) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    if (percentage >= 25) return Colors.red.shade300;
    return Colors.red;
  }

  String get displayName => studentName ?? 'Unknown';
  String get displayRoll => 'Roll: ${rollNumber ?? 'N/A'}';
  String get displayReg => 'Reg: ${registrationNumber ?? 'N/A'}';
  String get displayPercentage => '${attendancePercentage ?? 0}%';
  String get displayPresentDays => '${presentDays ?? 0}/${totalDays ?? 0} days';
}

// ========== EXTENSION METHODS ==========

extension AttendanceReportResponseExt on AttendanceReportResponse {
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null;
}

extension AttendanceReportDataExt on AttendanceReportData {
  bool get hasReportInfo => reportInfo != null;
  bool get hasAttendanceSummary => attendanceSummary != null;
  bool get hasAttendanceStats => attendanceStats != null && attendanceStats!.isNotEmpty;
  bool get hasTopDefaulters => topDefaulters != null && topDefaulters!.isNotEmpty;

  String get className => reportInfo?.fullClassName ?? '';
  String get month => reportInfo?.month ?? '';
  int get totalStudents => attendanceSummary?.totalStudents ?? 0;
  int get overallPercentage => attendanceSummary?.overallAttendancePercentage ?? 0;
}

extension TopDefaulterListExt on List<TopDefaulter> {
  List<TopDefaulter> get sortedByAttendance {
    final list = List<TopDefaulter>.from(this);
    list.sort((a, b) => (a.attendancePercentage ?? 0).compareTo(b.attendancePercentage ?? 0));
    return list;
  }

  List<TopDefaulter> get sortedByRollNumber {
    final list = List<TopDefaulter>.from(this);
    list.sort((a, b) => (a.rollNumber ?? '').compareTo(b.rollNumber ?? ''));
    return list;
  }

  List<TopDefaulter> searchByName(String query) {
    if (query.isEmpty) return this;
    final searchQuery = query.toLowerCase().trim();
    return where((e) =>
    (e.studentName ?? '').toLowerCase().contains(searchQuery) ||
        (e.rollNumber ?? '').contains(searchQuery) ||
        (e.registrationNumber ?? '').toLowerCase().contains(searchQuery)
    ).toList();
  }

  List<TopDefaulter> filterByAttendanceRange(int min, int max) {
    return where((e) {
      final percentage = e.attendancePercentage ?? 0;
      return percentage >= min && percentage <= max;
    }).toList();
  }

  List<TopDefaulter> get criticalDefaulters =>
      where((e) => (e.attendancePercentage ?? 0) < 25).toList();

  List<TopDefaulter> get poorDefaulters =>
      where((e) => (e.attendancePercentage ?? 0) >= 25 && (e.attendancePercentage ?? 0) < 50).toList();

  List<TopDefaulter> get averageDefaulters =>
      where((e) => (e.attendancePercentage ?? 0) >= 50 && (e.attendancePercentage ?? 0) < 75).toList();

  List<TopDefaulter> get goodDefaulters =>
      where((e) => (e.attendancePercentage ?? 0) >= 75).toList();
}