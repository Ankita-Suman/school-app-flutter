import 'dart:convert';

ExternalMarksResponse externalMarksResponseFromJson(String str) =>
    ExternalMarksResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String externalMarksResponseToJson(ExternalMarksResponse data) =>
    json.encode(data.toJson());

// ========================== ROOT ==========================
class ExternalMarksResponse {
  final bool status;
  final String message;
  final ExternalMarksData? data;

  ExternalMarksResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ExternalMarksResponse.fromJson(Map<String, dynamic> json) {
    return ExternalMarksResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ExternalMarksData.fromJson(json['data'] as Map<String, dynamic>)
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
  bool get hasData => data != null;
}

// ========================== DATA ==========================
class ExternalMarksData {
  final ExamTypes examType;
  final SubjectInfo subject;
  final ClassInfos classInfo;
  final SectionInfo section;
  final TermInfo term;
  final bool hasTheory;
  final bool hasPractical;
  final int? theoryMaxMarks;
  final int? practicalMaxMarks;
  final int? maxMarks;
  final int? passMarks;
  final int totalStudents;
  final List<StudentMark> students;

  ExternalMarksData({
    required this.examType,
    required this.subject,
    required this.classInfo,
    required this.section,
    required this.term,
    required this.hasTheory,
    required this.hasPractical,
    this.theoryMaxMarks,
    this.practicalMaxMarks,
    this.maxMarks,
    this.passMarks,
    required this.totalStudents,
    required this.students,
  });

  factory ExternalMarksData.fromJson(Map<String, dynamic> json) {
    return ExternalMarksData(
      examType: ExamTypes.fromJson(json['exam_type'] as Map<String, dynamic>),
      subject: SubjectInfo.fromJson(json['subject'] as Map<String, dynamic>),
      classInfo: ClassInfos.fromJson(json['class'] as Map<String, dynamic>),
      section: SectionInfo.fromJson(json['section'] as Map<String, dynamic>),
      term: TermInfo.fromJson(json['term'] as Map<String, dynamic>),
      hasTheory: json['has_theory'] as bool? ?? false,
      hasPractical: json['has_practical'] as bool? ?? false,
      theoryMaxMarks: json['theory_max_marks'] as int?,
      practicalMaxMarks: json['practical_max_marks'] as int?,
      maxMarks: json['max_marks'] as int?,
      passMarks: json['pass_marks'] as int?,
      totalStudents: json['total_students'] as int? ?? 0,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => StudentMark.fromJson(e as Map<String, dynamic>))
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
      'has_theory': hasTheory,
      'has_practical': hasPractical,
      'theory_max_marks': theoryMaxMarks,
      'practical_max_marks': practicalMaxMarks,
      'max_marks': maxMarks,
      'pass_marks': passMarks,
      'total_students': totalStudents,
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}

// ========================== EXAM TYPE ==========================
class ExamTypes {
  final String id;
  final String groupName;

  ExamTypes({required this.id, required this.groupName});

  factory ExamTypes.fromJson(Map<String, dynamic> json) {
    return ExamTypes(
      id: json['id'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'group_name': groupName};
  }
}

// ========================== SUBJECT INFO ==========================
class SubjectInfo {
  final String id;
  final String name;

  SubjectInfo({required this.id, required this.name});

  factory SubjectInfo.fromJson(Map<String, dynamic> json) {
    return SubjectInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== CLASS INFO ==========================
class ClassInfos {
  final String id;
  final String name;

  ClassInfos({required this.id, required this.name});

  factory ClassInfos.fromJson(Map<String, dynamic> json) {
    return ClassInfos(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== SECTION INFO ==========================
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

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

// ========================== TERM INFO ==========================
class TermInfo {
  final String id;
  final String term;
  final String? internalCustomName;
  final String? externalCustomName;

  TermInfo({
    required this.id,
    required this.term,
    this.internalCustomName,
    this.externalCustomName,
  });

  factory TermInfo.fromJson(Map<String, dynamic> json) {
    return TermInfo(
      id: json['id'] as String? ?? '',
      term: json['term'] as String? ?? '',
      internalCustomName: json['internal_custom_name'] as String?,
      externalCustomName: json['external_custom_name'] as String?,
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
class StudentMark {
  final String id;
  final String fullName;
  final String? photo;
  final String registrationNumber;
  final String admissionNumber;
  final String rollNumber;
  final Parent? parent;
  final bool isStudentAbsent;
  final int? theoryObtained;
  final int? practicalObtained;

  StudentMark({
    required this.id,
    required this.fullName,
    this.photo,
    required this.registrationNumber,
    required this.admissionNumber,
    required this.rollNumber,
    this.parent,
    required this.isStudentAbsent,
    this.theoryObtained,
    this.practicalObtained,
  });

  factory StudentMark.fromJson(Map<String, dynamic> json) {
    return StudentMark(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
      registrationNumber: json['registration_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      parent: json['parent'] != null
          ? Parent.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      isStudentAbsent: json['is_student_absent'] as bool? ?? false,
      theoryObtained: json['theory_obtained'] as int?,
      practicalObtained: json['practical_obtained'] as int?,
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
      'theory_obtained': theoryObtained,
      'practical_obtained': practicalObtained,
    };
  }
}

// ========================== PARENT ==========================
class Parent {
  final String fatherName;

  Parent({required this.fatherName});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      fatherName: json['father_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'father_name': fatherName};
  }
}