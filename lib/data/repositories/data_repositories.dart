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

  @override
  Future<ResponseModel> countryList({required bool isLoading}) async {
    var res = await connectHelper.getCountryList(isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> giftCartList(
      {required bool isLoading, required String deviceToken}) async {
    var res = await connectHelper.giftCartList(
        isLoading: isLoading, deviceToken: deviceToken);
    return res;
  }

  @override
  Future<ResponseModel> register(
      {required bool isLoading,
      required String phoneNumber,
      required String facebookId,
      required String appleId,
      required String countryCode,
      required int language,
      required int registrationVia,
      required String platformType,
      required String deviceToken,
      required String email}) async {
    var res = await connectHelper.register(
        isLoading: isLoading,
        phoneNumber: phoneNumber,
        facebookId: facebookId,
        appleId: appleId,
        countryCode: countryCode,
        language: language,
        registrationVia: registrationVia,
        platformType: platformType,
        deviceToken: deviceToken,
        email: email);
    return res;
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
      required String email}) async {
    var res = await connectHelper.socialAuth(
        isLoading: isLoading,
        phoneNumber: phoneNumber,
        facebookId: facebookId,
        appleId: appleId,
        countryCode: countryCode,
        language: language,
        registrationVia: registrationVia,
        platformType: platformType,
        deviceToken: deviceToken,
        email: email);
    return res;
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
    var res = await connectHelper.verifyOtp(
        isLoading: isLoading,
        isNumber: isNumber,
        otp: otp,
        deviceToken: deviceToken,
        isForgot: isForgot,
        token: token,
        email: email);
    return res;
  }

  @override
  Future<ResponseModel> resendEmailOtp(
      {required bool isLoading,
      required String deviceToken,
      bool? isForgot,
      String? token,
      String? email}) async {
    var res = await connectHelper.resendEmailOtp(
        isLoading: isLoading,
        deviceToken: deviceToken,
        isForgot: isForgot,
        email: email,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel> resendNumberOtp(
      {required bool isLoading,
      String? countryCode,
      String? phoneNumber,
      required int registrationVia,
      required String platformType,
      required String deviceToken}) async {
    var res = await connectHelper.resendNumberOtp(
        isLoading: isLoading,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        registrationVia: registrationVia,
        platformType: platformType,
        deviceToken: deviceToken);
    return res;
  }

  @override
  Future<ResponseModel> getS3UploadSignedURL({
    required bool isLoading,
    required String? directory,
    required String? fileName,
    required String? token,
  }) async {
    var res = await connectHelper.getS3UploadSignedURL(
        isLoading: isLoading,
        directory: directory,
        fileName: fileName,
        token: token);
    return res;
  }

  @override
  Future<dynamic> uploadImage({
    required bool isLoading,
    required String signedUploadUrl,
    required File image,
  }) async {
    var res = await connectHelper.uploadImage(
        isLoading: isLoading, signedUploadUrl: signedUploadUrl, image: image);
    return res;
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
  }) async {
    var res = await connectHelper.completeProfile(
        isLoading: isLoading,
        name: name,
        email: email,
        password: password,
        profileImage: profileImage,
        dateOfBirth: dateOfBirth,
        gender: gender,
        genderName: genderName,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        language: language,
        token: token,
        isUpdate: isUpdate);
    return res;
  }

  @override
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
    var res = await connectHelper.updateProfile(
      isLoading: isLoading,
      location: location,
      longitude: longitude,
      latitude: latitude,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
      token: token,
      language: language,
    );
    return res;
  }

  @override
  Future<ResponseModel> emailOtp(
      {required bool isLoading,
      required String email,
      required String token}) async {
    var res = await connectHelper.emailOtp(
      isLoading: isLoading,
      email: email,
      token: token,
    );
    return res;
  }

  @override
  Future<ResponseModel> phoneOtp(
      {required bool isLoading,
      required String countryCode,
      required String phone,
      required String token}) async {
    var res = await connectHelper.phoneOtp(
      isLoading: isLoading,
      phoneNumber: phone,
      countryCode: countryCode,
      token: token,
    );
    return res;
  }

  @override
  Future<ResponseModel> logout(
      {required bool isLoading,
      required String? token,
      required String? deviceToken}) async {
    var res = await connectHelper.logout(
        isLoading: isLoading, token: token, deviceToken: deviceToken);
    return res;
  }

  @override
  Future<ResponseModel> login(
      {required bool isLoading,
      required String email,
      required String platformType,
      required String deviceToken,
      required String password}) async {
    var res = await connectHelper.login(
        isLoading: isLoading,
        email: email,
        platformType: platformType,
        deviceToken: deviceToken,
        password: password);
    return res;
  }

  @override
  Future<ResponseModel> changePassword(
      {required bool isLoading,
      required String oldPassword,
      required String newPassword,
      required String token}) async {
    var res = await connectHelper.changePassword(
        isLoading: isLoading,
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel> homeList(
      {required bool isLoading, int? languageType, String? userId}) async {
    var res = await connectHelper.getHomeList(
        isLoading: isLoading, languageType: languageType, userId: userId);
    return res;
  }

  @override
  Future<ResponseModel> getOtp(
      {required bool isLoading, required String email}) async {
    var res = await connectHelper.getOtp(isLoading: isLoading, email: email);
    return res;
  }

  @override
  Future<ResponseModel> resetOtp(
      {required bool isLoading,
      required String password,
      required String? token,
      required String? email}) async {
    var res = await connectHelper.resetOtp(
        isLoading: isLoading, password: password, token: token!, email: email!);
    return res;
  }

  @override
  Future<ResponseModel> addressList(
      {required bool isLoading, required String token}) async {
    var res =
        await connectHelper.addressList(isLoading: isLoading, token: token);
    return res;
  }

  @override
  Future<ResponseModel> userData(
      {required bool isLoading, required String token}) async {
    var res = await connectHelper.userData(isLoading: isLoading, token: token);
    return res;
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
      required String id}) async {
    var res = await connectHelper.addAddress(
        isLoading: isLoading,
        title: title,
        location: location,
        floor: floor,
        landmark: landmark,
        latitude: latitude,
        longitude: longitude,
        zipcode: zipcode,
        token: token,
        isAddressUpdate: isAddressUpdate,
        id: id);
    return res;
  }

  @override
  Future<ResponseModel> deleteAddress(
      {required bool isLoading, String? id, required String token}) async {
    var res = await connectHelper.deleteAddress(
        isLoading: isLoading, token: token, id: id);
    return res;
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
  }) async {
    var res = await connectHelper.categoryListing(
        isLoading: isLoading,
        token: token,
        isSalon: isSalon,
        limit: limit,
        skip: skip,
        type: type,
        lat: lat,
        lang: lang,
        userId: userId);
    return res;
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
  }) async {
    var res = await connectHelper.subCategoryListing(
      isLoading: isLoading,
      token: token,
      catId: catId,
      subCatId: subCatId,
      isSalon: isSalon,
      lat: lat,
      lang: lang,
      userId: userId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getRecentSearch({
    required bool isLoading,
    required String token,
  }) async {
    var res = await connectHelper.getRecentSearch(
      isLoading: isLoading,
      token: token,
    );
    return res;
  }

  @override
  Future<ResponseModel> getPopularService({
    required bool isLoading,
    required String token,
  }) async {
    var res = await connectHelper.getPopularService(
      isLoading: isLoading,
      token: token,
    );
    return res;
  }

  @override
  Future<ResponseModel> postRecentSearch(
      {required bool isLoading,
      required String token,
      required String search,
      required String providerId}) async {
    var res = await connectHelper.postRecentSearch(
      isLoading: isLoading,
      token: token,
      search: search,
      providerId: providerId,
    );
    return res;
  }

  @override
  Future<ResponseModel> getDetails(
      {required bool isLoading,
      required String token,
      required String providerId,
      required String search,
      required int language,
      required int isSalon,
      String? userId}) async {
    var res = await connectHelper.getDetails(
        isLoading: isLoading,
        token: token,
        providerId: providerId,
        search: search,
        language: language,
        isSalon: isSalon,
        userId: userId);
    return res;
  }

  @override
  Future<ResponseModel> getServices(
      {required bool isLoading,
      required String token,
      required String providerId,
      required int isSalon,
      String? userId}) async {
    var res = await connectHelper.getServices(
        isLoading: isLoading,
        token: token,
        providerId: providerId,
        isSalon: isSalon,
        userId: userId);
    return res;
  }

  @override
  Future<ResponseModel> searchService(
      {required bool isLoading,
      required String token,
      required String search,
      required String serviceProviderId,
      required int language}) async {
    var res = await connectHelper.searchService(
        token: token,
        isLoading: isLoading,
        search: search,
        serviceProviderId: serviceProviderId,
        language: language);
    return res;
  }

  @override
  Future<ResponseModel> deleteRecentSearch({
    required bool isLoading,
    required String token,
  }) async {
    var res = await connectHelper.deleteRecentSearch(
      isLoading: isLoading,
      token: token,
    );
    return res;
  }

  @override
  Future<ResponseModel> getRecentlyViewed({
    required bool isLoading,
    required String token,
  }) async {
    var res = await connectHelper.getRecentlyViewed(
      isLoading: isLoading,
      token: token,
    );
    return res;
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
  }) async {
    var res = await connectHelper.search(
        isLoading: isLoading,
        token: token,
        search: search,
        isSalon: isSalon,
        lat: lat,
        lang: lang,
        userId: userId);
    return res;
  }

  @override
  Future<ResponseModel> topTenSearch(
      {required bool isLoading, required String token}) async {
    var res =
        await connectHelper.topTenSearch(isLoading: isLoading, token: token);
    return res;
  }

  @override
  Future<ResponseModel> suggestions(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) async {
    var res = await connectHelper.suggestions(
        isLoading: isLoading, token: token, isSalon: isSalon, search: search);
    return res;
  }

  @override
  Future<ResponseModel> priceRange(
      {required bool isLoading,
      required String token,
      required String search,
      required int isSalon}) async {
    var res = await connectHelper.priceRange(
        isLoading: isLoading, token: token, isSalon: isSalon, search: search);
    return res;
  }


  @override
  Future<ResponseModel> getMemberList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String? serviceId}) async {
    var res = await connectHelper.getMemberList(
        token: token,
        isLoading: isLoading,
        providerId: providerId,
        serviceId: serviceId!);
    return res;
  }

  @override
  Future<ResponseModel> addService(
      {required bool isLoading,
      required String token,
      required String providerId,
      required List<Map<String, dynamic>> services,
      required bool isUpdate,
      required String? bookingId,
      required int? isSalon,
      String? isRebookedUsingId}) async {
    var res = await connectHelper.addService(
        token: token,
        isLoading: isLoading,
        providerId: providerId,
        services: services,
        isUpdate: isUpdate,
        bookingId: bookingId,
        isSalon: isSalon,
        isRebookedUsingId: isRebookedUsingId!);
    return res;
  }

  @override
  Future<ResponseModel> deleteService(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId}) async {
    var res = await connectHelper.deleteService(
        token: token,
        isLoading: isLoading,
        serviceId: serviceId,
        bookingId: bookingId);
    return res;
  }

  @override
  Future<ResponseModel> updateMember(
      {required String token,
      required bool isLoading,
      String? serviceId,
      required String bookingId,
      required String memberId}) async {
    var res = await connectHelper.updateMember(
        token: token,
        isLoading: isLoading,
        serviceId: serviceId,
        bookingId: bookingId,
        memberId: memberId);
    return res;
  }

  @override
  Future<ResponseModel> clearCart(
      {required String token,
      required bool isLoading,
      required String bookingId}) async {
    var res = await connectHelper.clearCart(
        token: token, isLoading: isLoading, bookingId: bookingId);
    return res;
  }

  @override
  Future<ResponseModel> getSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset}) async {
    var res = await connectHelper.getSlot(
        token: token,
        isLoading: isLoading,
        bookingId: bookingId,
        date: date,
        dateTimeWithOffset: dateTimeWithOffset);
    return res;
  }

  @override
  Future<ResponseModel> getBookingData(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String couponId}) async {
    var res = await connectHelper.getBookingData(
        token: token,
        isLoading: isLoading,
        bookingId: bookingId,
        couponId: couponId);
    return res;
  }

  @override
  Future<ResponseModel> couponList(
      {required String token,
      required bool isLoading,
      required String providerId,
      required String total}) async {
    var res = await connectHelper.couponList(
        token: token,
        isLoading: isLoading,
        providerId: providerId,
        total: total);
    return res;
  }

  @override
  Future<ResponseModel> updateAddress(
      {required String token,
      required isLoading,
      required String addressId,
      required String bookingId,
      required String providerId,
      required int isSalon}) async {
    var res = await connectHelper.updateAddress(
        token: token,
        isLoading: isLoading,
        addressId: addressId,
        bookingId: bookingId,
        providerId: providerId,
        isSalon: isSalon);
    return res;
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
      required String dateTimeWithOffset}) async {
    var res = await connectHelper.updateAddresses(
        token: token,
        isLoading: isLoading,
        dateTime: dateTime,
        bookingId: bookingId,
        providerId: providerId,
        selectedTime: selectedTime,
        isSalon: isSalon,
        dateTimeWithOffset: dateTimeWithOffset);
    return res;
  }

  @override
  Future<ResponseModel> checkCouponCode(
      {required String token,
      required isLoading,
      required String couponCode,
      required String providerId,
      required String total}) async {
    var res = await connectHelper.checkCouponCode(
        token: token,
        isLoading: isLoading,
        couponCode: couponCode,
        providerId: providerId,
        total: total);
    return res;
  }

  @override
  Future<ResponseModel> applyCoupon(
      {required String token,
      required isLoading,
      required String couponId,
      required String providerId,
      required String bookingId,
      required int isSalon}) async {
    var res = await connectHelper.applyCoupon(
      token: token,
      isLoading: isLoading,
      couponId: couponId,
      providerId: providerId,
      bookingId: bookingId,
      isSalon: isSalon,
    );
    return res;
  }

  @override
  Future<ResponseModel> updateInstruction(
      {required String token,
      required isLoading,
      required String instruction,
      required String providerId,
      required String bookingId,
      required int isSalon}) async {
    var res = await connectHelper.updateInstruction(
      token: token,
      isLoading: isLoading,
      instruction: instruction,
      providerId: providerId,
      bookingId: bookingId,
      isSalon: isSalon,
    );
    return res;
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
      required String dateTimeWithOffset}) async {
    var res = await connectHelper.confirmBooking(
      token: token,
      isLoading: isLoading,
      providerId: providerId,
      bookingId: bookingId,
      isSalon: isSalon,
      discount: discount,
      subTotal: subTotal,
      serviceCharges: serviceCharges,
      total: total,
      couponDiscount: couponDiscount,
      dateTimeWithOffset: dateTimeWithOffset,
    );
    return res;
  }

  @override
  Future<ResponseModel> appointmentList({
    required String token,
    required bool isLoading,
    required int activeOrPast,
  }) async {
    var res = await connectHelper.appointmentList(
        token: token, isLoading: isLoading, activeOrPast: activeOrPast);
    return res;
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
      required List<int> status}) async {
    var res = await connectHelper.appointmentFilter(
        token: token,
        isLoading: isLoading,
        activeOrPast: activeOrPast,
        startDate: startDate,
        endDate: endDate,
        dateFilter: dateFilter,
        locationFilter: locationFilter,
        status: status,
        search: search);
    return res;
  }

  @override
  Future<ResponseModel> updateFavorite(
      {required String token,
      required bool isLoading,
      required String serviceProviderId,
      required num isFavorite}) async {
    var res = await connectHelper.updateFavorite(
        token: token,
        isLoading: isLoading,
        serviceProviderId: serviceProviderId,
        isFavorite: isFavorite);
    return res;
  }

  @override
  Future<ResponseModel> getFavorites(
      {required String token,
      required bool isLoading,
      required num skip,
      required num limit}) async {
    var res = await connectHelper.getFavorites(
        token: token, isLoading: isLoading, skip: skip, limit: limit);
    return res;
  }

  @override
  Future<ResponseModel> deleteAccount(
      {required String token,
      required String reason,
      required bool isLoading}) async {
    var res = await connectHelper.deleteAccount(
        token: token, reason: reason, isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> deleteAccountVerifyOtp(
      {required String token,
      required String otp,
      required bool isLoading}) async {
    var res = await connectHelper.deleteAccountVerifyOtp(
        token: token, otp: otp, isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> appointmentDetail(
      {required String token,
      required bool isLoading,
      required String id}) async {
    var res = await connectHelper.appointmentDetail(
        token: token, isLoading: isLoading, id: id);
    return res;
  }

  @override
  Future<ResponseModel> getNewSlot(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String date,
      required String dateTimeWithOffset,
      required List<String> memberIds}) async {
    var res = await connectHelper.getNewSlot(
        token: token,
        isLoading: isLoading,
        bookingId: bookingId,
        date: date,
        dateTimeWithOffset: dateTimeWithOffset,
        memberIds: memberIds);
    return res;
  }

  @override
  Future<ResponseModel> rescheduleAppointment(
      {required String token,
      required bool isLoading,
      required String bookingId,
      required String slotTime,
      required String rescheduleSlotDate,
      required String dateTimeWithOffset,
      required List<Map<String, dynamic>> updatedMembers}) async {
    var res = await connectHelper.rescheduleAppointment(
        token: token,
        isLoading: isLoading,
        bookingId: bookingId,
        slotTime: slotTime,
        rescheduleSlotDate: rescheduleSlotDate,
        dateTimeWithOffset: dateTimeWithOffset,
        updatedMembers: updatedMembers);
    return res;
  }

  @override
  Future<ResponseModel> getSubjectsForHelp(
      {required String token, required bool isLoading}) async {
    var res = await connectHelper.getSubjectsForHelp(
        token: token, isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> postQuery(
      {required String token,
      required String bookingId,
      required String subjectId,
      required String description,
      required String subject,
      required bool isLoading}) async {
    var res = await connectHelper.postQuery(
        token: token,
        bookingId: bookingId,
        subjectId: subjectId,
        description: description,
        subject: subject,
        isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> getPostedQueries(
      {required num skip,
      required num limit,
      required dynamic filter,
      required String search,
      required String token,
      required bool isLoading}) async {
    var res = await connectHelper.getPostedQueries(
        skip: skip,
        limit: limit,
        filter: filter,
        search: search,
        token: token,
        isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> acceptOrDecline({
    required String token,
    required bool isLoading,
    required String id,
    required int status,
    required String declineReason,
  }) async {
    var res = await connectHelper.acceptOrDecline(
        isLoading: isLoading,
        id: id,
        status: status,
        declineReason: declineReason,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel> cancellationReview({
    required String token,
    required bool isLoading,
    required String id,
  }) async {
    var res = await connectHelper.cancellationReview(
        isLoading: isLoading, token: token, id: id);
    return res;
  }

  @override
  Future<ResponseModel> salonRateReview({
    required String token,
    required bool isLoading,
    required String id,
  }) async {
    var res = await connectHelper.salonRateReview(
        isLoading: isLoading, token: token, id: id);
    return res;
  }

  @override
  Future<ResponseModel> reportingReason({
    required String token,
    required bool isLoading,
  }) async {
    var res =
        await connectHelper.reportingReason(isLoading: isLoading, token: token);
    return res;
  }

  @override
  Future<ResponseModel> requestRefund(
      {required bool isLoading,
      required String id,
      required String refundAmout,
      required String cancellationCharge,
      required String cancellationReason,
      required String token}) async {
    var res = await connectHelper.requestRefund(
      token: token,
      isLoading: isLoading,
      id: id,
      refundAmout: refundAmout,
      cancellationCharge: cancellationCharge,
      cancellationReason: cancellationReason,
    );
    return res;
  }

  @override
  Future<ResponseModel> rateAndReview(
      {required String token,
      required bool isLoading,
      required String id,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) async {
    var res = await connectHelper.rateAndReview(
      token: token,
      isLoading: isLoading,
      id: id,
      rating: rating,
      review: review,
      serviceProviderId: serviceProviderId,
      servicesRating: servicesRating,
    );
    return res;
  }

  @override
  Future<ResponseModel> userServicesProviderRatingId(
      {required bool isLoading,
      required String id,
      required String token,
      required int rating,
      required String review,
      required String serviceProviderId,
      required List<Map<String, dynamic>> servicesRating}) async {
    var res = await connectHelper.userServicesProviderRatingId(
        token: token,
        isLoading: isLoading,
        id: id,
        rating: rating,
        review: review,
        serviceProviderId: serviceProviderId,
        servicesRating: servicesRating);
    return res;
  }

  @override
  Future<ResponseModel> appointmentListWithPagination({
    required String token,
    required bool isLoading,
    required int activeOrPast,
    required num skip,
    required num limit,
    required String search,
  }) async {
    var res = await connectHelper.appointmentListWithPagination(
        token: token,
        isLoading: isLoading,
        activeOrPast: activeOrPast,
        skip: skip,
        limit: limit,
        search: search);
    return res;
  }

  @override
  Future<ResponseModel> getRatingAndReview(
      {required String token,
      required bool isLoading,
      required num skip,
      required num limit}) async {
    var res = await connectHelper.getRatingAndReview(
        token: token, isLoading: isLoading, skip: skip, limit: limit);
    return res;
  }

  @override
  Future<ResponseModel> reportReview(
      {required String token,
      required bool isLoading,
      required String userServicesProviderRatingId,
      required String reportId,
      required String reportReason,
      required String description}) async {
    var res = await connectHelper.reportReview(
        token: token,
        isLoading: isLoading,
        userServicesProviderRatingId: userServicesProviderRatingId,
        reportId: reportId,
        reportReason: reportReason,
        description: description);
    return res;
  }

  @override
  Future<ResponseModel> updateNotification(
      {required String token,
      required bool isLoading,
      required int status}) async {
    var res = await connectHelper.updateNotification(
        token: token, isLoading: isLoading, status: status);
    return res;
  }

  @override
  Future<ResponseModel> getHelpDetail(
      {required String token,
      required String id,
      required bool isLoading}) async {
    var res = await connectHelper.getHelpDetail(
        token: token, id: id, isLoading: isLoading);
    return res;
  }

  @override
  Future<ResponseModel> postHelpMessage(
      {required String token,
      required String message,
      required String id,
      required bool isLoading}) async {
    var res = await connectHelper.postHelpMessage(
        token: token, message: message, id: id, isLoading: isLoading);
    return res;
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
      required int? limit}) async {
    var res = await connectHelper.discoverList(
        isLoading: isLoading,
        languageType: languageType,
        userId: userId,
        homeServiceAvailable: homeServiceAvailable,
        lat: lat,
        lng: lng,
        token: token,
        limit: limit);
    return res;
  }

  @override
  Future<ResponseModel> offersList(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token}) async {
    var res = await connectHelper.offersList(
        isLoading: isLoading,
        languageType: languageType,
        userId: userId,
        homeServiceAvailable: homeServiceAvailable,
        lat: lat,
        lng: lng,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel> bestDeal(
      {required bool isLoading,
      int? languageType,
      String? userId,
      required int homeServiceAvailable,
      String? lat,
      String? lng,
      required String token}) async {
    var res = await connectHelper.bestDeal(
        isLoading: isLoading,
        languageType: languageType,
        userId: userId,
        homeServiceAvailable: homeServiceAvailable,
        lat: lat,
        lng: lng,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel> notificationList(
      {required bool isLoading,
      required String token,
      required num skip,
      required num limit}) async {
    var res = await connectHelper.notificationList(
      isLoading: isLoading,
      token: token,
      skip: skip,
      limit: limit,
    );
    return res;
  }

  @override
  Future<ResponseModel> markReadNotification(
      {required bool isLoading,
      required String id,
      required bool isAllRead,
      required String token}) async {
    var res = await connectHelper.markReadNotification(
        token: token, isLoading: isLoading, id: id, isAllRead: isAllRead);
    return res;
  }

  @override
  Future<ResponseModel?> sendUserMessage(
      {required bool isLoading,
      required String name,
      required String email,
      required String title,
      required String token,
      required String phoneNumber,
      required String message}) async {
    var res = await connectHelper.sendUserMessage(
        token: token,
        isLoading: isLoading,
        name: name,
        email: email,
        title: title,
        phoneNumber: phoneNumber,
        message: message);
    return res;
  }

  @override
  Future<ResponseModel?> buyGiftCards(
      {required bool isLoading,
      required String name,
      required String email,
      required String amount,
      required String message,
      required String token}) async {
    var res = await connectHelper.buyGiftCards(
        isLoading: isLoading,
        name: name,
        email: email,
        amount: amount,
        message: message,
        token: token);
    return res;
  }

  @override
  Future<ResponseModel?> redeemGiftCard(
      {required bool isLoading,
      required String giftCardId,
      required String code,
      required String pin,
      required String token}) async {
    var res = await connectHelper.redeemGiftCard(
        isLoading: isLoading,
        giftCardId: giftCardId,
        code: code,
        pin: pin,
        token: token);
    return res;
  }
}
