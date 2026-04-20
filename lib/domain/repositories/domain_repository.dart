import 'dart:io';

import 'package:school_app/domain/models/response_model.dart';

/// Abstract classes that define functionality for data and device layers.
///
/// Will be ignored for test since all are static values and would not change.
abstract class DomainRepository {
  /// Get the string value for the [key].
  /// [value] : The value which needs to be saved.
  void saveValue(dynamic key, dynamic value);

  /// Clear data from local storage for [key].
  void clearData(dynamic key);

  /// Delete box
  void deleteBox();

  /// Get stored value
  String getStringValue(String key);

  /// Get the boolean value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getBoolValue(String key);

  /// [key] : The key whose value is needed.
  Future<String> getSecuredValue(String key);

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved in secure storage.
  /// [value] : The value which needs to be saved.
  void saveValueSecurely(String key, String value);

  /// Clear data from secure storage for [key].
  void deleteSecuredValue(String key);

  /// Remove all data from secure storage.
  Future<void> deleteAllSecuredValues();

  Future<ResponseModel> loginApi({required bool isLoading,
    required String loginName,
    required String password,
    required String branchCode});


  // Future<ResponseModel> verifyOtp(
  //     {required bool isLoading,
  //     required bool isNumber,
  //     required String otp,
  //     required String deviceToken,
  //     required bool isForgot,
  //     required String? token,
  //     required email});
  //
  // Future<ResponseModel> resendEmailOtp(
  //     {required bool isLoading,
  //     required String deviceToken,
  //     bool? isForgot,
  //     String? token});
  //
  // Future<ResponseModel> resendNumberOtp(
  //     {required bool isLoading,
  //     String? countryCode,
  //     String? phoneNumber,
  //     required int registrationVia,
  //     required String platformType,
  //     required String deviceToken});

  // Future<ResponseModel> getS3UploadSignedURL({
  //   required bool isLoading,
  //   required String? directory,
  //   required String? fileName,
  //   required String? token,
  // });

  // Future<dynamic> uploadImage({
  //   required bool isLoading,
  //   required String signedUploadUrl,
  //   required File image,
  // });
  //
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
  // });

  // Future<ResponseModel> updateProfile({
  //   required bool isLoading,
  //   required String location,
  //   required String latitude,
  //   required String longitude,
  //   required String city,
  //   required String state,
  //   required String country,
  //   required String zipCode,
  //   required String token,
  //   required num language,
  // });
  //
  // Future<ResponseModel> emailOtp(
  //     {required bool isLoading, required String email, required String token});
  //
  // Future<ResponseModel> phoneOtp(
  //     {required bool isLoading,
  //     required String countryCode,
  //     required String phone,
  //     required String token});

  // Future<ResponseModel> logout(
  //     {required bool isLoading,
  //     required String? token,
  //     required String? deviceToken});
  //
  //
  //
  // Future<ResponseModel> changePassword(
  //     {required bool isLoading,
  //     required String oldPassword,
  //     required String newPassword,
  //     required String token});
  //
  // Future<ResponseModel> resetOtp(
  //     {required bool isLoading,
  //     required String password,
  //     required String token,
  //     required String email});

}
