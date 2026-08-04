import 'package:school_app/domain/domain.dart';


class StaffLeaveHistoryPresenter {
  StaffLeaveHistoryPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<LeaveHistoryResponse?> getLeaveHistory({
    required bool isLoading,
    required String token,
    required String branchId, required String staffId
  }) async {
    return await homeUseCases.getLeaveHistory(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      staffId: staffId,
    );
  }

}
