import 'package:school_app/domain/domain.dart';

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

  Future<SchoolInfoResponse?> getSchoolInfo({
    required bool isLoading,
    required String branchCode,

  }) async =>
      await repository.getSchoolInfo(
        isLoading: isLoading,
        branchCode: branchCode,
      );
}
