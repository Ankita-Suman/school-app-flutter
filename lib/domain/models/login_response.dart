import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final bool status;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data'] as Map<String, dynamic>) : null,
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

class LoginData {
  final User user;
  final String branchId;
  final String branchName;
  final String branchCode;
  final String token;
  final String tokenType;
  final int expiresIn;

  LoginData({
    required this.user,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      branchId: json['branch_id'] as String? ?? '',
      branchName: json['branch_name'] as String? ?? '',
      branchCode: json['branch_code'] as String? ?? '',
      token: json['token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'branch_id': branchId,
      'branch_name': branchName,
      'branch_code': branchCode,
      'token': token,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}

class User {
  final String id;
  final String username;
  final String email;
  final String roleId;
  final int screenTimeout;               // ✅ Added missing field
  final String? studentId;
  final String? studentParentId;
  final String? staffId;
  final String userType;
  final bool isActive;
  final bool mustChangePassword;
  final int failedLoginAttempts;
  final String? lockedAt;
  final String? lastLoginAt;
  final String? createdAt;              // ✅ Made nullable
  final String? updatedAt;              // ✅ Made nullable
  final String? deletedAt;
  final Role role;
  final Staff? staff;
  final dynamic student;
  final String name;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    required this.screenTimeout,
    this.studentId,
    this.studentParentId,
    this.staffId,
    required this.userType,
    required this.isActive,
    required this.mustChangePassword,
    required this.failedLoginAttempts,
    this.lockedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.role,
    this.staff,
    this.student,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roleId: json['role_id'] as String? ?? '',
      screenTimeout: json['screen_timeout'] as int? ?? 0,
      studentId: json['student_id'] as String?,
      studentParentId: json['student_parent_id'] as String?,
      staffId: json['staff_id'] as String?,
      userType: json['user_type'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      mustChangePassword: json['must_change_password'] as bool? ?? false,
      failedLoginAttempts: json['failed_login_attempts'] as int? ?? 0,
      lockedAt: json['locked_at'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      staff: json['staff'] != null ? Staff.fromJson(json['staff'] as Map<String, dynamic>) : null,
      student: json['student'],
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role_id': roleId,
      'screen_timeout': screenTimeout,
      'student_id': studentId,
      'student_parent_id': studentParentId,
      'staff_id': staffId,
      'user_type': userType,
      'is_active': isActive,
      'must_change_password': mustChangePassword,
      'failed_login_attempts': failedLoginAttempts,
      'locked_at': lockedAt,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'role': role.toJson(),
      'staff': staff?.toJson(),
      'student': student,
      'name': name,
    };
  }
}

class Staff {
  final String id;
  final String? sessionId;
  final String type;
  final String staffId;
  final String? roleId;
  final String? prefix;
  final String? maritalStatus;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String email;
  final String? fatherName;
  final String? motherName;
  final String? nationality;
  final String? religion;
  final String? gender;
  final String? dateOfBirth;
  final String? motherTongue;
  final String? joiningDate;
  final String? contact;
  final String? emergencyContact;
  final String? photo;
  final String? currentAddress;
  final String? permanentAddress;
  final String? qualification;
  final String? workExperience;
  final String? note;
  final String? epfNumber;
  final String? basicSalary;
  final String? contractType;
  final String? workShift;
  final String? location;
  final int? paidLeaves;          // ✅ changed from String to int
  final int? halfLeaves;          // ✅ changed from String to int
  final int? fullDay;             // ✅ changed from String to int
  final String? accountTitle;
  final String? accountNumber;
  final String? bankName;
  final String? ifscCode;
  final String? bankBranchName;
  final String? facebookUrl;
  final String? twitterUrl;
  final String? linkedinUrl;
  final String? instagramUrl;
  final String? resume;
  final String? joiningLetter;
  final List<String>? otherDocuments;  // ✅ changed from String? to List<String>?
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Staff({
    required this.id,
    this.sessionId,
    required this.type,
    required this.staffId,
    this.roleId,
    this.prefix,
    this.maritalStatus,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.email,
    this.fatherName,
    this.motherName,
    this.nationality,
    this.religion,
    this.gender,
    this.dateOfBirth,
    this.motherTongue,
    this.joiningDate,
    this.contact,
    this.emergencyContact,
    this.photo,
    this.currentAddress,
    this.permanentAddress,
    this.qualification,
    this.workExperience,
    this.note,
    this.epfNumber,
    this.basicSalary,
    this.contractType,
    this.workShift,
    this.location,
    this.paidLeaves,
    this.halfLeaves,
    this.fullDay,
    this.accountTitle,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
    this.bankBranchName,
    this.facebookUrl,
    this.twitterUrl,
    this.linkedinUrl,
    this.instagramUrl,
    this.resume,
    this.joiningLetter,
    this.otherDocuments,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    // handle otherDocuments which can be a list or null
    List<String>? docs;
    final docsJson = json['other_documents'];
    if (docsJson is List) {
      docs = docsJson.map((e) => e.toString()).toList();
    }
    return Staff(
      id: json['id'] as String? ?? '',
      sessionId: json['session_id'] as String?,
      type: json['type'] as String? ?? '',
      staffId: json['staff_id'] as String? ?? '',
      roleId: json['role_id'] as String?,
      prefix: json['prefix'] as String?,
      maritalStatus: json['marital_status'] as String?,
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String? ?? '',
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      motherTongue: json['mother_tongue'] as String?,
      joiningDate: json['joining_date'] as String?,
      contact: json['contact'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      photo: json['photo'] as String?,
      currentAddress: json['current_address'] as String?,
      permanentAddress: json['permanent_address'] as String?,
      qualification: json['qualification'] as String?,
      workExperience: json['work_experience'] as String?,
      note: json['note'] as String?,
      epfNumber: json['epf_number'] as String?,
      basicSalary: json['basic_salary'] as String?,
      contractType: json['contract_type'] as String?,
      workShift: json['work_shift'] as String?,
      location: json['location'] as String?,
      paidLeaves: json['paid_leaves'] as int?,   // int from API
      halfLeaves: json['half_leaves'] as int?,
      fullDay: json['full_day'] as int?,
      accountTitle: json['account_title'] as String?,
      accountNumber: json['account_number'] as String?,
      bankName: json['bank_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      bankBranchName: json['bank_branch_name'] as String?,
      facebookUrl: json['facebook_url'] as String?,
      twitterUrl: json['twitter_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      instagramUrl: json['instagram_url'] as String?,
      resume: json['resume'] as String?,
      joiningLetter: json['joining_letter'] as String?,
      otherDocuments: docs,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'type': type,
      'staff_id': staffId,
      'role_id': roleId,
      'prefix': prefix,
      'marital_status': maritalStatus,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'father_name': fatherName,
      'mother_name': motherName,
      'nationality': nationality,
      'religion': religion,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'mother_tongue': motherTongue,
      'joining_date': joiningDate,
      'contact': contact,
      'emergency_contact': emergencyContact,
      'photo': photo,
      'current_address': currentAddress,
      'permanent_address': permanentAddress,
      'qualification': qualification,
      'work_experience': workExperience,
      'note': note,
      'epf_number': epfNumber,
      'basic_salary': basicSalary,
      'contract_type': contractType,
      'work_shift': workShift,
      'location': location,
      'paid_leaves': paidLeaves,
      'half_leaves': halfLeaves,
      'full_day': fullDay,
      'account_title': accountTitle,
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'bank_branch_name': bankBranchName,
      'facebook_url': facebookUrl,
      'twitter_url': twitterUrl,
      'linkedin_url': linkedinUrl,
      'instagram_url': instagramUrl,
      'resume': resume,
      'joining_letter': joiningLetter,
      'other_documents': otherDocuments,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class Role {
  final String id;
  final String name;
  final String? deletedAt;
  final String? createdAt;    // ✅ made nullable
  final String? updatedAt;    // ✅ made nullable
  final List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'permissions': permissions.map((e) => e.toJson()).toList(),
    };
  }
}

class Permission {
  final String id;
  final String module;
  final String feature;
  final String? deletedAt;
  final String? createdAt;   // ✅ made nullable
  final String? updatedAt;   // ✅ made nullable
  final PermissionPivot pivot;

  Permission({
    required this.id,
    required this.module,
    required this.feature,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.pivot,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String? ?? '',
      module: json['module'] as String? ?? '',
      feature: json['feature'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: PermissionPivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module': module,
      'feature': feature,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot.toJson(),
    };
  }
}

class PermissionPivot {
  final String roleId;
  final String permissionId;
  final int hasViewPermission;
  final int hasCreatePermission;
  final int hasEditPermission;
  final int hasDeletePermission;
  final String? createdAt;
  final String? updatedAt;

  PermissionPivot({
    required this.roleId,
    required this.permissionId,
    required this.hasViewPermission,
    required this.hasCreatePermission,
    required this.hasEditPermission,
    required this.hasDeletePermission,
    this.createdAt,
    this.updatedAt,
  });

  factory PermissionPivot.fromJson(Map<String, dynamic> json) {
    return PermissionPivot(
      roleId: json['role_id'] as String? ?? '',
      permissionId: json['permission_id'] as String? ?? '',
      hasViewPermission: json['has_view_permission'] as int? ?? 0,
      hasCreatePermission: json['has_create_permission'] as int? ?? 0,
      hasEditPermission: json['has_edit_permission'] as int? ?? 0,
      hasDeletePermission: json['has_delete_permission'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'permission_id': permissionId,
      'has_view_permission': hasViewPermission,
      'has_create_permission': hasCreatePermission,
      'has_edit_permission': hasEditPermission,
      'has_delete_permission': hasDeletePermission,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}