import 'package:school_app/domain/domain.dart';

import '../models/forgot_password_model.dart';

/// Use case for getting the data from the API
class ForgotPasswordUseCases {
  ForgotPasswordUseCases(this.repository);

  final Repository repository;

  Future<ForgotPasswordResponse?> forgotPasswordAPI({
    required bool isLoading,
    required String login,
    required String branchCode,
  }) async =>
      await repository.forgotPasswordAPI(
        isLoading: isLoading,
        login: login,
        branchCode: branchCode,
      );
}
