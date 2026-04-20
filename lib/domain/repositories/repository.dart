import 'dart:async';
import 'package:school_app/app/app.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/models/profile_response.dart';

import '../models/forgot_password_model.dart';

/// The main repository which will get the data from [DeviceRepository] or the
/// [DataRepository].
class Repository {
  /// [_deviceRepository] : the local repository.
  /// [_dataRepository] : the data repository like api and all.
  Repository(this._deviceRepository, this._dataRepository);

  final DeviceRepository _deviceRepository;
  final DataRepository _dataRepository;

  /// Clear data from local storage for [key].
  void clearData(dynamic key) {
    try {
      _deviceRepository.clearData(
        key,
      );
    } catch (_) {
      _dataRepository.clearData(
        key,
      );
    }
  }

  /// Get the string value for the [key].
  ///
  /// [key] : The key whose value is needed.
  String getStringValue(String key) {
    try {
      return _deviceRepository.getStringValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getStringValue(
        key,
      );
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveValue(dynamic key, dynamic value) {
    try {
      _deviceRepository.saveValue(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValue(
        key,
        value,
      );
    }
  }

  /// Get the bool value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getBoolValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the stored value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getStoredValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the secure value for the [key].
  /// [key] : The key whose value is needed.
  Future<String> getSecureValue(String key) {
    try {
      return _deviceRepository.getSecuredValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getSecuredValue(
        key,
      );
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveSecureValue(String key, String value) async {
    try {
      _deviceRepository.saveValueSecurely(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValueSecurely(
        key,
        value,
      );
    }
  }

  /// Clear data from secure storage for [key].
  void deleteSecuredValue(String key) {
    try {
      _deviceRepository.deleteSecuredValue(
        key,
      );
    } catch (_) {
      _dataRepository.deleteSecuredValue(
        key,
      );
    }
  }

  /// Clear all data from secure storage .
  void deleteAllSecuredValues() {
    try {
      _deviceRepository.deleteAllSecuredValues();
    } catch (_) {
      _dataRepository.deleteAllSecuredValues();
    }
  }

  // Future<String?> uploadImage({
  //   required bool isLoading,
  //   required String signedUploadUrl,
  //   required File image,
  // }) async {
  //   try {
  //     await _dataRepository.uploadImage(
  //         isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
  //     //if (!res.hasError) {
  //     final uri = Uri.tryParse(signedUploadUrl);
  //     if (uri == null) {
  //       Utility.closeDialog();
  //       await Utility.showAlertInfoDialog(
  //           message: 'Could not parse S3 uploadURL',
  //           title: 'Info',
  //           onPress: () {
  //             Get.back<dynamic>();
  //           });
  //     }
  //
  //     return uri?.pathSegments.last;
  //     // } else {
  //     //   //Utility.showInfoDialog(res);
  //     //   return null;
  //     // }
  //   } catch (e) {
  //     await _deviceRepository.uploadImage(
  //         isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
  //     return null;
  //   }
  // }

  Future<LoginResponse?> loginApi(
      {required bool isLoading, required String loginName,
        required String password,
        required String branchCode}) async {
    try {
      var res = await _dataRepository.loginApi(isLoading: isLoading, loginName: loginName, password: password, branchCode: branchCode, );
      if (!res.hasError) {
        var data = loginResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.loginApi(isLoading: isLoading, loginName: loginName, password: password,branchCode: branchCode);
      return null;
    }
  }

  Future<ForgotPasswordResponse?> forgotPasswordAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) async {
    try {
      var res = await _dataRepository.forgotPasswordAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      if (!res.hasError) {
        var data = forgotPasswordResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.forgotPasswordAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      return null;
    }
  }

  Future<ForgotPasswordResponse?> resendOtpAPI({
    required bool isLoading,
    required String branchCode,
    required String login,
  }) async {
    try {
      var res = await _dataRepository.resendOtpAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      if (!res.hasError) {
        var data = forgotPasswordResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.resendOtpAPI(
        isLoading: isLoading,
        branchCode: branchCode,
        login: login,
      );
      return null;
    }
  }

  Future<OtpVerifyResponse?> verifyOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    try {
      var res = await _dataRepository.verifyOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        otp: otp,
      );
      if (!res.hasError) {
        var data = otpVerifyResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.verifyOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        otp: otp,
      );
      return null;
    }
  }

 Future<ResetPasswordResponse?> resetPasswordAPI({
   required bool isLoading,
   required String login,
   required String branchCode,
   required String token,
   required String newPassword,
   required String passwordConfirmation,
  }) async {
    try {
      var res = await _dataRepository.resetPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      if (!res.hasError) {
        var data = resetResponseFromJson(res.data);
        return data;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.resetPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      return null;
    }
  }

  Future<ProfileResponse?> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    try {
      var res = await _dataRepository.getProfileDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      if (!res.hasError && res.data != null) {
        return profileResponseFromJson(res.data);
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.getProfileDetailsAPI(
        isLoading: isLoading,
        token: token,
        branchId: branchId,
      );
      return null;
    }
  }

  Future<ResponseModel?> logoutAPI({
    required bool isLoading,
  }) async {
    var token =
        await _deviceRepository.getSecuredValue(DeviceConstants.accessToken);
    try {
      var res = await _dataRepository.logoutAPI(
          isLoading: isLoading, token: token);
      if (!res.hasError) {
        return res;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.logout(
          isLoading: isLoading, token: token, );
      return null;
    }
  }
}
