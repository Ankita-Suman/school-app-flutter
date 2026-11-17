// domain/models/co_curricular_marks_response.dart
import 'dart:convert';

// ============================================================
// ✅ ROOT RESPONSE
// ============================================================
class CoCurricularMarksResponse {
  final bool status;
  final String message;
  final CoCurricularMarksData? data;

  CoCurricularMarksResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CoCurricularMarksResponse.fromJson(Map<String, dynamic> json) {
    return CoCurricularMarksResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CoCurricularMarksData.fromJson(
          json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

// ============================================================
// ✅ DATA (term + activities + students)
// ============================================================
class CoCurricularMarksData {
  final CoCurricularTerm? term;
  final List<CoCurricularActivity> activities;
  final int totalStudents;
  final List<CoCurricularStudent> students;

  CoCurricularMarksData({
    this.term,
    required this.activities,
    required this.totalStudents,
    required this.students,
  });

  factory CoCurricularMarksData.fromJson(Map<String, dynamic> json) {
    return CoCurricularMarksData(
      term: json['term'] != null
          ? CoCurricularTerm.fromJson(json['term'] as Map<String, dynamic>)
          : null,
      activities: (json['activities'] as List<dynamic>? ?? [])
          .map((e) => CoCurricularActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalStudents: json['total_students'] ?? 0,
      students: (json['students'] as List<dynamic>? ?? [])
          .map((e) => CoCurricularStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'term': term?.toJson(),
    'activities': activities.map((e) => e.toJson()).toList(),
    'total_students': totalStudents,
    'students': students.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// ✅ TERM (id + term name)
// ============================================================
class CoCurricularTerm {
  final String id;
  final String term;

  CoCurricularTerm({
    required this.id,
    required this.term,
  });

  factory CoCurricularTerm.fromJson(Map<String, dynamic> json) {
    return CoCurricularTerm(
      id: json['id']?.toString() ?? '',
      term: json['term']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'term': term,
  };
}

// ============================================================
// ✅ ACTIVITY (id + title + max_marks)
// ============================================================
class CoCurricularActivity {
  final String id;
  final String title;

  /// API gives as String "100.00" — parse to double
  final double maxMarks;

  CoCurricularActivity({
    required this.id,
    required this.title,
    required this.maxMarks,
  });

  factory CoCurricularActivity.fromJson(Map<String, dynamic> json) {
    return CoCurricularActivity(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      maxMarks: _toDouble(json['max_marks']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'max_marks': maxMarks.toStringAsFixed(2),
  };
}

// ============================================================
// ✅ STUDENT (with marks map keyed by activity id)
// ============================================================
class CoCurricularStudent {
  final String id;
  final String fullName;
  final String registrationNumber;
  final String admissionNumber;
  final String rollNumber;
  final StudentParent? parent;
  final bool isStudentAbsent;

  /// activityId → marks (0–100)
  final Map<String, double> marks;

  CoCurricularStudent({
    required this.id,
    required this.fullName,
    required this.registrationNumber,
    required this.admissionNumber,
    required this.rollNumber,
    this.parent,
    required this.isStudentAbsent,
    required this.marks,
  });

  factory CoCurricularStudent.fromJson(Map<String, dynamic> json) {
    // ✅ marks map: {activityId: number}
    final Map<String, double> parsedMarks = {};
    final rawMarks = json['marks'];
    if (rawMarks is Map) {
      rawMarks.forEach((key, value) {
        parsedMarks[key.toString()] = _toDouble(value);
      });
    }

    return CoCurricularStudent(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      registrationNumber: json['registration_number']?.toString() ?? '',
      admissionNumber: json['admission_number']?.toString() ?? '',
      rollNumber: json['roll_number']?.toString() ?? '',
      parent: json['parent'] != null
          ? StudentParent.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      isStudentAbsent: json['is_student_absent'] == true,
      marks: parsedMarks,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'registration_number': registrationNumber,
    'admission_number': admissionNumber,
    'roll_number': rollNumber,
    'parent': parent?.toJson(),
    'is_student_absent': isStudentAbsent,
    'marks': marks,
  };

  /// Convenience — specific activity का mark
  double marksFor(String activityId) => marks[activityId] ?? 0.0;
}

// ============================================================
// ✅ PARENT (father_name only)
// ============================================================
class StudentParent {
  final String fatherName;

  StudentParent({required this.fatherName});

  factory StudentParent.fromJson(Map<String, dynamic> json) {
    return StudentParent(
      fatherName: json['father_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'father_name': fatherName,
  };
}

// ============================================================
// ✅ Safe number parser (String / int / double — सब handle करेगा)
// ============================================================
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

// ============================================================
// ✅ Helper for full response save/load (LoginResponse जैसा pattern)
// ============================================================
String coCurricularMarksResponseToJson(CoCurricularMarksResponse response) {
  return jsonEncode(response.toJson());
}