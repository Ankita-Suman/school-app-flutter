import 'dart:io';

import 'package:school_app/data/data.dart';
import 'package:school_app/device/device.dart';
import 'package:school_app/domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Repositories that communicate with the platform e.g. GPS
class DeviceRepository extends DomainRepository {
  /// initialize flutter secure storage
  final _flutterSecureStorage = const FlutterSecureStorage();

  /// initialize the hive box
  Future<void> init({bool isTest = false}) async {
    if (isTest) {
      Hive.init('HIVE_TEST');
      await Hive.openBox<dynamic>('appName'.tr);
    } else {
      await Hive.initFlutter();
      await Hive.openBox<dynamic>(
        'appName'.tr,
      );
    }
  }

  /// Returns the box in which the data is stored.
  Box _getBox() => Hive.box<dynamic>('appName'.tr);

  @override
  void clearData(dynamic key) {
    _getBox().delete(key);
  }

  /// Delete the box
  @override
  void deleteBox() async {
    await GetStorage('appData').remove(DeviceConstants.showLogin);
  }

  /// returns stored string value
  @override
  String getStringValue(String key) {
    var box = _getBox();
    var defaultValue = '';
    if (key == DeviceConstants.localLang) {
      defaultValue = DataConstants.defaultLang;
    }
    String? value = box.get(key, defaultValue: defaultValue) as String? ?? '';
    return value;
  }

  /// store the data
  @override
  void saveValue(dynamic key, dynamic value) {
    _getBox().put(key, value);
  }

  /// return bool value
  @override
  bool getBoolValue(String key) =>
      _getBox().get(key, defaultValue: false) as bool;

  /// Get data from secure storage
  @override
  Future<String> getSecuredValue(String key) async {
    try {
      var value =
          await _flutterSecureStorage.read(key: key, iOptions: _getIOSOption());
      if (value == null || value.isEmpty) {
        value = '';
      }
      return value;
    } catch (error) {
      return '';
    }
  }

  /// Save data in secure storage
  @override
  Future<void>   saveValueSecurely(String key, String value) async {
    await _flutterSecureStorage.write(
        key: key, value: value, iOptions: _getIOSOption());
  }

  IOSOptions _getIOSOption() => const IOSOptions(accountName: 'ePod');

  /// Delete data from secure storage
  @override
  void deleteSecuredValue(String key) {
    _flutterSecureStorage.delete(key: key);
  }

  /// Delete all data from secure storage
  @override
  Future<void> deleteAllSecuredValues() async {
    await _flutterSecureStorage.deleteAll();
  }

  @override
  Future<ResponseModel> loginApi(
      {required bool isLoading,
        required String loginName,
        required String branchCode,
        required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> forgotPasswordAPI({required bool isLoading,
    required String branchCode,
    required String login}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> verifyOtpAPI({required bool isLoading,
    required String branchCode,
    required String login,
    required String otp,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> resetPasswordAPI({  required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> resendOtpAPI({required bool isLoading,
    required String login,
    required String branchCode,
  }) {
    throw UnimplementedError();
  }

    @override
    Future<ResponseModel> getProfileDetailsAPI({required bool isLoading,
      required String token,
      required String branchId, required String studentId,
    }) {
      throw UnimplementedError();
  }
 @override
    Future<ResponseModel> getFeesDetailsAPI({required bool isLoading,
      required String token,
      required String branchId, required String studentId,
    }) {
      throw UnimplementedError();
  }
  @override
    Future<ResponseModel> getAllEvents({required bool isLoading,
      required String token,
      required String branchId, required String studentId,
    }) {
      throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getInvoiceDetailsAPI({required bool isLoading,
    required String token,
    required String invoiceId, required String branchId,
  }) {
    throw UnimplementedError();
  }

  @override
    Future<ResponseModel> logout({required bool isLoading,
      required String token,
    }) {
      throw UnimplementedError();
  }
}
