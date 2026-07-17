import 'dart:io';

import 'package:school_app/data/data.dart';
import 'package:school_app/domain/domain.dart';

/// Repositories (retrieve data, heavy processing etc..)
class DataRepository extends DomainRepository {
  /// [connectHelper] : A connection helper which will connect to the
  /// remote to get the data.
  DataRepository(this.connectHelper);

  final ConnectHelper connectHelper;

  @override
  void clearData(dynamic key) {
    throw UnimplementedError();
  }

  /// Delete the box
  @override
  void deleteBox() {
    throw UnimplementedError();
  }

  /// returns stored string value
  @override
  String getStringValue(String key) {
    throw UnimplementedError();
  }

  /// store the data
  @override
  void saveValue(dynamic key, dynamic value) {
    throw UnimplementedError();
  }

  /// return bool value
  @override
  bool getBoolValue(String key) => throw UnimplementedError();

  /// Get data from secure storage
  @override
  Future<String> getSecuredValue(String key) async {
    throw UnimplementedError();
  }

  /// Save data in secure storage
  @override
  void saveValueSecurely(String key, String value) {
    throw UnimplementedError();
  }

  /// Delete data from secure storage
  @override
  void deleteSecuredValue(String key) {
    throw UnimplementedError();
  }

  /// Delete all data from secure storage
  @override
  Future<void> deleteAllSecuredValues() async {
    throw UnimplementedError();
  }

  //
  // @override
  // Future<ResponseModel> verifyOtp(
  //     {required bool isLoading,
  //     required bool isNumber,
  //     required String otp,
  //     required String deviceToken,
  //     required bool isForgot,
  //     required String? token,
  //     required email}) async {
  //   var res = await connectHelper.verifyOtp(
  //       isLoading: isLoading,
  //       isNumber: isNumber,
  //       otp: otp,
  //       deviceToken: deviceToken,
  //       isForgot: isForgot,
  //       token: token,
  //       email: email);
  //   return res;
  // }

  // @override
  // Future<ResponseModel> resendNumberOtp(
  //     {required bool isLoading,
  //     String? countryCode,
  //     String? phoneNumber,
  //     required int registrationVia,
  //     required String platformType,
  //     required String deviceToken}) async {
  //   var res = await connectHelper.resendNumberOtp(
  //       isLoading: isLoading,
  //       countryCode: countryCode,
  //       phoneNumber: phoneNumber,
  //       registrationVia: registrationVia,
  //       platformType: platformType,
  //       deviceToken: deviceToken);
  //   return res;
  // }
  // //
  // @override
  // Future<ResponseModel> getS3UploadSignedURL({
  //   required bool isLoading,
  //   required String? directory,
  //   required String? fileName,
  //   required String? token,
  // }) async {
  //   var res = await connectHelper.getS3UploadSignedURL(
  //       isLoading: isLoading,
  //       directory: directory,
  //       fileName: fileName,
  //       token: token);
  //   return res;
  // }
  //
  // @override
  // Future<dynamic> uploadImage({
  //   required bool isLoading,
  //   required String signedUploadUrl,
  //   required File image,
  // }) async {
  //   var res = await connectHelper.uploadImage(
  //       isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
  //   return res;
  // }

  // @override
  // Future<ResponseModel> completeProfile({
  //   required bool isLoading,
  //   required String name,
  //   required String email,
  //   required String password,
  //   required String profileImage,
  //   required String dateOfBirth,
  //   required int gender,
  //   required String genderName,
  //   required String countryCode,
  //   required String phoneNumber,
  //   required int language,
  //   required String token,
  //   required bool isUpdate,
  // }) async {
  //   var res = await connectHelper.completeProfile(
  //       isLoading: isLoading,
  //       name: name,
  //       email: email,
  //       password: password,
  //       profileImage: profileImage,
  //       dateOfBirth: dateOfBirth,
  //       gender: gender,
  //       genderName: genderName,
  //       countryCode: countryCode,
  //       phoneNumber: phoneNumber,
  //       language: language,
  //       token: token,
  //       isUpdate: isUpdate);
  //   return res;
  // }
  //

  // @override
  // Future<ResponseModel> emailOtp(
  //     {required bool isLoading,
  //     required String email,
  //     required String token}) async {
  //   var res = await connectHelper.emailOtp(
  //     isLoading: isLoading,
  //     email: email,
  //     token: token,
  //   );
  //   return res;
  // }
  //
  // @override
  // Future<ResponseModel> phoneOtp(
  //     {required bool isLoading,
  //     required String countryCode,
  //     required String phone,
  //     required String token}) async {
  //   var res = await connectHelper.phoneOtp(
  //     isLoading: isLoading,
  //     phoneNumber: phone,
  //     countryCode: countryCode,
  //     token: token,
  //   );
  //   return res;
  // }
  //
  @override
  Future<ResponseModel> logoutAPI(
      {required bool isLoading,
      required String? token}) async {
    var res = await connectHelper.logoutAPI(
        isLoading: isLoading, token: token);
    return res;
  }

