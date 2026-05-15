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
