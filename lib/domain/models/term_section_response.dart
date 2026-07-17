// lib/domain/models/simple_section_response.dart

import 'dart:convert';

TermSectionResponse termSectionResponseFromJson(String str) =>
    TermSectionResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String termSectionResponseToJson(TermSectionResponse data) =>
    json.encode(data.toJson());

class TermSectionResponse {
  final bool status;
  final String message;
  final List<SimpleSection> data;

  TermSectionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TermSectionResponse.fromJson(Map<String, dynamic> json) {
    return TermSectionResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SimpleSection.fromJson(e as Map<String, dynamic>))
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
  List<String> get sectionNames => data.map((e) => e.name).toList();
  List<String> get sectionIds => data.map((e) => e.id).toList();
}

class SimpleSection {
  final String id;
  final String name;

  SimpleSection({
    required this.id,
    required this.name,
  });

  factory SimpleSection.fromJson(Map<String, dynamic> json) {
    return SimpleSection(
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