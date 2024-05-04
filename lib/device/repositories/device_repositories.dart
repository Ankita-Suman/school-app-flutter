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
  void saveValueSecurely(String key, String value) async {
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
  Future<ResponseModel> countryList({required bool isLoading}) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> giftCartList({
    required bool isLoading,
    required String deviceToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> register(
      {required bool isLoading,
      required String phoneNumber,
      required String countryCode,
      required int language,
      required String facebookId,
      required String appleId,
      required int registrationVia,
      required String platformType,
      required String deviceToken,
      required String email}) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> verifyOtp(
      {required bool isLoading,
      required bool isNumber,
      required String otp,
      required String deviceToken,
      required bool isForgot,
      required String? token,
      required email}) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> resendEmailOtp(
      {required bool isLoading,
      required String deviceToken,
      bool? isForgot,
      String? token,
      String? email}) async {
    throw UnimplementedError();
  }

  @override
  resendNumberOtp(
      {required bool isLoading,
      String? countryCode,
      String? phoneNumber,
      required int registrationVia,
      required String platformType,
      required String deviceToken}) async {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getS3UploadSignedURL({
    required bool isLoading,
    required String? directory,
    required String? fileName,
    required String? token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> uploadImage({
    required bool isLoading,
    required String signedUploadUrl,
    required File image,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> completeProfile({
    required bool isLoading,
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
    required bool isUpdate,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> emailOtp(
      {required bool isLoading, required String email, required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> phoneOtp(
      {required bool isLoading,
      required String phone,
      required String countryCode,
      required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> logout(
      {required bool isLoading,
      required String? token,
      required String? deviceToken}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> login(
      {required bool isLoading,
      required String email,
      required String platformType,
      required String deviceToken,
      required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> changePassword(
      {required bool isLoading,
      required String oldPassword,
      required String newPassword,
      required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> homeList(
      {required bool isLoading, int? languageType, String? userId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getOtp(
      {required bool isLoading, required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateProfile(
      {required bool isLoading,
      required String location,
      required String latitude,
      required String longitude,
      required String city,
      required String state,
      required String country,
      required String zipCode,
      required num language,
      required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> resetOtp(
      {required bool isLoading,
      required String password,
      required String? token,
      required String? email}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addressList(
      {required bool isLoading, required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> userData(
      {required bool isLoading, required String token}) {
    throw UnimplementedError();
  }

  @override
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
      required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> discoverList(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token,
      required int? limit}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> offersList({
    required bool isLoading,
    int? languageType,
    String? userId,
    required int homeServiceAvailable,
    String? lat,
    String? lng,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> bestDeal({
    required bool isLoading,
    int? languageType,
    String? userId,
    required int homeServiceAvailable,
    String? lat,
    String? lng,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteAddress(
      {required bool isLoading, String? id, required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> subCategoryListing({
    required bool isLoading,
    required String token,
    required String catId,
    required String subCatId,
    required int isSalon,
    required String lat,
    required String lang,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getRecentSearch({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getPopularService({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteRecentSearch({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getRecentlyViewed({
    required bool isLoading,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> search({
    required bool isLoading,
    required String token,
    required String search,
    required int isSalon,
    required String lat,
    required String lang,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> topTenSearch(
      {required bool isLoading, required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> suggestions(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> priceRange(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> postRecentSearch(
      {required bool isLoading,
      required String token,
      required String search,
      required String providerId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getDetails(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String search,
      required int language,
      required int isSalon,
      String? userId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getServices(
      {required bool isLoading,
      required String token,
      required String providerId,
      required int isSalon,
      String? userId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> searchService(
      {required bool isLoading,
      required String token,
      required String search,
      required String serviceProviderId,
      required int language}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getMemberList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String? serviceId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> addService(
      {required String token,
      required bool isLoading,
      required String providerId,
      required List<Map<String, dynamic>> services,
      required bool isUpdate,
      String? bookingId,
      int? isSalon,
      String? isRebookedUsingId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteService(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> clearCart(
      {required String token,
      required bool isLoading,
      required String bookingId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getBookingData(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String couponId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> couponList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String total}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateMember(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId,
      required String memberId}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateAddress(
      {required String token,
      required isLoading,
      required String addressId,
      required String bookingId,
      required String providerId,
      required int isSalon}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateAddresses(
      {required String token,
      required isLoading,
      required String dateTime,
      required String bookingId,
      required String providerId,
      required String selectedTime,
      required int isSalon,
      required String dateTimeWithOffset}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> checkCouponCode(
      {required String token,
      required isLoading,
      required String couponCode,
      required String providerId,
      required String total}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> applyCoupon(
      {required String token,
      required isLoading,
      required String couponId,
      required String providerId,
      required String bookingId,
      required int isSalon}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateInstruction(
      {required String token,
      required isLoading,
      required String instruction,
      required String providerId,
      required String bookingId,
      required int isSalon}) {
    throw UnimplementedError();
  }

  @override
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
      required String dateTimeWithOffset}) {
    // TODO: implement applyCoupon
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> appointmentList({
    required String token,
    required bool isLoading,
    required int activeOrPast,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> appointmentFilter(
      {required String token,
      required bool isLoading,
      required int activeOrPast,
      required String startDate,
      required String endDate,
      required String search,
      required int dateFilter,
      required int locationFilter,
      required List<int> status}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateFavorite({
    required String token,
    required bool isLoading,
    required String serviceProviderId,
    required num isFavorite,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getFavorites(
      {required String token,
      required bool isLoading,
      required num skip,
      required num limit}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> appointmentDetail(
      {required String token, required bool isLoading, required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteAccount(
      {required String token,
      required String reason,
      required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> deleteAccountVerifyOtp(
      {required String token, required String otp, required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getNewSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset,
      required List<String> memberIds}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> rescheduleAppointment(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String slotTime,
      required String rescheduleSlotDate,
      required String dateTimeWithOffset,
      required List<Map<String, dynamic>> updatedMembers}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getSubjectsForHelp(
      {required String token, required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> postQuery(
      {required String token,
      required String bookingId,
      required String subjectId,
      required String description,
      required String subject,
      required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getPostedQueries(
      {required num skip,
      required num limit,
      required dynamic filter,
      required String search,
      required String token,
      required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> acceptOrDecline(
      {required String token,
      required bool isLoading,
      required String id,
      required int status,
      required String declineReason}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> cancellationReview({
    required String token,
    required bool isLoading,
    required String id,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> salonRateReview({
    required String token,
    required bool isLoading,
    required String id,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> reportingReason({
    required String token,
    required bool isLoading,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> requestRefund(
      {required bool isLoading,
      required String id,
      required String refundAmout,
      required String cancellationCharge,
      required String cancellationReason,
      required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> rateAndReview(
      {required String token,
      required bool isLoading,
      required String id,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> reportReview(
      {required String token,
      required bool isLoading,
      required String userServicesProviderRatingId,
      required String reportId,
      required String reportReason,
      required String description}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> appointmentListWithPagination({
    required String token,
    required bool isLoading,
    required int activeOrPast,
    required num skip,
    required num limit,
    required String search,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getRatingAndReview(
      {required String token,
      required bool isLoading,
      required num skip,
      required num limit}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> updateNotification(
      {required String token, required bool isLoading, required int status}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> getHelpDetail(
      {required String token, required String id, required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> postHelpMessage(
      {required String token,
      required String message,
      required String id,
      required bool isLoading}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> socialAuth(
      {required bool isLoading,
      required String phoneNumber,
      required String facebookId,
      required String appleId,
      required String countryCode,
      required int language,
      required int registrationVia,
      required String platformType,
      required String deviceToken,
      required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> userServicesProviderRatingId(
      {required bool isLoading,
      required String id,
      required String token,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> notificationList(
      {required bool isLoading,
      required String token,
      required num skip,
      required num limit}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel> markReadNotification(
      {required bool isLoading,
      required String id,
      required bool isAllRead,
      required String token}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel?> sendUserMessage(
      {required bool isLoading,
      required String name,
      required String email,
      required String title,
      required String token,
      required String phoneNumber,
      required String message}) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel?> buyGiftCards({
    required bool isLoading,
    required String name,
    required String email,
    required String amount,
    required String message,
    required String token,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel?> redeemGiftCard({
    required bool isLoading,
    required String giftCardId,
    required String code,
    required String pin,
    required String token,
  }) {
    throw UnimplementedError();
  }
}
