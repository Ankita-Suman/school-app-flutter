import 'package:school_app/domain/domain.dart';
import 'package:school_app/domain/models/co_curricular_marks_response.dart';

class CurricularMarksPresenter {
  CurricularMarksPresenter(this.homeUseCases);

  final TeacherHomeUseCases homeUseCases;

  Future<TermClassResponse?> getTermClassData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getTermClassData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<ExaminationGroupResponse?> getExamGroupData({
    required bool isLoading,
    required String token,
    required String branchId,
  }) async {
    return await homeUseCases.getExamGroupData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
    );
  }

  Future<TermSectionResponse?> getTermSectionData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String classId,
  }) async {
    return await homeUseCases.getTermSectionData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      classId: classId,
    );
  }

  Future<SubjectResponse?> getSubjectData({
    required bool isLoading,
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

  Future<ExaminationTermResponse?> getExamTermData({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
  }) async {
    return await homeUseCases.getExamTermData(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
    );
  }
  // ============================================================
  // ✅ NEW: Save Co-Curricular Marks
  // ============================================================
  Future<SaveExternalMarksResponse?> saveCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await homeUseCases.saveCoCurricularMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
  // ============================================================
  // ✅ NEW: Co-Curricular Marks (replaces getInternalMarks)
  // ============================================================
  Future<CoCurricularMarksResponse?> getCoCurricularMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required String examinationGroupId,
    required String examinationTermId,
    required String classId,
    required String sectionId,
  }) async {
    return await homeUseCases.getCoCurricularMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      examinationGroupId: examinationGroupId,
      examinationTermId: examinationTermId,
      classId: classId,
      sectionId: sectionId,
    );
  }

  // ========== SAVE INTERNAL MARKS (अभी रखा है — बाद में update कर सकते हैं) ==========
  Future<SaveExternalMarksResponse?> saveInternalMarks({
    required bool isLoading,
    required String token,
    required String branchId,
    required Map<String, dynamic> payload,
  }) async {
    return await homeUseCases.saveInternalMarks(
      isLoading: isLoading,
      token: token,
      branchId: branchId,
      payload: payload,
    );
  }
}