// domain/models/login_response.dart
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

// ============================================================
// ✅ SAFE HELPERS — int/String/double/null sab handle
// ============================================================
String? _asString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

int _asInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

int? _asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

bool _asBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is String) {
    final s = v.toLowerCase();
    return s == 'true' || s == '1';
  }
  return false;
}

// ============================================================
// LOGIN RESPONSE
// ============================================================
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
      status: _asBool(json['status']),
      message: _asString(json['message']) ?? '',
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

// ============================================================
// LOGIN DATA
// ============================================================
class LoginData {
  final Auth? auth;
  final User user;
  final String branchId;
  final String branchName;
  final String branchCode;
  final String token;
  final String tokenType;
  final int expiresIn;

  LoginData({
    this.auth,
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
      auth: json['auth'] != null
          ? Auth.fromJson(json['auth'] as Map<String, dynamic>)
          : null,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      branchId: _asString(json['branch_id']) ?? '',
      branchName: _asString(json['branch_name']) ?? '',
      branchCode: _asString(json['branch_code']) ?? '',
      token: _asString(json['token']) ?? '',
      tokenType: _asString(json['token_type']) ?? '',
      expiresIn: _asInt(json['expires_in']),
    );
  }

  Map<String, dynamic> toJson() => {
    'auth': auth?.toJson(),
    'user': user.toJson(),
    'branch_id': branchId,
    'branch_name': branchName,
    'branch_code': branchCode,
    'token': token,
    'token_type': tokenType,
    'expires_in': expiresIn,
  };
}

// ============================================================
// AUTH
// ============================================================
class Auth {
  final String? userType;
  final String? userId;
  final String? studentId;
  final String? studentParentId;
  final String? staffId;
  final bool? mustChangePassword;
  final String? nextScreen;
  final String? defaultStudentId;
  final int? childrenCount;

  Auth({
    this.userType,
    this.userId,
    this.studentId,
    this.studentParentId,
    this.staffId,
    this.mustChangePassword,
    this.nextScreen,
    this.defaultStudentId,
    this.childrenCount,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      userType: _asString(json['user_type']),
      userId: _asString(json['user_id']),
      studentId: _asString(json['student_id']),
      studentParentId: _asString(json['student_parent_id']),
      staffId: _asString(json['staff_id']),
      mustChangePassword: json['must_change_password'] is bool
          ? json['must_change_password'] as bool
          : null,
      nextScreen: _asString(json['next_screen']),
      defaultStudentId: _asString(json['default_student_id']),
      childrenCount: _asIntOrNull(json['children_count']),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_type': userType,
    'user_id': userId,
    'student_id': studentId,
    'student_parent_id': studentParentId,
    'staff_id': staffId,
    'must_change_password': mustChangePassword,
    'next_screen': nextScreen,
    'default_student_id': defaultStudentId,
    'children_count': childrenCount,
  };
}

// ============================================================
// USER
// ============================================================
class User {
  final String id;
  final String username;
  final String? email;
  final String roleId;
  final int screenTimeout;
  final String? studentId;
  final String? studentParentId;
  final String? staffId;
  final String userType;
  final bool isActive;
  final bool mustChangePassword;
  final int failedLoginAttempts;
  final String? lockedAt;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final Role? role;
  final Staff? staff;
  final dynamic student;
  final StudentParent? studentParent;
  final String name;
  final List<Child> children;

