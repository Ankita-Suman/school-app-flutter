import 'dart:convert';

InternalMarksResponse internalMarksResponseFromJson(String str) =>
    InternalMarksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String internalMarksResponseToJson(InternalMarksResponse data) =>
    json.encode(data.toJson());

// ========================== ROOT ==========================
class InternalMarksResponse {
  final bool status;
  final String message;
  final InternalMarksData? data;

  InternalMarksResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory InternalMarksResponse.fromJson(Map<String, dynamic> json) {
    return InternalMarksResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? InternalMarksData.fromJson(json['data'] as Map<String, dynamic>)
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

  // ========== Helpers ==========
  bool get isSuccess => status == true;
  bool get hasData => data != null;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}

// ========================== DATA ==========================
class InternalMarksData {
  final ExamTypee examType;
  final SubjectInfe subject;
  final ClassInfe classInfo;
  final SectionInfe section;
  final TermInfe term;
  final int internalCount;
  final List<String> internalLabels;
  final List<int?> maxMarks; // nullable integers
  final int totalStudents;
  final List<InternalStudentMark> students;

  InternalMarksData({
    required this.examType,
    required this.subject,
    required this.classInfo,
    required this.section,
    required this.term,
    required this.internalCount,
    required this.internalLabels,
    required this.maxMarks,
    required this.totalStudents,
    required this.students,
  });

  factory InternalMarksData.fromJson(Map<String, dynamic> json) {
    return InternalMarksData(
      examType: ExamTypee.fromJson(json['exam_type'] as Map<String, dynamic>),
      subject: SubjectInfe.fromJson(json['subject'] as Map<String, dynamic>),
      classInfo: ClassInfe.fromJson(json['class'] as Map<String, dynamic>),
      section: SectionInfe.fromJson(json['section'] as Map<String, dynamic>),
      term: TermInfe.fromJson(json['term'] as Map<String, dynamic>),
      internalCount: json['internal_count'] as int? ?? 0,
      internalLabels: (json['internal_labels'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      maxMarks: (json['max_marks'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList() ??
          [],
      totalStudents: json['total_students'] as int? ?? 0,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => InternalStudentMark.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_type': examType.toJson(),
      'subject': subject.toJson(),
      'class': classInfo.toJson(),
      'section': section.toJson(),
      'term': term.toJson(),
      'internal_count': internalCount,
      'internal_labels': internalLabels,
      'max_marks': maxMarks,
      'total_students': totalStudents,
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}

// ========================== EXAM TYPE ==========================
class ExamTypee {
  final String id;
  final String groupName;

  ExamTypee({required this.id, required this.groupName});

  factory ExamTypee.fromJson(Map<String, dynamic> json) {
    return ExamTypee(
      id: json['id'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'group_name': groupName};
  }
}

// ========================== SUBJECT INFO ==========================
class SubjectInfe {
  final String id;
  final String name;

  SubjectInfe({required this.id, required this.name});

  factory SubjectInfe.fromJson(Map<String, dynamic> json) {
    return SubjectInfe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== CLASS INFO ==========================
class ClassInfe {
  final String id;
  final String name;

  ClassInfe({required this.id, required this.name});

  factory ClassInfe.fromJson(Map<String, dynamic> json) {
    return ClassInfe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== SECTION INFO ==========================
class SectionInfe {
  final String id;
  final String name;

  SectionInfe({required this.id, required this.name});

  factory SectionInfe.fromJson(Map<String, dynamic> json) {
    return SectionInfe(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== TERM INFO ==========================
class TermInfe {
  final String id;
  final String term;
  final String internalCustomName;
  final String externalCustomName;

  TermInfe({
    required this.id,
    required this.term,
    required this.internalCustomName,
    required this.externalCustomName,
  });

  factory TermInfe.fromJson(Map<String, dynamic> json) {
    return TermInfe(
      id: json['id'] as String? ?? '',
      term: json['term'] as String? ?? '',
      internalCustomName: json['internal_custom_name'] as String? ?? '',
      externalCustomName: json['external_custom_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'internal_custom_name': internalCustomName,
      'external_custom_name': externalCustomName,
    };
  }
}

// ========================== STUDENT MARK ==========================
class InternalStudentMark {
  final String id;
  final String fullName;
  final String? photo;
  final String registrationNumber;
  final String admissionNumber;
  final String rollNumber;
  final Parents? parent; // can be null
  final bool isStudentAbsent;
  final List<int> internalMarks; // list of integers

  InternalStudentMark({
    required this.id,
    required this.fullName,
    this.photo,
    required this.registrationNumber,
    required this.admissionNumber,
    required this.rollNumber,
    this.parent,
    required this.isStudentAbsent,
    required this.internalMarks,
  });

  factory InternalStudentMark.fromJson(Map<String, dynamic> json) {
    return InternalStudentMark(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      parent: json['parent'] != null
          ? Parents.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      isStudentAbsent: json['is_student_absent'] as bool? ?? false,
      internalMarks: (json['internal_marks'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'photo': photo,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'parent': parent?.toJson(),
      'is_student_absent': isStudentAbsent,
      'internal_marks': internalMarks,
    };
  }
}

// ========================== PARENT ==========================
class Parents {
  final String fatherName;

  Parents({required this.fatherName});

  factory Parents.fromJson(Map<String, dynamic> json) {
    return Parents(
      fatherName: json['father_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'father_name': fatherName};
  }
}