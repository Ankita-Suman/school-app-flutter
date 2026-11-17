import 'package:school_app/domain/domain.dart';

import '../../../domain/models/branch_verify_response.dart';
import '../../../domain/models/delete_account_response.dart';
import '../../../domain/usecases/login_usecases.dart';

class DeleteAccountPresenter {
  DeleteAccountPresenter(this.homeUseCases);

  final HomeUseCases homeUseCases;

  Future<DeleteAccountResponse?> sendDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
  }) async {
    return await homeUseCases.sendDeleteAccountOtp(
      isLoading: isLoading,
      branchCode: branchCode,
      username: username,
    );
  }

  Future<DeleteAccountResponse?> verifyDeleteAccountOtp({
    required bool isLoading,
    required String branchCode,
    required String username,
    required String otp,
  }) async {
    return await homeUseCases.verifyDeleteAccountOtp(
      isLoading: isLoading,
      branchCode: branchCode,
      username: username,
      otp: otp,
    );
  }

  Future<BranchVerifyResponse?> getSchoolInfo(
      { required bool isLoading,
        required String branchCode
      }) async =>
      await homeUseCases.getSchoolInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
}
