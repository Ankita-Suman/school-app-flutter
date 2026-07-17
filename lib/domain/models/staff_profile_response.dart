import 'dart:convert';

StaffProfileResponse staffProfileResponseFromJson(String str) =>
    StaffProfileResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String staffProfileResponseToJson(StaffProfileResponse data) =>
    json.encode(data.toJson());

// ========== MAIN RESPONSE ==========
class StaffProfileResponse {
  final bool status;
  final String message;
  final StaffProfileData? data;

  StaffProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory StaffProfileResponse.fromJson(Map<String, dynamic> json) {
    return StaffProfileResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? StaffProfileData.fromJson(json['data'] as Map<String, dynamic>)
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

  bool get isSuccess => status == true;
  bool get hasData => data != null && data!.staff != null;
  String get errorMessage => message.isNotEmpty ? message : 'Something went wrong';
}

// ========== DATA ==========
class StaffProfileData {
  final String id;
  final String username;
  final String email;
  final String roleId;
  final String role;
  final int screenTimeout;
  final bool mustChangePassword;
  final String userType;
  final Staffs? staff;

  StaffProfileData({
    required this.id,
    required this.username,
    required this.email,
    required this.roleId,
    required this.role,
    required this.screenTimeout,
    required this.mustChangePassword,
    required this.userType,
    this.staff,
  });

