import 'package:school_app/domain/domain.dart';

class  LeaveBalancePresenter {
  LeaveBalancePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<LeaveBalanceResponse?> getLeaveBalanceAPI({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getLeaveBalanceAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }


}
