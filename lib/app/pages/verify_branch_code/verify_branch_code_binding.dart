import 'package:get/get.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_controller.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_presenter.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';

/// A list of bindings which will be used in the route of [VerifyBranchCodeScreen].
class VerifyBranchCodeBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<VerifyBranchCodeController>(
      VerifyBranchCodeController(
        Get.put(
          VerifyBranchCodePresenter(
            LoginUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
