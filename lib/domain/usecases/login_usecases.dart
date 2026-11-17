import 'package:school_app/domain/domain.dart';

import '../models/branch_verify_response.dart';

/// Use case for getting the data from the API
class LoginUseCases {
  LoginUseCases(this.repository);

  final Repository repository;

  Future<LoginResponse?> loginAPI(
          {required bool isLoading,
            required String loginName,
            required String password,
            required String branchCode}) async =>
      await repository.loginApi(
          isLoading: isLoading,
          loginName: loginName,
          password: password,
          branchCode: branchCode);

  Future<BranchVerifyResponse?> getSchoolInfo({
    required bool isLoading,
    required String branchCode,

  }) async =>
      await repository.getBranchInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
}
