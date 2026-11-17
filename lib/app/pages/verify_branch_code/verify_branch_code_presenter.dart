import 'package:school_app/domain/domain.dart';

import '../../../domain/models/branch_verify_response.dart';
import '../../../domain/usecases/login_usecases.dart';

class VerifyBranchCodePresenter {
  VerifyBranchCodePresenter(this._loginUseCases);

  final LoginUseCases _loginUseCases;

  Future<BranchVerifyResponse?> getSchoolInfo(
          { required bool isLoading,
            required String branchCode
           }) async =>
      await _loginUseCases.getSchoolInfo(
        isLoading: isLoading,
        branchCode: branchCode,
       );
}
