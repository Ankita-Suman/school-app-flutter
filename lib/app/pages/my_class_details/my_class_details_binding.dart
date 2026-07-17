import 'package:get/get.dart';
import 'package:school_app/domain/repositories/repository.dart';

import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_class_details.dart';

/// A list of bindings which will be used in the route of [MyClassDetailsScreen].
class MyClassDetailsBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MyClassDetailsController>(
      MyClassDetailsController(
        Get.put(
          MyClassDetailsPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
