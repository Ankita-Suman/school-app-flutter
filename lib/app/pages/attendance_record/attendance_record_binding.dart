import 'package:get/get.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/home_usecases.dart';
import 'attendance_record_controller.dart';
import 'attendance_record_presenter.dart';


/// A list of bindings which will be used in the route of [AttendanceRecordScreen].
class AttendanceRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AttendanceRecordController>(
      AttendanceRecordController(
        Get.put(
          AttendanceRecordPresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
