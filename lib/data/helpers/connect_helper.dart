// coverage:ignore-file
import 'dart:io';

import 'package:school_app/app/app.dart';
import 'package:school_app/data/data.dart';
import 'package:school_app/domain/domain.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio_package;
import 'package:get/get.dart';

/// The helper class which will connect to the world to get the data.
class ConnectHelper {
  ConnectHelper() {
    _init();
  }

  // late Dio dio;
  late dio_package.Dio dio;

  /// Api wrapper initialization
  final apiWrapper = ApiWrapper();

  /// Device info plugin initialization
  final deviceinfo = DeviceInfoPlugin();

  /// To get android device info
  AndroidDeviceInfo? androidDeviceInfo;

  /// To get iOS device info
  IosDeviceInfo? iosDeviceInfo;

  // IosDeviceInfo? iosDeviceInfo;

  // coverage:ignore-start
  /// initialize the andorid device information
  void _init() async {
    if (GetPlatform.isAndroid) {
      androidDeviceInfo = await deviceinfo.androidInfo;
    } else {
      iosDeviceInfo = await deviceinfo.iosInfo;
    }
    dio = dio_package.Dio();
  }

  // coverage:ignore-end

  /// Device id
  String? get deviceId => GetPlatform.isAndroid
      ? androidDeviceInfo?.id
      : iosDeviceInfo?.identifierForVendor;

  /// Device make brand
  String? get deviceMake =>
      GetPlatform.isAndroid ? androidDeviceInfo?.brand : 'Apple';

  /// Device Model
  String? get deviceModel =>
      GetPlatform.isAndroid ? androidDeviceInfo?.model : iosDeviceInfo?.model;

  /// Device is a type of 1 for Android and 2 for iOS
  String get deviceTypeCode => GetPlatform.isAndroid ? '1' : '2';

  /// Device OS
  String get deviceOs => GetPlatform.isAndroid ? 'ANDROID' : 'IOS';

