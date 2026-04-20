import 'package:school_app/domain/domain.dart';

import '../models/forgot_password_model.dart';

/// Use case for getting the data from the API
class VerifyOTPUseCases {
  VerifyOTPUseCases(this.repository);

  final Repository repository;

  Future<ForgotPasswordResponse?> resendOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
  }) async =>
      await repository.resendOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
      );

  Future<OtpVerifyResponse?> verifyOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async =>
      await repository.verifyOtpAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        otp: otp,
      );
}
