import 'dart:async';
import 'dart:io';
import 'package:school_app/app/app.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:get/get.dart';

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

  Future<String?> uploadImage({
    required bool isLoading,
    required String signedUploadUrl,
    required File image,
  }) async {
    try {
      await _dataRepository.uploadImage(
          isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
      //if (!res.hasError) {
      final uri = Uri.tryParse(signedUploadUrl);
      if (uri == null) {
        Utility.closeDialog();
        await Utility.showAlertInfoDialog(
            message: 'Could not parse S3 uploadURL',
            title: 'Info',
            onPress: () {
              Get.back<dynamic>();
            });
      }

      return uri?.pathSegments.last;
      // } else {
      //   //Utility.showInfoDialog(res);
      //   return null;
      // }
    } catch (e) {
      await _deviceRepository.uploadImage(
          isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
      return null;
    }
  }

  Future<ResponseModel?> emailOtp(
      {required bool isLoading, required String email}) async {
    var token =
        await _deviceRepository.getSecuredValue(DeviceConstants.accessToken);
    try {
      var res = await _dataRepository.emailOtp(
        isLoading: isLoading,
        email: email,
        token: token,
      );
      if (!res.hasError) {
        return res;
      } else {
        if (res.errorCode == 520) {
          await Utility.showAlertInfoDialog(
              buttonText: 'Ok',
              onPress: () {
                // RouteManagement.goToInstructions();
              },
              title: 'Alert',
              message:
                  'You have exhausted the OTP limit. Please try again later');
        } else {
          Utility.showInfoDialog(res);
        }
        return null;
      }
    } catch (e) {
      await _deviceRepository.emailOtp(
        isLoading: isLoading,
        email: email,
        token: token,
      );
      return null;
    }
  }

  Future<ResponseModel?> phoneOtp(
      {required bool isLoading,
      required String phone,
      required String countryCode}) async {
    var token =
        await _deviceRepository.getSecuredValue(DeviceConstants.accessToken);
    try {
      var res = await _dataRepository.phoneOtp(
        isLoading: isLoading,
        phone: phone,
        countryCode: countryCode,
        token: token,
      );
      if (!res.hasError) {
        return res;
      } else {
        if (res.errorCode == 520) {
          await Utility.showAlertInfoDialog(
              buttonText: 'Ok',
              onPress: () {
                // RouteManagement.goToInstructions();
              },
              title: 'Alert',
              message:
                  'You have exhausted the OTP limit. Please try again later');
        } else {
          Utility.showInfoDialog(res);
        }
        return null;
      }
    } catch (e) {
      await _deviceRepository.phoneOtp(
        isLoading: isLoading,
        phone: phone,
        countryCode: countryCode,
        token: token,
      );
      return null;
    }
  }

  Future<ResponseModel?> logout({
    required bool isLoading,
    required String? deviceToken,
  }) async {
    var token =
        await _deviceRepository.getSecuredValue(DeviceConstants.accessToken);
    try {
      var res = await _dataRepository.logout(
          isLoading: isLoading, token: token, deviceToken: deviceToken);
      if (!res.hasError) {
        return res;
      } else {
        Utility.showInfoDialog(res);
        return null;
      }
    } catch (e) {
      await _deviceRepository.logout(
          isLoading: isLoading, token: token, deviceToken: deviceToken);
      return null;
    }
  }
}