  Future<ResponseModel> getCountryList({
    required bool isLoading,
  }) async {
    var res = await apiWrapper.makeRequest(DataConstants.countryListing,
        Request.get, null, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> register(
      {required bool isLoading,
      required String phoneNumber,
      required String countryCode,
      required String facebookId,
      required String appleId,
      required int language,
      required int registrationVia,
      required String platformType,
      required String deviceToken,
      required String email}) async {
    var data = {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'language': language,
      'registrationVia': registrationVia,
      'platformType': deviceOs,
      'deviceToken': deviceToken,
      'email': email,
      'facebookId': facebookId,
      'appleId': appleId,
    };
    var res = await apiWrapper.makeRequest(DataConstants.register, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> socialAuth(
      {required bool isLoading,
      required String phoneNumber,
      required String countryCode,
      required String facebookId,
      required String appleId,
      required int language,
      required int registrationVia,
      required String platformType,
      required String deviceToken,
      required String email}) async {
    var data = registrationVia == 3
        ? {
            'language': language,
            'registrationVia': registrationVia,
            'platformType': deviceOs,
            'deviceToken': deviceToken,
            'email': email,
            'facebookId': facebookId,
            'userType': 0
          }
        : {
            'language': language,
            'registrationVia': registrationVia,
            'platformType': deviceOs,
            'deviceToken': deviceToken,
            'email': email,
            'appleId': appleId,
            'userType': 0
          };
    print(data);
    var res = await apiWrapper.makeRequest(DataConstants.socialAuth,
        Request.post, data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> login(
      {required bool isLoading,
      required String email,
      required String platformType,
      required String deviceToken,
      required String password}) async {
    var data = {
      'email': email,
      'platformType': deviceOs,
      'deviceToken': deviceToken,
      'password': password
    };
    var res = await apiWrapper.makeRequest(DataConstants.login, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> verifyOtp(
      {required bool isLoading,
      required bool isNumber,
      required String otp,
      required String deviceToken,
      required bool isForgot,
      required String? token,
      required email}) async {
    var data = isForgot
        ? {'token': token, 'otp': otp, 'email': email}
        : {
            'otp': otp,
          };

    var res = await apiWrapper.makeRequest(
        isForgot
            ? DataConstants.verifyForgetPasswordOtp
            : isNumber
                ? DataConstants.verifyOtp
                : DataConstants.verifyEmailOtp,
        Request.put,
        data,
        isLoading,
        isForgot
            ? {'Content-type': 'Application/json'}
            : {
                'Content-type': 'Application/json',
                'authorization': deviceToken
              });
    return res;
  }

  Future<ResponseModel> resendEmailOtp(
      {required bool isLoading,
      required String deviceToken,
      bool? isForgot,
      String? token,
      String? email}) async {
    // var data = {};
    var data = isForgot! ? {'token': token, 'email': email} : {};
    var res = await apiWrapper.makeRequest(
        isForgot
            ? DataConstants.resendForgotPasswordOtp
            : DataConstants.resendEmailOtp,
        Request.put,
        data,
        isLoading,
        isForgot
            ? {'Content-type': 'Application/json'}
            : {
                'Content-type': 'Application/json',
                'authorization': deviceToken
              });
    return res;
  }

  Future<ResponseModel> resendNumberOtp(
      {required bool isLoading,
      String? countryCode,
      String? phoneNumber,
      required int registrationVia,
      required String platformType,
      required String deviceToken}) async {
    var data = {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'registrationVia': registrationVia,
      'platformType': deviceOs,
      'deviceToken': deviceToken,
    };
    var res = await apiWrapper.makeRequest(DataConstants.register, Request.post,
        data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> getS3UploadSignedURL({
    required bool isLoading,
    required String? directory,
    required String? fileName,
    required String? token,
  }) async {
    var data = <String, dynamic>{
      'directory': directory,
      'fileName': fileName,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.getSignedURL,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': '$token'});
    return res;
  }

  Future<dio_package.Response<dynamic>> uploadImage({
    required bool isLoading,
    required String signedUploadUrl,
    required File image,
  }) async {
    final response = await dio.put<dynamic>(
      signedUploadUrl,
      data: image.openRead(),
      options: dio_package.Options(
        headers: <String, dynamic>{
          'Content-Length': image.lengthSync(),
          'Content-Type': 'image/jpeg',
        },
      ),
    );
    return response;
  }

  Future<ResponseModel> completeProfile(
      {required bool isLoading,
      required String name,
      required String email,
      required String password,
      required String profileImage,
      required String dateOfBirth,
      required int gender,
      required String genderName,
      required String countryCode,
      required String phoneNumber,
      required int language,
      required String token,
      required bool isUpdate}) async {
    var data = {
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'genderName': genderName,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'language': language,
    };
    var res = await apiWrapper.makeRequest(
        isUpdate ? DataConstants.updateProfile : DataConstants.completeProfile,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'authorization': token});
    return res;
  }

  Future<ResponseModel> updateProfile({
    required bool isLoading,
    required String location,
    required String latitude,
    required String longitude,
    required String city,
    required String state,
    required String country,
    required String zipCode,
    required String token,
    required num language,
  }) async {
    var data = {
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'language': language
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.updateProfile,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'authorization': token});
    return res;
  }

  Future<ResponseModel> emailOtp({
    required bool isLoading,
    required String email,
    required String token,
  }) async {
    var data = <String, dynamic>{
      'email': email,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.emailOtp,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> phoneOtp({
    required bool isLoading,
    required String phoneNumber,
    required String countryCode,
    required String token,
  }) async {
    var data = <String, dynamic>{
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.phoneNumberOtp,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> logout(
      {required bool isLoading,
      required String? token,
      required String? deviceToken}) async {
    var data = <String, dynamic>{'deviceToken': deviceToken!};
    var res = await apiWrapper.makeRequest(
        DataConstants.logout,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': '$token'});
    return res;
  }

  Future<ResponseModel> changePassword(
      {required bool isLoading,
      required String oldPassword,
      required String newPassword,
      required String token}) async {
    var data = <String, dynamic>{
      'oldPassword': oldPassword,
      'newPassword': newPassword
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.changePassword,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getHomeList({
    required bool isLoading,
    int? languageType,
    String? userId,
  }) async {
    var res = await apiWrapper.makeRequest(
        userId!.isEmpty
            ? languageType == 0
                ? '${DataConstants.homeList}?languageType=$languageType'
                : '${DataConstants.homeList}?languageType=$languageType'
            : '${DataConstants.homeList}?languageType=${languageType == null ? languageType = 1 : languageType = languageType}&userId=$userId',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> getOtp({
    required bool isLoading,
    required String email,
  }) async {
    var data = <String, dynamic>{'email': email};

    var res = await apiWrapper.makeRequest(DataConstants.getEmailForgotOtp,
        Request.put, data, isLoading, {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> resetOtp(
      {required bool isLoading,
      required String password,
      required String token,
      required String email}) async {
    var data = <String, dynamic>{
      'password': password,
      'token': token,
      'email': email,
    };

    var res = await apiWrapper.makeRequest(
        DataConstants.resetPassword, Request.put, data, isLoading, {
      'Content-type': 'Application/json',
    });
    return res;
  }

  Future<ResponseModel> addressList(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.userAddresses,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> userData(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.getUserDetails,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> addAddress(
      {required bool isLoading,
      required String title,
      required String location,
      required String floor,
      required String landmark,
      required String latitude,
      required String longitude,
      required String zipcode,
      required String token,
      required bool isAddressUpdate,
      required String id}) async {
    // var data = <String, dynamic>
    var data = isAddressUpdate
        ? <String, dynamic>{
            'id': id,
            'title': title,
            'location': location,
            'floor': floor,
            'landmark': landmark,
            'latitude': latitude,
            'longitude': longitude,
            'zipcode': zipcode,
          }
        : {
            'title': title,
            'location': location,
            'floor': floor,
            'landmark': landmark,
            'latitude': latitude,
            'longitude': longitude,
            'zipcode': zipcode,
          };
    var res = await apiWrapper.makeRequest(
        DataConstants.userAddresses,
        isAddressUpdate ? Request.put : Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> deleteAddress(
      {required bool isLoading, required String token, String? id}) async {
    var data = {
      'id': id,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.userAddresses,
        Request.delete,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> categoryListing({
    required bool isLoading,
    required String token,
    required int isSalon,
    required int limit,
    required int skip,
    required int type,
    required String lat,
    required String lang,
    required String userId,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.listing}?isSalon=$isSalon&type=$type&skip=$skip&limit=$limit&lat=$lat&long=$lang&userId=$userId',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> subCategoryListing({
    required bool isLoading,
    required String token,
    required String catId,
    required String subCatId,
    required int isSalon,
    required String lat,
    required String lang,
    required String userId,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.categoriesListing}?categoryId=$catId&subcategoryId=$subCatId&isSalon=$isSalon&userId=$userId&lat=$lat&long=$lang',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getRecentSearch(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.recentSearch,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getPopularService(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.popularServices,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> postRecentSearch(
      {required bool isLoading,
      required String token,
      required String search,
      required String providerId}) async {
    var data = <String, dynamic>{};
    providerId.isNotEmpty
        ? data = <String, dynamic>{
            'search': search,
            'providerId': providerId,
          }
        : data = <String, dynamic>{
            'search': search,
          };
    var res = await apiWrapper.makeRequest(
        DataConstants.recentSearch,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> deleteRecentSearch(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.recentSearch,
        Request.delete,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getRecentlyViewed(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.recentlyViewed,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> search({
    required bool isLoading,
    required String token,
    required String search,
    required int isSalon,
    required String lat,
    required String lang,
    required String userId,
  }) async {
    var encoded = search.contains('&') ? Uri.encodeComponent(search) : search;

    var res = await apiWrapper.makeRequest(
        '${DataConstants.search}?search=$encoded&isSalon=$isSalon&lat=$lat&long=$lang&userId=$userId',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> topTenSearch(
      {required bool isLoading, required String token}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.topTenSearched,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> suggestions(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.suggestions}?search=$search',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> priceRange(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) async {
    var encoded = search.isNotEmpty ? Uri.encodeComponent(search) : '';

    var res = await apiWrapper.makeRequest(
        '${DataConstants.priceRange}?search=$encoded&isSalon=$isSalon',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }


  Future<ResponseModel> getDetails(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String search,
      required int language,
      required int isSalon,
      String? userId}) async {
    // var name = 'Glow Spa \& Salon';

    var encoded = search.isNotEmpty ? Uri.encodeComponent(search) : '';

    var res = await apiWrapper.makeRequest(
        search.isNotEmpty
            ? userId!.isNotEmpty
                ? '${DataConstants.serviceProviderDetail}?serviceProviderId=$providerId&search=$encoded&languageType=$language&isSalon=$isSalon&userId=$userId'
                : '${DataConstants.serviceProviderDetail}?serviceProviderId=$providerId&search=$encoded&languageType=$language&isSalon=$isSalon'
            : userId!.isNotEmpty
                ? '${DataConstants.serviceProviderDetail}?serviceProviderId=$providerId&languageType=$language&isSalon=$isSalon&userId=$userId'
                : '${DataConstants.serviceProviderDetail}?serviceProviderId=$providerId&languageType=$language&isSalon=$isSalon',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getServices(
      {required bool isLoading,
      required String token,
      required String providerId,
      required int isSalon,
      String? userId}) async {
    var languageType = 1;
    var skip = 0;
    var limit = 50;
    var res = await apiWrapper.makeRequest(
        // userId!.isNotEmpty
        //     ?
        '${DataConstants.getCategoryListing}?serviceProviderId=$providerId&isSalon=$isSalon&languageType=$languageType&skip=$skip&limit=$limit',
        // : '${DataConstants.getCategoryListing}?serviceProviderId=$providerId&isSalon=$isSalon&languageType=$languageType&skip=$skip&limit=$limit',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> searchService(
      {required bool isLoading,
      required String token,
      required String search,
      required String serviceProviderId,
      required int language}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getSearchServices}?serviceProviderId=$serviceProviderId&search=$search&languageType=$language',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getMemberList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String serviceId}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getMembers}?serviceProviderId=$providerId&serviceId=$serviceId',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> addService(
      {required String token,
      required bool isLoading,
      required String providerId,
      required List<Map<String, dynamic>> services,
      required bool isUpdate,
      required String? bookingId,
      required int? isSalon,
      required String isRebookedUsingId}) async {
    var data = isUpdate
        ? services.isNotEmpty
            ? {
                'id': bookingId,
                'services': services,
                'providerId': providerId,
                'isSalon': isSalon,
              }
            : {
                'id': bookingId,
                'providerId': providerId,
                'isSalon': isSalon,
              }
        : {
            'services': services,
            'providerId': providerId,
            'isSalon': isSalon,
            'isRebookedUsingId': isRebookedUsingId
          };
    print(data);
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        isUpdate ? Request.put : Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> deleteService(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId}) async {
    var data = <String, dynamic>{
      'bookingId': bookingId,
      'serviceId': serviceId,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.bookingService,
        Request.delete,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateMember(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId,
      required String memberId}) async {
    var data = <String, dynamic>{
      'bookingId': bookingId,
      'serviceId': serviceId,
      'memberId': memberId,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.bookingService,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> clearCart(
      {required String token,
      required bool isLoading,
      required String bookingId}) async {
    var data = <String, dynamic>{'id': bookingId};

    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.delete,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getSlot}?bookingId=$bookingId&date=$date&timeZone=$dateTimeWithOffset',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    print(res);
    return res;
  }

  Future<ResponseModel> getBookingData(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String couponId}) async {
    var res = await apiWrapper.makeRequest(
        couponId.isEmpty
            ? '${DataConstants.booking}/$bookingId'
            : '${DataConstants.booking}/$bookingId?couponId=$couponId',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> couponList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String total}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getOfferCoupons}?serviceProviderId=$providerId&minAmount=$total',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateAddress(
      {required String token,
      required isLoading,
      required String addressId,
      required String bookingId,
      required String providerId,
      required int isSalon}) async {
    var data = <String, dynamic>{
      'id': bookingId,
      'addressId': addressId,
      'providerId': providerId,
      'isSalon': isSalon
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateAddresses(
      {required String token,
      required isLoading,
      required String dateTime,
      required String bookingId,
      required String providerId,
      required String selectedTime,
      required int isSalon,
      required String dateTimeWithOffset}) async {
    var data = dateTimeWithOffset.isNotEmpty
        ? <String, dynamic>{
            'id': bookingId,
            'slotDate': dateTime,
            'providerId': providerId,
            'slotTime': selectedTime,
            'isSalon': isSalon,
            'timeZone': dateTimeWithOffset,
          }
        : <String, dynamic>{
            'id': bookingId,
            'slotDate': dateTime,
            'providerId': providerId,
            'slotTime': selectedTime,
            'isSalon': isSalon,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> checkCouponCode(
      {required String token,
      required isLoading,
      required String couponCode,
      required String providerId,
      required String total}) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.verifyCoupon}?serviceProviderId=$providerId&coupon=$couponCode&minAmount=$total',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> applyCoupon(
      {required String token,
      required bool isLoading,
      required String couponId,
      required String providerId,
      required String bookingId,
      required int isSalon}) async {
    var data = <String, dynamic>{
      'id': bookingId,
      'couponId': couponId,
      'providerId': providerId,
      'isSalon': isSalon,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateInstruction(
      {required String token,
      required bool isLoading,
      required String instruction,
      required String providerId,
      required String bookingId,
      required int isSalon}) async {
    var data = <String, dynamic>{
      'id': bookingId,
      'specialInstruction': instruction,
      'providerId': providerId,
      'isSalon': isSalon
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> confirmBooking(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String bookingId,
      required int isSalon,
      required num discount,
      required num subTotal,
      required num serviceCharges,
      required num total,
      required num couponDiscount,
      required String dateTimeWithOffset}) async {
    var data = dateTimeWithOffset.isNotEmpty
        ? <String, dynamic>{
            'id': bookingId,
            'isSalon': isSalon,
            'providerId': providerId,
            'discount': discount,
            'subTotal': subTotal,
            'serviceCharges': serviceCharges,
            'total': total,
            'couponDiscount': couponDiscount,
            'timeZone': dateTimeWithOffset,
          }
        : <String, dynamic>{
            'id': bookingId,
            'isSalon': isSalon,
            'providerId': providerId,
            'discount': discount,
            'subTotal': subTotal,
            'serviceCharges': serviceCharges,
            'total': total,
            'couponDiscount': couponDiscount,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.booking,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> appointmentList({
    required String token,
    required bool isLoading,
    required int activeOrPast,
  }) async {
    var data = <String, dynamic>{};
    var skip = 0;
    var limit = 100;
    var res = await apiWrapper.makeRequest(
        '${DataConstants.appointments}?activeOrPast=$activeOrPast&skip=$skip&limit=$limit',
        Request.get,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> appointmentListWithPagination({
    required String token,
    required String search,
    required bool isLoading,
    required int activeOrPast,
    required num skip,
    required num limit,
  }) async {
    var res = await apiWrapper.makeRequest(
        search.isNotEmpty
            ? activeOrPast == 0
                ? '${DataConstants.appointments}?skip=$skip&limit=$limit&search=$search'
                : '${DataConstants.appointments}?activeOrPast=$activeOrPast&skip=$skip&limit=$limit&search=$search'
            : activeOrPast == 0
                ? '${DataConstants.appointments}?skip=$skip&limit=$limit'
                : '${DataConstants.appointments}?activeOrPast=$activeOrPast&skip=$skip&limit=$limit',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateFavorite({
    required String token,
    required bool isLoading,
    required String serviceProviderId,
    required num isFavorite,
  }) async {
    var data = <String, dynamic>{
      'serviceProviderId': serviceProviderId,
      'isFavorite': '$isFavorite'
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.updateFav,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getFavorites({
    required String token,
    required bool isLoading,
    required num skip,
    required num limit,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getFavs}?skip=$skip&limit=$limit',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getRatingAndReview({
    required String token,
    required bool isLoading,
    required num skip,
    required num limit,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.getUserRatingAndReview}?skip=$skip&limit=$limit',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> reportReview(
      {required String token,
      required bool isLoading,
      required String userServicesProviderRatingId,
      required String reportId,
      required String reportReason,
      required String description}) async {
    var data = reportId.isNotEmpty
        ? <String, dynamic>{
            'userServicesProviderRatingId': userServicesProviderRatingId,
            'reportId': reportId,
            'reportReason': reportReason,
            'description': description,
          }
        : <String, dynamic>{
            'userServicesProviderRatingId': userServicesProviderRatingId,
            'reportReason': reportReason,
            'description': description,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.reviewAboutYourReport,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> postHelpMessage({
    required String token,
    required String message,
    required String id,
    required bool isLoading,
  }) async {
    var data = {'message': message, 'userHelpId': id};
    var res = await apiWrapper.makeRequest(
        DataConstants.helpChat,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getHelpDetail({
    required String token,
    required String id,
    required bool isLoading,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.chatDetail}?id=$id',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> appointmentFilter({
    required String token,
    required bool isLoading,
    required int activeOrPast,
    required String startDate,
    required String endDate,
    required String search,
    required int dateFilter,
    required int locationFilter,
    required List<int> status,
  }) async {
    var data = '${DataConstants.appointments}?activeOrPast=$activeOrPast';
    if (dateFilter == 4) {
      data = '$data&startDate=$startDate&endDate=$endDate';
    }
    if (dateFilter != -1) {
      data = '$data&dateFilter=$dateFilter';
    }
    if (status.isNotEmpty) {
      data = '$data&status=$status';
    }
    if (locationFilter != -1) {
      data = '$data&locationFilter=$locationFilter';
    }
    if (search.isNotEmpty) {
      data = '$data&search=$search';
    }
    var res = await apiWrapper.makeRequest(data, Request.get, null, isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> appointmentDetail(
      {required String token,
      required bool isLoading,
      required String id}) async {
    var data = '${DataConstants.appointments}/$id';

    var res = await apiWrapper.makeRequest(data, Request.get, null, isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> deleteAccount({
    required String token,
    required String reason,
    required bool isLoading,
  }) async {
    var data = {'deleteReason': reason};
    var res = await apiWrapper.makeRequest(
        DataConstants.deleteAccount,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> deleteAccountVerifyOtp({
    required String token,
    required String otp,
    required bool isLoading,
  }) async {
    var data = {'otp': otp};
    var res = await apiWrapper.makeRequest(
        DataConstants.deleteAccountVerifyOtp,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getNewSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset,
      required List<String> memberIds}) async {
    var res = await apiWrapper.makeRequest(
        memberIds.isNotEmpty
            ? '${DataConstants.appointmentTime}?bookingId=$bookingId&date=$date&timeZone=$dateTimeWithOffset&memberIds=$memberIds'
            : '${DataConstants.appointmentTime}?bookingId=$bookingId&date=$date&timeZone=$dateTimeWithOffset',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> rescheduleAppointment(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String slotTime,
      required String rescheduleSlotDate,
      required String dateTimeWithOffset,
      required List<Map<String, dynamic>> updatedMembers}) async {
    var data = <String, dynamic>{
      'id': bookingId,
      'slotTime': slotTime,
      'rescheduleSlotDate': rescheduleSlotDate,
      'timeZone': dateTimeWithOffset,
      'updatedMembers': updatedMembers,
    };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.reschedule,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getSubjectsForHelp({
    required String token,
    required bool isLoading,
  }) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.subjectsForHelp,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> postQuery({
    required String token,
    required String bookingId,
    required String subjectId,
    required String description,
    required String subject,
    required bool isLoading,
  }) async {
    var data = {
      'bookingId': bookingId,
      'subjectId': subjectId,
      'description': description,
      'queryRaisedBy': '0',
      'subject': subject
    };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.postQuery,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> getPostedQueries({
    required num skip,
    required num limit,
    required dynamic filter,
    required String search,
    required String token,
    required bool isLoading,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.postQuery}?skip=$skip&limit=$limit&filter=$filter&search=$search',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> acceptOrDecline({
    required String token,
    required bool isLoading,
    required String id,
    required int status,
    required String declineReason,
  }) async {
    var data = declineReason.isNotEmpty
        ? <String, dynamic>{
            'id': id,
            'status': status,
            'declineReason': declineReason,
          }
        : <String, dynamic>{
            'id': id,
            'status': status,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.acceptOrDecline,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> cancellationReview({
    required String token,
    required bool isLoading,
    required String id,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.cancellationReview}?id=$id',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> requestRefund(
      {required String token,
      required bool isLoading,
      required String id,
      required String refundAmout,
      required String cancellationReason,
      required String cancellationCharge}) async {
    var data = cancellationReason.isNotEmpty
        ? <String, dynamic>{
            'id': id,
            'refundAmout': refundAmout,
            'cancellationCharge': cancellationCharge,
            'cancellationReason': cancellationReason,
          }
        : <String, dynamic>{
            'id': id,
            'refundAmout': refundAmout,
            'cancellationCharge': cancellationCharge,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.cancel,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> rateAndReview(
      {required String token,
      required bool isLoading,
      required String id,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) async {
    var data = review.isNotEmpty
        ? <String, dynamic>{
            'id': id,
            'rating': rating,
            'review': review,
            'serviceProviderId': serviceProviderId,
            'servicesRating': servicesRating,
          }
        : <String, dynamic>{
            'id': id,
            'rating': rating,
            'serviceProviderId': serviceProviderId,
            'servicesRating': servicesRating,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.rateAndReview,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> userServicesProviderRatingId(
      {required String token,
      required bool isLoading,
      required String id,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) async {
    var data = review.isNotEmpty
        ? <String, dynamic>{
            'id': id,
            'rating': rating,
            'review': review,
            'serviceProviderId': serviceProviderId,
            'servicesRating': servicesRating,
          }
        : <String, dynamic>{
            'id': id,
            'rating': rating,
            'serviceProviderId': serviceProviderId,
            'servicesRating': servicesRating,
          };
    print(data);
    var res = await apiWrapper.makeRequest(
        DataConstants.rateAndReview,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> salonRateReview({
    required String token,
    required bool isLoading,
    required String id,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.salonRateReview}?serviceProviderId=$id',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> reportingReason(
      {required String token, required bool isLoading}) async {
    var res = await apiWrapper.makeRequest(
        DataConstants.reportingReason,
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> updateNotification(
      {required String token,
      required bool isLoading,
      required int status}) async {
    var data = <String, dynamic>{
      'status': status,
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.notificationsSetting,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> discoverList(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token,
      required int? limit}) async {
    var res = await apiWrapper.makeRequest(
        // DataConstants.discover,
        userId!.isNotEmpty ?
        '${DataConstants.discover}?userId=$userId&homeServiceAvailable=$homeServiceAvailable&lng=$lng&lat=$lat&skip=${0}&limit=${limit == 5 ? limit : 200}':
        '${DataConstants.discover}?homeServiceAvailable=$homeServiceAvailable&lng=$lng&lat=$lat&skip=${0}&limit=${limit == 5 ? limit : 200}',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json'});
    return res;
  }

  Future<ResponseModel> offersList(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token}) async {
    var res = await apiWrapper.makeRequest(
        // DataConstants.discover,
        '${DataConstants.offersList}?userId=$userId&homeServiceAvailable=$homeServiceAvailable&lng=$lng&lat=$lat&skip=${0}&limit=${200}',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> bestDeal(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token}) async {
    var res = await apiWrapper.makeRequest(
        // DataConstants.discover,
        '${DataConstants.bestDeal}?userId=$userId&homeServiceAvailable=$homeServiceAvailable&lng=$lng&lat=$lat&skip=${0}&limit=${200}',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> notificationList(
      {required bool isLoading,
      required String token,
      required num skip,
      required num limit}) async {
    var res = await apiWrapper.makeRequest(
        // DataConstants.discover,
        '${DataConstants.notifications}?skip=$skip&limit=$limit',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> markReadNotification(
      {required bool isLoading,
      required String id,
      required bool isAllRead,
      required String token}) async {
    var data = isAllRead
        ? <String, dynamic>{
            'status': 1,
          }
        : <String, dynamic>{'status': 1, 'id': id};
    var res = await apiWrapper.makeRequest(
        DataConstants.notificationsRead,
        Request.put,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> sendUserMessage(
      {required bool isLoading,
      required String name,
      required String email,
      required String title,
      required String token,
      required String phoneNumber,
      required String message}) async {
    var data = <String, dynamic>{
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'title': title,
      'message': message
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.contactToAdmin,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> giftCartList({
    required bool isLoading,
    required String deviceToken,
  }) async {
    var res = await apiWrapper.makeRequest(
        '${DataConstants.giftCards}?skip=${0}&limit=${100}',
        Request.get,
        null,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': deviceToken});
    return res;
  }

  Future<ResponseModel> buyGiftCards(
      {required bool isLoading,
      required String name,
      required String email,
      required String amount,
      required String message,
      required String token}) async {
    var data = <String, dynamic>{
      'name': name,
      'email': email,
      'message': message,
      'amount': int.parse(amount),
      'walletAmountUsed': 0,
      'paymentType': 2
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.giftCards,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }

  Future<ResponseModel> redeemGiftCard(
      {required bool isLoading,
      required String giftCardId,
      required String code,
      required String pin,
      required String token}) async {
    var data = <String, dynamic>{
      'code': code,
      'pin': pin,
      'giftCardId': giftCardId
    };
    var res = await apiWrapper.makeRequest(
        DataConstants.giftCardRedeem,
        Request.post,
        data,
        isLoading,
        {'Content-type': 'Application/json', 'Authorization': token});
    return res;
  }
}
