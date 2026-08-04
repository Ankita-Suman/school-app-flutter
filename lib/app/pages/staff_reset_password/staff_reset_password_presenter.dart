import 'package:school_app/domain/domain.dart';

class StaffResetPasswordPresenter {
  StaffResetPasswordPresenter(this.resetPasswordUseCases);

  final ResetPasswordUseCases resetPasswordUseCases;

  Future<StaffResetPasswordResponse?> resetStaffPassword({
    required bool isLoading,
    required String token,
    required String branchId,
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async =>
      await resetPasswordUseCases.resetStaffPassword(
        isLoading: isLoading,
        branchId: branchId,
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
}
