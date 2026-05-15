// controllers/new_otp_verification_presenter.dart
import 'package:school_app/domain/domain.dart';
import '../../../domain/models/forgot_password_model.dart';

class NewOtpVerificationPresenter {
  NewOtpVerificationPresenter(this._verifyOTPUseCases);

  final VerifyOTPUseCases _verifyOTPUseCases;

  Future<ForgotPasswordResponse?> resendOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
  }) async {
    return await _verifyOTPUseCases.resendOtpAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
    );
  }

  Future<OtpVerifyResponse?> verifyOtpAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String otp,
  }) async {
    return await _verifyOTPUseCases.verifyOtpAPI(
      isLoading: isLoading,
      login: login,
      branchCode: branchCode,
      otp: otp,
    );
  }
}