// coverage:ignore-file

/// A chunk of shared preference keys which will
/// be used by DeviceRepository to get/save the data locally.
///
/// Will be ignored for test since all are static values and would not change.
abstract class DeviceConstants {
  static const String localLang = 'localLang';
  static const String appVersion = '0.0.1';
  static const String accessToken = 'accessToken';
  static const String registrationVia = 'registrationVia';
  static const String deviceToken = 'deviceToken';
  static const String profileData = 'profileData';
  static const String email = 'email';
  static const String password = 'password';
  static const String phoneNumber = 'phoneNumber';
  static const String facebook = 'facebook';
  static const String apple = 'apple';
  static const String showLogin = 'showLogin';
  static const String guest = 'guest';
  static const String home = 'home';
  static const String location = 'location';
  static const String isPasswordReset = 'isPasswordReset';
  static const String token = 'token';
  static const String isForgot = 'isForgot';
  static const String isSalon = 'isSalon';
  static const String type = 'type';
  static const String isSubCat = 'isSubCat';
  static const String title = 'title';
  static const String isSearchListing = 'isSearchListing';
  static const String userData = 'userData';
  static const String serviceProviderId = 'serviceProviderId';
  static const String bookingId = 'bookingId';
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String homeData = 'homeData';
  static const String appointmentData = 'appointmentData';
  static const String favouriteData = 'favouriteData';
  static const String discoverData = 'discoverData';

}
