// lib/domain/models/examination_term_response.dart

import 'dart:convert';

ExaminationTermResponse examinationTermResponseFromJson(String str) =>
    ExaminationTermResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String examinationTermResponseToJson(ExaminationTermResponse data) =>
    json.encode(data.toJson());

class ExaminationTermResponse {
  final bool status;
  final String message;
  final List<ExaminationTerm> data;

  ExaminationTermResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExaminationTermResponse.fromJson(Map<String, dynamic> json) {
    return ExaminationTermResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExaminationTerm.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  // ========== HELPER METHODS ==========
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data.isNotEmpty;
  List<String> get termNames => data.map((e) => e.term).toList();
  List<String> get termIds => data.map((e) => e.id).toList();

  // Get terms with max attendance set
  List<ExaminationTerm> get termsWithMaxAttendance =>
      data.where((e) => e.maxAttendance != null).toList();
}

class ExaminationTerm {
  final String id;
  final String term;
  final int? maxAttendance;

  ExaminationTerm({
    required this.id,
    required this.term,
    this.maxAttendance,
  });

  factory ExaminationTerm.fromJson(Map<String, dynamic> json) {
    return ExaminationTerm(
      id: json['id'] as String? ?? '',
      term: json['term'] as String? ?? '',
      maxAttendance: json['max_attendance'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'max_attendance': maxAttendance,
    };
  }
}