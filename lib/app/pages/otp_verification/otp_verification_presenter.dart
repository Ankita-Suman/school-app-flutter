import 'package:school_app/domain/domain.dart';

import '../../../domain/models/forgot_password_model.dart';

class OtpVerificationPresenter {
  OtpVerificationPresenter(this._verifyOTPUseCases);


  final VerifyOTPUseCases _verifyOTPUseCases;

  Future<ForgotPasswordResponse?> resendOtpAPI(
      {required bool isLoading,
        required String login,
        required String branchCode}) async =>
      await _verifyOTPUseCases.resendOtpAPI(
          isLoading: isLoading,
          login: login,
          branchCode: branchCode);

  Future<OtpVerifyResponse?> verifyOtpAPI(
      {required bool isLoading,
        required String login,
        required String branchCode,
        required String otp,
      }) async =>
      await _verifyOTPUseCases.verifyOtpAPI(
          isLoading: isLoading,
          login: login,
          branchCode: branchCode,
          otp: otp,
      );

}
