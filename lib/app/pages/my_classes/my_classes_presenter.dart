import 'package:school_app/domain/domain.dart';

class MyClassesPresenter {
  MyClassesPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<TeacherClassesResponse?> getMyClassData({
    required bool isLoading,
    required String token,
    required String branchId
  }) async {
    return await homeUseCases.getMyClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }


}
