import 'package:get/get.dart';
import 'package:school_app/app/pages/staff_attendance_record/staff_attendance_record_controller.dart';
import 'package:school_app/app/pages/staff_attendance_record/staff_attendance_record_presenter.dart';

import '../../../domain/repositories/repository.dart';
import '../../../domain/usecases/home_usecases.dart';


/// A list of bindings which will be used in the route of [AttendanceRecordScreen].
class StaffAttendanceRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<StaffAttendanceRecordController>(
      StaffAttendanceRecordController(
        Get.put(
          StaffAttendanceRecordPresenter(
            HomeUseCases(
              Get.find<Repository>(),
            ),
          ),
        ),
      ),
    );
  }
}
