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
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
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
      user: User.fromJson(json['user']),
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
  final String? studentId;
  final String? studentParentId;
  final String? staffId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Role role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    this.studentId,
    this.studentParentId,
    this.staffId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roleId: json['role_id'] as String? ?? '',
      studentId: json['student_id'] as String?,
      studentParentId: json['student_parent_id'] as String?,
      staffId: json['staff_id'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      role: Role.fromJson(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role_id': roleId,
      'student_id': studentId,
      'student_parent_id': studentParentId,
      'staff_id': staffId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'role': role.toJson(),
    };
  }
}
class Role {
  final String id;
  final String name;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => Permission.fromJson(e))
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
  final String createdAt;
  final String updatedAt;
  final PermissionPivot pivot;

  Permission({
    required this.id,
    required this.module,
    required this.feature,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String? ?? '',
      module: json['module'] as String? ?? '',
      feature: json['feature'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      pivot: PermissionPivot.fromJson(json['pivot']),
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
  final String createdAt;
  final String updatedAt;

  PermissionPivot({
    required this.roleId,
    required this.permissionId,
    required this.hasViewPermission,
    required this.hasCreatePermission,
    required this.hasEditPermission,
    required this.hasDeletePermission,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PermissionPivot.fromJson(Map<String, dynamic> json) {
    return PermissionPivot(
      roleId: json['role_id'] as String? ?? '',
      permissionId: json['permission_id'] as String? ?? '',
      hasViewPermission: json['has_view_permission'] as int? ?? 0,
      hasCreatePermission: json['has_create_permission'] as int? ?? 0,
      hasEditPermission: json['has_edit_permission'] as int? ?? 0,
      hasDeletePermission: json['has_delete_permission'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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
