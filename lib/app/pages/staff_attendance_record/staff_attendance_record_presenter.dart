import 'package:get/get.dart';
import '../../../domain/models/attendance_response.dart';
import '../../../domain/models/staff_attendance_response.dart';
import '../../../domain/usecases/home_usecases.dart';

class StaffAttendanceRecordPresenter extends GetxController {
  StaffAttendanceRecordPresenter(this.homeUseCases);

  final HomeUseCases homeUseCases;

  // ✅ API Call for Staff
  Future<StaffAttendanceResponse?> getStaffAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String month,
  }) async {
    return await homeUseCases.getStaffAttendanceRecordAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      month: month,
    );
  }
}