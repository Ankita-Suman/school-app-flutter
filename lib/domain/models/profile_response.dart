// profile_response.dart
import 'dart:convert';

class ProfileResponse {
  bool? status;
  String? message;
  ProfileData? data;

  ProfileResponse({this.status, this.message, this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message'] ?? '';
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  String? id;
  String? username;
  String? email;
  String? roleId;
  String? role;
  Staff? staff;

  ProfileData({
    this.id,
    this.username,
    this.email,
    this.roleId,
    this.role,
    this.staff
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    username = json['username']?.toString();
    email = json['email']?.toString();
    roleId = json['role_id']?.toString();
    role = json['role']?.toString();
    staff = json['staff'] != null ? Staff.fromJson(json['staff']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['role_id'] = roleId;
    data['role'] = role;
    if (staff != null) {
      data['staff'] = staff!.toJson();
    }
    return data;
  }

  // Helper method to get safe value
  String getSafeValue(String? value) {
    return value ?? 'N/A';
  }
}

class Staff {
  String? id;
  String? staffId;
  String? type;
  String? role;
  String? firstName;
  String? middleName;
  String? lastName;
  String? fullName;
  String? photo;
  String? email;
  String? contact;
  String? gender;
  String? dateOfBirth;
  String? joiningDate;

  Staff({
    this.id,
    this.staffId,
    this.type,
    this.role,
    this.firstName,
    this.middleName,
    this.lastName,
    this.fullName,
    this.photo,
    this.email,
    this.contact,
    this.gender,
    this.dateOfBirth,
    this.joiningDate,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    staffId = json['staff_id']?.toString();
    type = json['type']?.toString();
    role = json['role']?.toString();
    firstName = json['first_name']?.toString();
    middleName = json['middle_name']?.toString();
    lastName = json['last_name']?.toString();
    fullName = json['full_name']?.toString();
    photo = json['photo']?.toString();
    email = json['email']?.toString();
    contact = json['contact']?.toString();
    gender = json['gender']?.toString();
    dateOfBirth = json['date_of_birth']?.toString();
    joiningDate = json['joining_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['staff_id'] = staffId;
    data['type'] = type;
    data['role'] = role;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['full_name'] = fullName;
    data['photo'] = photo;
    data['email'] = email;
    data['contact'] = contact;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['joining_date'] = joiningDate;
    return data;
  }
}
ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str) as Map<String, dynamic>);