import 'package:school_app/domain/domain.dart';

/// Use case for getting the data from the API
class ResetPasswordUseCases {
  ResetPasswordUseCases(this.repository);

  final Repository repository;

  Future<ResetPasswordResponse?> resetPasswordAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
    required String token,
    required String newPassword,
    required String passwordConfirmation,
  }) async =>
      await repository.resetPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );

  Future<StaffResetPasswordResponse?> resetStaffPassword({
    required bool isLoading,
    required String token,
    required String branchId,
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async =>
      await repository.resetStaffPassword(
        isLoading: isLoading,
        currentPassword: currentPassword,
        branchId: branchId,
        token: token,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
}