  User({
    required this.id,
    required this.username,
    this.email,
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
    this.role,
    this.staff,
    this.student,
    this.studentParent,
    required this.name,
    this.children = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _asString(json['id']) ?? '',
      username: _asString(json['username']) ?? '',
      email: _asString(json['email']),
      roleId: _asString(json['role_id']) ?? '',
      screenTimeout: _asInt(json['screen_timeout']),
      studentId: _asString(json['student_id']),
      studentParentId: _asString(json['student_parent_id']),
      staffId: _asString(json['staff_id']),
      userType: _asString(json['user_type']) ?? '',
      isActive: _asBool(json['is_active']),
      mustChangePassword: _asBool(json['must_change_password']),
      failedLoginAttempts: _asInt(json['failed_login_attempts']),
      lockedAt: _asString(json['locked_at']),
      lastLoginAt: _asString(json['last_login_at']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
      role: json['role'] != null
          ? Role.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      staff: json['staff'] != null
          ? Staff.fromJson(json['staff'] as Map<String, dynamic>)
          : null,
      student: json['student'],
      studentParent: json['student_parent'] != null
          ? StudentParent.fromJson(
          json['student_parent'] as Map<String, dynamic>)
          : null,
      name: _asString(json['name']) ?? '',
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => Child.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
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
    'role': role?.toJson(),
    'staff': staff?.toJson(),
    'student': student,
    'student_parent': studentParent?.toJson(),
    'name': name,
    'children': children.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// ROLE
// ============================================================
class Role {
  final String id;
  final String name;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.permissions = const [],
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: _asString(json['id']) ?? '',
      name: _asString(json['name']) ?? '',
      deletedAt: _asString(json['deleted_at']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'deleted_at': deletedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'permissions': permissions.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// PERMISSION
// ============================================================
class Permission {
  final String id;
  final String module;
  final String feature;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final PermissionPivot? pivot;

  Permission({
    required this.id,
    required this.module,
    required this.feature,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: _asString(json['id']) ?? '',
      module: _asString(json['module']) ?? '',
      feature: _asString(json['feature']) ?? '',
      deletedAt: _asString(json['deleted_at']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      pivot: json['pivot'] != null
          ? PermissionPivot.fromJson(json['pivot'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'module': module,
    'feature': feature,
    'deleted_at': deletedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'pivot': pivot?.toJson(),
  };
}

// ============================================================
// PERMISSION PIVOT
// ============================================================
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
      roleId: _asString(json['role_id']) ?? '',
      permissionId: _asString(json['permission_id']) ?? '',
      hasViewPermission: _asInt(json['has_view_permission']),
      hasCreatePermission: _asInt(json['has_create_permission']),
      hasEditPermission: _asInt(json['has_edit_permission']),
      hasDeletePermission: _asInt(json['has_delete_permission']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
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

// ============================================================
// STUDENT PARENT
// ============================================================
class StudentParent {
  final String id;
  final String? studentId;
  final String? fatherName;
  final String? fatherContact;
  final String? fatherOccupation;
  final String? fatherAdhaarNumber;
  final String? fatherEmail;
  final String? fatherPhoto;
  final String? motherName;
  final String? motherContact;
  final String? motherOccupation;
  final String? motherAdhaarNumber;
  final String? motherEmail;
  final String? motherPhoto;
  final String? guardianName;
  final String? guardianRelation;
  final String? guardianEmail;
  final String? guardianContact;
  final String? guardianOccupation;
  final String? guardianWhatsappContact;
  final String? guardianAddress;
  final String? guardianPhoto;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  StudentParent({
    required this.id,
    this.studentId,
    this.fatherName,
    this.fatherContact,
    this.fatherOccupation,
    this.fatherAdhaarNumber,
    this.fatherEmail,
    this.fatherPhoto,
    this.motherName,
    this.motherContact,
    this.motherOccupation,
    this.motherAdhaarNumber,
    this.motherEmail,
    this.motherPhoto,
    this.guardianName,
    this.guardianRelation,
    this.guardianEmail,
    this.guardianContact,
    this.guardianOccupation,
    this.guardianWhatsappContact,
    this.guardianAddress,
    this.guardianPhoto,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory StudentParent.fromJson(Map<String, dynamic> json) {
    return StudentParent(
      id: _asString(json['id']) ?? '',
      studentId: _asString(json['student_id']),
      fatherName: _asString(json['father_name']),
      fatherContact: _asString(json['father_contact']),
      fatherOccupation: _asString(json['father_occupation']),
      fatherAdhaarNumber: _asString(json['father_adhaar_number']),
      fatherEmail: _asString(json['father_email']),
      fatherPhoto: _asString(json['father_photo']),
      motherName: _asString(json['mother_name']),
      motherContact: _asString(json['mother_contact']),
      motherOccupation: _asString(json['mother_occupation']),
      motherAdhaarNumber: _asString(json['mother_adhaar_number']),
      motherEmail: _asString(json['mother_email']),
      motherPhoto: _asString(json['mother_photo']),
      guardianName: _asString(json['guardian_name']),
      guardianRelation: _asString(json['guardian_relation']),
      guardianEmail: _asString(json['guardian_email']),
      guardianContact: _asString(json['guardian_contact']),
      guardianOccupation: _asString(json['guardian_occupation']),
      guardianWhatsappContact: _asString(json['guardian_whatsapp_contact']),
      guardianAddress: _asString(json['guardian_address']),
      guardianPhoto: _asString(json['guardian_photo']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'father_name': fatherName,
    'father_contact': fatherContact,
    'father_occupation': fatherOccupation,
    'father_adhaar_number': fatherAdhaarNumber,
    'father_email': fatherEmail,
    'father_photo': fatherPhoto,
    'mother_name': motherName,
    'mother_contact': motherContact,
    'mother_occupation': motherOccupation,
    'mother_adhaar_number': motherAdhaarNumber,
    'mother_email': motherEmail,
    'mother_photo': motherPhoto,
    'guardian_name': guardianName,
    'guardian_relation': guardianRelation,
    'guardian_email': guardianEmail,
    'guardian_contact': guardianContact,
    'guardian_occupation': guardianOccupation,
    'guardian_whatsapp_contact': guardianWhatsappContact,
    'guardian_address': guardianAddress,
    'guardian_photo': guardianPhoto,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}

// ============================================================
// SIBLING
// ============================================================
class Sibling {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? registrationNumber;
  final String? admissionNumber;
  final String? classId;
  final String? sectionId;

  Sibling({
    required this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.registrationNumber,
    this.admissionNumber,
    this.classId,
    this.sectionId,
  });

  factory Sibling.fromJson(Map<String, dynamic> json) {
    return Sibling(
      id: _asString(json['id']) ?? '',
      firstName: _asString(json['first_name']),
      lastName: _asString(json['last_name']),
      fullName: _asString(json['full_name']),
      registrationNumber: _asString(json['registration_number']),
      admissionNumber: _asString(json['admission_number']),
      classId: _asString(json['class_id']),
      sectionId: _asString(json['section_id']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'full_name': fullName,
    'registration_number': registrationNumber,
    'admission_number': admissionNumber,
    'class_id': classId,
    'section_id': sectionId,
  };
}

// ============================================================
// CHILD
// ============================================================
class Child {
  final String id;
  final String? admissionDate;
  final String? admissionType;
  final String? registrationNumber;
  final String? admissionNumber;
  final String? sessionId;
  final String? classId;
  final String? sectionId;
  final String? rollNumber;
  final String? previousClass;
  final String? previousClassName;
  final String? previousClassScorePercentage;
  final String? previousSchoolAttended;
  final String? firstName;
  final String? lastName;
  final String fullName;
  final String? gender;
  final String? photo;
  final String? dateOfBirth;
  final String? adhaarNumber;
  final String? email;
  final String? currentAddress;
  final String? permanentAddress;
  final String? state;
  final String? city;
  final String? zipcode;
  final String? bloodGroup;
  final String? height;
  final String? weight;
  final String? studentHouseId;
  final String? studentCategoryId;
  final String? parentId;
  final String? religion;
  final String? cast;
  final String? bankAccountNumber;
  final String? bankName;
  final String? bankIfscCode;
  final bool isScholarshipRegistered;
  final bool isDayboardingRegistered;
  final String? dayboardingRegisteredDate;
  final bool isTransportRegistered;
  final String? transportRegisteredDate;
  final bool isParkingRegistered;
  final String? parkingRegisteredDate;
  final String? parkingFeeConfigurationId;
  final String? previousSessionPendingAmount;
  final String? leavingType;
  final String? leavingReason;
  final String? leavingDate;
  final String? studentStatus;
  final bool isPreAdmission;
  final String? readmissionInitiatedAt;
  final int pendingFeeAmount;
  final String? createdAt;
  final String? updatedAt;
  final Sessions? session;
  final ClassModel? classData;
  final Section? section;
  final dynamic studentHouse;
  final dynamic studentCategory;
  final StudentParent? parent;
  final StudentParent? parentInfo;
  final dynamic libraryMember;
  final dynamic transportMapping;
  final List<String> siblingIds;
  final List<Sibling> siblings;

  Child({
    required this.id,
    this.admissionDate,
    this.admissionType,
    this.registrationNumber,
    this.admissionNumber,
    this.sessionId,
    this.classId,
    this.sectionId,
    this.rollNumber,
    this.previousClass,
    this.previousClassName,
    this.previousClassScorePercentage,
    this.previousSchoolAttended,
    this.firstName,
    this.lastName,
    required this.fullName,
    this.gender,
    this.photo,
    this.dateOfBirth,
    this.adhaarNumber,
    this.email,
    this.currentAddress,
    this.permanentAddress,
    this.state,
    this.city,
    this.zipcode,
    this.bloodGroup,
    this.height,
    this.weight,
    this.studentHouseId,
    this.studentCategoryId,
    this.parentId,
    this.religion,
    this.cast,
    this.bankAccountNumber,
    this.bankName,
    this.bankIfscCode,
    this.isScholarshipRegistered = false,
    this.isDayboardingRegistered = false,
    this.dayboardingRegisteredDate,
    this.isTransportRegistered = false,
    this.transportRegisteredDate,
    this.isParkingRegistered = false,
    this.parkingRegisteredDate,
    this.parkingFeeConfigurationId,
    this.previousSessionPendingAmount,
    this.leavingType,
    this.leavingReason,
    this.leavingDate,
    this.studentStatus,
    this.isPreAdmission = false,
    this.readmissionInitiatedAt,
    this.pendingFeeAmount = 0,
    this.createdAt,
    this.updatedAt,
    this.session,
    this.classData,
    this.section,
    this.studentHouse,
    this.studentCategory,
    this.parent,
    this.parentInfo,
    this.libraryMember,
    this.transportMapping,
    this.siblingIds = const [],
    this.siblings = const [],
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: _asString(json['id']) ?? '',
      admissionDate: _asString(json['admission_date']),
      admissionType: _asString(json['admission_type']),
      registrationNumber: _asString(json['registration_number']),
      admissionNumber: _asString(json['admission_number']),
      sessionId: _asString(json['session_id']),
      classId: _asString(json['class_id']),
      sectionId: _asString(json['section_id']),
      rollNumber: _asString(json['roll_number']),
      previousClass: _asString(json['previous_class']),
      previousClassName: _asString(json['previous_class_name']),
      previousClassScorePercentage:
      _asString(json['previous_class_score_percentage']),
      previousSchoolAttended: _asString(json['previous_school_attended']),
      firstName: _asString(json['first_name']),
      lastName: _asString(json['last_name']),
      fullName: _asString(json['full_name']) ?? '',
      gender: _asString(json['gender']),
      photo: _asString(json['photo']),
      dateOfBirth: _asString(json['date_of_birth']),
      adhaarNumber: _asString(json['adhaar_number']),
      email: _asString(json['email']),
      currentAddress: _asString(json['current_address']),
      permanentAddress: _asString(json['permanent_address']),
      state: _asString(json['state']),
      city: _asString(json['city']),
      zipcode: _asString(json['zipcode']),
      bloodGroup: _asString(json['blood_group']),
      height: _asString(json['height']),
      weight: _asString(json['weight']),
      studentHouseId: _asString(json['student_house_id']),
      studentCategoryId: _asString(json['student_category_id']),
      parentId: _asString(json['parent_id']),
      religion: _asString(json['religion']),
      cast: _asString(json['cast']),
      bankAccountNumber: _asString(json['bank_account_number']),
      bankName: _asString(json['bank_name']),
      bankIfscCode: _asString(json['bank_ifsc_code']),
      isScholarshipRegistered: _asBool(json['is_scholarship_registered']),
      isDayboardingRegistered: _asBool(json['is_dayboarding_registered']),
      dayboardingRegisteredDate: _asString(json['dayboarding_registered_date']),
      isTransportRegistered: _asBool(json['is_transport_registered']),
      transportRegisteredDate: _asString(json['transport_registered_date']),
      isParkingRegistered: _asBool(json['is_parking_registered']),
      parkingRegisteredDate: _asString(json['parking_registered_date']),
      parkingFeeConfigurationId:
      _asString(json['parking_fee_configuration_id']),
      previousSessionPendingAmount:
      _asString(json['previous_session_pending_amount']),
      leavingType: _asString(json['leaving_type']),
      leavingReason: _asString(json['leaving_reason']),
      leavingDate: _asString(json['leaving_date']),
      studentStatus: _asString(json['student_status']),
      isPreAdmission: _asBool(json['is_pre_admission']),
      readmissionInitiatedAt: _asString(json['readmission_initiated_at']),
      pendingFeeAmount: _asInt(json['pending_fee_amount']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      session: json['session'] != null
          ? Sessions.fromJson(json['session'] as Map<String, dynamic>)
          : null,
      classData: json['class'] != null
          ? ClassModel.fromJson(json['class'] as Map<String, dynamic>)
          : null,
      section: json['section'] != null
          ? Section.fromJson(json['section'] as Map<String, dynamic>)
          : null,
      studentHouse: json['student_house'],
      studentCategory: json['student_category'],
      parent: json['parent'] != null
          ? StudentParent.fromJson(json['parent'] as Map<String, dynamic>)
          : null,
      parentInfo: json['parent_info'] != null
          ? StudentParent.fromJson(
          json['parent_info'] as Map<String, dynamic>)
          : null,
      libraryMember: json['library_member'],
      transportMapping: json['transport_mapping'],
      siblingIds: (json['sibling_ids'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      siblings: (json['siblings'] as List<dynamic>?)
          ?.map((e) => Sibling.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'admission_date': admissionDate,
    'admission_type': admissionType,
    'registration_number': registrationNumber,
    'admission_number': admissionNumber,
    'session_id': sessionId,
    'class_id': classId,
    'section_id': sectionId,
    'roll_number': rollNumber,
    'previous_class': previousClass,
    'previous_class_name': previousClassName,
    'previous_class_score_percentage': previousClassScorePercentage,
    'previous_school_attended': previousSchoolAttended,
    'first_name': firstName,
    'last_name': lastName,
    'full_name': fullName,
    'gender': gender,
    'photo': photo,
    'date_of_birth': dateOfBirth,
    'adhaar_number': adhaarNumber,
    'email': email,
    'current_address': currentAddress,
    'permanent_address': permanentAddress,
    'state': state,
    'city': city,
    'zipcode': zipcode,
    'blood_group': bloodGroup,
    'height': height,
    'weight': weight,
    'student_house_id': studentHouseId,
    'student_category_id': studentCategoryId,
    'parent_id': parentId,
    'religion': religion,
    'cast': cast,
    'bank_account_number': bankAccountNumber,
    'bank_name': bankName,
    'bank_ifsc_code': bankIfscCode,
    'is_scholarship_registered': isScholarshipRegistered,
    'is_dayboarding_registered': isDayboardingRegistered,
    'dayboarding_registered_date': dayboardingRegisteredDate,
    'is_transport_registered': isTransportRegistered,
    'transport_registered_date': transportRegisteredDate,
    'is_parking_registered': isParkingRegistered,
    'parking_registered_date': parkingRegisteredDate,
    'parking_fee_configuration_id': parkingFeeConfigurationId,
    'previous_session_pending_amount': previousSessionPendingAmount,
    'leaving_type': leavingType,
    'leaving_reason': leavingReason,
    'leaving_date': leavingDate,
    'student_status': studentStatus,
    'is_pre_admission': isPreAdmission,
    'readmission_initiated_at': readmissionInitiatedAt,
    'pending_fee_amount': pendingFeeAmount,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'session': session?.toJson(),
    'class': classData?.toJson(),
    'section': section?.toJson(),
    'student_house': studentHouse,
    'student_category': studentCategory,
    'parent': parent?.toJson(),
    'parent_info': parentInfo?.toJson(),
    'library_member': libraryMember,
    'transport_mapping': transportMapping,
    'sibling_ids': siblingIds,
    'siblings': siblings.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// SESSIONS — 🔥 YAHI THA PROBLEM
// ============================================================
class Sessions {
  final String id;
  final String session;
  final String? startDate;
  final String? endDate;
  final String? lastCollectionDate;
  final String? newCollectionDate;
  final bool isActive;
  final bool isCompleted;
  final String? admissionNumberStart;
  final String? receiptPrefix;
  final String? startReceipt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Sessions({
    required this.id,
    required this.session,
    this.startDate,
    this.endDate,
    this.lastCollectionDate,
    this.newCollectionDate,
    this.isActive = false,
    this.isCompleted = false,
    this.admissionNumberStart,
    this.receiptPrefix,
    this.startReceipt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Sessions.fromJson(Map<String, dynamic> json) {
    return Sessions(
      id: _asString(json['id']) ?? '',
      session: _asString(json['session']) ?? '',
      startDate: _asString(json['start_date']),       // ✅ int bhi handle
      endDate: _asString(json['end_date']),           // ✅ int bhi handle
      lastCollectionDate: _asString(json['last_collection_date']),
      newCollectionDate: _asString(json['new_collection_date']),
      isActive: _asBool(json['is_active']),
      isCompleted: _asBool(json['is_completed']),
      admissionNumberStart: _asString(json['admission_number_start']),
      receiptPrefix: _asString(json['receipt_prefix']),
      startReceipt: _asString(json['start_receipt']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'session': session,
    'start_date': startDate,
    'end_date': endDate,
    'last_collection_date': lastCollectionDate,
    'new_collection_date': newCollectionDate,
    'is_active': isActive,
    'is_completed': isCompleted,
    'admission_number_start': admissionNumberStart,
    'receipt_prefix': receiptPrefix,
    'start_receipt': startReceipt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}

// ============================================================
// CLASS MODEL
// ============================================================
class ClassModel {
  final String id;
  final String name;
  final int order;
  final int strength;
  final String? markingScheme;
  final int isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.order,
    required this.strength,
    this.markingScheme,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: _asString(json['id']) ?? '',
      name: _asString(json['name']) ?? '',
      order: _asInt(json['order']),
      strength: _asInt(json['strength']),
      markingScheme: _asString(json['marking_scheme']),
      isActive: _asInt(json['is_active']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'order': order,
    'strength': strength,
    'marking_scheme': markingScheme,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}

// ============================================================
// SECTION
// ============================================================
class Section {
  final String id;
  final String name;
  final String? roomNumber;
  final String? status;
  final int? orderNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Section({
    required this.id,
    required this.name,
    this.roomNumber,
    this.status,
    this.orderNumber,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: _asString(json['id']) ?? '',
      name: _asString(json['name']) ?? '',
      roomNumber: _asString(json['room_number']),
      status: _asString(json['status']),
      orderNumber: _asIntOrNull(json['order_number']),
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'room_number': roomNumber,
    'status': status,
    'order_number': orderNumber,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
  };
}

// ============================================================
// STAFF
// ============================================================
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
  final int? paidLeaves;
  final int? halfLeaves;
  final int? fullDay;
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
  final List<String>? otherDocuments;
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
    List<String>? docs;
    final docsJson = json['other_documents'];
    if (docsJson is List) {
      docs = docsJson.map((e) => e.toString()).toList();
    }
    return Staff(
      id: _asString(json['id']) ?? '',
      sessionId: _asString(json['session_id']),
      type: _asString(json['type']) ?? '',
      staffId: _asString(json['staff_id']) ?? '',
      roleId: _asString(json['role_id']),
      prefix: _asString(json['prefix']),
      maritalStatus: _asString(json['marital_status']),
      firstName: _asString(json['first_name']) ?? '',
      middleName: _asString(json['middle_name']),
      lastName: _asString(json['last_name']),
      email: _asString(json['email']) ?? '',
      fatherName: _asString(json['father_name']),
      motherName: _asString(json['mother_name']),
      nationality: _asString(json['nationality']),
      religion: _asString(json['religion']),
      gender: _asString(json['gender']),
      dateOfBirth: _asString(json['date_of_birth']),
      motherTongue: _asString(json['mother_tongue']),
      joiningDate: _asString(json['joining_date']),
      contact: _asString(json['contact']),
      emergencyContact: _asString(json['emergency_contact']),
      photo: _asString(json['photo']),
      currentAddress: _asString(json['current_address']),
      permanentAddress: _asString(json['permanent_address']),
      qualification: _asString(json['qualification']),
      workExperience: _asString(json['work_experience']),
      note: _asString(json['note']),
      epfNumber: _asString(json['epf_number']),
      basicSalary: _asString(json['basic_salary']),
      contractType: _asString(json['contract_type']),
      workShift: _asString(json['work_shift']),
      location: _asString(json['location']),
      paidLeaves: _asIntOrNull(json['paid_leaves']),
      halfLeaves: _asIntOrNull(json['half_leaves']),
      fullDay: _asIntOrNull(json['full_day']),
      accountTitle: _asString(json['account_title']),
      accountNumber: _asString(json['account_number']),
      bankName: _asString(json['bank_name']),
      ifscCode: _asString(json['ifsc_code']),
      bankBranchName: _asString(json['bank_branch_name']),
      facebookUrl: _asString(json['facebook_url']),
      twitterUrl: _asString(json['twitter_url']),
      linkedinUrl: _asString(json['linkedin_url']),
      instagramUrl: _asString(json['instagram_url']),
      resume: _asString(json['resume']),
      joiningLetter: _asString(json['joining_letter']),
      otherDocuments: docs,
      createdAt: _asString(json['created_at']),
      updatedAt: _asString(json['updated_at']),
      deletedAt: _asString(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
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