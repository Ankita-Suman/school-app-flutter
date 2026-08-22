// school_info_response.dart
import 'dart:convert';

SchoolInfoResponse schoolInfoResponseFromJson(String str) =>
    SchoolInfoResponse.fromJson(json.decode(str) as Map<String, dynamic>);

class SchoolInfoResponse {
  final bool status;
  final String message;
  final SchoolData? data;

  SchoolInfoResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory SchoolInfoResponse.fromJson(Map<String, dynamic> json) {
    return SchoolInfoResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SchoolData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class SchoolData {
  final String schoolName;
  final String branchName;
  final String? branchAddress;
  final Session? session;

  SchoolData({
    required this.schoolName,
    required this.branchName,
    this.branchAddress,
    this.session,
  });

  factory SchoolData.fromJson(Map<String, dynamic> json) {
    return SchoolData(
      schoolName: json['school_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      branchAddress: json['branch_address'],
      session: json['session'] != null ? Session.fromJson(json['session']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'branch_name': branchName,
      'branch_address': branchAddress,
      'session': session?.toJson(),
    };
  }
}

class Session {
  final String id;
  final String session;
  final String startDate;
  final String endDate;

  Session({
    required this.id,
    required this.session,
    required this.startDate,
    required this.endDate,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      session: json['session'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session': session,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}