import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/models/profile_response.dart';
import 'package:school_app/domain/usecases/login_usecases.dart';

class ProfilePresenter {
  ProfilePresenter(this._profileUseCases);

   final HomeUseCases _profileUseCases;
  //
  // Future<ProfileResponse?> getProfileDetailsAPI(
  //     {required bool isLoading,
  //       required String branchId,
  //       required String token,
  //     }) async =>
  //     await _profileUseCases.getProfileDetailsAPI(
  //         isLoading: isLoading,
  //         token: token,
  //       branchId: branchId,
  //     );
  //
  // Future<ResponseModel?> logoutAPI({
  //   required bool isLoading,
  // }) async =>
  //     await _profileUseCases.logoutAPI(isLoading: isLoading);
}
