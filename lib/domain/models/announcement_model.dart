import 'dart:convert';

class AnnouncementResponse {
  final bool status;
  final String message;
  final List<Announcement> data;

  AnnouncementResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Announcement.fromJson(e as Map<String, dynamic>))
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
}

class Announcement {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime announcementDate;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.announcementDate,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      announcementDate: json['announcement_date'] != null
          ? DateTime.parse(json['announcement_date'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'announcement_date': announcementDate.toIso8601String(),
    };
  }
}
AnnouncementResponse announcementResponseFromJson(String str) =>
    AnnouncementResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String announcementToJson(AnnouncementResponse data) => json.encode(data.toJson());