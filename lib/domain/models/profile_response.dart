// lib/app/models/profile_model.dart

import 'dart:convert';

class ProfileResponse {
  final bool status;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ProfileData {
  final PersonalInfo personal;
  final ParentsInfo parents;
  final OtherInfo other;

  ProfileData({
    required this.personal,
    required this.parents,
    required this.other,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      personal: PersonalInfo.fromJson(json['personal'] ?? {}),
      parents: ParentsInfo.fromJson(json['parents'] ?? {}),
      other: OtherInfo.fromJson(json['other'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personal': personal.toJson(),
      'parents': parents.toJson(),
      'other': other.toJson(),
    };
  }
}

// ========== PERSONAL INFO ==========
class PersonalInfo {
  final String id;
  final String name;
  final String firstName;
  final String lastName;
  final String? photo;
  final String gender;
  final String dateOfBirth;
  final String? bloodGroup;
  final String? religion;
  final String admissionNumber;
  final String registrationNumber;
  final String rollNumber;
  final String admissionDate;
  final ClassInfo classInfo;
  final SectionInfo section;
  final ContactInfo contact;
  final AddressInfo address;
  final List<Sibling> siblings; // <-- NEW FIELD

  PersonalInfo({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    this.photo,
    required this.gender,
    required this.dateOfBirth,
    this.bloodGroup,
    this.religion,
    required this.admissionNumber,
    required this.registrationNumber,
    required this.rollNumber,
    required this.admissionDate,
    required this.classInfo,
    required this.section,
    required this.contact,
    required this.address,
    this.siblings = const [], // default empty list
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      photo: json['photo'],
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      bloodGroup: json['blood_group'],
      religion: json['religion'],
      admissionNumber: json['admission_number'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      admissionDate: json['admission_date'] ?? '',
      classInfo: ClassInfo.fromJson(json['class'] ?? {}),
      section: SectionInfo.fromJson(json['section'] ?? {}),
      contact: ContactInfo.fromJson(json['contact'] ?? {}),
      address: AddressInfo.fromJson(json['address'] ?? {}),
      siblings: (json['siblings'] as List?)
          ?.map((e) => Sibling.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photo,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'blood_group': bloodGroup,
      'religion': religion,
      'admission_number': admissionNumber,
      'registration_number': registrationNumber,
      'roll_number': rollNumber,
      'admission_date': admissionDate,
      'class': classInfo.toJson(),
      'section': section.toJson(),
      'contact': contact.toJson(),
      'address': address.toJson(),
      'siblings': siblings.map((e) => e.toJson()).toList(),
    };
  }
}

// ========== SIBLING CLASS ==========
class Sibling {
  final String id;
  final String fullName;
  final String admissionNumber;
  final String rollNumber;
  final String? photo;
  final ClassInfo classInfo;
  final SectionInfo section;

  Sibling({
    required this.id,
    required this.fullName,
    required this.admissionNumber,
    required this.rollNumber,
    this.photo,
    required this.classInfo,
    required this.section,
  });

  factory Sibling.fromJson(Map<String, dynamic> json) {
    return Sibling(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      admissionNumber: json['admission_number'] ?? '',
      rollNumber: json['roll_number'] ?? '',
      photo: json['photo'],
      classInfo: ClassInfo.fromJson(json['class'] ?? {}),
      section: SectionInfo.fromJson(json['section'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'admission_number': admissionNumber,
      'roll_number': rollNumber,
      'photo': photo,
      'class': classInfo.toJson(),
      'section': section.toJson(),
    };
  }
}

class ClassInfo {
  final String id;
  final String name;

  ClassInfo({
    required this.id,
    required this.name,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SectionInfo {
  final String id;
  final String name;

  SectionInfo({
    required this.id,
    required this.name,
  });

  factory SectionInfo.fromJson(Map<String, dynamic> json) {
    return SectionInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ContactInfo {
  final String? email;

  ContactInfo({
    this.email,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

class AddressInfo {
  final String current;
  final String permanent;
  final String? city;
  final String? state;
  final String? zipcode;

  AddressInfo({
    required this.current,
    required this.permanent,
    this.city,
    this.state,
    this.zipcode,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      current: json['current'] ?? '',
      permanent: json['permanent'] ?? '',
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'permanent': permanent,
      'city': city,
      'state': state,
      'zipcode': zipcode,
    };
  }
}

// ========== PARENTS INFO ==========
class ParentsInfo {
  final ParentDetail father;
  final ParentDetail mother;
  final GuardianDetail guardian;

  ParentsInfo({
    required this.father,
    required this.mother,
    required this.guardian,
  });

  factory ParentsInfo.fromJson(Map<String, dynamic> json) {
    return ParentsInfo(
      father: ParentDetail.fromJson(json['father'] ?? {}),
      mother: ParentDetail.fromJson(json['mother'] ?? {}),
      guardian: GuardianDetail.fromJson(json['guardian'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'father': father.toJson(),
      'mother': mother.toJson(),
      'guardian': guardian.toJson(),
    };
  }
}

class ParentDetail {
  final String name;
  final String phone;
  final String? email;
  final String? occupation;
  final String? photo;

  ParentDetail({
    required this.name,
    required this.phone,
    this.email,
    this.occupation,
    this.photo,
  });

  factory ParentDetail.fromJson(Map<String, dynamic> json) {
    return ParentDetail(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      occupation: json['occupation'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'occupation': occupation,
      'photo': photo,
    };
  }
}

class GuardianDetail {
  final String name;
  final String phone;
  final String? whatsapp;
  final String? email;
  final String? occupation;
  final String relation;
  final String address;

  GuardianDetail({
    required this.name,
    required this.phone,
    this.whatsapp,
    this.email,
    this.occupation,
    required this.relation,
    required this.address,
  });

  factory GuardianDetail.fromJson(Map<String, dynamic> json) {
    return GuardianDetail(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'],
      email: json['email'],
      occupation: json['occupation'],
      relation: json['relation'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'occupation': occupation,
      'relation': relation,
      'address': address,
    };
  }
}

// ========== OTHER INFO ==========
class OtherInfo {
  final AttendanceInfo attendance;
  final GradeInfo grade;
  final AcademicInfo academic;
  final LibraryInfo library;
  final TransportInfo transport;
  final dynamic health;
  final dynamic behaviour;

  OtherInfo({
    required this.attendance,
    required this.grade,
    required this.academic,
    required this.library,
    required this.transport,
    this.health,
    this.behaviour,
  });

  factory OtherInfo.fromJson(Map<String, dynamic> json) {
    return OtherInfo(
      attendance: AttendanceInfo.fromJson(json['attendance'] ?? {}),
      grade: GradeInfo.fromJson(json['grade'] ?? {}),
      academic: AcademicInfo.fromJson(json['academic'] ?? {}),
      library: LibraryInfo.fromJson(json['library'] ?? {}),
      transport: TransportInfo.fromJson(json['transport'] ?? {}),
      health: json['health'],
      behaviour: json['behaviour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance': attendance.toJson(),
      'grade': grade.toJson(),
      'academic': academic.toJson(),
      'library': library.toJson(),
      'transport': transport.toJson(),
      'health': health,
      'behaviour': behaviour,
    };
  }
}

class AttendanceInfo {
  final int percentage;
  final int totalDays;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final int halfDays;
  final int leaveDays;

  AttendanceInfo({
    required this.percentage,
    required this.totalDays,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.halfDays,
    required this.leaveDays,
  });

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceInfo(
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      totalDays: json['total_days'] ?? 0,
      presentDays: json['present_days'] ?? 0,
      absentDays: json['absent_days'] ?? 0,
      lateDays: json['late_days'] ?? 0,
      halfDays: json['half_days'] ?? 0,
      leaveDays: json['leave_days'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'total_days': totalDays,
      'present_days': presentDays,
      'absent_days': absentDays,
      'late_days': lateDays,
      'half_days': halfDays,
      'leave_days': leaveDays,
    };
  }
}

class GradeInfo {
  final dynamic averagePercentage;
  final String grade;
  final int totalSubjects;

  GradeInfo({
    this.averagePercentage,
    required this.grade,
    required this.totalSubjects,
  });

  factory GradeInfo.fromJson(Map<String, dynamic> json) {
    return GradeInfo(
      averagePercentage: json['average_percentage'],
      grade: json['grade'] ?? 'N/A',
      totalSubjects: json['total_subjects'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_percentage': averagePercentage,
      'grade': grade,
      'total_subjects': totalSubjects,
    };
  }
}

class AcademicInfo {
  final String classInfo;
  final String section;
  final String session;
  final String admissionType;

  AcademicInfo({
    required this.classInfo,
    required this.section,
    required this.session,
    required this.admissionType,
  });

  factory AcademicInfo.fromJson(Map<String, dynamic> json) {
    return AcademicInfo(
      classInfo: json['class'] ?? '',
      section: json['section'] ?? '',
      session: json['session'] ?? '',
      admissionType: json['admission_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': classInfo,
      'section': section,
      'session': session,
      'admission_type': admissionType,
    };
  }
}

class LibraryInfo {
  final bool isMember;

  LibraryInfo({
    required this.isMember,
  });

  factory LibraryInfo.fromJson(Map<String, dynamic> json) {
    return LibraryInfo(
      isMember: json['is_member'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_member': isMember,
    };
  }
}

class TransportInfo {
  final bool isRegistered;

  TransportInfo({
    required this.isRegistered,
  });

  factory TransportInfo.fromJson(Map<String, dynamic> json) {
    return TransportInfo(
      isRegistered: json['is_registered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_registered': isRegistered,
    };
  }
}

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str) as Map<String, dynamic>);