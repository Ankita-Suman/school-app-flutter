import 'package:school_app/domain/domain.dart';


class MyStudentListPresenter {
  MyStudentListPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<StudentsResponse?> getAllStudentList({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
    required String sectionId,
  }) async {
    return await homeUseCases.getAllStudentList(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
    );
  }
}
