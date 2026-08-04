// controllers/teacher_dashboard_presenter.dart
import 'package:get/get.dart';
import '../../../domain/models/response_model.dart';
import '../../../domain/models/staff_profile_response.dart';
import '../../../domain/models/teacher_dashboard_response.dart';
import '../../../domain/usecases/teacher_home_usecase.dart';

class TeacherDashboardPresenter extends GetxController {
  TeacherDashboardPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<TeacherDashboardResponse?> getTeacherDashboardAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getTeacherDashboardAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<StaffProfileResponse?> getStaffProfileData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getStaffProfileData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<ResponseModel?> logoutAPI({
    required bool isLoading,
    required String token,
  }) async =>
      await homeUseCases.logoutAPI(isLoading: isLoading, token: token);
}
