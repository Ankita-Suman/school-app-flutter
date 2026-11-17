class ClassmatesResponse {
  bool? status;
  String? message;
  ClassmatesData? data;

  ClassmatesResponse({this.status, this.message, this.data});

  ClassmatesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ClassmatesData.fromJson(json['data']) : null;
  }
}

class ClassmatesData {
  ClassInfo? classInfo;
  SectionInfo? section;
  int? total;
  List<Classmate>? classmates;

  ClassmatesData({this.classInfo, this.section, this.total, this.classmates});

  ClassmatesData.fromJson(Map<String, dynamic> json) {
    classInfo = json['class'] != null ? ClassInfo.fromJson(json['class']) : null;
    section = json['section'] != null ? SectionInfo.fromJson(json['section']) : null;
    total = json['total'];
    if (json['classmates'] != null) {
      classmates = <Classmate>[];
      json['classmates'].forEach((v) {
        classmates!.add(Classmate.fromJson(v));
      });
    }
  }
}

class ClassInfo {
  String? id;
  String? name;

  ClassInfo({this.id, this.name});

  ClassInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class SectionInfo {
  String? id;
  String? name;

  SectionInfo({this.id, this.name});

  SectionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Classmate {
  String? id;
  String? fullName;
  String? rollNumber;
  String? photo;

  Classmate({this.id, this.fullName, this.rollNumber, this.photo});

  Classmate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    rollNumber = json['roll_number'];
    photo = json['photo'];
  }
}