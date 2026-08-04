import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'leave_balance.dart';

/// A list of bindings which will be used in the route of [ LeaveBalanceScreen].
class LeaveBalanceBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<LeaveBalanceController>(
      LeaveBalanceController(
        Get.put(
          LeaveBalancePresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
