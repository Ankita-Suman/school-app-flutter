import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/usecases/login_usecases.dart';

class ResetPasswordPresenter {
  ResetPasswordPresenter(this.resetPasswordUseCases);

  final ResetPasswordUseCases resetPasswordUseCases;

  Future<ResetPasswordResponse?> resetPasswordAPI(
      {required bool isLoading,
        required String login,
        required String branchCode,
        required String token,
        required String newPassword,
        required String passwordConfirmation,
      }) async =>
      await resetPasswordUseCases.resetPasswordAPI(
          isLoading: isLoading,
          login: login,
          branchCode: branchCode,
          token: token,
          newPassword: newPassword,
          passwordConfirmation: passwordConfirmation,
      );
}
