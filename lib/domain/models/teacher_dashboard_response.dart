// lib/domain/models/teacher_dashboard_response.dart

import 'dart:convert';

TeacherDashboardResponse teacherDashboardResponseFromJson(String str) =>
    TeacherDashboardResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String teacherDashboardResponseToJson(TeacherDashboardResponse data) =>
    json.encode(data.toJson());

class TeacherDashboardResponse {
  final bool status;
  final String message;
  final TeacherDashboardData? data;

  TeacherDashboardResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TeacherDashboardResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TeacherDashboardData.fromJson(json['data'] as Map<String, dynamic>)
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
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null;
}

class TeacherDashboardData {
  final TeacherInfo? teacher;
  final List<DashboardCard>? dashboardCards;

  TeacherDashboardData({
    this.teacher,
    this.dashboardCards,
  });

  factory TeacherDashboardData.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardData(
      teacher: json['teacher'] != null
          ? TeacherInfo.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      dashboardCards: (json['dashboard_cards'] as List<dynamic>?)
          ?.map((e) => DashboardCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher': teacher?.toJson(),
      'dashboard_cards': dashboardCards?.map((e) => e.toJson()).toList(),
    };
  }

  String get teacherName => teacher?.fullName ?? '';
  String get teacherId => teacher?.id ?? '';
  String get staffId => teacher?.staffId ?? '';
  bool get hasTeacher => teacher != null;

  List<DashboardCard> get timetableCards =>
      dashboardCards?.where((c) => c.type == DashboardCardType.timetable).toList() ?? [];

  List<DashboardCard> get reviewCards =>
      dashboardCards?.where((c) => c.type == DashboardCardType.reviews).toList() ?? [];

  List<DashboardCard> get announcementCards =>
      dashboardCards?.where((c) => c.type == DashboardCardType.announcements).toList() ?? [];

  List<DashboardCard> get meetingCards =>
      dashboardCards?.where((c) => c.type == DashboardCardType.meeting).toList() ?? [];

  // ✅ FIXED: orElse hatao
  DashboardCard? getCardByType(DashboardCardType type) {
    for (var card in dashboardCards ?? []) {
      if (card.type == type) {
        return card;
      }
    }
    return null;
  }

  List<DashboardCard> getCardsExcept(DashboardCardType type) {
    return dashboardCards?.where((c) => c.type != type).toList() ?? [];
  }
}

class TeacherInfo {
  final String id;
  final String staffId;
  final String fullName;
  final String? photo;
  final String email;
  final String designation;

  TeacherInfo({
    required this.id,
    required this.staffId,
    required this.fullName,
    this.photo,
    required this.email,
    required this.designation,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'] as String? ?? '',
      staffId: json['staff_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      photo: json['photo'] as String?,
      email: json['email'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'full_name': fullName,
      'photo': photo,
      'email': email,
      'designation': designation,
    };
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
  String get initials => fullName.isNotEmpty ? fullName[0].toUpperCase() : 'T';
  String get displayName => fullName.isNotEmpty ? fullName : 'Teacher';
}

class DashboardCard {
  final String id;
  final String title;
  final String value;
  final String? time;
  final DashboardCardType type;

  DashboardCard({
    required this.id,
    required this.title,
    required this.value,
    this.time,
    required this.type,
  });

  factory DashboardCard.fromJson(Map<String, dynamic> json) {
    return DashboardCard(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: json['value'] as String? ?? '',
      time: json['time'] as String?,
      type: DashboardCardType.fromString(json['type'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'time': time,
      'type': type.value,
    };
  }

  bool get hasValue => value.isNotEmpty && value != '0';
  bool get hasTime => time != null && time!.isNotEmpty;
  bool get isTimetable => type == DashboardCardType.timetable;
  bool get isReview => type == DashboardCardType.reviews;
  bool get isAnnouncement => type == DashboardCardType.announcements;
  bool get isMeeting => type == DashboardCardType.meeting;
  String get displayValue => hasValue ? value : '0';
}

enum DashboardCardType {
  timetable,
  reviews,
  announcements,
  meeting,
  unknown;

  String get value {
    switch (this) {
      case DashboardCardType.timetable:
        return 'timetable';
      case DashboardCardType.reviews:
        return 'reviews';
      case DashboardCardType.announcements:
        return 'announcements';
      case DashboardCardType.meeting:
        return 'meeting';
      case DashboardCardType.unknown:
        return 'unknown';
    }
  }

  static DashboardCardType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'timetable':
        return DashboardCardType.timetable;
      case 'reviews':
        return DashboardCardType.reviews;
      case 'announcements':
        return DashboardCardType.announcements;
      case 'meeting':
        return DashboardCardType.meeting;
      default:
        return DashboardCardType.unknown;
    }
  }

  String get iconName {
    switch (this) {
      case DashboardCardType.timetable:
        return 'ic_timetable';
      case DashboardCardType.reviews:
        return 'ic_review';
      case DashboardCardType.announcements:
        return 'ic_announcement';
      case DashboardCardType.meeting:
        return 'ic_meeting';
      case DashboardCardType.unknown:
        return 'ic_default';
    }
  }

  String get colorHex {
    switch (this) {
      case DashboardCardType.timetable:
        return '#4A90D9';
      case DashboardCardType.reviews:
        return '#F5A623';
      case DashboardCardType.announcements:
        return '#7ED321';
      case DashboardCardType.meeting:
        return '#D0021B';
      case DashboardCardType.unknown:
        return '#9B9B9B';
    }
  }
}

// ========== EXTENSION METHODS ==========

extension DashboardCardListExt on List<DashboardCard> {
  List<DashboardCard> get timetable => where((c) => c.isTimetable).toList();
  List<DashboardCard> get reviews => where((c) => c.isReview).toList();
  List<DashboardCard> get announcements => where((c) => c.isAnnouncement).toList();
  List<DashboardCard> get meetings => where((c) => c.isMeeting).toList();

  // ✅ FIXED: orElse hatao
  DashboardCard? getByType(DashboardCardType type) {
    for (var card in this) {
      if (card.type == type) {
        return card;
      }
    }
    return null;
  }

  bool get hasTimetable => timetable.isNotEmpty;
  bool get hasReviews => reviews.isNotEmpty;
  bool get hasAnnouncements => announcements.isNotEmpty;
  bool get hasMeetings => meetings.isNotEmpty;

  int get totalValue {
    int sum = 0;
    for (var card in this) {
      sum += int.tryParse(card.value) ?? 0;
    }
    return sum;
  }

  List<DashboardCard> get nonEmptyCards =>
      where((c) => c.hasValue || c.hasTime).toList();
}

extension TeacherDashboardResponseExt on TeacherDashboardResponse {
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null;
}