// staff_attendance_model.dart

class StaffAttendanceResponse {
  bool? status;
  String? message;
  StaffAttendanceData? data;

  StaffAttendanceResponse({this.status, this.message, this.data});

  StaffAttendanceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? StaffAttendanceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StaffAttendanceData {
  String? type;
  StaffPerson? person;
  String? startDate;
  String? endDate;
  StaffSummary? summary;
  List<StaffDay>? days;

  StaffAttendanceData(
      {this.type,
        this.person,
        this.startDate,
        this.endDate,
        this.summary,
        this.days});

  StaffAttendanceData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    person = json['person'] != null ? StaffPerson.fromJson(json['person']) : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    summary = json['summary'] != null ? StaffSummary.fromJson(json['summary']) : null;
    if (json['days'] != null) {
      days = <StaffDay>[];
      json['days'].forEach((v) {
        days!.add(StaffDay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (person != null) {
      data['person'] = person!.toJson();
    }
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StaffPerson {
  String? id;
  String? name;
  String? code;
  String? detail;

  StaffPerson({this.id, this.name, this.code, this.detail});

  StaffPerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['detail'] = detail;
    return data;
  }
}

class StaffSummary {
  int? present;
  int? late;
  int? absent;
  int? halfDay;
  int? leave;
  int? notMarked;
  int? markedDays;
  num? percentage; // Percentage kabhi double bhi ho sakta hai

  StaffSummary(
      {this.present,
        this.late,
        this.absent,
        this.halfDay,
        this.leave,
        this.notMarked,
        this.markedDays,
        this.percentage});

  StaffSummary.fromJson(Map<String, dynamic> json) {
    present = json['present'];
    late = json['late'];
    absent = json['absent'];
    halfDay = json['half_day'];
    leave = json['leave'];
    notMarked = json['not_marked'];
    markedDays = json['marked_days'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['present'] = present;
    data['late'] = late;
    data['absent'] = absent;
    data['half_day'] = halfDay;
    data['leave'] = leave;
    data['not_marked'] = notMarked;
    data['marked_days'] = markedDays;
    data['percentage'] = percentage;
    return data;
  }
}

class StaffDay {
  String? date;
  String? weekday;
  String? status; // Null ho sakta hai (agar mark nahi hua hai)
  String? checkIn;
  String? checkOut;
  String? source;
  String? remarks;
  bool? isFuture;

  StaffDay(
      {this.date,
        this.weekday,
        this.status,
        this.checkIn,
        this.checkOut,
        this.source,
        this.remarks,
        this.isFuture});

  StaffDay.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    weekday = json['weekday'];
    status = json['status'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    source = json['source'];
    remarks = json['remarks'];
    isFuture = json['is_future'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['weekday'] = weekday;
    data['status'] = status;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['source'] = source;
    data['remarks'] = remarks;
    data['is_future'] = isFuture;
    return data;
  }
}