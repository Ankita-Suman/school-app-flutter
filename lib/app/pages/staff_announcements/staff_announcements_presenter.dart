import 'package:school_app/domain/domain.dart';

class StaffAnnouncementsPresenter {
  StaffAnnouncementsPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  // ✅ यहाँ tab पैरामीटर जोड़ा गया है
  Future<ResponseModel?> getStaffAnnouncementDetailsAPI({
    required bool isLoading,
    required String token,
    required String branchId,
    required String tab,
  }) async {
    return await homeUseCases.getStaffAnnouncementDetailsAPI(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      tab: tab,
    );
  }
}