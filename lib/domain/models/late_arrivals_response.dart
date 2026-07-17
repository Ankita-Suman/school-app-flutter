// lib/domain/models/late_arrivals_response.dart

import 'dart:convert';

LateArrivalsResponse lateArrivalsResponseFromJson(String str) =>
    LateArrivalsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String lateArrivalsResponseToJson(LateArrivalsResponse data) =>
    json.encode(data.toJson());

class LateArrivalsResponse {
  final bool status;
  final String message;
  final LateArrivalsData? data;

  LateArrivalsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LateArrivalsResponse.fromJson(Map<String, dynamic> json) {
    return LateArrivalsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? LateArrivalsData.fromJson(json['data'] as Map<String, dynamic>)
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

  // ========== HELPER METHODS ==========
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null && data!.data != null && data!.data!.isNotEmpty;
  int get totalLateArrivals => data?.total ?? 0;
}

class LateArrivalsData {
  final List<LateArrival>? data;
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;

  LateArrivalsData({
    this.data,
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  factory LateArrivalsData.fromJson(Map<String, dynamic> json) {
    return LateArrivalsData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LateArrival.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasMorePages => currentPage != null && lastPage != null && currentPage! < lastPage!;
  bool get isNotEmpty => data != null && data!.isNotEmpty;
  bool get isEmpty => data == null || data!.isEmpty;
  int get totalCount => total ?? 0;
}

class LateArrival {
  final String? attendanceId;
  final String? attendanceDate;
  final String? status;
  final String? remarks;
  final LateArrivalStudent? student;
  final LateArrivalClass? classInfo;
  final LateArrivalSection? section;

  LateArrival({
    this.attendanceId,
    this.attendanceDate,
    this.status,
    this.remarks,
    this.student,
    this.classInfo,
    this.section,
  });

  factory LateArrival.fromJson(Map<String, dynamic> json) {
    return LateArrival(
      attendanceId: json['attendance_id'] as String?,
      attendanceDate: json['attendance_date'] as String?,
      status: json['status'] as String?,
      remarks: json['remarks'] as String?,
      student: json['student'] != null
          ? LateArrivalStudent.fromJson(json['student'] as Map<String, dynamic>)
          : null,
      classInfo: json['class'] != null
          ? LateArrivalClass.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      section: json['section'] != null
          ? LateArrivalSection.fromJson(json['section'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'attendance_date': attendanceDate,
      'status': status,
      'remarks': remarks,
      'student': student?.toJson(),
      'class': classInfo?.toJson(),
      'section': section?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========
  String get studentName => student?.fullName ?? '';
  String get studentRollNumber => student?.rollNumber ?? '';
  String get studentRegistrationNumber => student?.registrationNumber ?? '';
  String get className => classInfo?.name ?? '';
  String get sectionName => section?.name ?? '';
  String get fullClass => '$className - $sectionName';

  bool get hasRemarks => remarks != null && remarks!.isNotEmpty;

  String get formattedDate {
    try {
      if (attendanceDate != null && attendanceDate!.contains('-')) {
        final parts = attendanceDate!.split('-');
        if (parts.length == 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
      }
      return attendanceDate ?? '';
    } catch (e) {
      return attendanceDate ?? '';
    }
  }

  String get statusDisplay {
    switch (status?.toUpperCase()) {
      case 'PRESENT':
        return 'Present';
      case 'ABSENT':
        return 'Absent';
      case 'LATE':
        return 'Late';
      case 'HALF_DAY':
        return 'Half Day';
      case 'LEAVE':
        return 'Leave';
      default:
        return status ?? 'Not Marked';
    }
  }

  bool get isLate => status?.toUpperCase() == 'LATE';
  bool get isPresent => status?.toUpperCase() == 'PRESENT';
  bool get isAbsent => status?.toUpperCase() == 'ABSENT';
  bool get isHalfDay => status?.toUpperCase() == 'HALF_DAY';
  bool get isLeave => status?.toUpperCase() == 'LEAVE';
}

class LateArrivalStudent {
  final String? id;
  final String? registrationNumber;
  final String? admissionNumber;
  final String? rollNumber;
  final String? fullName;
  final String? photo;

  LateArrivalStudent({
    this.id,
    this.registrationNumber,
    this.admissionNumber,
    this.rollNumber,
    this.fullName,
    this.photo,
  });

  factory LateArrivalStudent.fromJson(Map<String, dynamic> json) {
    return LateArrivalStudent(
      id: json['id'] as String?,
      registrationNumber: json['registration_number'] as String?,
      admissionNumber: json['admission_number'] as String?,
      rollNumber: json['roll_number'] as String?,
      fullName: json['full_name'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration_number': registrationNumber,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'full_name': fullName,
      'photo': photo,
    };
  }

  bool get hasPhoto => photo != null && photo!.isNotEmpty;
}

class LateArrivalClass {
  final String? id;
  final String? name;

  LateArrivalClass({
    this.id,
    this.name,
  });

  factory LateArrivalClass.fromJson(Map<String, dynamic> json) {
    return LateArrivalClass(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class LateArrivalSection {
  final String? id;
  final String? name;

  LateArrivalSection({
    this.id,
    this.name,
  });

  factory LateArrivalSection.fromJson(Map<String, dynamic> json) {
    return LateArrivalSection(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// ========== EXTENSION METHODS ==========

extension LateArrivalsResponseExt on LateArrivalsResponse {
  bool get isSuccess => status == true;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
  bool get hasData => data != null && data!.data != null && data!.data!.isNotEmpty;
  int get total => data?.total ?? 0;
  int get currentPage => data?.currentPage ?? 1;
  int get lastPage => data?.lastPage ?? 1;
  bool get hasMorePages => currentPage < lastPage;
  bool get isEmpty => data == null || data!.data == null || data!.data!.isEmpty;
  bool get isNotEmpty => !isEmpty;
}

extension LateArrivalListExt on List<LateArrival> {
  List<LateArrival> get todayLateArrivals => where((e) {
    final today = DateTime.now();
    final date = DateTime.tryParse(e.attendanceDate ?? '');
    if (date == null) return false;
    return date.year == today.year && date.month == today.month && date.day == today.day;
  }).toList();

  List<LateArrival> get withRemarks => where((e) => e.hasRemarks).toList();
  List<LateArrival> get withoutRemarks => where((e) => !e.hasRemarks).toList();

  List<LateArrival> searchByStudentName(String query) {
    if (query.isEmpty) return this;
    final searchQuery = query.toLowerCase().trim();
    return where((e) =>
    e.studentName.toLowerCase().contains(searchQuery) ||
        e.studentRollNumber.contains(searchQuery) ||
        e.studentRegistrationNumber.toLowerCase().contains(searchQuery)
    ).toList();
  }

  List<LateArrival> sortedByDate() {
    final list = List<LateArrival>.from(this);
    list.sort((a, b) => (b.attendanceDate ?? '').compareTo(a.attendanceDate ?? ''));
    return list;
  }

  List<LateArrival> sortedByStudentName() {
    final list = List<LateArrival>.from(this);
    list.sort((a, b) => a.studentName.compareTo(b.studentName));
    return list;
  }

  List<LateArrival> filterByDate(String date) {
    if (date.isEmpty) return this;
    return where((e) => e.attendanceDate == date).toList();
  }
}