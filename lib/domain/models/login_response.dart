// domain/models/login_response.dart
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

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
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
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
  final Auth? auth; // ✅ NEW: Auth object added
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
      branchId: json['branch_id'] as String? ?? '',
      branchName: json['branch_name'] as String? ?? '',
      branchCode: json['branch_code'] as String? ?? '',
      token: json['token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
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
// ✅ NEW: AUTH MODEL (Missing in previous code)
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
      userType: json['user_type'] as String?,
      userId: json['user_id'] as String?,
      studentId: json['student_id'] as String?,
      studentParentId: json['student_parent_id'] as String?,
      staffId: json['staff_id'] as String?,
      mustChangePassword: json['must_change_password'] as bool?,
      nextScreen: json['next_screen'] as String?,
      defaultStudentId: json['default_student_id'] as String?,
      childrenCount: json['children_count'] as int?,
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
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String?,
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
      name: json['name'] as String? ?? '',
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
      id: json['id'] as String? ?? '',
      module: json['module'] as String? ?? '',
      feature: json['feature'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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
      id: json['id'] as String? ?? '',
      studentId: json['student_id'] as String?,
      fatherName: json['father_name'] as String?,
      fatherContact: json['father_contact'] as String?,
      fatherOccupation: json['father_occupation'] as String?,
      fatherAdhaarNumber: json['father_adhaar_number'] as String?,
      fatherEmail: json['father_email'] as String?,
      fatherPhoto: json['father_photo'] as String?,
      motherName: json['mother_name'] as String?,
      motherContact: json['mother_contact'] as String?,
      motherOccupation: json['mother_occupation'] as String?,
      motherAdhaarNumber: json['mother_adhaar_number'] as String?,
      motherEmail: json['mother_email'] as String?,
      motherPhoto: json['mother_photo'] as String?,
      guardianName: json['guardian_name'] as String?,
      guardianRelation: json['guardian_relation'] as String?,
      guardianEmail: json['guardian_email'] as String?,
      guardianContact: json['guardian_contact'] as String?,
      guardianOccupation: json['guardian_occupation'] as String?,
      guardianWhatsappContact: json['guardian_whatsapp_contact'] as String?,
      guardianAddress: json['guardian_address'] as String?,
      guardianPhoto: json['guardian_photo'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
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
// ✅ NEW: SIBLING MODEL (Missing in previous code)
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
      id: json['id'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String?,
      registrationNumber: json['registration_number'] as String?,
      admissionNumber: json['admission_number'] as String?,
      classId: json['class_id'] as String?,
      sectionId: json['section_id'] as String?,
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
// CHILD (Student)
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
  final List<Sibling> siblings; // ✅ Updated from dynamic to Sibling object

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
      id: json['id'] as String? ?? '',
      admissionDate: json['admission_date'] as String?,
      admissionType: json['admission_type'] as String?,
      registrationNumber: json['registration_number'] as String?,
      admissionNumber: json['admission_number'] as String?,
      sessionId: json['session_id'] as String?,
      classId: json['class_id'] as String?,
      sectionId: json['section_id'] as String?,
      rollNumber: json['roll_number'] as String?,
      previousClass: json['previous_class'] as String?,
      previousClassName: json['previous_class_name'] as String?,
      previousClassScorePercentage:
      json['previous_class_score_percentage']?.toString(),
      previousSchoolAttended: json['previous_school_attended'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String? ?? '',
      gender: json['gender'] as String?,
      photo: json['photo'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      adhaarNumber: json['adhaar_number'] as String?,
      email: json['email'] as String?,
      currentAddress: json['current_address'] as String?,
      permanentAddress: json['permanent_address'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
      bloodGroup: json['blood_group'] as String?,
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      studentHouseId: json['student_house_id'] as String?,
      studentCategoryId: json['student_category_id'] as String?,
      parentId: json['parent_id'] as String?,
      religion: json['religion'] as String?,
      cast: json['cast'] as String?,
      bankAccountNumber: json['bank_account_number'] as String?,
      bankName: json['bank_name'] as String?,
      bankIfscCode: json['bank_ifsc_code'] as String?,
      isScholarshipRegistered:
      json['is_scholarship_registered'] as bool? ?? false,
      isDayboardingRegistered:
      json['is_dayboarding_registered'] as bool? ?? false,
      dayboardingRegisteredDate:
      json['dayboarding_registered_date'] as String?,
      isTransportRegistered:
      json['is_transport_registered'] as bool? ?? false,
      transportRegisteredDate:
      json['transport_registered_date'] as String?,
      isParkingRegistered:
      json['is_parking_registered'] as bool? ?? false,
      parkingRegisteredDate: json['parking_registered_date'] as String?,
      parkingFeeConfigurationId:
      json['parking_fee_configuration_id'] as String?,
      previousSessionPendingAmount:
      json['previous_session_pending_amount']?.toString(),
      leavingType: json['leaving_type'] as String?,
      leavingReason: json['leaving_reason'] as String?,
      leavingDate: json['leaving_date'] as String?,
      studentStatus: json['student_status'] as String?,
      isPreAdmission: json['is_pre_admission'] as bool? ?? false,
      readmissionInitiatedAt: json['readmission_initiated_at'] as String?,
      pendingFeeAmount: json['pending_fee_amount'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
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
          [], // ✅ Updated Mapping
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
// SESSION
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
      id: json['id'] as String? ?? '',
      session: json['session'] as String? ?? '',
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      lastCollectionDate: json['last_collection_date'] as String?,
      newCollectionDate: json['new_collection_date'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
      admissionNumberStart: json['admission_number_start'] as String?,
      receiptPrefix: json['receipt_prefix'] as String?,
      startReceipt: json['start_receipt'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      strength: json['strength'] as int? ?? 0,
      markingScheme: json['marking_scheme'] as String?,
      isActive: json['is_active'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      roomNumber: json['room_number'] as String?,
      status: json['status'] as String?,
      orderNumber: json['order_number'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
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
      paidLeaves: json['paid_leaves'] as int?,
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