  @override
  Future<ResponseModel> loginApi(
      {required bool isLoading,
      required String password,
        required String loginName,
        required String branchCode}) async {
    var res = await connectHelper.loginApi(
        isLoading: isLoading,
        loginName: loginName,
        branchCode: branchCode,
        password: password);
    return res;
  }

  @override
  Future<ResponseModel> forgotPasswordAPI({required bool isLoading, required String login,
    required String branchCode}) async {
    var res = await connectHelper.forgotPasswordAPI(
      isLoading: isLoading,
      branchCode: branchCode,
      login: login,
    );
    return res;
  }

  @override
  Future<ResponseModel> resendOtpAPI({required bool isLoading, required String login,
    required String branchCode}) async {
    var res = await connectHelper.resendOtpAPI(
      isLoading: isLoading,
      branchCode: branchCode,
      login: login,
    );
    return res;
  }

  @override
  Future<ResponseModel> verifyOtpAPI({required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    var res = await connectHelper.verifyOtpAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
      otp: otp,
    );
    return res;
  }

  @override
  Future<ResponseModel> resetPasswordAPI({required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    var res = await connectHelper.resetPasswordAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
      token: token,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    );
    return res;
  }

  @override
  Future<ResponseModel> getProfileDetailsAPI({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getProfileDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getFeesDetailsAPI({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getFeesDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

@override
  Future<ResponseModel> getTeacherDashboardAPI({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getTeacherDashboardAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getStaffProfileData({required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    var res = await connectHelper.getStaffProfileData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

@override
  Future<ResponseModel> getLateArrivalData({required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var res = await connectHelper.getLateArrivalData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
    return res;
  }

  @override
  Future<ResponseModel> getLeaveStatusData({required bool isLoading,
    required String token,
    required String branchId,
    required String filter,
  }) async {
    var res = await connectHelper.getLeaveStatusData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
    return res;
  }

  @override
  Future<ResponseModel> getAllEvents({required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    var res = await connectHelper.getAllEvents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getMyClassData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getMyClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

 @override
  Future<ResponseModel> getTermClassData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getTermClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }
  @override
  Future<ResponseModel> getTermAttendanceStudents({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getTermAttendanceStudents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }
  @override
  Future<ResponseModel> getExamGroupData({required bool isLoading,
    required String token,
    required String branchId
  }) async {
    var res = await connectHelper.getExamGroupData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
    return res;
  }

@override
  Future<ResponseModel> getTermSectionData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId
  }) async {
    var res = await connectHelper.getTermSectionData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
    );
    return res;
  }

@override
  Future<ResponseModel> getExamTermData({required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId
  }) async {
    var res = await connectHelper.getExamTermData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getMyClassDetailsData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    var res = await connectHelper.getMyClassDetailsData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getStudentListData({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var res = await connectHelper.getStudentListData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
    return res;
  }

@override
  Future<ResponseModel> fetchClassAttendanceReport({required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
    required String date,
  }) async {
    var res = await connectHelper.fetchClassAttendanceReport(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
      date: date,
    );
    return res;
  }

@override
  Future<ResponseModel> getAllStudentList({required bool isLoading,
    required String token,
    required String branchId,
  required String classId,
  required String sectionId,
  }) async {
    var res = await connectHelper.getAllStudentList(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
    return res;
  }

 @override
  Future<ResponseModel> saveAttendance({required bool isLoading,
   required String token,
   required String branchId,
   required Map<String, dynamic> payload
  }) async {
    var res = await connectHelper.saveAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }
  @override
  Future<ResponseModel> updateAttendance({required bool isLoading,
   required String token,
   required String branchId,
   required Map<String, dynamic> payload
  }) async {
    var res = await connectHelper.updateAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  Future<ResponseModel> saveTermAttendance({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    var res = await connectHelper.saveTermAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
    return res;
  }

  @override
  Future<ResponseModel> getClassAttendance({required bool isLoading,
    required String token,
    required String attendanceDate,
    required String branchId,
    required String classId,
    required String sectionId, required int perPage,required int page
  }) async {
    var res = await connectHelper.getClassAttendance(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      attendanceDate: attendanceDate,
      classId: classId,
      sectionId: sectionId,
      perPage: perPage,
      page: page,
    );
    return res;
  }

 @override
  Future<ResponseModel> getInvoiceDetailsAPI({required bool isLoading,
    required String token,
    required String invoiceId, required String branchId,
  }) async {
    var res = await connectHelper.getInvoiceDetailsAPI(
      isLoading: isLoading,
      token: token,
      invoiceId: invoiceId,
      branchId: branchId,
    );
    return res;
  }

}
