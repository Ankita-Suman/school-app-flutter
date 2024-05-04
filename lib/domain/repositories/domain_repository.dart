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

  Future<ResponseModel> countryList({required bool isLoading});

  Future<ResponseModel> giftCartList({
    required bool isLoading,
    required String deviceToken,
  });

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
      required String email});

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
      required String email});

  Future<ResponseModel> verifyOtp(
      {required bool isLoading,
      required bool isNumber,
      required String otp,
      required String deviceToken,
      required bool isForgot,
      required String? token,
      required email});

  Future<ResponseModel> resendEmailOtp(
      {required bool isLoading,
      required String deviceToken,
      bool? isForgot,
      String? token});

  Future<ResponseModel> resendNumberOtp(
      {required bool isLoading,
      String? countryCode,
      String? phoneNumber,
      required int registrationVia,
      required String platformType,
      required String deviceToken});

  Future<ResponseModel> getS3UploadSignedURL({
    required bool isLoading,
    required String? directory,
    required String? fileName,
    required String? token,
  });

  Future<dynamic> uploadImage({
    required bool isLoading,
    required String signedUploadUrl,
    required File image,
  });

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
  });

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
  });

  Future<ResponseModel> emailOtp(
      {required bool isLoading, required String email, required String token});

  Future<ResponseModel> phoneOtp(
      {required bool isLoading,
      required String countryCode,
      required String phone,
      required String token});

  Future<ResponseModel> logout(
      {required bool isLoading,
      required String? token,
      required String? deviceToken});

  Future<ResponseModel> login(
      {required bool isLoading,
      required String email,
      required String platformType,
      required String deviceToken,
      required String password});

  Future<ResponseModel> changePassword(
      {required bool isLoading,
      required String oldPassword,
      required String newPassword,
      required String token});

  Future<ResponseModel> homeList({required bool isLoading});

  Future<ResponseModel> getOtp(
      {required bool isLoading, required String email});

  Future<ResponseModel> resetOtp(
      {required bool isLoading,
      required String password,
      required String token,
      required String email});

  Future<ResponseModel> addressList(
      {required bool isLoading, required String token});

  Future<ResponseModel> userData(
      {required bool isLoading, required String token});

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
      required String id});

  Future<ResponseModel> discoverList({
    required bool isLoading,
    int? languageType,
    String? userId,
    required int homeServiceAvailable,
    String? lat,
    String? lng,
    required String token,
    required int limit,
  });

  Future<ResponseModel> offersList({
    required bool isLoading,
    int? languageType,
    String? userId,
    required int homeServiceAvailable,
    String? lat,
    String? lng,
    required String token,
  });

  Future<ResponseModel> bestDeal({
    required bool isLoading,
    int? languageType,
    String? userId,
    required int homeServiceAvailable,
    String? lat,
    String? lng,
    required String token,
  });

  Future<ResponseModel> deleteAddress(
      {required bool isLoading, required String token, required String id});

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
  });

  Future<ResponseModel> subCategoryListing({
    required bool isLoading,
    required String token,
    required String catId,
    required String subCatId,
    required int isSalon,
    required String lat,
    required String lang,
    required String userId,
  });

  Future<ResponseModel> getRecentSearch({
    required bool isLoading,
    required String token,
  });

  Future<ResponseModel> getPopularService({
    required bool isLoading,
    required String token,
  });

  Future<ResponseModel> deleteRecentSearch({
    required bool isLoading,
    required String token,
  });

  Future<ResponseModel> getRecentlyViewed({
    required bool isLoading,
    required String token,
  });

  Future<ResponseModel> search(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon,
      required String lat,
      required String lang,
      required String userId});

  Future<ResponseModel> topTenSearch(
      {required bool isLoading, required String token});

  Future<ResponseModel> suggestions(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon});

  Future<ResponseModel> priceRange(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon});

  Future<ResponseModel> postRecentSearch(
      {required bool isLoading,
      required String token,
      required String search,
      required String providerId});

  Future<ResponseModel> getDetails(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String search,
      required int language,
      required String userId,
      required int isSalon});

  Future<ResponseModel> getServices(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String userId,
      required int isSalon});

  Future<ResponseModel> searchService(
      {required bool isLoading,
      required String token,
      required String search,
      required String serviceProviderId,
      required int language});



  Future<ResponseModel> getMemberList(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String? serviceId});

  Future<ResponseModel> addService(
      {required bool isLoading,
      required String token,
      required String providerId,
      required List<Map<String, dynamic>> services,
      required bool isUpdate,
      required String? bookingId,
      required int? isSalon});

  Future<ResponseModel> deleteService(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId});

  Future<ResponseModel> updateMember(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId,
      required String memberId});

  Future<ResponseModel> clearCart(
      {required String token,
      required bool isLoading,
      required String bookingId});

  Future<ResponseModel> getSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset});

  Future<ResponseModel> getBookingData(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String couponId});

  Future<ResponseModel> couponList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String total});

  Future<ResponseModel> updateAddress(
      {required String token,
      required isLoading,
      required String addressId,
      required String bookingId,
      required String providerId,
      required int isSalon});

  Future<ResponseModel> updateAddresses(
      {required String token,
      required isLoading,
      required String dateTime,
      required String bookingId,
      required String providerId,
      required String selectedTime,
      required int isSalon,
      required String dateTimeWithOffset});

  Future<ResponseModel> checkCouponCode(
      {required String token,
      required isLoading,
      required String couponCode,
      required String providerId,
      required String total});

  Future<ResponseModel> applyCoupon(
      {required String token,
      required isLoading,
      required String couponId,
      required String providerId,
      required String bookingId,
      required int isSalon});

  Future<ResponseModel> updateInstruction(
      {required String token,
      required isLoading,
      required String instruction,
      required String providerId,
      required String bookingId,
      required int isSalon});

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
      required String dateTimeWithOffset});

  Future<ResponseModel> appointmentList({
    required String token,
    required bool isLoading,
    required int activeOrPast,
  });

  Future<ResponseModel> appointmentFilter(
      {required String token,
      required bool isLoading,
      required int activeOrPast,
      required String startDate,
      required String endDate,
      required String search,
      required int dateFilter,
      required int locationFilter,
      required List<int> status});

  Future<ResponseModel> updateFavorite({
    required String token,
    required bool isLoading,
    required String serviceProviderId,
    required num isFavorite,
  });

  Future<ResponseModel> getFavorites({
    required String token,
    required bool isLoading,
    required num skip,
    required num limit,
  });

  Future<ResponseModel> deleteAccount({
    required String token,
    required String reason,
    required bool isLoading,
  });

  Future<ResponseModel> deleteAccountVerifyOtp({
    required String token,
    required String otp,
    required bool isLoading,
  });

  Future<ResponseModel> appointmentDetail(
      {required String token, required bool isLoading, required String id});

  Future<ResponseModel> getSubjectsForHelp({
    required String token,
    required bool isLoading,
  });

  Future<ResponseModel> postQuery({
    required String token,
    required String bookingId,
    required String subjectId,
    required String description,
    required String subject,
    required bool isLoading,
  });

  Future<ResponseModel> getPostedQueries({
    required num skip,
    required num limit,
    required dynamic filter,
    required String search,
    required String token,
    required bool isLoading,
  });

  Future<ResponseModel> getNewSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset,
      required List<String> memberIds});

  Future<ResponseModel> rescheduleAppointment(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String slotTime,
      required String rescheduleSlotDate,
      required String dateTimeWithOffset,
      required List<Map<String, dynamic>> updatedMembers});

  Future<ResponseModel> acceptOrDecline(
      {required String token,
      required bool isLoading,
      required String id,
      required int status,
      required String declineReason});

  Future<ResponseModel> cancellationReview({
    required String token,
    required bool isLoading,
    required String id,
  });

  Future<ResponseModel> salonRateReview({
    required String token,
    required bool isLoading,
    required String id,
  });

  Future<ResponseModel> reportingReason({
    required String token,
    required bool isLoading,
  });

  Future<ResponseModel> requestRefund(
      {required bool isLoading,
      required String id,
      required String refundAmout,
      required String cancellationCharge,
      required String cancellationReason,
      required String token});

  Future<ResponseModel> rateAndReview(
      {required String token,
      required bool isLoading,
      required String id,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating});

  Future<ResponseModel> reportReview(
      {required String token,
      required bool isLoading,
      required String userServicesProviderRatingId,
      required String reportId,
      required String reportReason,
      required String description});

  Future<ResponseModel> appointmentListWithPagination({
    required String token,
    required String search,
    required bool isLoading,
    required int activeOrPast,
    required num skip,
    required num limit,
  });

  Future<ResponseModel> getRatingAndReview({
    required String token,
    required bool isLoading,
    required num skip,
    required num limit,
  });

  Future<ResponseModel> getHelpDetail({
    required String token,
    required String id,
    required bool isLoading,
  });

  Future<ResponseModel> postHelpMessage({
    required String token,
    required String message,
    required String id,
    required bool isLoading,
  });

  Future<ResponseModel> userServicesProviderRatingId(
      {required bool isLoading,
      required String id,
      required String token,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating});

  Future<ResponseModel> updateNotification(
      {required String token, required bool isLoading, required int status});

  Future<ResponseModel> notificationList(
      {required String token,
      required bool isLoading,
      required num skip,
      required num limit});

  Future<ResponseModel> markReadNotification(
      {required bool isLoading,
      required String id,
      required bool isAllRead,
      required String token});

  Future<ResponseModel?> sendUserMessage(
      {required bool isLoading,
      required String name,
      required String email,
      required String title,
      required String token,
      required String phoneNumber,
      required String message});

  Future<ResponseModel?> buyGiftCards({
    required bool isLoading,
    required String name,
    required String email,
    required String amount,
    required String message,
    required String token,
  });

  Future<ResponseModel?> redeemGiftCard({
    required bool isLoading,
    required String giftCardId,
    required String code,
    required String pin,
    required String token,
  });
}
