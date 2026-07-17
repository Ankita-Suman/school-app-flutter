import 'package:school_app/domain/domain.dart';

class LateArrivalsPresenter {
  LateArrivalsPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<LateArrivalsResponse?> getLateArrivalData({
    required bool isLoading,
    required String token,
    required String branchId, required String filter
  }) async {
    return await homeUseCases.getLateArrivalData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      filter: filter,
    );
  }

}
