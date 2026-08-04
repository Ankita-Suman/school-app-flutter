import 'dart:convert';

SubjectResponse subjectResponseFromJson(String str) =>
    SubjectResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String subjectResponseToJson(SubjectResponse data) =>
    json.encode(data.toJson());

class SubjectResponse {
  final bool status;
  final String message;
  final List<Subjects> data; // direct list of subjects

  SubjectResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SubjectResponse.fromJson(Map<String, dynamic> json) {
    return SubjectResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Subjects.fromJson(e as Map<String, dynamic>))
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

  // ========== HELPERS ==========
  bool get isSuccess => status == true;
  bool get hasData => data.isNotEmpty;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}

class Subjects {
  final String id;
  final String name;

  Subjects({
    required this.id,
    required this.name,
  });

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
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