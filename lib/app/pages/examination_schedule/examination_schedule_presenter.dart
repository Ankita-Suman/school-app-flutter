import 'package:school_app/domain/domain.dart';

class ExaminationSchedulePresenter {
  ExaminationSchedulePresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<TermClassResponse?> getTermClassData(
      {required bool isLoading,
        required String token,
        required String branchId}) async {
    return await homeUseCases.getTermClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<ExaminationGroupResponse?> getExamGroupData(
      {required bool isLoading,
        required String token,
        required String branchId}) async {
    return await homeUseCases.getExamGroupData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<TermSectionResponse?> getTermSectionData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId}) async {
    return await homeUseCases.getTermSectionData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
    );
  }

  Future<ExaminationTermResponse?> getExamTermData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String examinationGroupId}) async {
    return await homeUseCases.getExamTermData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
    );
  }

  Future<ExamScheduleResponse?> getExamSchedule({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    return await homeUseCases.getExamSchedule(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
    );
  }
}
