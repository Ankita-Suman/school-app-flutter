import 'package:school_app/domain/domain.dart';

class CreatePasswordPresenter {
  CreatePasswordPresenter(this.resetPasswordUseCases);

  final ResetPasswordUseCases resetPasswordUseCases;

  Future<ResetPasswordResponse?> changePasswordAPI({
    required bool isLoading,
    required String branchId,
    required String token,
    required String oldPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async =>
      await resetPasswordUseCases.changePasswordAPI(
        isLoading: isLoading,
        branchId: branchId,
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );


}
