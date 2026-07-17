import 'package:school_app/domain/domain.dart';

class LeaveApplicationStatusPresenter {
  LeaveApplicationStatusPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<LeaveApplicationsResponse?> getLeaveStatusData({
    required bool isLoading,
    required String token,
    required String branchId, required String filter
  }) async {
    return await homeUseCases.getLeaveStatusData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
  }

}
