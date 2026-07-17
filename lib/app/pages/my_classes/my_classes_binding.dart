import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';
import 'my_classes.dart';

/// A list of bindings which will be used in the route of [MyClassesScreen].
class MyClassesBinding extends Bindings {

  @override
  void dependencies() {
    Get.put<MyClassesController>(
      MyClassesController(
        Get.put(
          MyClassesPresenter(
            TeacherHomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
