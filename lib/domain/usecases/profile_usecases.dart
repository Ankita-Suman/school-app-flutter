import 'package:school_app/domain/domain.dart';

import '../models/profile_response.dart';

/// Use case for getting the data from the API
class ProfileUseCases {
  ProfileUseCases(this.repository);

  final Repository repository;

  Future<ProfileResponse?> getProfileDetailsAPI(
          {required bool isLoading,
            required String token,
            required String branchId,
          }) async =>
      await repository.getProfileDetailsAPI(
          isLoading: isLoading,
          token: token,
        branchId: branchId,
      );

  Future<ResponseModel?> logoutAPI(
          {required bool isLoading,
          }) async =>
      await repository.logoutAPI(
          isLoading: isLoading,
      );
}
