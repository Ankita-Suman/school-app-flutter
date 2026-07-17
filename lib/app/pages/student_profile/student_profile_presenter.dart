import 'package:school_app/domain/domain.dart';

import '../../../domain/models/profile_response.dart';

class StudentProfilePresenter {
  StudentProfilePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

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

}
