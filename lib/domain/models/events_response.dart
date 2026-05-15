// domain/models/events_response.dart

import 'dart:convert';

import 'package:flutter/material.dart';

class EventsResponseModel {
  final bool status;
  final String message;
  final EventsData? data;

  EventsResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory EventsResponseModel.fromJson(Map<String, dynamic> json) {
    return EventsResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? EventsData.fromJson(json['data'] as Map<String, dynamic>) : null,
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

class EventsData {
  final int? currentPage;
  final List<Event>? events;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  EventsData({
    this.currentPage,
    this.events,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      currentPage: json['current_page'] as int?,
      events: json['data'] != null
          ? (json['data'] as List).map((e) => Event.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      firstPageUrl: json['first_page_url'] as String?,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int?,
      lastPageUrl: json['last_page_url'] as String?,
      links: json['links'] != null
          ? (json['links'] as List).map((e) => Link.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String?,
      perPage: json['per_page'] as int?,
      prevPageUrl: json['prev_page_url'] as String?,
      to: json['to'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': events?.map((e) => e.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links?.map((e) => e.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  // Helper getters
  bool get hasNextPage => nextPageUrl != null && nextPageUrl!.isNotEmpty;
  bool get hasPrevPage => prevPageUrl != null && prevPageUrl!.isNotEmpty;
  bool get isNotEmpty => (events?.isNotEmpty ?? false);
  bool get isEmpty => (events?.isEmpty ?? true);
  int get eventCount => events?.length ?? 0;
}

class Event {
  final String? id;
  final String? title;
  final String? description;
  final String? eventDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String? eventType;
  final String? targetAudience;
  final String? status;
  final String? sessionId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List<dynamic>? targets;

  Event({
    this.id,
    this.title,
    this.description,
    this.eventDate,
    this.startTime,
    this.endTime,
    this.location,
    this.eventType,
    this.targetAudience,
    this.status,
    this.sessionId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.targets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      eventDate: json['event_date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      location: json['location'] as String?,
      eventType: json['event_type'] as String?,
      targetAudience: json['target_audience'] as String?,
      status: json['status'] as String?,
      sessionId: json['session_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      targets: json['targets'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_date': eventDate,
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'event_type': eventType,
      'target_audience': targetAudience,
      'status': status,
      'session_id': sessionId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'targets': targets,
    };
  }

  // Helper getters
  bool get isUpcoming => status?.toLowerCase() == 'upcoming';
  bool get isOngoing => status?.toLowerCase() == 'ongoing';
  bool get isCompleted => status?.toLowerCase() == 'completed';
  bool get isCancelled => status?.toLowerCase() == 'cancelled';

  bool get isHoliday => eventType?.toLowerCase() == 'holiday';
  bool get isExam => eventType?.toLowerCase() == 'exam';
  bool get isEvent => eventType?.toLowerCase() == 'event';
  bool get isMeeting => eventType?.toLowerCase() == 'meeting';

  bool get hasStartTime => startTime != null && startTime!.isNotEmpty;
  bool get hasEndTime => endTime != null && endTime!.isNotEmpty;
  bool get hasLocation => location != null && location!.isNotEmpty;
  bool get hasDescription => description != null && description!.isNotEmpty;

  String get formattedEventDate {
    if (eventDate == null) return 'N/A';
    // Convert YYYY-MM-DD to DD MMM YYYY
    final parts = eventDate!.split('-');
    if (parts.length == 3) {
      final month = _getMonthName(int.parse(parts[1]));
      return '${parts[2]} $month ${parts[0]}';
    }
    return eventDate!;
  }

  String get formattedStartTime {
    if (startTime == null || startTime!.isEmpty) return 'N/A';
    // Convert 15:40:00 to 03:40 PM
    final parts = startTime!.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }
    return startTime!;
  }

  String get formattedEndTime {
    if (endTime == null || endTime!.isEmpty) return 'N/A';
    final parts = endTime!.split(':');
    if (parts.length >= 2) {
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }
    return endTime!;
  }

  String get eventDuration {
    if (!hasStartTime && !hasEndTime) return 'All Day';
    if (hasStartTime && !hasEndTime) return 'Starts at $formattedStartTime';
    if (!hasStartTime && hasEndTime) return 'Ends at $formattedEndTime';
    return '$formattedStartTime - $formattedEndTime';
  }

  Color get statusColor {
    switch (status?.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color get eventTypeColor {
    switch (eventType?.toLowerCase()) {
      case 'holiday':
        return Colors.orange;
      case 'exam':
        return Colors.red;
      case 'event':
        return Colors.purple;
      case 'meeting':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  IconData get eventTypeIcon {
    switch (eventType?.toLowerCase()) {
      case 'holiday':
        return Icons.beach_access;
      case 'exam':
        return Icons.assignment;
      case 'event':
        return Icons.event;
      case 'meeting':
        return Icons.group;
      default:
        return Icons.calendar_today;
    }
  }
}

class Link {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String?,
      page: json['page'] as int?,
      active: json['active'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}

// Helper function to get month name
String _getMonthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}

// Extension for better date handling
extension EventDateExtension on String {
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  bool isToday() {
    final dateTime = toDateTime();
    if (dateTime == null) return false;
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool isTomorrow() {
    final dateTime = toDateTime();
    if (dateTime == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day;
  }

  bool isYesterday() {
    final dateTime = toDateTime();
    if (dateTime == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }
}

// Helper function to parse JSON string
EventsResponseModel eventsResponseFromJson(String str) =>
    EventsResponseModel.fromJson(json.decode(str) as Map<String, dynamic>);

String eventsResponseToJson(EventsResponseModel data) => json.encode(data.toJson());