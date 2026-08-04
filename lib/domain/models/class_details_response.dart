// lib/domain/models/class_details_response.dart

import 'dart:convert';

ClassDetailsResponse classDetailsResponseFromJson(String str) =>
    ClassDetailsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String classDetailsResponseToJson(ClassDetailsResponse data) =>
    json.encode(data.toJson());

class ClassDetailsResponse {
  final bool status;
  final String message;
  final ClassDetailsData? data;

  ClassDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ClassDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ClassDetailsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ClassDetailsData.fromJson(json['data'] as Map<String, dynamic>)
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
}

class ClassDetailsData {
  final ClassInfo? classInfo;
  final List<Timetable>? todayTimetable;
  final List<SubjectAllocation>? subjectAllocation;
  final ClassStrength? classStrength;

  ClassDetailsData({
    this.classInfo,
    this.todayTimetable,
    this.subjectAllocation,
    this.classStrength,
  });

  factory ClassDetailsData.fromJson(Map<String, dynamic> json) {
    return ClassDetailsData(
      classInfo: json['class_info'] != null
          ? ClassInfo.fromJson(json['class_info'] as Map<String, dynamic>)
          : null,
      todayTimetable: (json['today_timetable'] as List<dynamic>?)
          ?.map((e) => Timetable.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjectAllocation: (json['subject_allocation'] as List<dynamic>?)
          ?.map((e) => SubjectAllocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      classStrength: json['class_strength'] != null
          ? ClassStrength.fromJson(json['class_strength'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_info': classInfo?.toJson(),
      'today_timetable': todayTimetable?.map((e) => e.toJson()).toList(),
      'subject_allocation': subjectAllocation?.map((e) => e.toJson()).toList(),
      'class_strength': classStrength?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========

  String get fullClassName =>
      '${classInfo?.className ?? ''} - ${classInfo?.sectionName ?? ''}';

  int get totalStudents => classStrength?.totalStudents ?? 0;
  int get boysCount => classStrength?.boys ?? 0;
  int get girlsCount => classStrength?.girls ?? 0;
  int get presentCount => classStrength?.present ?? 0;
  int get absentCount => classStrength?.absent ?? 0;

  int get subjectCount => subjectAllocation?.length ?? 0;

  List<String> get subjectNames =>
      subjectAllocation?.map((s) => s.subject).toList() ?? [];

  bool get hasSubjects => subjectAllocation != null && subjectAllocation!.isNotEmpty;
  bool get hasTimetable => todayTimetable != null && todayTimetable!.isNotEmpty;
}

class ClassInfo {
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final String fullName;
  final String? roomNumber;
  final String? classTeacher;

  ClassInfo({
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.fullName,
    this.roomNumber,
    this.classTeacher,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classId: json['class_id'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      sectionName: json['section_name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      roomNumber: json['room_number'] as String?,
      classTeacher: json['class_teacher'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'section_id': sectionId,
      'section_name': sectionName,
      'full_name': fullName,
      'room_number': roomNumber,
      'class_teacher': classTeacher,
    };
  }

  // ========== HELPER METHODS ==========

  bool get hasRoomNumber => roomNumber != null && roomNumber!.isNotEmpty;
  bool get hasClassTeacher => classTeacher != null && classTeacher!.isNotEmpty;
}

class Timetable {
  // Add fields as per timetable API response
  // Currently empty array in response, so keeping it flexible

  Timetable();

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class SubjectAllocation {
  final String id;
  final String subject;
  final String? subjectCode;
  final String teacherName;
  final String teacherId;
  final bool isClassTeacher;
  final String? room;

  SubjectAllocation({
    required this.id,
    required this.subject,
    this.subjectCode,
    required this.teacherName,
    required this.teacherId,
    required this.isClassTeacher,
    this.room,
  });

  factory SubjectAllocation.fromJson(Map<String, dynamic> json) {
    return SubjectAllocation(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      subjectCode: json['subject_code'] as String?,
      teacherName: json['teacher_name'] as String? ?? '',
      teacherId: json['teacher_id'] as String? ?? '',
      isClassTeacher: json['is_class_teacher'] as bool? ?? false,
      room: json['room'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'subject_code': subjectCode,
      'teacher_name': teacherName,
      'teacher_id': teacherId,
      'is_class_teacher': isClassTeacher,
      'room': room,
    };
  }

  // ========== HELPER METHODS ==========

  String get displayName => subjectCode != null && subjectCode!.isNotEmpty
      ? '$subject ($subjectCode)'
      : subject;

  bool get hasRoom => room != null && room!.isNotEmpty;
}

class ClassStrength {
  final int totalStudents;
  final int boys;
  final int girls;
  final int present;
  final int absent;

  ClassStrength({
    required this.totalStudents,
    required this.boys,
    required this.girls,
    required this.present,
    required this.absent,
  });

  factory ClassStrength.fromJson(Map<String, dynamic> json) {
    return ClassStrength(
      totalStudents: json['total_students'] as int? ?? 0,
      boys: json['boys'] as int? ?? 0,
      girls: json['girls'] as int? ?? 0,
      present: json['present'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'boys': boys,
      'girls': girls,
      'present': present,
      'absent': absent,
    };
  }

  // ========== HELPER METHODS ==========

  int get markedCount => present + absent;
  int get unmarkedCount => totalStudents - markedCount;
  double get attendancePercentage => totalStudents > 0
      ? (present / totalStudents) * 100
      : 0.0;

  bool get hasData => totalStudents > 0;

  String get genderRatio => boys > 0 && girls > 0
      ? '${boys}B : ${girls}G'
      : boys > 0
      ? '$boys Boys'
      : girls > 0
      ? '$girls Girls'
      : 'No students';
}

// ========== EXTENSION METHODS ==========

extension ClassDetailsListExt on List<SubjectAllocation> {
  List<SubjectAllocation> get classTeacherSubjects =>
      where((item) => item.isClassTeacher).toList();

  List<SubjectAllocation> get nonClassTeacherSubjects =>
      where((item) => !item.isClassTeacher).toList();

  List<String> get subjectNames => map((item) => item.subject).toList();
}