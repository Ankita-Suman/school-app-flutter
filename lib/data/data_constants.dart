// coverage:ignore-file
/// A constants such as API keys, urls, etc. used in the data layer.
///
/// Will be ignored for test since all are static values and would not change.
abstract class DataConstants {
  static const String defaultLang = 'en';
  static const String appBaseUrl =
  // 'https://koxev34z1k.execute-api.ap-south-1.amazonaws.com/test'; //Testing Url
  // 'https://0v4dy6r9r4.execute-api.ap-south-1.amazonaws.com/dev'; //Testing Url
  'https://pokqpc6hj6.execute-api.ap-south-1.amazonaws.com/stage'; //Testing Url
  static const String countryListing = '/api/v1/common/countries';
  static const String register = '/api/v1/user/register';
  static const String socialAuth = '/api/v1/social-auth';
  static const String login = '/api/v1/user/login';
  static const String verifyOtp = '/api/v1/user/userMobileVerifyOtp';
  static const String verifyEmailOtp = '/api/v1/user/verify-otp';
  static const String completeProfile = '/api/v1/user/completeProfile';
  static const String updateProfile = '/api/v1/user/updateProfile';
  static const String resendEmailOtp = '/api/v1/user/resendSignUpOtp';
  static const String getSignedURL = '/api/v1/common/getSignedURL';
  static const String emailOtp = '/api/v1/user/secondaryEmailVerification';
  static const String phoneNumberOtp = '/api/v1/user/secondaryPhoneVerification';
  static const String logout = '/api/v1/user/logout';
  static const String changePassword = '/api/v1/user/changePassword';
  static const String homeList = '/api/v1/category';
  static const String getEmailForgotOtp = '/api/v1/user/forgotPassword';
  static const String userAddresses = '/api/v1/userAddresses';
  static const String verifyForgetPasswordOtp = '/api/v1/user/verifyForgetPasswordOtp';
  static const String resetPassword = '/api/v1/user/resetPassword';
  static const String resendForgotPasswordOtp = '/api/v1/user/resendForgotPasswordOtp';
  static const String listing = '/api/v1/user/home/listing';
  static const String categoriesListing = '/api/v1/user/home/categoriesListing';
  static const String getUserDetails = '/api/v1/user/getUserDetails';
  static const String recentSearch = '/api/v1/user/home/recentSearch';
  static const String popularServices = '/api/v1/user/home/popularServices';
  static const String recentlyViewed = '/api/v1/user/home/recentlyViewed';
  static const String search = '/api/v1/user/home/search';
  static const String topTenSearched = '/api/v1/user/home/topTenSearched';
  static const String suggestions = '/api/v1/user/home/suggestions';
  static const String priceRange = '/api/v1/user/home/priceRange';
  static const String serviceProviderDetail = '/api/v1/user/home/serviceProviderDetail';
  static const String getCategoryListing = '/api/v1/user/home/getCategoryListing';
  static const String getSearchServices = '/api/v1/user/home/getSearchServices';
  static const String getMembers = '/api/v1/user/booking/getMembers';
  static const String booking = '/api/v1/user/booking';
  static const String verifyCoupon = '/api/v1/user/booking/verifyCoupon';
  static const String getSlot = '/api/v1/user/booking/selectTime';
  static const String bookingService = '/api/v1/user/booking/service';
  static const String getOfferCoupons = '/api/v1/user/booking/getOfferCoupons';
  static const String appointments = '/api/v1/user/appointments';
  static const String updateFav = '/api/v1/user/favorite';
  static const String getFavs = '/api/v1/user/favorite';
  static const String getUserRatingAndReview = '/api/v1/user/home/getUserRatingAndReview';
  static const String helpChat = '/api/v1/user/helpChat';
  static const String chatDetail = '/api/v1/user/helpDetails';
  static const String deleteAccount = '/api/v1/user/deleteUserAccount';
  static const String deleteAccountVerifyOtp = '/api/v1/user/verifyDeletingOtp';
  static const String appointmentTime = '/api/v1/user/appointments/selectTime';
  static const String reschedule = '/api/v1/user/appointments/reschedule';
  static const String subjectsForHelp = '/api/v1/user/adminSubject';
  static const String postQuery = '/api/v1/user/help';
  static const String acceptOrDecline = '/api/v1/user/appointments/reschedule/acceptOrDecline';
  static const String cancellationReview = '/api/v1/user/appointments/cancellationReview';
  static const String cancel = '/api/v1/user/appointments/cancel';
  static const String rateAndReview = '/api/v1/user/appointments/rateAndReview';
  static const String salonRateReview = '/api/v1/user/home/getRatingAndReview';
  static const String reportingReason = '/api/v1/user/reportingReason';
  static const String reviewAboutYourReport = '/api/v1/user/reviewAboutYouReport';
  static const String notificationsSetting = '/api/v1/user/notifications/setting';
  static const String discover = '/api/v1/discover';
  static const String offersList = '/api/v1/discover/offers';
  static const String bestDeal = '/api/v1/discover/deals';
  static const String notifications = '/api/v1/user/notifications';
  static const String notificationsRead = '/api/v1/user/notifications/markRead';
  static const String contactToAdmin = '/api/v1/user/contact-to-admin';
  static const String giftCards = '/api/v1/user/giftCards';
  static const String giftCardRedeem = '/api/v1/user/giftCards/redeem';
}
