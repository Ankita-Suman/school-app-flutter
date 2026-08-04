// lib/domain/models/examination_group_response.dart

import 'dart:convert';

ExaminationGroupResponse examinationGroupResponseFromJson(String str) =>
    ExaminationGroupResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String examinationGroupResponseToJson(ExaminationGroupResponse data) =>
    json.encode(data.toJson());

class ExaminationGroupResponse {
  final bool status;
  final String message;
  final List<ExaminationGroup> data;

  ExaminationGroupResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ExaminationGroupResponse.fromJson(Map<String, dynamic> json) {
    return ExaminationGroupResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExaminationGroup.fromJson(e as Map<String, dynamic>))
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
  List<String> get groupNames => data.map((e) => e.groupName).toList();
  List<String> get groupIds => data.map((e) => e.id).toList();
}

class ExaminationGroup {
  final String id;
  final String groupName;
  final String examPattern;        // new
  final bool hasInternal;          // new
  final int internalCount;         // new
  final List<String> internalLabels; // new

  ExaminationGroup({
    required this.id,
    required this.groupName,
    required this.examPattern,
    required this.hasInternal,
    required this.internalCount,
    required this.internalLabels,
  });

  factory ExaminationGroup.fromJson(Map<String, dynamic> json) {
    return ExaminationGroup(
      id: json['id'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
      examPattern: json['exam_pattern'] as String? ?? '',
      hasInternal: json['has_internal'] as bool? ?? false,
      internalCount: json['internal_count'] as int? ?? 0,
      internalLabels: (json['internal_labels'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'exam_pattern': examPattern,
      'has_internal': hasInternal,
      'internal_count': internalCount,
      'internal_labels': internalLabels,
    };
  }
}