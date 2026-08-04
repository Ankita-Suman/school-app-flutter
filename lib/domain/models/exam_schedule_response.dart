import 'dart:convert';

ExamScheduleResponse examScheduleResponseFromJson(String str) =>
    ExamScheduleResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String examScheduleResponseToJson(ExamScheduleResponse data) =>
    json.encode(data.toJson());

// ========================== ROOT ==========================
class ExamScheduleResponse {
  final bool status;
  final String message;
  final ExamScheduleData? data;

  ExamScheduleResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ExamScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ExamScheduleResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ExamScheduleData.fromJson(json['data'] as Map<String, dynamic>)
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
class ExamScheduleData {
  final ExamType examType;
  final ExamTerm term;
  final ExamClass classData;
  final ExamSection? section; // can be null
  final List<ExamScheduleItem> schedule;

  ExamScheduleData({
    required this.examType,
    required this.term,
    required this.classData,
    this.section,
    required this.schedule,
  });

  factory ExamScheduleData.fromJson(Map<String, dynamic> json) {
    return ExamScheduleData(
      examType: ExamType.fromJson(json['exam_type'] as Map<String, dynamic>),
      term: ExamTerm.fromJson(json['term'] as Map<String, dynamic>),
      classData: ExamClass.fromJson(json['class'] as Map<String, dynamic>),
      section: json['section'] != null
          ? ExamSection.fromJson(json['section'] as Map<String, dynamic>)
          : null,
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => ExamScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_type': examType.toJson(),
      'term': term.toJson(),
      'class': classData.toJson(),
      'section': section?.toJson(),
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }
}

// ========================== EXAM TYPE ==========================
class ExamType {
  final String id;
  final String groupName;

  ExamType({
    required this.id,
    required this.groupName,
  });

  factory ExamType.fromJson(Map<String, dynamic> json) {
    return ExamType(
      id: json['id'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
    };
  }
}

// ========================== EXAM TERM ==========================
class ExamTerm {
  final String id;
  final String term;

  ExamTerm({
    required this.id,
    required this.term,
  });

  factory ExamTerm.fromJson(Map<String, dynamic> json) {
    return ExamTerm(
      id: json['id'] as String? ?? '',
      term: json['term'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
    };
  }
}

// ========================== CLASS ==========================
class ExamClass {
  final String id;
  final String name;

  ExamClass({
    required this.id,
    required this.name,
  });

  factory ExamClass.fromJson(Map<String, dynamic> json) {
    return ExamClass(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ========================== SECTION ==========================
class ExamSection {
  final String id;
  final String name;

  ExamSection({
    required this.id,
    required this.name,
  });

  factory ExamSection.fromJson(Map<String, dynamic> json) {
    return ExamSection(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ========================== SCHEDULE ITEM ==========================
class ExamScheduleItem {
  final String subjectId;
  final String subjectName;
  final String divisionTitle;
  final bool hasPractical;
  final String? examDate;
  final String? dayName;
  final String? startTime;
  final String? endTime;
  final String? practicalExamDate;
  final String? practicalStartTime;
  final String? practicalEndTime;

  ExamScheduleItem({
    required this.subjectId,
    required this.subjectName,
    required this.divisionTitle,
    required this.hasPractical,
    this.examDate,
    this.dayName,
    this.startTime,
    this.endTime,
    this.practicalExamDate,
    this.practicalStartTime,
    this.practicalEndTime,
  });

  factory ExamScheduleItem.fromJson(Map<String, dynamic> json) {
    return ExamScheduleItem(
      subjectId: json['subject_id'] as String? ?? '',
      subjectName: json['subject_name'] as String? ?? '',
      divisionTitle: json['division_title'] as String? ?? '',
      hasPractical: json['has_practical'] as bool? ?? false,
      examDate: json['exam_date'] as String?,
      dayName: json['day_name'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      practicalExamDate: json['practical_exam_date'] as String?,
      practicalStartTime: json['practical_start_time'] as String?,
      practicalEndTime: json['practical_end_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'subject_name': subjectName,
      'division_title': divisionTitle,
      'has_practical': hasPractical,
      'exam_date': examDate,
      'day_name': dayName,
      'start_time': startTime,
      'end_time': endTime,
      'practical_exam_date': practicalExamDate,
      'practical_start_time': practicalStartTime,
      'practical_end_time': practicalEndTime,
    };
  }
}