import 'package:get/get.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_controller.dart';
import 'package:school_app/app/pages/verify_branch_code/verify_branch_code_presenter.dart';
import 'package:school_app/domain/domain.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/login_usecases.dart';
import 'delete_account_controller.dart';
import 'delete_account_presenter.dart';

/// A list of bindings which will be used in the route of [DeleteAccountScreen].
class DeleteAccountBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<DeleteAccountController>(
      DeleteAccountController(
        Get.put(
          DeleteAccountPresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
