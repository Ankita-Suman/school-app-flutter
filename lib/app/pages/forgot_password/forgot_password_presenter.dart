import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/models/forgot_password_model.dart';

class ForgotPasswordPresenter {
  ForgotPasswordPresenter(this._forgotPasswordUseCases);

  final ForgotPasswordUseCases _forgotPasswordUseCases;

  Future<ForgotPasswordResponse?> forgotPasswordAPI(
      {required bool isLoading,
        required String login,
        required String branchCode}) async =>
      await _forgotPasswordUseCases.forgotPasswordAPI(
          isLoading: isLoading,
          login: login,
          branchCode: branchCode);

}