  factory StaffProfileData.fromJson(Map<String, dynamic> json) {
    return StaffProfileData(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roleId: json['role_id'] as String? ?? '',
      role: json['role'] as String? ?? '',
      screenTimeout: json['screen_timeout'] as int? ?? 0,
      mustChangePassword: json['must_change_password'] as bool? ?? false,
      userType: json['user_type'] as String? ?? '',
      staff: json['staff'] != null
          ? Staffs.fromJson(json['staff'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role_id': roleId,
      'role': role,
      'screen_timeout': screenTimeout,
      'must_change_password': mustChangePassword,
      'user_type': userType,
      'staff': staff?.toJson(),
    };
  }

  bool get hasStaff => staff != null;
}

// ========== STAFF ==========
class Staffs {
  final String id;
  final String staffId;
  final String? photo;
  final String fullName;
  final String? designation;
  final BasicInfo? basicInfo;
  final OtherDetails? otherDetails;

  // Flattened fields for backward compatibility (optional)
  String get type => basicInfo?.roleDetails?.staffType ?? '';
  String get role => basicInfo?.roleDetails?.staffRole ?? '';
  String get firstName => basicInfo?.personalDetails?.firstName ?? '';
  String? get middleName => basicInfo?.personalDetails?.middleName;
  String? get lastName => basicInfo?.personalDetails?.lastName;
  String get email => basicInfo?.contactInfo?.email ?? '';
  String get contact => basicInfo?.contactInfo?.contact ?? '';
  String get gender => basicInfo?.personalDetails?.gender ?? '';
  String get dateOfBirth => basicInfo?.personalDetails?.dateOfBirth ?? '';
  String get joiningDate => basicInfo?.professionalInfo?.joiningDate ?? '';

  Staffs({
    required this.id,
    required this.staffId,
    this.photo,
    required this.fullName,
    this.designation,
    this.basicInfo,
    this.otherDetails,
  });

  factory Staffs.fromJson(Map<String, dynamic> json) {
    return Staffs(
      id: json['id'] as String? ?? '',
      staffId: json['staff_id'] as String? ?? '',
      photo: json['photo'] as String?,
      fullName: json['full_name'] as String? ?? '',
      designation: json['designation'] as String?,
      basicInfo: json['basic_info'] != null
          ? BasicInfo.fromJson(json['basic_info'] as Map<String, dynamic>)
          : null,
      otherDetails: json['other_details'] != null
          ? OtherDetails.fromJson(json['other_details'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'photo': photo,
      'full_name': fullName,
      'designation': designation,
      'basic_info': basicInfo?.toJson(),
      'other_details': otherDetails?.toJson(),
    };
  }

  // ========== HELPER METHODS ==========
  bool get hasPhoto => photo != null && photo!.isNotEmpty;

  String get displayName => fullName.isNotEmpty ? fullName : 'Staff';

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String get genderDisplay {
    final g = gender.toUpperCase();
    switch (g) {
      case 'MALE':
        return 'Male';
      case 'FEMALE':
        return 'Female';
      default:
        return gender;
    }
  }

  String get formattedDateOfBirth {
    try {
      final parts = dateOfBirth.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateOfBirth;
    } catch (e) {
      return dateOfBirth;
    }
  }

  String get formattedJoiningDate {
    try {
      final parts = joiningDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return joiningDate;
    } catch (e) {
      return joiningDate;
    }
  }
}

// ========== BASIC INFO ==========
class BasicInfo {
  final RoleDetails? roleDetails;
  final PersonalDetails? personalDetails;
  final ContactInfo? contactInfo;
  final ProfessionalInfo? professionalInfo;

  BasicInfo({
    this.roleDetails,
    this.personalDetails,
    this.contactInfo,
    this.professionalInfo,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      roleDetails: json['role_details'] != null
          ? RoleDetails.fromJson(json['role_details'] as Map<String, dynamic>)
          : null,
      personalDetails: json['personal_details'] != null
          ? PersonalDetails.fromJson(json['personal_details'] as Map<String, dynamic>)
          : null,
      contactInfo: json['contact_info'] != null
          ? ContactInfo.fromJson(json['contact_info'] as Map<String, dynamic>)
          : null,
      professionalInfo: json['professional_info'] != null
          ? ProfessionalInfo.fromJson(json['professional_info'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_details': roleDetails?.toJson(),
      'personal_details': personalDetails?.toJson(),
      'contact_info': contactInfo?.toJson(),
      'professional_info': professionalInfo?.toJson(),
    };
  }
}

// ========== ROLE DETAILS ==========
class RoleDetails {
  final String staffType;
  final String staffRole;

  RoleDetails({
    required this.staffType,
    required this.staffRole,
  });

  factory RoleDetails.fromJson(Map<String, dynamic> json) {
    return RoleDetails(
      staffType: json['staff_type'] as String? ?? '',
      staffRole: json['staff_role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staff_type': staffType,
      'staff_role': staffRole,
    };
  }
}

// ========== PERSONAL DETAILS ==========
class PersonalDetails {
  final String? prefix;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String? gender;
  final String? dateOfBirth;
  final String? motherTongue;
  final String? nationality;
  final String? religion;
  final String? maritalStatus;
  final String? fatherName;
  final String? motherName;

  PersonalDetails({
    this.prefix,
    required this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.motherTongue,
    this.nationality,
    this.religion,
    this.maritalStatus,
    this.fatherName,
    this.motherName,
  });

  factory PersonalDetails.fromJson(Map<String, dynamic> json) {
    return PersonalDetails(
      prefix: json['prefix'] as String?,
      firstName: json['first_name'] as String? ?? '',
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      motherTongue: json['mother_tongue'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
      maritalStatus: json['marital_status'] as String?,
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'mother_tongue': motherTongue,
      'nationality': nationality,
      'religion': religion,
      'marital_status': maritalStatus,
      'father_name': fatherName,
      'mother_name': motherName,
    };
  }
}

// ========== CONTACT INFO ==========
class ContactInfo {
  final String? email;
  final String? contact;
  final String? emergencyContact;
  final String? currentAddress;
  final String? permanentAddress;

  ContactInfo({
    this.email,
    this.contact,
    this.emergencyContact,
    this.currentAddress,
    this.permanentAddress,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'] as String?,
      contact: json['contact'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      currentAddress: json['current_address'] as String?,
      permanentAddress: json['permanent_address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contact': contact,
      'emergency_contact': emergencyContact,
      'current_address': currentAddress,
      'permanent_address': permanentAddress,
    };
  }
}

// ========== PROFESSIONAL INFO ==========
class ProfessionalInfo {
  final String? joiningDate;
  final String? qualification;
  final String? workExperience;

  ProfessionalInfo({
    this.joiningDate,
    this.qualification,
    this.workExperience,
  });

  factory ProfessionalInfo.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfo(
      joiningDate: json['joining_date'] as String?,
      qualification: json['qualification'] as String?,
      workExperience: json['work_experience'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joining_date': joiningDate,
      'qualification': qualification,
      'work_experience': workExperience,
    };
  }
}

// ========== OTHER DETAILS ==========
class OtherDetails {
  final EmploymentDetails? employmentDetails;
  final LeaveConfiguration? leaveConfiguration;
  final BankAccountInformation? bankAccountInformation;
  final SocialMediaProfiles? socialMediaProfiles;
  final DocumentUploads? documentUploads;

  OtherDetails({
    this.employmentDetails,
    this.leaveConfiguration,
    this.bankAccountInformation,
    this.socialMediaProfiles,
    this.documentUploads,
  });

  factory OtherDetails.fromJson(Map<String, dynamic> json) {
    return OtherDetails(
      employmentDetails: json['employment_details'] != null
          ? EmploymentDetails.fromJson(json['employment_details'] as Map<String, dynamic>)
          : null,
      leaveConfiguration: json['leave_configuration'] != null
          ? LeaveConfiguration.fromJson(json['leave_configuration'] as Map<String, dynamic>)
          : null,
      bankAccountInformation: json['bank_account_information'] != null
          ? BankAccountInformation.fromJson(json['bank_account_information'] as Map<String, dynamic>)
          : null,
      socialMediaProfiles: json['social_media_profiles'] != null
          ? SocialMediaProfiles.fromJson(json['social_media_profiles'] as Map<String, dynamic>)
          : null,
      documentUploads: json['document_uploads'] != null
          ? DocumentUploads.fromJson(json['document_uploads'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employment_details': employmentDetails?.toJson(),
      'leave_configuration': leaveConfiguration?.toJson(),
      'bank_account_information': bankAccountInformation?.toJson(),
      'social_media_profiles': socialMediaProfiles?.toJson(),
      'document_uploads': documentUploads?.toJson(),
    };
  }
}

// ========== EMPLOYMENT DETAILS ==========
class EmploymentDetails {
  final String? epfNumber;
  final String? basicSalary;
  final String? contractType;
  final String? workShift;
  final String? workLocation;

  EmploymentDetails({
    this.epfNumber,
    this.basicSalary,
    this.contractType,
    this.workShift,
    this.workLocation,
  });

  factory EmploymentDetails.fromJson(Map<String, dynamic> json) {
    return EmploymentDetails(
      epfNumber: json['epf_number'] as String?,
      basicSalary: json['basic_salary'] as String?,
      contractType: json['contract_type'] as String?,
      workShift: json['work_shift'] as String?,
      workLocation: json['work_location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'epf_number': epfNumber,
      'basic_salary': basicSalary,
      'contract_type': contractType,
      'work_shift': workShift,
      'work_location': workLocation,
    };
  }
}

// ========== LEAVE CONFIGURATION ==========
class LeaveConfiguration {
  final int? paidLeaves;
  final int? halfLeaves;
  final int? fullDayLeaves;

  LeaveConfiguration({
    this.paidLeaves,
    this.halfLeaves,
    this.fullDayLeaves,
  });

  factory LeaveConfiguration.fromJson(Map<String, dynamic> json) {
    return LeaveConfiguration(
      paidLeaves: json['paid_leaves'] as int?,
      halfLeaves: json['half_leaves'] as int?,
      fullDayLeaves: json['full_day_leaves'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paid_leaves': paidLeaves,
      'half_leaves': halfLeaves,
      'full_day_leaves': fullDayLeaves,
    };
  }
}

// ========== BANK ACCOUNT INFORMATION ==========
class BankAccountInformation {
  final String? accountTitle;
  final String? accountNumber;
  final String? bankName;
  final String? ifscCode;
  final String? bankBranchName;

  BankAccountInformation({
    this.accountTitle,
    this.accountNumber,
    this.bankName,
    this.ifscCode,
    this.bankBranchName,
  });

  factory BankAccountInformation.fromJson(Map<String, dynamic> json) {
    return BankAccountInformation(
      accountTitle: json['account_title'] as String?,
      accountNumber: json['account_number'] as String?,
      bankName: json['bank_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      bankBranchName: json['bank_branch_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_title': accountTitle,
      'account_number': accountNumber,
      'bank_name': bankName,
      'ifsc_code': ifscCode,
      'bank_branch_name': bankBranchName,
    };
  }
}

// ========== SOCIAL MEDIA PROFILES ==========
class SocialMediaProfiles {
  final String? facebookUrl;
  final String? twitterUrl;
  final String? linkedinUrl;
  final String? instagramUrl;

  SocialMediaProfiles({
    this.facebookUrl,
    this.twitterUrl,
    this.linkedinUrl,
    this.instagramUrl,
  });

  factory SocialMediaProfiles.fromJson(Map<String, dynamic> json) {
    return SocialMediaProfiles(
      facebookUrl: json['facebook_url'] as String?,
      twitterUrl: json['twitter_url'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      instagramUrl: json['instagram_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook_url': facebookUrl,
      'twitter_url': twitterUrl,
      'linkedin_url': linkedinUrl,
      'instagram_url': instagramUrl,
    };
  }
}

// ========== DOCUMENT UPLOADS ==========
class DocumentUploads {
  final String? resume;
  final String? joiningLetter;
  final List<String>? otherDocuments;

  DocumentUploads({
    this.resume,
    this.joiningLetter,
    this.otherDocuments,
  });

  factory DocumentUploads.fromJson(Map<String, dynamic> json) {
    List<String>? docs;
    final docsJson = json['other_documents'];
    if (docsJson is List) {
      docs = docsJson.map((e) => e.toString()).toList();
    }
    return DocumentUploads(
      resume: json['resume'] as String?,
      joiningLetter: json['joining_letter'] as String?,
      otherDocuments: docs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resume': resume,
      'joining_letter': joiningLetter,
      'other_documents': otherDocuments,
    };
  }
}