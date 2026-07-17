// lib/domain/models/teacher_classes_response.dart

import 'dart:convert';

TeacherClassesResponse teacherClassesResponseFromJson(String str) =>
    TeacherClassesResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String teacherClassesResponseToJson(TeacherClassesResponse data) =>
    json.encode(data.toJson());

class TeacherClassesResponse {
  final bool status;
  final String message;
  final TeacherClassesData? data;

  TeacherClassesResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TeacherClassesResponse.fromJson(Map<String, dynamic> json) {
    return TeacherClassesResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TeacherClassesData.fromJson(json['data'] as Map<String, dynamic>)
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
}

class TeacherClassesData {
  final int totalClasses;
  final List<ClassItem>? classes;

  TeacherClassesData({
    required this.totalClasses,
    this.classes,
  });

  factory TeacherClassesData.fromJson(Map<String, dynamic> json) {
    return TeacherClassesData(
      totalClasses: json['total_classes'] as int? ?? 0,
      classes: (json['classes'] as List<dynamic>?)
          ?.map((e) => ClassItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_classes': totalClasses,
      'classes': classes?.map((e) => e.toJson()).toList(),
    };
  }
}

class ClassItem {
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final int totalStudentCount;
  final List<Subject>? subjects;

  ClassItem({
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.totalStudentCount,
    this.subjects,
  });

  factory ClassItem.fromJson(Map<String, dynamic> json) {
    return ClassItem(
      classId: json['class_id'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      sectionName: json['section_name'] as String? ?? '',
      totalStudentCount: json['total_student_count'] as int? ?? 0,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_name': className,
      'section_id': sectionId,
      'section_name': sectionName,
      'total_student_count': totalStudentCount,
      'subjects': subjects?.map((e) => e.toJson()).toList(),
    };
  }

  // ✅ Helper method to get full class name with section
  String get fullClassName => '$className - $sectionName';

  // ✅ Helper method to check if class has students
  bool get hasStudents => totalStudentCount > 0;

  // ✅ Helper method to get subject count
  int get subjectCount => subjects?.length ?? 0;

  // ✅ Helper method to get subject names as comma separated string
  String get subjectNames => subjects?.map((e) => e.subjectName).join(', ') ?? '';
}

class Subject {
  final String subjectId;
  final String subjectName;
  final String? subjectCode;

  Subject({
    required this.subjectId,
    required this.subjectName,
    this.subjectCode,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectId: json['subject_id'] as String? ?? '',
      subjectName: json['subject_name'] as String? ?? '',
      subjectCode: json['subject_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'subject_code': subjectCode,
    };
  }
}