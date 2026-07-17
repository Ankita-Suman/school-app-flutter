import 'dart:convert';

TermClassResponse termClassResponseFromJson(String str) => TermClassResponse.fromJson(json.decode(str));
String termClassResponseToJson(TermClassResponse data) => json.encode(data.toJson());

class TermClassResponse {
  final bool status;
  final String message;
  final List<SimpleClass> data;

  TermClassResponse({required this.status, required this.message, required this.data});

  factory TermClassResponse.fromJson(Map<String, dynamic> json) {
    return TermClassResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)?.map((e) => SimpleClass.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class SimpleClass {
  final String id;
  final String name;

  SimpleClass({required this.id, required this.name});

  factory SimpleClass.fromJson(Map<String, dynamic> json) {
    return SimpleClass(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}