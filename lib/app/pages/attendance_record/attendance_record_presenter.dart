import 'package:get/get.dart';
import '../../../domain/models/attendance_response.dart';
import '../../../domain/usecases/home_usecases.dart';

class AttendanceRecordPresenter extends GetxController {
  AttendanceRecordPresenter(this.homeUseCases);

  final HomeUseCases homeUseCases;

  // ✅ API Call via HomeUseCases
  Future<AttendanceResponse?> getAttendanceRecordAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String studentId,
    required String month,
  }) async {
    return await homeUseCases.getAttendanceRecordAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
      month: month,
    );
  }
}