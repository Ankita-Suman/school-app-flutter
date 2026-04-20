import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/usecases/login_usecases.dart';

class LoginStudentPresenter {
  LoginStudentPresenter(this._loginUseCases);

  final LoginUseCases _loginUseCases;

  Future<LoginResponse?> loginAPI(
      {required bool isLoading,
        required String loginName,
        required String password,
        required String branchCode}) async =>
      await _loginUseCases.loginAPI(
          isLoading: isLoading,
          loginName: loginName,
          password: password,
          branchCode: branchCode);
}
