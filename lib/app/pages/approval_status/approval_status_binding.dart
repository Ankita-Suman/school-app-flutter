import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'approval_status.dart';

/// A list of bindings which will be used in the route of [ApprovalStatuscreen].
class ApprovalStatusBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<ApprovalStatusController>(
      ApprovalStatusController(
        Get.put(
          ApprovalStatusPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
