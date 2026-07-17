import 'package:school_app/domain/domain.dart';

class MyClassDetailsPresenter {
  MyClassDetailsPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<ClassDetailsResponse?> getMyClassDetailsData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    return await homeUseCases.getMyClassDetailsData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
  }

}
