import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'student_fee_list.dart';

/// A list of bindings which will be used in the route of [StudentFeeListScreen].
class StudentFeeListBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<StudentFeeListController>(
      StudentFeeListController(
        Get.put(
          StudentFeeListPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
