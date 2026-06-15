import 'package:school_app/domain/domain.dart';

import '../models/events_response.dart';
import '../models/profile_response.dart';

/// Use case for getting the data from the API
class HomeUseCases {
  HomeUseCases(this.repository);

  final Repository repository;

  Future<ProfileResponse?> getProfileDetailsAPI(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getProfileDetailsAPI(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );

  Future<FeeResponseModel?> getFeesDetailsAPI(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getFeesDetailsAPI(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );

  Future<EventsResponseModel?> getAllEvents(
          {required bool isLoading,
            required String token,
            required String branchId, required String studentId,
          }) async =>
      await repository.getAllEvents(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
        studentId: studentId,
      );

  Future<ResponseModel?> logoutAPI(
          {required bool isLoading, required String token,
          }) async =>
      await repository.logoutAPI(
          isLoading: isLoading,
        token: token,
      );
}
