import 'package:school_app/domain/domain.dart';

class ExternalMarksPresenter {
  ExternalMarksPresenter(this.homeUseCases);

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

Future<SubjectResponse?> getSubjectData(
      {required bool isLoading,
        required String token,
        required String branchId,
        required String classId,
        required String sectionId,
      }) async {
    return await homeUseCases.getSubjectData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
      sectionId: sectionId,
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
  Future<SaveExternalMarksResponse?> saveExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await homeUseCases.saveExternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
  Future<ExternalMarksResponse?> getExternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
    required String subjectId,
    required String markType,
    required String internalCount,
  }) async {
    return await homeUseCases.getExternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
      subjectId: subjectId,
      markType: markType,
      internalCount: internalCount,
    );
  }
}
