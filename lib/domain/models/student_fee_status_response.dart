import 'dart:convert';

StudentFeeStatusResponse studentFeeStatusResponseFromJson(String str) =>
    StudentFeeStatusResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String studentFeeStatusResponseToJson(StudentFeeStatusResponse data) =>
    json.encode(data.toJson());

// ========================== ROOT ==========================
class StudentFeeStatusResponse {
  final bool status;
  final String message;
  final StudentFeeStatusData? data;

  StudentFeeStatusResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory StudentFeeStatusResponse.fromJson(Map<String, dynamic> json) {
    return StudentFeeStatusResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? StudentFeeStatusData.fromJson(json['data'] as Map<String, dynamic>)
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
class StudentFeeStatusData {
  final String? classId;
  final String? sectionId;
  final String? sessionId;
  final StudentFeeSummary summary;
  final List<StudentFeeStudent> students;

  StudentFeeStatusData({
    this.classId,
    this.sectionId,
    this.sessionId,
    required this.summary,
    required this.students,
  });

  factory StudentFeeStatusData.fromJson(Map<String, dynamic> json) {
    return StudentFeeStatusData(
      classId: json['class_id'] as String?,
      sectionId: json['section_id'] as String?,
      sessionId: json['session_id'] as String?,
      summary: StudentFeeSummary.fromJson(json['summary'] as Map<String, dynamic>),
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => StudentFeeStudent.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'section_id': sectionId,
      'session_id': sessionId,
      'summary': summary.toJson(),
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}

// ========================== SUMMARY ==========================
class StudentFeeSummary {
  final int total;
  final int paid;
  final int pending;
  final int partial;
  final int month;
  final int year;
  final String monthName;
  final String label;

  StudentFeeSummary({
    required this.total,
    required this.paid,
    required this.pending,
    required this.partial,
    required this.month,
    required this.year,
    required this.monthName,
    required this.label,
  });

  factory StudentFeeSummary.fromJson(Map<String, dynamic> json) {
    return StudentFeeSummary(
      total: json['total'] as int? ?? 0,
      paid: json['paid'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      partial: json['partial'] as int? ?? 0,
      month: json['month'] as int? ?? 0,
      year: json['year'] as int? ?? 0,
      monthName: json['month_name'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'paid': paid,
      'pending': pending,
      'partial': partial,
      'month': month,
      'year': year,
      'month_name': monthName,
      'label': label,
    };
  }
}

// ========================== STUDENT ==========================
class StudentFeeStudent {
  final String id;
  final String fullName;
  final String rollNumber;
  final String admissionNumber;
  final String? photo;
  final String classId;
  final String className;
  final String sectionId;
  final String sectionName;
  final String status; // e.g. "PENDING", "PAID", "PARTIAL"
  final int netAmount;
  final int paidAmount;
  final int pendingAmount;

  StudentFeeStudent({
    required this.id,
    required this.fullName,
    required this.rollNumber,
    required this.admissionNumber,
    this.photo,
    required this.classId,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.status,
    required this.netAmount,
    required this.paidAmount,
    required this.pendingAmount,
  });

  factory StudentFeeStudent.fromJson(Map<String, dynamic> json) {
    return StudentFeeStudent(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      rollNumber: json['roll_number'] as String? ?? '',
      admissionNumber: json['admission_number'] as String? ?? '',
      photo: json['photo'] as String?,
      classId: json['class_id'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      sectionId: json['section_id'] as String? ?? '',
      sectionName: json['section_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      netAmount: json['net_amount'] as int? ?? 0,
      paidAmount: json['paid_amount'] as int? ?? 0,
      pendingAmount: json['pending_amount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'roll_number': rollNumber,
      'admission_number': admissionNumber,
      'photo': photo,
      'class_id': classId,
      'class_name': className,
      'section_id': sectionId,
      'section_name': sectionName,
      'status': status,
      'net_amount': netAmount,
      'paid_amount': paidAmount,
      'pending_amount': pendingAmount,
    };
  }
}