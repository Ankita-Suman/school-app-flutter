import 'package:school_app/domain/domain.dart';

class  ApprovalStatusPresenter {
  ApprovalStatusPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<LeaveRequestsResponse?> getLeaveApprovalStatusAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getLeaveApprovalStatusAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }


}
