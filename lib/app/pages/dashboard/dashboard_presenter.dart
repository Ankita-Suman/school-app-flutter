// controllers/teacher_dashboard_presenter.dart
import 'package:get/get.dart';
import '../../../domain/models/events_response.dart';
import '../../../domain/models/fees_response.dart';
import '../../../domain/models/profile_response.dart';
import '../../../domain/models/response_model.dart';
import '../../../domain/usecases/home_usecases.dart';

class DashboardPresenter extends GetxController {
  DashboardPresenter(this.homeUseCases);

  final HomeUseCases homeUseCases;

  Future<ProfileResponse?> getProfileDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    return await homeUseCases.getProfileDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }

  Future<FeeResponseModel?> getFeesDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    return await homeUseCases.getFeesDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }

  Future<EventsResponseModel?> getAllEvents({
    required bool isLoading,
    required String token,
    required String branchId, required String studentId,
  }) async {
    return await homeUseCases.getAllEvents(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      studentId: studentId,
    );
  }

Future<ResponseModel?> logoutAPI({
  required bool isLoading, required String token,
}) async =>
    await homeUseCases.logoutAPI(isLoading: isLoading,token:token);
}