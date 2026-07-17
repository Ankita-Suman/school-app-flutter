// lib/domain/models/students_response.dart

import 'dart:convert';

StudentsResponse studentsResponseFromJson(String str) =>
    StudentsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String studentsResponseToJson(StudentsResponse data) =>
    json.encode(data.toJson());

class StudentsResponse {
  final bool status;
  final String message;
  final StudentListData? data;

  StudentsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    return StudentsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? StudentListData.fromJson(json['data'] as Map<String, dynamic>)
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
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null;
}

/// NOTE: Backend response shape is:
/// "data": { "data": [ {...student...}, {...student...} ] }
/// i.e. the actual student list is nested inside a "data" key
/// (not "students"), and there is no top-level class_info or
/// total_student_count field in the payload.
class StudentListData {
  final List<StudentInfi>? students;

  StudentListData({
    this.students,
  });

  factory StudentListData.fromJson(Map<String, dynamic> json) {
    return StudentListData(
      students: (json['data'] as List<dynamic>?)
          ?.map((e) => StudentInfi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': students?.map((e) => e.toJson()).toList(),
    };
  }

  // ========== HELPER METHODS ==========

  bool get hasStudents => students != null && students!.isNotEmpty;

  int get studentCount => students?.length ?? 0;

  // total_student_count backend se nahi aata, isliye list length use karein
  int get totalStudentCount => students?.length ?? 0;

  List<StudentInfi> sortedByRollNumber() {
    final list = List<StudentInfi>.from(students ?? []);
    list.sort((a, b) => a.rollNumber.compareTo(b.rollNumber));
    return list;
  }

  List<StudentInfi> searchByName(String query) {
    if (query.isEmpty) return students ?? [];
    final searchQuery = query.toLowerCase().trim();
    return students?.where((s) =>
    s.studentName.toLowerCase().contains(searchQuery) ||
        s.admissionNumber.toLowerCase().contains(searchQuery) ||
        s.rollNumber.contains(searchQuery)
    ).toList() ?? [];
  }
}

class ClassInfoShort {
  final String id;
  final String name;

  ClassInfoShort({required this.id, required this.name});

  factory ClassInfoShort.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ClassInfoShort(id: '', name: '');
    return ClassInfoShort(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ParentInfo {
  final String name;
  final String contact;

  ParentInfo({required this.name, required this.contact});

  factory ParentInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ParentInfo(name: '', contact: '');
    return ParentInfo(
      name: json['name'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'contact': contact};
}

class StudentInfi {
  final String studentId;
  final String admissionNumber;
  final String rollNumber;
  final String studentName;
  final String? photo;
  final ClassInfoShort classInfo;
  final ClassInfoShort sectionInfo;
  final ParentInfo parent;

  StudentInfi({
    required this.studentId,
    required this.admissionNumber,
    required this.rollNumber,
    required this.studentName,
    this.photo,
    required this.classInfo,
    required this.sectionInfo,
    required this.parent,
  });

  factory StudentInfi.fromJson(Map<String, dynamic> json) {
    return StudentInfi(
      studentId: json['id'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      studentName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
      classInfo: ClassInfoShort.fromJson(json['class'] as Map<String, dynamic>?),
      sectionInfo: ClassInfoShort.fromJson(json['section'] as Map<String, dynamic>?),
      parent: ParentInfo.fromJson(json['parent'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': studentId,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'full_name': studentName,
      'photo': photo,
      'class': classInfo.toJson(),
      'section': sectionInfo.toJson(),
      'parent': parent.toJson(),
    };
  }

  // ========== HELPER METHODS ==========

  bool get hasPhoto => photo != null && photo!.isNotEmpty;

  String get initials {
    final parts = studentName.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String get displayName => studentName.isNotEmpty ? studentName : 'Student';

  String get className => classInfo.name;
  String get sectionName => sectionInfo.name;
  String get fullClassName => '${classInfo.name} - ${sectionInfo.name}';
}