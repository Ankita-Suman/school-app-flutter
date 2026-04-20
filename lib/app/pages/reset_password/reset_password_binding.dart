import 'package:get/get.dart';
import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/usecases/login_usecases.dart';

import '../../../domain/repositories/repository.dart';
import 'reset_password.dart';

/// A list of bindings which will be used in the route of [ResetPasswordScreen].
class ResetPasswordBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ResetPasswordController>(
      ResetPasswordController(
        Get.put(
          ResetPasswordPresenter(
            ResetPasswordUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
